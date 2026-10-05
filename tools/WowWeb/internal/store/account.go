package store

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"

	"tortoiseweb/internal/gamepwd"
)

// Account mirrors the columns of tw_logon.account that the panel needs.
type Account struct {
	ID            uint32
	Username      string
	Rank          uint8
	Email         string
	JoinDate      *time.Time // nil when the column holds a zero date
	LastIP        string
	LastLogin     *time.Time
	Online        bool
	Active        bool
	Expansion     uint8
	Locale        uint8
	Locked        uint8
	Security      string // Base32 TOTP secret, empty when 2FA is off
	Flags         uint32
	FailedLogins  uint32
	MuteTime      int64
	MuteReason    string
	MuteBy        string
	CurrentRealm  uint8
	EmailVerified bool
}

// RankName maps account.rank to the names used by the core
// (enum AccountTypes in src/shared/Common.h).
func RankName(rank uint8) string {
	switch rank {
	case 0:
		return "Player"
	case 1:
		return "Observer"
	case 2:
		return "Moderator"
	case 3:
		return "Developer"
	case 4:
		return "Administrator"
	case 5:
		return "SigmaChad"
	case 6:
		return "Console"
	default:
		return fmt.Sprintf("Unknown(%d)", rank)
	}
}

// accountColumns is the projection used by every account query. last_login and
// joindate are forced through NULLIF because the core writes zero dates.
const accountColumns = `
	id, username, ` + "`rank`" + `, COALESCE(email, ''),
	NULLIF(joindate, '0000-00-00 00:00:00'),
	last_ip, NULLIF(last_login, '0000-00-00 00:00:00'),
	online, active, expansion, locale, locked, COALESCE(security, ''),
	flags, failed_logins, mutetime, mutereason, muteby, current_realm,
	email_verif`

func scanAccount(row interface{ Scan(...any) error }) (*Account, error) {
	var (
		a          Account
		joinDate   nullTime
		lastLogin  nullTime
		online     int8
		active     int8
		emailVerif int8
	)
	err := row.Scan(
		&a.ID, &a.Username, &a.Rank, &a.Email, &joinDate,
		&a.LastIP, &lastLogin,
		&online, &active, &a.Expansion, &a.Locale, &a.Locked, &a.Security,
		&a.Flags, &a.FailedLogins, &a.MuteTime, &a.MuteReason, &a.MuteBy,
		&a.CurrentRealm, &emailVerif,
	)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	a.JoinDate = joinDate.Ptr()
	a.LastLogin = lastLogin.Ptr()
	a.Online = online != 0
	a.Active = active != 0
	a.EmailVerified = emailVerif != 0
	return &a, nil
}

func (s *Store) AccountByID(ctx context.Context, id uint32) (*Account, error) {
	row := s.Logon.QueryRowContext(ctx,
		`SELECT `+accountColumns+` FROM account WHERE id = ?`, id)
	return scanAccount(row)
}

func (s *Store) AccountByUsername(ctx context.Context, username string) (*Account, error) {
	row := s.Logon.QueryRowContext(ctx,
		`SELECT `+accountColumns+` FROM account WHERE username = ?`, username)
	return scanAccount(row)
}

