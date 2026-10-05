package store

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Character mirrors the columns of tw_char.characters the panel displays.
type Character struct {
	GUID        uint32
	AccountID   uint32
	AccountName string
	Name        string
	Race        uint8
	Class       uint8
	Gender      uint8
	Level       uint8
	XP          uint32
	Money       uint32
	Online      bool
	Map         uint32
	Zone        uint32
	PosX        float32
	PosY        float32
	PosZ        float32
	Orientation float32
	TotalTime   uint32
	LevelTime   uint32
	LogoutTime  int64
	AtLogin     uint32
	GuildName   string
}

// AtLogin flags from enum AtLoginFlags (src/game/Objects/Player.h).
const (
	AtLoginRename       = 0x01 // character is forced to rename on next login
	AtLoginResetSpells  = 0x02
	AtLoginResetTalents = 0x04
	AtLoginFirst        = 0x20
)

var raceNames = map[uint8]string{
	1: "Human", 2: "Orc", 3: "Dwarf", 4: "Night Elf",
	5: "Undead", 6: "Tauren", 7: "Gnome", 8: "Troll",
}

var classNames = map[uint8]string{
	1: "Warrior", 2: "Paladin", 3: "Hunter", 4: "Rogue", 5: "Priest",
	7: "Shaman", 8: "Mage", 9: "Warlock", 11: "Druid",
}

var genderNames = map[uint8]string{0: "Male", 1: "Female"}

func RaceName(id uint8) string  { return lookup(raceNames, id) }
func ClassName(id uint8) string { return lookup(classNames, id) }
func GenderName(id uint8) string {
	return lookup(genderNames, id)
}

func lookup(m map[uint8]string, id uint8) string {
	if s, ok := m[id]; ok {
		return s
	}
	return fmt.Sprintf("#%d", id)
}

// AtLoginFlags renders the pending at-login flags as a list.
func AtLoginFlags(atLogin uint32) []string {
	var out []string
	if atLogin&AtLoginRename != 0 {
		out = append(out, "rename")
	}
	if atLogin&AtLoginResetSpells != 0 {
		out = append(out, "reset spells")
	}
	if atLogin&AtLoginResetTalents != 0 {
		out = append(out, "reset talents")
	}
	if atLogin&AtLoginFirst != 0 {
		out = append(out, "first login")
	}
	return out
}

// characterSelect is shared by the lookups and the search.
const characterSelect = `
	SELECT c.guid, c.account, COALESCE(a.username, ''), c.name, c.race, c.class,
	       c.gender, c.level, c.xp, c.money, c.online, c.map, c.zone,
	       c.position_x, c.position_y, c.position_z, c.orientation,
	       c.totaltime, c.leveltime, c.logout_time, c.at_login,
	       COALESCE(g.name, '')
	FROM characters c
	LEFT JOIN %s.account a ON a.id = c.account
	LEFT JOIN guild_member gm ON gm.guid = c.guid
	LEFT JOIN guild g ON g.guildid = gm.guildid`

func scanCharacter(row interface{ Scan(...any) error }) (*Character, error) {
	var (
		c      Character
		online int8
	)
	err := row.Scan(
		&c.GUID, &c.AccountID, &c.AccountName, &c.Name, &c.Race, &c.Class,
		&c.Gender, &c.Level, &c.XP, &c.Money, &online, &c.Map, &c.Zone,
		&c.PosX, &c.PosY, &c.PosZ, &c.Orientation,
		&c.TotalTime, &c.LevelTime, &c.LogoutTime, &c.AtLogin,
		&c.GuildName,
	)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	c.Online = online != 0
	return &c, nil
}

