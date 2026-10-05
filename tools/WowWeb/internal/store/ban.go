package store

import (
	"context"
	"database/sql"
	"errors"
	"strings"
	"time"
)

// Ban mirrors one row of tw_logon.account_banned.
type Ban struct {
	BanID      uint64
	AccountID  uint32
	Username   string
	BanDate    time.Time
	UnbanDate  time.Time
	BannedBy   string
	Reason     string
	Active     bool
	Realm      uint8
	Permanent  bool // bandate == unbandate, the core's marker for a permanent ban
	StillValid bool // active AND (unbandate in the future OR permanent)
}

// activeBanPredicate is the exact expression the core uses when it loads the
// ban list (AccountMgr::LoadAccountBanList):
//
//	active = 1 AND (unbandate > UNIX_TIMESTAMP() OR bandate = unbandate)
const activeBanPredicate = `b.active = 1
	AND (b.unbandate > UNIX_TIMESTAMP() OR b.bandate = b.unbandate)`

func scanBan(row interface{ Scan(...any) error }) (*Ban, error) {
	var (
		b       Ban
		active  int8
		banUnix int64
		unban   int64
	)
	err := row.Scan(&b.BanID, &b.AccountID, &b.Username, &banUnix, &unban,
		&b.BannedBy, &b.Reason, &active, &b.Realm)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	b.Active = active != 0
	b.BanDate = time.Unix(banUnix, 0)
	b.UnbanDate = time.Unix(unban, 0)
	b.Permanent = banUnix == unban
	b.StillValid = b.Active && (b.Permanent || unban > time.Now().Unix())
	return &b, nil
}

const banSelect = `
	SELECT b.banid, b.id, COALESCE(a.username, ''), b.bandate, b.unbandate,
	       b.bannedby, b.banreason, b.active, b.realm
	FROM account_banned b
	LEFT JOIN account a ON a.id = b.id`

// ActiveBanFor returns the currently effective ban of an account, if any.
func (s *Store) ActiveBanFor(ctx context.Context, accountID uint32) (*Ban, error) {
	row := s.Logon.QueryRowContext(ctx,
		banSelect+` WHERE b.id = ? AND `+activeBanPredicate+`
		ORDER BY b.bandate DESC LIMIT 1`, accountID)
	return scanBan(row)
}

// IsBanned is a convenience wrapper for templates.
func (s *Store) IsBanned(ctx context.Context, accountID uint32) (bool, *Ban) {
	ban, err := s.ActiveBanFor(ctx, accountID)
	if err != nil {
		return false, nil
	}
	return true, ban
}

type BanFilter struct {
	Search string // account name
	Only   string // "active" | "expired" | "all"
	Limit  int
	Offset int
}

