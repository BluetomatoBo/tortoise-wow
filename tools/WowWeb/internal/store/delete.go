package store

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
)

// characterDeleteTargets mirrors the tables Player::DeleteFromDB clears in
// src/game/Objects/Player.cpp (core revision 4f4fcaa1), with the column that
// holds the character GUID.
//
// Keeping this list in sync with the core matters: a missed table leaves rows
// behind that the character server will happily read again if a new character
// ever reuses the same GUID.
var characterDeleteTargets = []struct {
	Table  string
	Column string
}{
	{"character_action", "guid"},
	{"character_aura", "guid"},
	{"character_battleground_data", "guid"},
	{"character_gifts", "guid"},
	{"character_homebind", "guid"},
	{"character_instance", "guid"},
	{"character_inventory", "guid"},
	{"character_queststatus", "guid"},
	{"character_reputation", "guid"},
	{"character_skills", "guid"},
	{"character_forgotten_skills", "guid"},
	{"character_spell", "guid"},
	{"character_spell_cooldown", "guid"},
	{"character_ticket", "guid"},
	{"character_pet", "owner"},
	{"item_instance", "owner_guid"},
	{"mail", "receiver"},
	{"mail_items", "receiver"},
	{"character_deleted_items", "player_guid"}, // column is player_guid, not guid
	{"group_instance", "leaderGuid"},
}

// DeleteAccount removes an account together with the characters on it.
//
// The caller must pass the account's characters and is responsible for having
// refused the operation when any of them is online: the world server keeps
// logged-in characters in memory and writes them back on logout, which would
// resurrect rows that were just deleted.
//
// Guild membership is the one thing this function refuses to guess at. A
// character that leads a guild is rejected, because disbanding or reassigning
// a guild from a web panel would leave the core's in-memory guild state
// inconsistent. Characters that are merely members are removed from
// guild_member.
func (s *Store) DeleteAccount(ctx context.Context, accountID uint32, chars []Character) error {
	// Refuse while anything is online.
	for _, c := range chars {
		if c.Online {
			return fmt.Errorf("character %q (guid %d) is still online", c.Name, c.GUID)
		}
	}

	// Refuse when one of the characters leads a guild.
	for _, c := range chars {
		var guildID uint32
		err := s.Char.QueryRowContext(ctx,
			"SELECT guildid FROM guild WHERE leaderGuid = ?", c.GUID).Scan(&guildID)
		if err == nil {
			return fmt.Errorf("character %q (guid %d) leads guild %d; disband or reassign it first",
				c.Name, c.GUID, guildID)
		}
		if err != nil && err != sql.ErrNoRows {
			return fmt.Errorf("check guild leadership: %w", err)
		}
	}

	charTx, err := s.Char.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer charTx.Rollback() //nolint:errcheck

	for _, c := range chars {
		for _, target := range characterDeleteTargets {
			q := fmt.Sprintf("DELETE FROM `%s` WHERE `%s` = ?", target.Table, target.Column)
			if _, err := charTx.ExecContext(ctx, q, c.GUID); err != nil {
				return fmt.Errorf("delete from %s: %w", target.Table, err)
			}
		}
		if _, err := charTx.ExecContext(ctx,
			"DELETE FROM guild_member WHERE guid = ?", c.GUID); err != nil {
			return fmt.Errorf("delete guild membership: %w", err)
		}
		if _, err := charTx.ExecContext(ctx,
			"DELETE FROM guild_eventlog WHERE PlayerGuid1 = ? OR PlayerGuid2 = ?",
			c.GUID, c.GUID); err != nil {
			return fmt.Errorf("delete guild event log: %w", err)
		}
		if _, err := charTx.ExecContext(ctx,
			"DELETE FROM character_social WHERE guid = ? OR friend = ?",
			c.GUID, c.GUID); err != nil {
			return fmt.Errorf("delete social entries: %w", err)
		}
		if _, err := charTx.ExecContext(ctx,
			"DELETE FROM characters WHERE guid = ?", c.GUID); err != nil {
			return fmt.Errorf("delete character: %w", err)
		}
	}
	if err := charTx.Commit(); err != nil {
		return err
	}

	// Logon side: bans, trusted addresses, web sessions, realm counters, and
	// finally the account row itself.
	logonTx, err := s.Logon.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer logonTx.Rollback() //nolint:errcheck

	for _, q := range []string{
		"DELETE FROM account_banned WHERE id = ?",
		"DELETE FROM account_twofactor_allowed WHERE account_id = ?",
		"DELETE FROM realmcharacters WHERE acctid = ?",
		"DELETE FROM web_sessions WHERE account_id = ?",
		"DELETE FROM web_totp_setup WHERE account_id = ?",
		"DELETE FROM account WHERE id = ?",
	} {
		if _, err := logonTx.ExecContext(ctx, q, accountID); err != nil {
			// The web_* tables may not exist on a partially initialised
			// deployment; ignore only those, never the core tables.
			if isMissingTable(err) {
				continue
			}
			return fmt.Errorf("logon cleanup (%s): %w", q, err)
		}
	}
	return logonTx.Commit()
}

// ActiveBansForAccounts returns the currently effective ban of each account in
// ids, so a list view can render a badge without one query per row.
func (s *Store) ActiveBansForAccounts(ctx context.Context, ids []uint32) (map[uint32]*Ban, error) {
	out := map[uint32]*Ban{}
	if len(ids) == 0 {
		return out, nil
	}

	placeholders := strings.TrimSuffix(strings.Repeat("?,", len(ids)), ",")
	args := make([]any, len(ids))
	for i, id := range ids {
		args[i] = id
	}

	query := `SELECT b.banid, b.id, '', b.bandate, b.unbandate,
	                 b.bannedby, b.banreason, b.active, b.realm
	          FROM account_banned b
	          WHERE b.id IN (` + placeholders + `) AND ` + activeBanPredicate

	rows, err := s.Logon.QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		b, err := scanBan(rows)
		if err != nil {
			return nil, err
		}
		out[b.AccountID] = b
	}
	return out, rows.Err()
}