// VerifyLogin returns the account when username/password are correct.
//
// The password comparison happens in Go (see gamepwd) rather than in SQL: the
// stored hash is an unsalted SHA-1, so shipping the comparison to the database
// buys nothing and makes error handling harder.
func (s *Store) VerifyLogin(ctx context.Context, username, password string) (*Account, error) {
	normalized, err := gamepwd.Normalize(username)
	if err != nil {
		return nil, ErrNotFound
	}

	var (
		id   uint32
		hash string
	)
	err = s.Logon.QueryRowContext(ctx,
		`SELECT id, sha_pass_hash FROM account WHERE username = ?`, normalized).Scan(&id, &hash)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, err
	}

	if !gamepwd.Verify(username, password, hash) {
		// Record the failure the same way the core's login does, but only for
		// accounts that exist, so this cannot be used to probe usernames.
		_, _ = s.Logon.ExecContext(ctx,
			`UPDATE account SET failed_logins = failed_logins + 1 WHERE id = ?`, id)
		return nil, ErrNotFound
	}

	if _, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET failed_logins = 0 WHERE id = ?`, id); err != nil {
		return nil, err
	}
	return s.AccountByID(ctx, id)
}

// ---------------------------------------------------------------------------
// Listing
// ---------------------------------------------------------------------------

type AccountFilter struct {
	Search string // matches username or email
	Rank   *uint8 // filter by exact rank
	Online *bool
	Banned *bool
	Active *bool
	Limit  int
	Offset int
}

func (f AccountFilter) where() (string, []any) {
	var (
		clauses []string
		args    []any
	)
	if f.Search != "" {
		like := "%" + f.Search + "%"
		clauses = append(clauses, "(username LIKE ? OR email LIKE ?)")
		args = append(args, like, like)
	}
	if f.Rank != nil {
		clauses = append(clauses, "`rank` = ?")
		args = append(args, *f.Rank)
	}
	if f.Online != nil {
		clauses = append(clauses, "online = ?")
		if *f.Online {
			args = append(args, 1)
		} else {
			args = append(args, 0)
		}
	}
	if f.Active != nil {
		clauses = append(clauses, "active = ?")
		if *f.Active {
			args = append(args, 1)
		} else {
			args = append(args, 0)
		}
	}
	if f.Banned != nil {
		sub := `EXISTS (SELECT 1 FROM account_banned b
		                WHERE b.id = account.id AND b.active = 1
		                  AND (b.unbandate > UNIX_TIMESTAMP() OR b.bandate = b.unbandate))`
		if *f.Banned {
			clauses = append(clauses, sub)
		} else {
			clauses = append(clauses, "NOT "+sub)
		}
	}
	if len(clauses) == 0 {
		return "", args
	}
	return " WHERE " + strings.Join(clauses, " AND "), args
}

func (s *Store) ListAccounts(ctx context.Context, f AccountFilter) ([]Account, int, error) {
	where, args := f.where()

	var total int
	if err := s.Logon.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM account`+where, args...).Scan(&total); err != nil {
		return nil, 0, err
	}

	limit := f.Limit
	if limit <= 0 || limit > 200 {
		limit = 50
	}

	rows, err := s.Logon.QueryContext(ctx,
		`SELECT `+accountColumns+` FROM account`+where+
			` ORDER BY id DESC LIMIT ? OFFSET ?`,
		append(args, limit, max(f.Offset, 0))...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var out []Account
	for rows.Next() {
		a, err := scanAccount(rows)
		if err != nil {
			return nil, 0, err
		}
		out = append(out, *a)
	}
	return out, total, rows.Err()
}

// ---------------------------------------------------------------------------
// Mutation
// ---------------------------------------------------------------------------

// CreateAccount inserts a new account exactly the way
// AccountMgr::CreateAccount does: normalized username and password, the SHA-1
// hash in sha_pass_hash, and a zeroed realmcharacters row per realm.
//
// The whole thing runs in one transaction so a failure cannot leave an account
// without its realm counters.
func (s *Store) CreateAccount(ctx context.Context, username, password, email string) (*Account, error) {
	normalizedUser, err := gamepwd.Normalize(username)
	if err != nil {
		return nil, fmt.Errorf("username: %w", err)
	}
	hash, err := gamepwd.Hash(username, password)
	if err != nil {
		return nil, fmt.Errorf("password: %w", err)
	}

	tx, err := s.Logon.BeginTx(ctx, nil)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback() //nolint:errcheck // no-op after a successful Commit

	res, err := tx.ExecContext(ctx,
		`INSERT INTO account (username, sha_pass_hash, email, joindate, last_login)
		 VALUES (?, ?, NULLIF(?, ''), NOW(), NOW())`,
		normalizedUser, hash, email)
	if err != nil {
		if isDuplicate(err) {
			return nil, ErrDuplicate
		}
		return nil, err
	}

	id64, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}
	id := uint32(id64)

	// Mirror the core: one realmcharacters row per realm, count 0.
	if _, err := tx.ExecContext(ctx,
		`INSERT INTO realmcharacters (realmid, acctid, numchars)
		 SELECT r.id, ?, 0 FROM realmlist r
		 LEFT JOIN realmcharacters rc ON rc.realmid = r.id AND rc.acctid = ?
		 WHERE rc.acctid IS NULL`,
		id, id); err != nil {
		return nil, err
	}

	if err := tx.Commit(); err != nil {
		return nil, err
	}
	return s.AccountByID(ctx, id)
}