func (s *Store) ListBans(ctx context.Context, f BanFilter) ([]Ban, int, error) {
	var (
		clauses []string
		args    []any
	)
	switch f.Only {
	case "active":
		clauses = append(clauses, "("+activeBanPredicate+")")
	case "expired":
		clauses = append(clauses, "NOT ("+activeBanPredicate+")")
	}
	if f.Search != "" {
		clauses = append(clauses, "a.username LIKE ?")
		args = append(args, "%"+f.Search+"%")
	}
	where := ""
	if len(clauses) > 0 {
		where = " WHERE " + strings.Join(clauses, " AND ")
	}

	var total int
	if err := s.Logon.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM account_banned b LEFT JOIN account a ON a.id = b.id`+where,
		args...).Scan(&total); err != nil {
		return nil, 0, err
	}

	limit := f.Limit
	if limit <= 0 || limit > 200 {
		limit = 50
	}

	rows, err := s.Logon.QueryContext(ctx,
		banSelect+where+` ORDER BY b.bandate DESC LIMIT ? OFFSET ?`,
		append(args, limit, max(f.Offset, 0))...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var out []Ban
	for rows.Next() {
		b, err := scanBan(rows)
		if err != nil {
			return nil, 0, err
		}
		out = append(out, *b)
	}
	return out, total, rows.Err()
}

// BanAccount inserts a ban exactly the way World::BanAccount does.
//
// duration == 0 produces a permanent ban: the core writes
// unbandate = UNIX_TIMESTAMP() + 0, making bandate == unbandate, and treats
// that equality as "never expires" both here and in LoadAccountBanList.
//
// It does not log the player out - the web service has no way to talk to the
// running world server - so an already online character keeps playing until it
// disconnects. The ban takes effect on the next login.
func (s *Store) BanAccount(ctx context.Context, accountID uint32, duration time.Duration, reason, by string, realmID uint8) error {
	res, err := s.Logon.ExecContext(ctx,
		`INSERT INTO account_banned
		   (id, bandate, unbandate, bannedby, banreason, active, realm)
		 VALUES (?, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + ?, ?, ?, 1, ?)`,
		accountID, int64(duration.Seconds()),
		truncate(by, 50), truncate(reason, 255), realmID)
	if err != nil {
		return err
	}
	_ = res
	return nil
}

// UnbanAccount clears every ban row of the account, matching
// World::UnBanAccount (`UPDATE account_banned SET active = '0' WHERE id = ?`).
func (s *Store) UnbanAccount(ctx context.Context, accountID uint32) error {
	_, err := s.Logon.ExecContext(ctx,
		`UPDATE account_banned SET active = 0 WHERE id = ?`, accountID)
	return err
}

// ---------------------------------------------------------------------------
// IP bans (tw_logon.ip_banned)
// ---------------------------------------------------------------------------

// BanIP inserts or refreshes an IP ban.
//
// duration == 0 means permanent; the core's IP ban loader compares
// unbandate with the current time and treats 0 as "never expires".
func (s *Store) BanIP(ctx context.Context, ip string, duration time.Duration, reason, by string) error {
	unban := time.Now().Add(duration).Unix()
	permanent := duration <= 0
	if permanent {
		unban = 0 // 0 = permanent, see AccountMgr::LoadIPBanList
	}

	// ip_banned has a composite primary key on (ip, bandate), so an existing
	// row for the same address would coexist with the new one. Replace the
	// previous entry to keep one row per address per ban.
	tx, err := s.Logon.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback() //nolint:errcheck

	if _, err := tx.ExecContext(ctx, `DELETE FROM ip_banned WHERE ip = ?`, ip); err != nil {
		return err
	}
	if _, err := tx.ExecContext(ctx,
		`INSERT INTO ip_banned (ip, bandate, unbandate, bannedby, banreason)
		 VALUES (?, UNIX_TIMESTAMP(), ?, ?, ?)`,
		ip, unban, truncate(by, 50), truncate(reason, 128)); err != nil {
		return err
	}
	return tx.Commit()
}

func (s *Store) UnbanIP(ctx context.Context, ip string) error {
	_, err := s.Logon.ExecContext(ctx, `DELETE FROM ip_banned WHERE ip = ?`, ip)
	return err
}

type IPBan struct {
	IP        string
	BanDate   time.Time
	UnbanDate time.Time
	BannedBy  string
	Reason    string
	Permanent bool
}

func (s *Store) ListIPBans(ctx context.Context) ([]IPBan, error) {
	rows, err := s.Logon.QueryContext(ctx,
		`SELECT ip, bandate, unbandate, bannedby, banreason FROM ip_banned ORDER BY bandate DESC`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []IPBan
	for rows.Next() {
		var (
			b       IPBan
			banUnix int64
			unban   int64
		)
		if err := rows.Scan(&b.IP, &banUnix, &unban, &b.BannedBy, &b.Reason); err != nil {
			return nil, err
		}
		b.BanDate = time.Unix(banUnix, 0)
		b.UnbanDate = time.Unix(unban, 0)
		b.Permanent = unban == 0
		out = append(out, b)
	}
	return out, rows.Err()
}

// ---------------------------------------------------------------------------
// Two-factor IP allowances (tw_logon.account_twofactor_allowed)
// ---------------------------------------------------------------------------

// TwoFactorAllowance is a trusted address that skips the authenticator prompt.
type TwoFactorAllowance struct {
	ID        uint64
	IP        string
	AccountID uint32
	ExpiresAt time.Time
}

func (s *Store) ListTwoFactorAllowances(ctx context.Context, accountID uint32) ([]TwoFactorAllowance, error) {
	rows, err := s.Logon.QueryContext(ctx,
		`SELECT id, ip_address, COALESCE(account_id, 0), COALESCE(expires_at, 0)
		 FROM account_twofactor_allowed WHERE account_id = ? ORDER BY expires_at DESC`,
		accountID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []TwoFactorAllowance
	for rows.Next() {
		var (
			a       TwoFactorAllowance
			expires int64
		)
		if err := rows.Scan(&a.ID, &a.IP, &a.AccountID, &expires); err != nil {
			return nil, err
		}
		a.ExpiresAt = time.Unix(expires, 0)
		out = append(out, a)
	}
	return out, rows.Err()
}

func (s *Store) RevokeTwoFactorAllowance(ctx context.Context, id uint64, accountID uint32) error {
	res, err := s.Logon.ExecContext(ctx,
		`DELETE FROM account_twofactor_allowed WHERE id = ? AND account_id = ?`, id, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

func (s *Store) RevokeAllTwoFactorAllowances(ctx context.Context, accountID uint32) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM account_twofactor_allowed WHERE account_id = ?`, accountID)
	return err
}

// ---------------------------------------------------------------------------
// Audit log
// ---------------------------------------------------------------------------

type AuditEntry struct {
	At      time.Time
	ActorID uint32
	Actor   string
	Action  string
	Target  string
	Detail  string
	IP      string
}

// Audit records an administrative action. Failures are not fatal for the
// request that triggered them, but they are returned so the caller can log.
func (s *Store) Audit(ctx context.Context, actorID uint32, actor, action, target, detail, ip string) error {
	_, err := s.Logon.ExecContext(ctx,
		`INSERT INTO web_audit (at, actor_account_id, actor_name, action, target, detail, ip)
		 VALUES (NOW(), ?, ?, ?, ?, ?, ?)`,
		actorID, truncate(actor, 32), truncate(action, 64), truncate(target, 64),
		detail, truncate(ip, 45))
	return err
}

func (s *Store) RecentAudit(ctx context.Context, limit int) ([]AuditEntry, error) {
	if limit <= 0 || limit > 500 {
		limit = 100
	}
	rows, err := s.Logon.QueryContext(ctx,
		`SELECT at, actor_account_id, actor_name, action, target,
		        COALESCE(detail, ''), ip
		 FROM web_audit ORDER BY id DESC LIMIT ?`, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []AuditEntry
	for rows.Next() {
		var e AuditEntry
		if err := rows.Scan(&e.At, &e.ActorID, &e.Actor, &e.Action, &e.Target, &e.Detail, &e.IP); err != nil {
			return nil, err
		}
		out = append(out, e)
	}
	return out, rows.Err()
}

func isMissingTable(err error) bool {
	return err != nil && strings.Contains(err.Error(), "doesn't exist")
}
