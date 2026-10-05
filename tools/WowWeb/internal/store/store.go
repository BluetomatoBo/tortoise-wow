// Package store contains all database access for the web service.
//
// It talks to the live game databases created by sql/create_databases.sql and
// never alters the core's schema. The only tables it creates are its own
// web_-prefixed tables inside the logon database (sessions and an audit log);
// the core ignores anything it does not know about.
package store

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/go-sql-driver/mysql"

	"tortoiseweb/internal/config"
)

// ErrNotFound is returned when a lookup matches no row.
var ErrNotFound = errors.New("not found")

// ErrDuplicate is returned when an insert violates a unique key.
var ErrDuplicate = errors.New("already exists")

type Store struct {
	// Logon holds account, realmlist, account_banned, realmcharacters.
	Logon *sql.DB
	// Char holds characters and friends.
	Char *sql.DB
	// World holds world content (read-only for this service).
	World *sql.DB
	// Logs is kept for completeness; the panel does not write to it.
	Logs *sql.DB

	cfg config.Config
}

func Open(ctx context.Context, cfg config.Config) (*Store, error) {
	s := &Store{cfg: cfg}

	var err error
	if s.Logon, err = openPool(ctx, cfg, cfg.DBLogon); err != nil {
		return nil, fmt.Errorf("logon database %q: %w", cfg.DBLogon, err)
	}
	if s.Char, err = openPool(ctx, cfg, cfg.DBChar); err != nil {
		return nil, fmt.Errorf("character database %q: %w", cfg.DBChar, err)
	}
	// The world database is optional: a panel without it still works, it just
	// cannot show world-side information.
	if s.World, err = openPool(ctx, cfg, cfg.DBWorld); err != nil {
		return nil, fmt.Errorf("world database %q: %w", cfg.DBWorld, err)
	}
	if s.Logs, err = openPool(ctx, cfg, cfg.DBLogs); err != nil {
		return nil, fmt.Errorf("logs database %q: %w", cfg.DBLogs, err)
	}
	return s, nil
}

func openPool(ctx context.Context, cfg config.Config, database string) (*sql.DB, error) {
	db, err := sql.Open("mysql", cfg.DSN(database))
	if err != nil {
		return nil, err
	}
	db.SetMaxOpenConns(16)
	db.SetMaxIdleConns(4)
	db.SetConnMaxLifetime(time.Hour)

	pingCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()
	if err := db.PingContext(pingCtx); err != nil {
		db.Close()
		return nil, err
	}
	return db, nil
}

func (s *Store) Close() error {
	var firstErr error
	for _, db := range []*sql.DB{s.Logon, s.Char, s.World, s.Logs} {
		if db == nil {
			continue
		}
		if err := db.Close(); err != nil && firstErr == nil {
			firstErr = err
		}
	}
	return firstErr
}

func (s *Store) Config() config.Config { return s.cfg }

