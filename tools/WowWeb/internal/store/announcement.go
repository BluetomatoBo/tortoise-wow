package store

import (
	"context"
	"database/sql"
	"time"
)

// Announcement is the notice the game client shows on the left of the login
// screen, in the "Server Alert" panel.
//
// The panel is drawn by the client from Interface\GlueXML\AccountLogin.xml
// (ServerAlertFrame) using the text it fetches from the URL in the Lua global
// SERVER_ALERT_URL. That URL is baked into a client patch, so the client can
// only be pointed at this service once; everything after that is this row.
//
// Only one row exists, pinned at id 1.
type Announcement struct {
	// Enabled false serves an empty panel. The client still shows the frame
	// (its visibility is driven by the fetch succeeding), so an empty body is
	// the closest thing to "no announcement".
	Enabled bool

	// Title is unused by the client today: the panel heading comes from the
	// client's own SERVER_ALERT_TITLE string. It is kept so the admin page can
	// label what is being edited, and so a future client patch can use it.
	Title string

	// Body is plain text. The /alert endpoint escapes it and turns newlines
	// into markup, because the client renders it with SimpleHTML and cannot be
	// trusted with arbitrary input.
	Body string

	UpdatedAt time.Time
	UpdatedBy string
}

// Announcement reads the stored notice. A missing row is not an error: it
// returns a disabled announcement, which is what a fresh install should show.
func (s *Store) Announcement(ctx context.Context) (Announcement, error) {
	var (
		a       Announcement
		title   string
		body    sql.NullString
		updAt   sql.NullTime
		updBy   sql.NullString
		enabled bool
	)
	err := s.Logon.QueryRowContext(ctx,
		`SELECT enabled, title, COALESCE(body, ''), updated_at, COALESCE(updated_by, '')
		 FROM web_announcement WHERE id = 1`).
		Scan(&enabled, &title, &body, &updAt, &updBy)
	if err == sql.ErrNoRows {
		return Announcement{}, nil
	}
	if err != nil {
		return Announcement{}, err
	}

	a.Enabled = enabled
	a.Title = title
	a.Body = body.String
	if updAt.Valid {
		a.UpdatedAt = updAt.Time
	}
	a.UpdatedBy = updBy.String
	return a, nil
}

// SaveAnnouncement writes the single announcement row.
func (s *Store) SaveAnnouncement(ctx context.Context, a Announcement, actor string) error {
	_, err := s.Logon.ExecContext(ctx,
		`INSERT INTO web_announcement (id, enabled, title, body, updated_at, updated_by)
		 VALUES (1, ?, ?, ?, NOW(), ?)
		 ON DUPLICATE KEY UPDATE
		   enabled = VALUES(enabled),
		   title   = VALUES(title),
		   body    = VALUES(body),
		   updated_at = VALUES(updated_at),
		   updated_by = VALUES(updated_by)`,
		a.Enabled, truncate(a.Title, 64), a.Body, truncate(actor, 32))
	return err
}
