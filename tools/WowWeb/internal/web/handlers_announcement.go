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

// The game client is strict about the shape of this response and gives no sign
// when it dislikes it: the 1.12 client's ServerAlertService parses the body,
// looks for this prefix at the very start, and discards the whole response if it
// is missing. The panel then simply never appears.
//
//	constexpr std::string_view kServerAlertPrefix = "SERVERALERT:";
//	if (StartsWithIgnoreCaseAscii(response_body, kServerAlertPrefix)) {
//	    return kServerAlertPrefix.size();   // everything after it is the alert
//	}
//	return npos;                            // -> no alert at all
//
// The prefix may be preceded by a UTF-8 BOM, and is matched case-insensitively;
// sending it directly is the simple case.
const serverAlertPrefix = "SERVERALERT:"

// serverAlertCapacity is the client's buffer for this response, so the payload
// has to fit inside it. Anything longer is silently truncated by the client,
// which can cut the trailing HTML tags off.
//
//	constexpr std::size_t kServerAlertBufferCapacity = 2047;
const serverAlertCapacity = 2047

// alertDocument turns the stored plain text into what the client renders.
//
// Two rules, both learned the hard way:
//
//  1. The body must start with the SERVERALERT: prefix or the client discards
//     the whole response and the panel never appears.
//
//  2. The markup is parsed **line by line**. Tags packed onto one line with the
//     text are not recognised, and the client renders them literally - an
//     announcement written as "<html><body><p>text</p></body></html>" shows up
//     as exactly that, tags and all. Every tag gets its own line here, which is
//     how the client's own HTML files are written (see its
//     Interface\GlueXML\connection-help.html, loaded into the same
//     SimpleHTML widget) and how the pages that worked in the wild were
//     written too.
//
// One paragraph per input line, and a <br/> on its own line for a blank one.
func alertDocument(body string) string {
	var b strings.Builder
	b.WriteString(serverAlertPrefix)
	b.WriteString("<html>\n<body>\n")

	text := strings.ReplaceAll(body, "\r\n", "\n")
	text = strings.ReplaceAll(text, "\r", "\n")

	wrote := false
	for _, line := range strings.Split(text, "\n") {
		line = strings.TrimRight(line, " \t")
		if strings.TrimSpace(line) == "" {
			// A blank line reads as spacing between paragraphs. Skipped
			// before the first paragraph so the panel does not open with a
			// gap.
			if wrote {
				b.WriteString("<br/>\n")
			}
			continue
		}
		b.WriteString("<p>")
		b.WriteString(html.EscapeString(line))
		b.WriteString("</p>\n")
		wrote = true
	}

	b.WriteString("</body>\n</html>\n")
	return b.String()
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

	// Log who fetched it. This endpoint is hit by the game client rather than a
	// browser, so when the login-screen panel stays empty the only way to tell
	// "the client never asked" from "the client asked and disliked the answer"
	// is to see whether a request arrived at all - and from where.
	s.log.Info("announcement fetched",
		"ip", s.clientIP(r),
		"ua", r.UserAgent(),
		"proto", r.Proto,
		"enabled", ann.Enabled,
		"bytes", len(body))

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

	// RenderedSize is what the client would actually receive, and Capacity is
	// the client's buffer. The panel is only ever a few lines tall, and the
	// client truncates silently, so the admin needs to see when the text has
	// outgrown what can be delivered.
	RenderedSize int
	Capacity     int
	TooLong      bool
}

func (s *Server) handleAdminAnnouncement(w http.ResponseWriter, r *http.Request, page *PageData) {
	ann, err := s.store.Announcement(r.Context())
	if err != nil {
		s.serverError(w, r, "load announcement", err)
		return
	}

	rendered := len(alertDocument(ann.Body))

	page.Title = page.T("ann.title")
	page.Active = "admin-announcement"
	s.rend.Render(w, http.StatusOK, "admin_announcement", adminAnnouncementView{
		PageData:     *page,
		Announcement: ann,
		Endpoint:     strings.TrimRight(s.cfg.BaseURL, "/") + "/alert",
		HasBody:      strings.TrimSpace(ann.Body) != "",
		RenderedSize: rendered,
		Capacity:     serverAlertCapacity,
		TooLong:      rendered > serverAlertCapacity,
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
