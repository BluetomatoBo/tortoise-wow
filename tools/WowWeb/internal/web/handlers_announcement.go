package web

import (
	"html"
	"net/http"
	"strconv"
	"strings"

	"tortoiseweb/internal/store"
)

// The game client shows an announcement on the left of the login screen, in a
// panel drawn by Interface\GlueXML\AccountLogin.xml (ServerAlertFrame) from the
// text it fetches over HTTP. The address is the Lua global SERVER_ALERT_URL,
// which lives in a small client patch (see client-patch/ in this repo), so the
// client is pointed at /alert once and this service owns the wording after
// that.
//
// The panel is a SimpleHTML widget, so it understands only a small tag subset:
// it is not a browser. The body is therefore stored as plain text and escaped
// here, never rendered as markup the admin supplied.

// alertDocument wraps escaped body text in the minimal document the client's
// SimpleHTML widget expects.
func alertDocument(body string) string {
	body = strings.ReplaceAll(body, "\r\n", "\n")
	body = strings.ReplaceAll(body, "\r", "\n")
	body = strings.TrimSpace(body)
	if body == "" {
		return "<html><body></body></html>"
	}

	paragraphs := strings.Split(body, "\n\n")
	for i, p := range paragraphs {
		lines := strings.Split(strings.Trim(p, "\n"), "\n")
		for j, line := range lines {
			lines[j] = html.EscapeString(strings.TrimRight(line, " \t"))
		}
		paragraphs[i] = "<p>" + strings.Join(lines, "<br/>") + "</p>"
	}
	return "<html><body>" + strings.Join(paragraphs, "") + "</body></html>"
}

// handleAnnouncement serves the login-screen notice.
//
// It is deliberately outside the session middleware: the game client has no
// cookie jar and sends no headers this service could key on. It is fetched once
// per login screen, so it must stay cheap and must never require state.
func (s *Server) handleAnnouncement(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	ann, err := s.store.Announcement(ctx)
	if err != nil {
		s.log.Warn("load announcement", "err", err)
		http.Error(w, "announcement unavailable", http.StatusInternalServerError)
		return
	}

	body := ""
	if ann.Enabled {
		body = ann.Body
	}

	// The client caches what it fetched; ask it not to, so an edit shows up on
	// the next login rather than whenever the cache happens to expire.
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")
	w.Header().Set("X-Content-Type-Options", "nosniff")
	_, _ = w.Write([]byte(alertDocument(body)))
}

// ---------------------------------------------------------------------------
// Admin
// ---------------------------------------------------------------------------

type adminAnnouncementView struct {
	PageData
	Announcement store.Announcement
	Endpoint     string
	HasBody      bool
}

func (s *Server) handleAdminAnnouncement(w http.ResponseWriter, r *http.Request, page *PageData) {
	ann, err := s.store.Announcement(r.Context())
	if err != nil {
		s.serverError(w, r, "load announcement", err)
		return
	}

	page.Title = page.T("ann.title")
	page.Active = "admin-announcement"
	s.rend.Render(w, http.StatusOK, "admin_announcement", adminAnnouncementView{
		PageData:     *page,
		Announcement: ann,
		Endpoint:     strings.TrimRight(s.cfg.BaseURL, "/") + "/alert",
		HasBody:      strings.TrimSpace(ann.Body) != "",
	})
}

func (s *Server) handleAdminAnnouncementSave(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	// A textarea submits CRLF from Windows clients; normalise once here so the
	// stored value and the rendered output agree with the admin page.
	body := strings.ReplaceAll(r.PostFormValue("body"), "\r\n", "\n")
	body = strings.ReplaceAll(body, "\r", "\n")

	ann := store.Announcement{
		Enabled: r.PostFormValue("enabled") != "",
		Title:   strings.TrimSpace(r.PostFormValue("title")),
		Body:    strings.TrimSpace(body),
	}
	if len(ann.Body) > 20000 {
		ann.Body = ann.Body[:20000]
	}

	if err := s.store.SaveAnnouncement(ctx, ann, actor.Username); err != nil {
		s.serverError(w, r, "save announcement", err)
		return
	}

	detail := "disabled"
	if ann.Enabled {
		detail = "enabled, " + strconv.Itoa(len(ann.Body)) + " bytes"
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "announcement-save", "login-screen",
		detail, s.clientIP(r))

	s.setFlash(w, "ok", page.T("flash.ok.announcementSaved"))
	http.Redirect(w, r, "/admin/announcement", http.StatusSeeOther)
}
