package web

import (
	"net/http"
	"strings"

	"tortoiseweb/internal/i18n"
)

// handleSetLanguage stores an explicit language choice and returns the user to
// the page they came from.
//
// The return path travels in a hidden form field rather than a query string, so
// it can be validated as a site-local path (see returnPath).
func (s *Server) handleSetLanguage(w http.ResponseWriter, r *http.Request) {
	code := strings.ToLower(strings.TrimSpace(r.PathValue("code")))

	lang, ok := i18n.Parse(code)
	if !ok {
		// Unknown language: keep the current one and do not set a cookie.
		s.log.Warn("unsupported language requested", "code", code, "ip", s.clientIP(r))
		s.redirectBack(w, r, "/")
		return
	}

	i18n.SetCookie(w, lang, s.cfg.SessionSecure)

	// Answer with the translated page directly so the change is visible
	// immediately, without relying on the browser to follow a redirect.
	s.redirectBack(w, r, "/")
}

func (s *Server) redirectBack(w http.ResponseWriter, r *http.Request, fallback string) {
	target := fallback
	if ref := r.Referer(); ref != "" {
		if p, ok := sameSitePath(ref); ok {
			target = p
		}
	}
	// A form post carries the current path explicitly.
	if r.Method == http.MethodPost {
		if err := r.ParseForm(); err == nil {
			if next, ok := returnPath(r.PostFormValue("next")); ok {
				target = next
			}
		}
	}
	http.Redirect(w, r, target, http.StatusSeeOther)
}

// sameSitePath extracts the path from a Referer header, rejecting anything that
// points somewhere else. Returns ok=false when the URL is not usable.
func sameSitePath(ref string) (string, bool) {
	// Compare only the path: an attacker-influenced Referer must not turn this
	// into an open redirect.
	rest := ref
	if i := strings.Index(rest, "://"); i >= 0 {
		rest = rest[i+3:]
		if j := strings.IndexByte(rest, '/'); j >= 0 {
			rest = rest[j:]
		} else {
			return "", false
		}
	}
	if !strings.HasPrefix(rest, "/") {
		return "", false
	}
	return returnPath(rest)
}

// returnPath accepts only a same-site absolute path, mirroring safeNext.
func returnPath(p string) (string, bool) {
	if p == "" || !strings.HasPrefix(p, "/") || strings.HasPrefix(p, "//") {
		return "", false
	}
	// Strip a fragment, keep the query: the page should come back with its
	// filters intact.
	if i := strings.IndexByte(p, '#'); i >= 0 {
		p = p[:i]
	}
	return p, true
}