// EnsureSchema creates the service's own tables. It is safe to run on every
// start and never touches core tables.
func (s *Store) EnsureSchema(ctx context.Context) error {
	stmts := []string{
		`CREATE TABLE IF NOT EXISTS ` + "`web_sessions`" + ` (
			` + "`id`" + ` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
			` + "`token_hash`" + ` CHAR(64) NOT NULL COMMENT 'SHA-256 of the cookie value',
			` + "`account_id`" + ` INT UNSIGNED NOT NULL,
			` + "`csrf_token`" + ` CHAR(64) NOT NULL,
			` + "`created_at`" + ` DATETIME NOT NULL,
			` + "`expires_at`" + ` DATETIME NOT NULL,
			` + "`last_seen_at`" + ` DATETIME NOT NULL,
			` + "`ip`" + ` VARCHAR(45) NOT NULL DEFAULT '',
			` + "`user_agent`" + ` VARCHAR(255) NOT NULL DEFAULT '',
			PRIMARY KEY (` + "`id`" + `),
			UNIQUE KEY ` + "`uniq_token`" + ` (` + "`token_hash`" + `),
			KEY ` + "`idx_account`" + ` (` + "`account_id`" + `),
			KEY ` + "`idx_expires`" + ` (` + "`expires_at`" + `)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci`,

		`CREATE TABLE IF NOT EXISTS ` + "`web_audit`" + ` (
			` + "`id`" + ` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
			` + "`at`" + ` DATETIME NOT NULL,
			` + "`actor_account_id`" + ` INT UNSIGNED NOT NULL,
			` + "`actor_name`" + ` VARCHAR(32) NOT NULL DEFAULT '',
			` + "`action`" + ` VARCHAR(64) NOT NULL,
			` + "`target`" + ` VARCHAR(64) NOT NULL DEFAULT '',
			` + "`detail`" + ` TEXT,
			` + "`ip`" + ` VARCHAR(45) NOT NULL DEFAULT '',
			PRIMARY KEY (` + "`id`" + `),
			KEY ` + "`idx_at`" + ` (` + "`at`" + `),
			KEY ` + "`idx_actor`" + ` (` + "`actor_account_id`" + `)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci`,

		// Rate-limit counters, kept in the database so they survive a restart
		// and are shared by every process. One row per event; the kind decides
		// which rule it feeds (failed sign-ins per address, per account, or
		// sign-up submissions per address).
		//
		// Replaces an earlier web_register_attempts table, which only counted
		// successful sign-ups. An install that predates this keeps the old
		// table unused; it can be dropped.
		`CREATE TABLE IF NOT EXISTS ` + "`web_throttle`" + ` (
			` + "`id`" + ` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
			` + "`kind`" + ` VARCHAR(24) NOT NULL,
			` + "`bucket`" + ` VARCHAR(64) NOT NULL,
			` + "`at`" + ` DATETIME NOT NULL,
			PRIMARY KEY (` + "`id`" + `),
			KEY ` + "`idx_lookup`" + ` (` + "`kind`" + `,` + "`bucket`" + `,` + "`at`" + `),
			KEY ` + "`idx_at`" + ` (` + "`at`" + `)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci`,

		// A generated authenticator secret is parked here until the user proves
		// their app produces valid codes for it. Only then does it move into
		// account.security, so a mis-scanned QR code cannot lock an account out.
		`CREATE TABLE IF NOT EXISTS ` + "`web_totp_setup`" + ` (
			` + "`account_id`" + ` INT UNSIGNED NOT NULL,
			` + "`secret`" + ` VARCHAR(64) NOT NULL,
			` + "`created_at`" + ` DATETIME NOT NULL,
			` + "`expires_at`" + ` DATETIME NOT NULL,
			PRIMARY KEY (` + "`account_id`" + `),
			KEY ` + "`idx_expires`" + ` (` + "`expires_at`" + `)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci`,

		// The notice shown on the game client's login screen. Single row, id 1:
		// the client fetches it from a URL baked into a client patch, and there
		// is only ever one such panel.
		`CREATE TABLE IF NOT EXISTS ` + "`web_announcement`" + ` (
			` + "`id`" + ` TINYINT UNSIGNED NOT NULL,
			` + "`enabled`" + ` TINYINT(1) NOT NULL DEFAULT 1,
			` + "`title`" + ` VARCHAR(64) NOT NULL DEFAULT '',
			` + "`body`" + ` TEXT,
			` + "`updated_at`" + ` DATETIME NOT NULL,
			` + "`updated_by`" + ` VARCHAR(32) NOT NULL DEFAULT '',
			PRIMARY KEY (` + "`id`" + `)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci`,
	}

	for _, stmt := range stmts {
		if _, err := s.Logon.ExecContext(ctx, stmt); err != nil {
			return fmt.Errorf("create web tables: %w", err)
		}
	}
	return nil
}

// isDuplicate reports whether err is a MySQL duplicate-key error, so callers
// can map it onto ErrDuplicate.
func isDuplicate(err error) bool {
	var mysqlErr *mysql.MySQLError
	if errors.As(err, &mysqlErr) {
		return mysqlErr.Number == 1062
	}
	return false
}

// nullTime scans a nullable or zero date into a *time.Time.
//
// The core stores '0000-00-00 00:00:00' in several TIMESTAMP columns
// (account.last_login among them). With parseTime=true the driver cannot
// convert that to a time.Time, so those columns are selected as
// NULLIF(col, '0000-00-00 00:00:00').
type nullTime struct {
	Time  time.Time
	Valid bool
}

func (n *nullTime) Scan(v any) error {
	switch t := v.(type) {
	case nil:
		n.Time, n.Valid = time.Time{}, false
	case time.Time:
		n.Time, n.Valid = t, true
	case []byte:
		parsed, err := time.Parse("2006-01-02 15:04:05", string(t))
		if err != nil {
			return err
		}
		n.Time, n.Valid = parsed, true
	default:
		return fmt.Errorf("cannot scan %T into time", v)
	}
	return nil
}

func (n nullTime) Ptr() *time.Time {
	if !n.Valid {
		return nil
	}
	t := n.Time
	return &t
}