// SetPassword changes an account password.
//
// v and s are the SRP6 verifier and salt; the core drops them on a password
// change (AccountMgr::ChangePassword) so an in-flight session cannot keep
// using the old credentials. The web panel does the same.
func (s *Store) SetPassword(ctx context.Context, accountID uint32, newPassword string) error {
	acct, err := s.AccountByID(ctx, accountID)
	if err != nil {
		return err
	}
	hash, err := gamepwd.Hash(acct.Username, newPassword)
	if err != nil {
		return fmt.Errorf("password: %w", err)
	}

	res, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET sha_pass_hash = ?, v = '', s = '', sessionkey = NULL WHERE id = ?`,
		hash, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

func (s *Store) SetRank(ctx context.Context, accountID uint32, rank uint8) error {
	res, err := s.Logon.ExecContext(ctx,
		"UPDATE account SET `rank` = ? WHERE id = ?", rank, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

func (s *Store) SetEmail(ctx context.Context, accountID uint32, email string) error {
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET email = NULLIF(?, '') WHERE id = ?`, email, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// SetActive disables (0) or re-enables (1) an account. realmd rejects logins
// when active = 0 (AuthSocket.cpp: `if (!active) -> WOW_FAIL_INCORRECT_PASSWORD`).
func (s *Store) SetActive(ctx context.Context, accountID uint32, active bool) error {
	v := 0
	if active {
		v = 1
	}
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET active = ? WHERE id = ?`, v, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// Locked bit flags, from the LockFlag enum in src/realmd/AuthSocket.h.
const (
	LockIPLock        = 0x01
	LockFixedPIN      = 0x02 // "authenticator token active"
	LockTOTP          = 0x04
	LockAlwaysEnforce = 0x08
	LockGeoCountry    = 0x10
	LockGeoCity       = 0x20
)

// SetTOTP stores a Base32 secret and turns the authenticator on.
//
// realmd reads account.security and only asks for a code when the locked
// bitmask contains FIXED_PIN (or TOTP) - see AuthSocket.cpp.
func (s *Store) SetTOTP(ctx context.Context, accountID uint32, secret string) error {
	if err := gamepwd.ValidateTOTPSecret(secret); err != nil {
		return err
	}
	normalized := strings.ToUpper(strings.TrimRight(strings.TrimSpace(secret), "="))
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET security = ?, locked = (locked | ?) WHERE id = ?`,
		normalized, LockFixedPIN, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// ClearTOTP removes the secret and the authenticator flag, so the account logs
// in without a code again.
func (s *Store) ClearTOTP(ctx context.Context, accountID uint32) error {
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET security = NULL, locked = (locked & ~?) WHERE id = ?`,
		LockFixedPIN|LockTOTP|LockAlwaysEnforce, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// SetMute applies a temporary mute. The core checks account.mutetime
// (unix seconds) when a muted player tries to chat.
func (s *Store) SetMute(ctx context.Context, accountID uint32, until time.Time, reason, by string) error {
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET mutetime = ?, mutereason = ?, muteby = ? WHERE id = ?`,
		until.Unix(), truncate(reason, 255), truncate(by, 50), accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

func (s *Store) ClearMute(ctx context.Context, accountID uint32) error {
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE account SET mutetime = 0, mutereason = '', muteby = '' WHERE id = ?`, accountID)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// AccountCount returns how many accounts exist, used by MAX_ACCOUNTS.
func (s *Store) AccountCount(ctx context.Context) (int, error) {
	var n int
	err := s.Logon.QueryRowContext(ctx, `SELECT COUNT(*) FROM account`).Scan(&n)
	return n, err
}

// CharacterCount returns the number of characters on an account, from the
// character database (the realmcharacters counters are only refreshed by the
// world server, so they can lag behind).
func (s *Store) CharacterCount(ctx context.Context, accountID uint32) (int, error) {
	var n int
	err := s.Char.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM characters WHERE account = ?`, accountID).Scan(&n)
	return n, err
}

func requireAffected(res sql.Result) error {
	n, err := res.RowsAffected()
	if err != nil {
		return err
	}
	if n == 0 {
		return ErrNotFound
	}
	return nil
}

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
