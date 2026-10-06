package web

import (
	"net/http"
	"slices"
	"strings"

	"tortoiseweb/internal/store"
)

// The game client can open exactly two kinds of address, and both end up in the
// same place: the Lua function LaunchURL. It is what the announcement panel's
// links call, and it is what the client's own sign-in failure dialogs call after
// reading one of the AUTH_*_URL strings. So these two pages cover everything the
// client can send a browser to:
//
//   - /notice is where the panel's link points, the announcement for someone
//     with a browser instead of a 320-pixel panel
//   - /account/<reason> backs the sign-in failure dialogs, one page per reason
//     the server can actually report
//
// They are public on purpose. Most of these are reached by someone who cannot
// sign in, so requiring a session would make them useless exactly when they are
// needed. They are also written to say nothing about the realm: a public page
// that describes where the server lives, or how busy it is, is an invitation to
// scan or flood it.

// ---------------------------------------------------------------------------
// /notice
// ---------------------------------------------------------------------------

type noticeView struct {
	PageData
	Announcement store.Announcement
	HasBody      bool
	Paragraphs   []string
	LinkURL      string
}

// handleNotice serves the announcement to a browser.
//
// It reads the same single stored announcement as /alert, and splits it the
// same way, so the two views cannot drift apart: a line that is only an address
// is a link in both. The panel keeps the player on the login screen with a
// summary; this page is where the link takes them.
func (s *Server) handleNotice(w http.ResponseWriter, r *http.Request, page *PageData) {
	ann, err := s.store.Announcement(r.Context())
	if err != nil {
		s.serverError(w, r, "load announcement", err)
		return
	}

	view := noticeView{PageData: *page, Announcement: ann}
	if ann.Enabled {
		for _, line := range noticeLines(ann.Body) {
			if strings.TrimSpace(line) == "" {
				continue
			}
			if url := soleURL(line); url != "" {
				// The first address on its own line is what the panel's link
				// points at, so this page offers the same one.
				if view.LinkURL == "" {
					view.LinkURL = url
				}
				continue
			}
			view.Paragraphs = append(view.Paragraphs, line)
		}
		view.HasBody = len(view.Paragraphs) > 0 || view.LinkURL != ""
	}

	page.Title = page.T("notice.title")
	page.Active = "notice"
	view.PageData = *page
	s.rend.Render(w, http.StatusOK, "notice", view)
}

// ---------------------------------------------------------------------------
// /account/<reason>
// ---------------------------------------------------------------------------

// accountNoticeReasons are the sign-in failures that a client dialog turns into
// a visit here, and they are the ones this server can actually send:
//
//	banned     WOW_FAIL_BANNED, a permanent ban on the account
//	suspended  WOW_FAIL_SUSPENDED, a timed ban, or an IP lock the account does
//	           not satisfy
//	no-time    WOW_FAIL_NO_TIME, the account's coin balance went negative
//	verify     WOW_FAIL_PARENTCONTROL, the e-mail on the account is unverified
//
// The path is the last part of each AUTH_*_URL in the client patch, so the two
// lists have to be kept in step; a test checks that every one of these renders
// and that anything else is a 404.
var accountNoticeReasons = []string{"banned", "suspended", "no-time", "verify"}

type accountNoticeView struct {
	PageData
	Reason string

	// ActionHref is the useful next step for this reason, when there is one.
	// Some reasons are answered by the page itself and offer nothing.
	ActionHref  string
	ActionLabel string
}

// accountNoticeAction returns the one thing worth sending the reader to do, per
// reason. It is a switch rather than a table because each case has its own
// justification; see the reasons list above.
func accountNoticeAction(reason string) (href, labelKey string) {
	switch reason {
	case "suspended":
		// The common cause on this server is an IP lock that the account
		// cannot satisfy: setting up two-factor authentication, or a fixed
		// PIN, is what releases it. That is the one thing the reader can do
		// without asking anybody.
		return "/panel/security", "reason.action.security"
	case "banned":
		// Nothing to fix here - a ban is lifted by an administrator - so the
		// useful destination is whatever the server last announced.
		return "/notice", "reason.action.notice"
	default:
		// An unverified address and a negative balance both need an
		// administrator; the page already offers sign-in and registration.
		return "", ""
	}
}

func (s *Server) handleAccountNotice(w http.ResponseWriter, r *http.Request, page *PageData) {
	reason := r.PathValue("reason")
	if !slices.Contains(accountNoticeReasons, reason) {
		s.notFound(w, r)
		return
	}

	href, labelKey := accountNoticeAction(reason)
	page.Title = page.T("reason." + reason + ".title")
	page.Active = "reason"
	s.rend.Render(w, http.StatusOK, "account_notice", accountNoticeView{
		PageData:    *page,
		Reason:      reason,
		ActionHref:  href,
		ActionLabel: page.T(labelKey),
	})
}