// CharactersByAccount lists the characters of one account.
//
// The join on the logon database is fully qualified because the two databases
// live in the same MySQL instance in every supported deployment.
func (s *Store) CharactersByAccount(ctx context.Context, accountID uint32) ([]Character, error) {
	rows, err := s.Char.QueryContext(ctx,
		fmt.Sprintf(characterSelect, quoteIdent(s.cfg.DBLogon))+
			` WHERE c.account = ? ORDER BY c.level DESC, c.name`, accountID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	return collectCharacters(rows)
}

func (s *Store) CharacterByGUID(ctx context.Context, guid uint32) (*Character, error) {
	row := s.Char.QueryRowContext(ctx,
		fmt.Sprintf(characterSelect, quoteIdent(s.cfg.DBLogon))+
			` WHERE c.guid = ?`, guid)
	return scanCharacter(row)
}

type CharacterFilter struct {
	Search    string // character name
	AccountID *uint32
	MinLevel  *uint8
	Online    *bool
	Limit     int
	Offset    int
}

func (s *Store) ListCharacters(ctx context.Context, f CharacterFilter) ([]Character, int, error) {
	var (
		clauses []string
		args    []any
	)
	if f.Search != "" {
		clauses = append(clauses, "c.name LIKE ?")
		args = append(args, "%"+f.Search+"%")
	}
	if f.AccountID != nil {
		clauses = append(clauses, "c.account = ?")
		args = append(args, *f.AccountID)
	}
	if f.MinLevel != nil {
		clauses = append(clauses, "c.level >= ?")
		args = append(args, *f.MinLevel)
	}
	if f.Online != nil {
		clauses = append(clauses, "c.online = ?")
		if *f.Online {
			args = append(args, 1)
		} else {
			args = append(args, 0)
		}
	}

	where := ""
	if len(clauses) > 0 {
		where = " WHERE " + strings.Join(clauses, " AND ")
	}

	var total int
	countQuery := `SELECT COUNT(*) FROM characters c` + where
	if err := s.Char.QueryRowContext(ctx, countQuery, args...).Scan(&total); err != nil {
		return nil, 0, err
	}

	limit := f.Limit
	if limit <= 0 || limit > 200 {
		limit = 50
	}

	rows, err := s.Char.QueryContext(ctx,
		fmt.Sprintf(characterSelect, quoteIdent(s.cfg.DBLogon))+where+
			` ORDER BY c.level DESC, c.name LIMIT ? OFFSET ?`,
		append(args, limit, max(f.Offset, 0))...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	list, err := collectCharacters(rows)
	return list, total, err
}

func collectCharacters(rows *sql.Rows) ([]Character, error) {
	var out []Character
	for rows.Next() {
		c, err := scanCharacter(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, *c)
	}
	return out, rows.Err()
}

// Homebind returns the character's hearthstone position, used by Unstick.
func (s *Store) Homebind(ctx context.Context, guid uint32) (mapID, zone uint32, x, y, z float32, err error) {
	err = s.Char.QueryRowContext(ctx,
		`SELECT map, zone, position_x, position_y, position_z
		 FROM character_homebind WHERE guid = ?`, guid).
		Scan(&mapID, &zone, &x, &y, &z)
	if errors.Is(err, sql.ErrNoRows) {
		err = ErrNotFound
	}
	return
}

// Unstick moves a character back to its homebind position.
//
// This only takes effect while the character is offline: the world server
// keeps the in-memory position of a logged-in character and writes it back on
// logout, which would undo the change. Callers must check Character.Online
// first - the HTTP layer refuses the action for online characters.
func (s *Store) Unstick(ctx context.Context, guid uint32) error {
	mapID, _, x, y, z, err := s.Homebind(ctx, guid)
	if err != nil {
		return fmt.Errorf("character has no homebind row: %w", err)
	}

	res, err := s.Char.ExecContext(ctx,
		`UPDATE characters
		 SET map = ?, position_x = ?, position_y = ?, position_z = ?
		 WHERE guid = ? AND online = 0`,
		mapID, x, y, z, guid)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// SetAtLoginFlag adds or removes bits from characters.at_login. The world
// server reads the column when the character logs in and performs the
// corresponding action (rename prompt, talent/spell reset).
func (s *Store) SetAtLoginFlag(ctx context.Context, guid uint32, flag uint32, enabled bool) error {
	op := "|"
	if !enabled {
		op = "& ~"
	}
	res, err := s.Char.ExecContext(ctx,
		"UPDATE characters SET at_login = (at_login "+op+" ?) WHERE guid = ?",
		flag, guid)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// RenameCharacter forces a rename prompt on next login.
func (s *Store) RenameCharacter(ctx context.Context, guid uint32) error {
	return s.SetAtLoginFlag(ctx, guid, AtLoginRename, true)
}

// SetCharacterLevel is exposed for completeness; the panel uses it behind an
// explicit confirmation because it is not reversible.
func (s *Store) SetCharacterLevel(ctx context.Context, guid uint32, level uint8) error {
	res, err := s.Char.ExecContext(ctx,
		`UPDATE characters SET level = ? WHERE guid = ?`, level, guid)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// OnlineCounts returns how many characters are online per account.
func (s *Store) OnlineCounts(ctx context.Context) (map[uint32]int, error) {
	rows, err := s.Char.QueryContext(ctx,
		`SELECT account, COUNT(*) FROM characters WHERE online = 1 GROUP BY account`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	out := map[uint32]int{}
	for rows.Next() {
		var (
			acct uint32
			n    int
		)
		if err := rows.Scan(&acct, &n); err != nil {
			return nil, err
		}
		out[acct] = n
	}
	return out, rows.Err()
}

// ServerStats is the data shown on the dashboard.
type ServerStats struct {
	Accounts      int
	Characters    int
	OnlineChars   int
	OnlineAccs    int
	ActiveBans    int
	NewToday      int
	Guilds        int
	MaxLevelChars int
}

func (s *Store) Stats(ctx context.Context) (ServerStats, error) {
	var st ServerStats

	if err := s.Logon.QueryRowContext(ctx, `SELECT COUNT(*) FROM account`).Scan(&st.Accounts); err != nil {
		return st, fmt.Errorf("count accounts: %w", err)
	}
	if err := s.Logon.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM account WHERE joindate >= CURDATE()`).Scan(&st.NewToday); err != nil {
		return st, fmt.Errorf("count new accounts: %w", err)
	}
	if err := s.Logon.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM account_banned
		 WHERE active = 1 AND (unbandate > UNIX_TIMESTAMP() OR bandate = unbandate)`).
		Scan(&st.ActiveBans); err != nil {
		return st, fmt.Errorf("count bans: %w", err)
	}

	if err := s.Char.QueryRowContext(ctx, `SELECT COUNT(*) FROM characters`).Scan(&st.Characters); err != nil {
		return st, fmt.Errorf("count characters: %w", err)
	}
	if err := s.Char.QueryRowContext(ctx,
		`SELECT COUNT(*), COUNT(DISTINCT account) FROM characters WHERE online = 1`).
		Scan(&st.OnlineChars, &st.OnlineAccs); err != nil {
		return st, fmt.Errorf("count online: %w", err)
	}
	if err := s.Char.QueryRowContext(ctx, `SELECT COUNT(*) FROM guild`).Scan(&st.Guilds); err != nil {
		// guild lives in the character database as well; a missing table is not
		// fatal for the dashboard.
		st.Guilds = 0
	}

	return st, nil
}

// RealmStatus reports whether the world server looks reachable, based on the
// population counter the world server keeps in realmlist.
func (s *Store) OnlinePlayersNow(ctx context.Context, realmID int) (int, error) {
	var n int
	err := s.Char.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM characters WHERE online = 1`).Scan(&n)
	return n, err
}

func quoteIdent(name string) string {
	return "`" + strings.ReplaceAll(name, "`", "``") + "`"
}

// CharacterAccountID is a small helper for ownership checks.
func (s *Store) CharacterAccountID(ctx context.Context, guid uint32) (uint32, error) {
	var acct uint32
	err := s.Char.QueryRowContext(ctx,
		`SELECT account FROM characters WHERE guid = ?`, guid).Scan(&acct)
	if errors.Is(err, sql.ErrNoRows) {
		return 0, ErrNotFound
	}
	return acct, err
}

// FormatPlaytime renders totaltime (seconds) as "Xd Yh Zm".
func FormatPlaytime(seconds uint32) string {
	if seconds == 0 {
		return "-"
	}
	d := time.Duration(seconds) * time.Second
	days := int(d.Hours()) / 24
	hours := int(d.Hours()) % 24
	mins := int(d.Minutes()) % 60
	switch {
	case days > 0:
		return fmt.Sprintf("%dd %dh %dm", days, hours, mins)
	case hours > 0:
		return fmt.Sprintf("%dh %dm", hours, mins)
	default:
		return fmt.Sprintf("%dm", mins)
	}
}

// CoinsFromCopper renders money the way the client does.
func CoinsFromCopper(copper uint32) string {
	gold := copper / 10000
	silver := (copper % 10000) / 100
	rest := copper % 100
	switch {
	case gold > 0:
		return fmt.Sprintf("%dg %ds", gold, silver)
	case silver > 0:
		return fmt.Sprintf("%ds %dc", silver, rest)
	default:
		return fmt.Sprintf("%dc", rest)
	}
}
