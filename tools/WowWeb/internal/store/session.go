package store

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"database/sql"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"time"

	"tortoiseweb/internal/gamepwd"
)

// WebSession is a logged-in browser session.
//
// The cookie carries a random token; the database stores only its SHA-256, so
// a leaked database dump does not hand out live sessions.
type WebSession struct {
	TokenHash  string
	AccountID  uint32
	CSRFToken  string
	CreatedAt  time.Time
	ExpiresAt  time.Time
	LastSeenAt time.Time
	IP         string
	UserAgent  string
}

// NewToken returns a URL-safe random token (32 bytes of entropy).
func NewToken() (string, error) {
	buf := make([]byte, 32)
	if _, err := rand.Read(buf); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(buf), nil
}

// hashToken is the value stored in web_sessions.token_hash.
func hashToken(token string) string {
	sum := sha256.Sum256([]byte(token))
	return hex.EncodeToString(sum[:])
}

// CreateSession stores a new session and returns the raw cookie token.
func (s *Store) CreateSession(ctx context.Context, accountID uint32, ttl time.Duration, ip, userAgent string) (token, csrf string, err error) {
	token, err = NewToken()
	if err != nil {
		return "", "", err
	}
	csrf, err = NewToken()
	if err != nil {
		return "", "", err
	}

	now := time.Now()
	_, err = s.Logon.ExecContext(ctx,
		`INSERT INTO web_sessions
		   (token_hash, account_id, csrf_token, created_at, expires_at, last_seen_at, ip, user_agent)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
		hashToken(token), accountID, csrf, now, now.Add(ttl), now,
		truncate(ip, 45), truncate(userAgent, 255))
	if err != nil {
		return "", "", err
	}
	return token, csrf, nil
}

// SessionByToken looks up a live session and refreshes last_seen_at.
//
// Expired rows are deleted on access, which keeps the table small without a
// background job.
func (s *Store) SessionByToken(ctx context.Context, token string) (*WebSession, error) {
	if token == "" {
		return nil, ErrNotFound
	}
	h := hashToken(token)

	var sess WebSession
	err := s.Logon.QueryRowContext(ctx,
		`SELECT token_hash, account_id, csrf_token, created_at, expires_at, last_seen_at, ip, user_agent
		 FROM web_sessions WHERE token_hash = ?`, h).
		Scan(&sess.TokenHash, &sess.AccountID, &sess.CSRFToken, &sess.CreatedAt,
			&sess.ExpiresAt, &sess.LastSeenAt, &sess.IP, &sess.UserAgent)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, err
	}

	if time.Now().After(sess.ExpiresAt) {
		_ = s.DeleteSession(ctx, h)
		return nil, ErrNotFound
	}

	// Refresh at most once a minute to avoid a write on every request.
	if time.Since(sess.LastSeenAt) > time.Minute {
		_, _ = s.Logon.ExecContext(ctx,
			`UPDATE web_sessions SET last_seen_at = NOW() WHERE token_hash = ?`, h)
		sess.LastSeenAt = time.Now()
	}
	return &sess, nil
}

func (s *Store) DeleteSession(ctx context.Context, tokenHash string) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_sessions WHERE token_hash = ?`, tokenHash)
	return err
}

// DeleteSessionByToken removes the session identified by a raw cookie value.
func (s *Store) DeleteSessionByToken(ctx context.Context, token string) error {
	if token == "" {
		return nil
	}
	return s.DeleteSession(ctx, hashToken(token))
}

// DeleteSessionsForAccount is used after a password change or a ban so other
// browsers are logged out.
func (s *Store) DeleteSessionsForAccount(ctx context.Context, accountID uint32) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_sessions WHERE account_id = ?`, accountID)
	return err
}

// DeleteSessionsExcept keeps the current session while logging out the rest.
func (s *Store) DeleteSessionsExcept(ctx context.Context, accountID uint32, keepToken string) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_sessions WHERE account_id = ? AND token_hash <> ?`,
		accountID, hashToken(keepToken))
	return err
}

// CountSessionsForAccount powers the "active sessions" panel.
func (s *Store) CountSessionsForAccount(ctx context.Context, accountID uint32) (int, error) {
	var n int
	err := s.Logon.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM web_sessions WHERE account_id = ? AND expires_at > NOW()`,
		accountID).Scan(&n)
	return n, err
}

// SessionsForAccount lists the live sessions of an account.
func (s *Store) SessionsForAccount(ctx context.Context, accountID uint32) ([]WebSession, error) {
	rows, err := s.Logon.QueryContext(ctx,
		`SELECT token_hash, account_id, csrf_token, created_at, expires_at, last_seen_at, ip, user_agent
		 FROM web_sessions WHERE account_id = ? AND expires_at > NOW()
		 ORDER BY last_seen_at DESC`, accountID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []WebSession
	for rows.Next() {
		var sess WebSession
		if err := rows.Scan(&sess.TokenHash, &sess.AccountID, &sess.CSRFToken,
			&sess.CreatedAt, &sess.ExpiresAt, &sess.LastSeenAt,
			&sess.IP, &sess.UserAgent); err != nil {
			return nil, err
		}
		out = append(out, sess)
	}
	return out, rows.Err()
}

// ---------------------------------------------------------------------------
// Pending authenticator setups
// ---------------------------------------------------------------------------

// SavePendingSecret stores a newly generated TOTP secret until the user proves
// their authenticator produces valid codes for it. Only then is it written to
// account.security - otherwise a typo in the app would lock the account out of
// the game entirely.
func (s *Store) SavePendingSecret(ctx context.Context, accountID uint32, secret string, ttl time.Duration) error {
	if err := gamepwd.ValidateTOTPSecret(secret); err != nil {
		return err
	}
	_, err := s.Logon.ExecContext(ctx,
		`INSERT INTO web_totp_setup (account_id, secret, created_at, expires_at)
		 VALUES (?, ?, NOW(), ?)
		 ON DUPLICATE KEY UPDATE secret = VALUES(secret), created_at = NOW(), expires_at = VALUES(expires_at)`,
		accountID, secret, time.Now().Add(ttl))
	return err
}

// PendingSecret returns the unconfirmed secret of an account, if any.
func (s *Store) PendingSecret(ctx context.Context, accountID uint32) (string, error) {
	var secret string
	err := s.Logon.QueryRowContext(ctx,
		`SELECT secret FROM web_totp_setup WHERE account_id = ? AND expires_at > NOW()`,
		accountID).Scan(&secret)
	if errors.Is(err, sql.ErrNoRows) {
		return "", ErrNotFound
	}
	return secret, err
}

func (s *Store) DeletePendingSecret(ctx context.Context, accountID uint32) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_totp_setup WHERE account_id = ?`, accountID)
	return err
}

func (s *Store) PrunePendingSecrets(ctx context.Context) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_totp_setup WHERE expires_at < NOW()`)
	return err
}

// PruneSessions removes expired rows.
func (s *Store) PruneSessions(ctx context.Context) (int64, error) {
	res, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_sessions WHERE expires_at < NOW()`)
	if err != nil {
		return 0, err
	}
	return res.RowsAffected()
}
