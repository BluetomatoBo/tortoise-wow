package web

import (
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"log/slog"
	"net"
	"net/http"
	"strings"
	"sync"
	"time"

	"tortoiseweb/internal/config"
	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

const sessionCookieName = "tw_session"

type Server struct {
	cfg    config.Config
	store  *store.Store
	log    *slog.Logger
	rend   *renderer
	mux    *http.ServeMux
	i18n   *i18n.Bundle
	defLng i18n.Lang

	// warnProxyHeaders keeps the misconfiguration warning below to one line per
	// process: the condition it describes holds for every single request.
	warnProxyHeaders sync.Once
}

func New(cfg config.Config, st *store.Store, log *slog.Logger) (*Server, error) {
	rend, err := newRenderer()
	if err != nil {
		return nil, err
	}

	bundle, err := i18n.Load()
	if err != nil {
		return nil, fmt.Errorf("load translations: %w", err)
	}

	defLang := i18n.Lang(cfg.DefaultLang)
	if defLang == "" {
		defLang = i18n.Default
	}

	s := &Server{
		cfg:    cfg,
		store:  st,
		log:    log,
		rend:   rend,
		mux:    http.NewServeMux(),
		i18n:   bundle,
		defLng: defLang,
	}
	s.routes()
	return s, nil
}

func (s *Server) Handler() http.Handler {
	return s.recoverer(s.mux)
}

// ---------------------------------------------------------------------------
// Routes
// ---------------------------------------------------------------------------

func (s *Server) routes() {
	// Static assets
	assets, _ := fs.Sub(templateFS, "assets")
	s.mux.Handle("GET /assets/",
		http.StripPrefix("/assets/", cacheStatic(http.FileServerFS(assets))))

	// Public
	s.mux.HandleFunc("GET /{$}", s.public(s.handleHome))
	s.mux.HandleFunc("GET /healthz", s.handleHealth)
	s.mux.HandleFunc("GET /api/status", s.handleAPIStatus)

	// The game client's login-screen notice. Fetched by the client, not a
	// browser, so it sits outside the session middleware on purpose: there is
	// no cookie to key a session on.
	s.mux.HandleFunc("GET /alert", s.handleAnnouncement)

	// Where the client's links land. Both are fetched by a browser that the
	// client opened, usually for someone who cannot sign in, so they are public
	// for the same reason /alert is. See handlers_notice.go.
	s.mux.HandleFunc("GET /notice", s.public(s.handleNotice))
	s.mux.HandleFunc("GET /account/{reason}", s.public(s.handleAccountNotice))

	s.mux.HandleFunc("GET /register", s.public(s.handleRegisterForm))
	s.mux.HandleFunc("POST /register", s.public(s.handleRegisterSubmit))
	s.mux.HandleFunc("GET /login", s.public(s.handleLoginForm))
	s.mux.HandleFunc("POST /login", s.public(s.handleLoginSubmit))
	s.mux.HandleFunc("POST /logout", s.public(s.handleLogout))

	// Language switcher. POST because it changes state (the cookie), GET so a
	// plain link works without JavaScript.
	s.mux.HandleFunc("GET /lang/{code}", s.handleSetLanguage)
	s.mux.HandleFunc("POST /lang/{code}", s.handleSetLanguage)

	// The database browser. Public on purpose: it reads nothing but the content
	// tables the client itself is served from. See handlers_db.go.
	s.mux.HandleFunc("GET /db", s.public(s.handleDBHome))
	s.mux.HandleFunc("GET /db/search", s.public(s.handleDBSearch))
	s.mux.HandleFunc("GET /db/items", s.public(s.handleDBItems))
	s.mux.HandleFunc("GET /db/items/{entry}", s.public(s.handleDBItem))
	// The hover tooltip. A fragment rather than a page: it is fetched by
	// assets/db-tooltip.js and dropped next to the link being hovered.
	s.mux.HandleFunc("GET /db/items/{entry}/tooltip", s.public(s.handleDBItemTooltip))
	s.mux.HandleFunc("GET /db/spells", s.public(s.handleDBSpells))
	s.mux.HandleFunc("GET /db/spells/{entry}", s.public(s.handleDBSpell))
	s.mux.HandleFunc("GET /db/quests", s.public(s.handleDBQuests))
	s.mux.HandleFunc("GET /db/quests/{entry}", s.public(s.handleDBQuest))
	s.mux.HandleFunc("GET /db/npcs", s.public(s.handleDBCreatures))
	s.mux.HandleFunc("GET /db/npcs/{entry}", s.public(s.handleDBCreature))
	s.mux.HandleFunc("GET /db/objects", s.public(s.handleDBObjects))
	s.mux.HandleFunc("GET /db/objects/{entry}", s.public(s.handleDBObject))

	// Player area
	s.mux.HandleFunc("GET /panel", s.player(s.handlePanel))
	s.mux.HandleFunc("GET /panel/password", s.player(s.handlePasswordForm))
	s.mux.HandleFunc("POST /panel/password", s.player(s.handlePasswordSubmit))
	s.mux.HandleFunc("GET /panel/characters", s.player(s.handlePanelCharacters))
	s.mux.HandleFunc("POST /panel/characters/{guid}/unstick", s.player(s.handlePanelUnstick))
	s.mux.HandleFunc("GET /panel/security", s.player(s.handleSecurity))
	s.mux.HandleFunc("POST /panel/security/enable", s.player(s.handleSecurityEnable))
	s.mux.HandleFunc("POST /panel/security/confirm", s.player(s.handleSecurityConfirm))
	s.mux.HandleFunc("POST /panel/security/disable", s.player(s.handleSecurityDisable))
	s.mux.HandleFunc("POST /panel/security/revoke", s.player(s.handleSecurityRevokeIP))
	s.mux.HandleFunc("GET /panel/sessions", s.player(s.handlePanelSessions))
	s.mux.HandleFunc("POST /panel/sessions/revoke", s.player(s.handleSessionRevoke))

	// Administration
	s.mux.HandleFunc("GET /admin", s.admin(s.handleAdminDashboard))
	s.mux.HandleFunc("GET /admin/accounts", s.admin(s.handleAdminAccounts))
	s.mux.HandleFunc("GET /admin/accounts/new", s.admin(s.handleAdminAccountNewForm))
	s.mux.HandleFunc("POST /admin/accounts/new", s.admin(s.handleAdminAccountNewSubmit))
	s.mux.HandleFunc("GET /admin/accounts/{id}", s.admin(s.handleAdminAccountDetail))
	s.mux.HandleFunc("POST /admin/accounts/{id}/rank", s.admin(s.handleAdminSetRank))
	s.mux.HandleFunc("POST /admin/accounts/{id}/password", s.admin(s.handleAdminResetPassword))
	s.mux.HandleFunc("POST /admin/accounts/{id}/email", s.admin(s.handleAdminSetEmail))
	s.mux.HandleFunc("POST /admin/accounts/{id}/active", s.admin(s.handleAdminSetActive))
	s.mux.HandleFunc("POST /admin/accounts/{id}/ban", s.admin(s.handleAdminBan))
	s.mux.HandleFunc("POST /admin/accounts/{id}/unban", s.admin(s.handleAdminUnban))
	s.mux.HandleFunc("POST /admin/accounts/{id}/mute", s.admin(s.handleAdminMute))
	s.mux.HandleFunc("POST /admin/accounts/{id}/unmute", s.admin(s.handleAdminUnmute))
	s.mux.HandleFunc("POST /admin/accounts/{id}/reset-2fa", s.admin(s.handleAdminReset2FA))
	s.mux.HandleFunc("POST /admin/accounts/{id}/delete", s.admin(s.handleAdminDeleteAccount))

	s.mux.HandleFunc("GET /admin/characters", s.admin(s.handleAdminCharacters))
	s.mux.HandleFunc("GET /admin/characters/{guid}", s.admin(s.handleAdminCharacterDetail))
	s.mux.HandleFunc("POST /admin/characters/{guid}/rename", s.admin(s.handleAdminCharacterRename))
	s.mux.HandleFunc("POST /admin/characters/{guid}/unstick", s.admin(s.handleAdminCharacterUnstick))
	s.mux.HandleFunc("POST /admin/characters/{guid}/atlogin", s.admin(s.handleAdminCharacterAtLogin))
	s.mux.HandleFunc("POST /admin/characters/{guid}/level", s.admin(s.handleAdminCharacterLevel))

	s.mux.HandleFunc("GET /admin/bans", s.admin(s.handleAdminBans))
	s.mux.HandleFunc("POST /admin/bans/ip", s.admin(s.handleAdminBanIP))
	s.mux.HandleFunc("POST /admin/bans/ip/remove", s.admin(s.handleAdminUnbanIP))

	// Donation shop (world database: shop_categories / shop_items).
	s.mux.HandleFunc("GET /admin/shop", s.admin(s.handleAdminShop))
	s.mux.HandleFunc("GET /admin/shop/new", s.admin(s.handleAdminShopNewForm))
	s.mux.HandleFunc("POST /admin/shop/new", s.admin(s.handleAdminShopNewSubmit))
	s.mux.HandleFunc("GET /admin/shop/items/{id}", s.admin(s.handleAdminShopItemForm))
	s.mux.HandleFunc("POST /admin/shop/items/{id}", s.admin(s.handleAdminShopItemSubmit))
	s.mux.HandleFunc("POST /admin/shop/items/{id}/delete", s.admin(s.handleAdminShopItemDelete))

	// Shop categories. Deleting one is refused while items point at it.
	s.mux.HandleFunc("GET /admin/shop/categories", s.admin(s.handleAdminShopCategories))
	s.mux.HandleFunc("GET /admin/shop/categories/new", s.admin(s.handleAdminShopCategoryNewForm))
	s.mux.HandleFunc("POST /admin/shop/categories/new", s.admin(s.handleAdminShopCategoryNewSubmit))
	s.mux.HandleFunc("GET /admin/shop/categories/{id}", s.admin(s.handleAdminShopCategoryForm))
	s.mux.HandleFunc("POST /admin/shop/categories/{id}", s.admin(s.handleAdminShopCategorySubmit))
	s.mux.HandleFunc("POST /admin/shop/categories/{id}/delete", s.admin(s.handleAdminShopCategoryDelete))

	s.mux.HandleFunc("GET /admin/announcement", s.admin(s.handleAdminAnnouncement))
	s.mux.HandleFunc("POST /admin/announcement", s.admin(s.handleAdminAnnouncementSave))

	s.mux.HandleFunc("GET /admin/realms", s.admin(s.handleAdminRealms))
	s.mux.HandleFunc("POST /admin/realms/{id}", s.admin(s.handleAdminRealmUpdate))
	s.mux.HandleFunc("POST /admin/realms/{id}/flags", s.admin(s.handleAdminRealmFlags))
	s.mux.HandleFunc("POST /admin/realms/{id}/security", s.admin(s.handleAdminRealmSecurity))

	s.mux.HandleFunc("GET /admin/audit", s.admin(s.handleAdminAudit))
}

// ---------------------------------------------------------------------------
// Context plumbing
// ---------------------------------------------------------------------------

type ctxKey int

const (
	ctxKeySession ctxKey = iota
	ctxKeyAccount
	ctxKeyFlash
)

func sessionFrom(ctx context.Context) *store.WebSession {
	s, _ := ctx.Value(ctxKeySession).(*store.WebSession)
	return s
}

func accountFrom(ctx context.Context) *store.Account {
	a, _ := ctx.Value(ctxKeyAccount).(*store.Account)
	return a
}

// ---------------------------------------------------------------------------
// Middleware
// ---------------------------------------------------------------------------

// loadSession resolves the session cookie (when present) and puts the session
// and account into the request context. It never rejects: handlers decide
// whether authentication is required.
func (s *Server) loadSession(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()

		if cookie, err := r.Cookie(sessionCookieName); err == nil && cookie.Value != "" {
			sess, err := s.store.SessionByToken(ctx, cookie.Value)
			if err == nil {
				acct, err := s.store.AccountByID(ctx, sess.AccountID)
				if err == nil && acct.Active {
					ctx = context.WithValue(ctx, ctxKeySession, sess)
					ctx = context.WithValue(ctx, ctxKeyAccount, acct)
				} else {
					// Account vanished or was disabled: drop the cookie.
					s.clearSessionCookie(w)
				}
			} else if !errors.Is(err, store.ErrNotFound) {
				s.log.Error("session lookup failed", "err", err)
			}
		}

		if flashes := s.readFlash(w, r); len(flashes) > 0 {
			ctx = context.WithValue(ctx, ctxKeyFlash, flashes)
		}
		next(w, r.WithContext(ctx))
	}
}

// player requires an authenticated account.
func (s *Server) player(next func(http.ResponseWriter, *http.Request, *PageData)) http.HandlerFunc {
	return s.loadSession(func(w http.ResponseWriter, r *http.Request) {
		acct := accountFrom(r.Context())
		if acct == nil {
			s.redirectToLogin(w, r)
			return
		}
		page := s.basePage(r, acct, false)
		next(w, r, page)
	})
}

// admin requires an authenticated account with a sufficient rank.
func (s *Server) admin(next func(http.ResponseWriter, *http.Request, *PageData)) http.HandlerFunc {
	return s.loadSession(func(w http.ResponseWriter, r *http.Request) {
		acct := accountFrom(r.Context())
		if acct == nil {
			s.redirectToLogin(w, r)
			return
		}
		if acct.Rank < uint8(s.cfg.AdminMinRank) {
			s.log.Warn("admin access denied",
				"account", acct.Username, "rank", acct.Rank,
				"need", s.cfg.AdminMinRank, "path", r.URL.Path)
			page := s.basePage(r, acct, false)
			page.Title = page.T("err.forbidden")
			page.addFlash("error", page.T("err.rankTooLow"))
			s.rend.Render(w, http.StatusForbidden, "error", page)
			return
		}
		page := s.basePage(r, acct, true)
		next(w, r, page)
	})
}

// public wraps handlers that work with or without a session.
func (s *Server) public(next func(http.ResponseWriter, *http.Request, *PageData)) http.HandlerFunc {
	return s.loadSession(func(w http.ResponseWriter, r *http.Request) {
		acct := accountFrom(r.Context())
		page := s.basePage(r, acct, acct != nil && acct.Rank >= uint8(s.cfg.AdminMinRank))
		next(w, r, page)
	})
}

func (s *Server) basePage(r *http.Request, acct *store.Account, isAdmin bool) *PageData {
	page := &PageData{
		Account: acct,
		IsAdmin: isAdmin,
		Year:    time.Now().Year(),
		Tr:      s.i18n.Translator(i18n.Detect(r, s.defLng)),
		Langs:   i18n.Supported,
		Config: PageConfig{
			SiteName:        s.cfg.RealmName,
			RealmName:       s.cfg.RealmName,
			RealmID:         s.cfg.RealmID,
			WorldAddress:    s.worldAddress(),
			WorldPort:       s.cfg.WorldPort,
			RealmPort:       s.cfg.RealmPort,
			AllowRegister:   s.cfg.AllowRegister,
			RequireEmail:    s.cfg.RequireEmail,
			DefaultLang:     s.cfg.DefaultLang,
			AdminMinRank:    s.cfg.AdminMinRank,
			SessionTTLHours: int(s.cfg.SessionTTL.Hours()),
			PasswordMinLen:  s.cfg.PasswordMinLen,
		},
	}
	if sess := sessionFrom(r.Context()); sess != nil {
		page.CSRFToken = sess.CSRFToken
	}
	if flashes, ok := r.Context().Value(ctxKeyFlash).([]Flash); ok {
		page.Flash = flashes
	}
	return page
}

func (s *Server) worldAddress() string {
	if s.cfg.WorldAddress != "" {
		return s.cfg.WorldAddress
	}
	return "(not configured)"
}

func (s *Server) redirectToLogin(w http.ResponseWriter, r *http.Request) {
	target := "/panel"
	if strings.HasPrefix(r.URL.Path, "/admin") {
		target = r.URL.Path
	}
	http.Redirect(w, r, "/login?next="+urlQueryEscape(target), http.StatusSeeOther)
}

// recoverer turns a panic into a 500 instead of killing the process.
func (s *Server) recoverer(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if rec := recover(); rec != nil {
				s.log.Error("panic serving request",
					"path", r.URL.Path, "panic", rec)
				http.Error(w, "internal server error", http.StatusInternalServerError)
			}
		}()
		next.ServeHTTP(w, r)
	})
}

// ---------------------------------------------------------------------------
// CSRF
// ---------------------------------------------------------------------------

// checkCSRF validates the double-submit token for state changing requests.
//
// Every POST form embeds the session's CSRF token; a request without a matching
// token is rejected. Requests that arrive without a session are rejected too,
// because there is nothing to compare against.
func (s *Server) checkCSRF(w http.ResponseWriter, r *http.Request) bool {
	sess := sessionFrom(r.Context())
	if sess == nil {
		http.Error(w, "no session", http.StatusForbidden)
		return false
	}
	if err := r.ParseForm(); err != nil {
		http.Error(w, "bad form", http.StatusBadRequest)
		return false
	}
	token := r.PostFormValue("csrf_token")
	if token == "" {
		token = r.Header.Get("X-CSRF-Token")
	}
	if subtleCompare(token, sess.CSRFToken) {
		return true
	}
	s.log.Warn("csrf check failed", "path", r.URL.Path, "ip", s.clientIP(r))
	http.Error(w, "CSRF token mismatch", http.StatusForbidden)
	return false
}

func subtleCompare(a, b string) bool {
	if len(a) != len(b) || a == "" {
		return false
	}
	var diff byte
	for i := 0; i < len(a); i++ {
		diff |= a[i] ^ b[i]
	}
	return diff == 0
}

// ---------------------------------------------------------------------------
// Session cookie helpers
// ---------------------------------------------------------------------------

func (s *Server) setSessionCookie(w http.ResponseWriter, token string) {
	http.SetCookie(w, &http.Cookie{
		Name:     sessionCookieName,
		Value:    token,
		Path:     "/",
		HttpOnly: true,
		Secure:   s.cfg.SessionSecure,
		SameSite: http.SameSiteLaxMode,
		Expires:  time.Now().Add(s.cfg.SessionTTL),
		MaxAge:   int(s.cfg.SessionTTL.Seconds()),
	})
}

func (s *Server) clearSessionCookie(w http.ResponseWriter) {
	http.SetCookie(w, &http.Cookie{
		Name:     sessionCookieName,
		Value:    "",
		Path:     "/",
		HttpOnly: true,
		Secure:   s.cfg.SessionSecure,
		SameSite: http.SameSiteLaxMode,
		MaxAge:   -1,
	})
}

// ---------------------------------------------------------------------------
// Flash messages
// ---------------------------------------------------------------------------

const flashCookieName = "tw_flash"

// setFlash stores a short-lived message in a cookie so the next request can
// display it after a redirect.
func (s *Server) setFlash(w http.ResponseWriter, kind, message string) {
	if message == "" {
		return
	}
	payload, err := json.Marshal([]Flash{{Kind: kind, Message: message}})
	if err != nil {
		return
	}
	http.SetCookie(w, &http.Cookie{
		Name:     flashCookieName,
		Value:    base64.RawURLEncoding.EncodeToString(payload),
		Path:     "/",
		HttpOnly: true,
		Secure:   s.cfg.SessionSecure,
		SameSite: http.SameSiteLaxMode,
		MaxAge:   60,
	})
}

func (s *Server) readFlash(w http.ResponseWriter, r *http.Request) []Flash {
	cookie, err := r.Cookie(flashCookieName)
	if err != nil || cookie.Value == "" {
		return nil
	}
	// Consume it: clear the cookie so the message shows exactly once.
	http.SetCookie(w, &http.Cookie{
		Name: flashCookieName, Value: "", Path: "/",
		HttpOnly: true, Secure: s.cfg.SessionSecure,
		SameSite: http.SameSiteLaxMode, MaxAge: -1,
	})

	raw, err := base64.RawURLEncoding.DecodeString(cookie.Value)
	if err != nil {
		return nil
	}
	var flashes []Flash
	if err := json.Unmarshal(raw, &flashes); err != nil {
		return nil
	}
	// Only allow the three known kinds, so a tampered cookie cannot inject
	// arbitrary CSS classes into the page.
	for i := range flashes {
		switch flashes[i].Kind {
		case "ok", "error", "info":
		default:
			flashes[i].Kind = "info"
		}
	}
	return flashes
}

// ---------------------------------------------------------------------------
// Small helpers
// ---------------------------------------------------------------------------

// clientIP returns the address of the caller, honouring the forwarding headers
// only when the deployment says a proxy this host controls is in front
// (WEB_TRUST_PROXY=1).
//
// Which end of X-Forwarded-For counts is the whole question here. Proxies
// append the address they actually saw to the right of whatever the client sent,
// so with the usual setup - nginx's $proxy_add_x_forwarded_for, HAProxy's
// `option forwardfor` - the last entry is the peer the proxy talked to and
// everything to its left is client-supplied. Taking the *leftmost* entry instead
// hands the caller a free choice of identity: one request with
// `X-Forwarded-For: 1.2.3.4` and the sign-in and sign-up throttles, the audit
// log and the stored session all record 1.2.3.4, which is a different bucket on
// every request.
//
// X-Real-IP is the fallback for proxies that set only that one. Values that are
// not addresses are ignored rather than returned, so a junk header cannot put
// prose in the audit log or overrun the width of a throttle key.
func (s *Server) clientIP(r *http.Request) string {
	if s.cfg.TrustProxy {
		chain := strings.Split(r.Header.Get("X-Forwarded-For"), ",")
		for i := len(chain) - 1; i >= 0; i-- {
			if ip := parseForwardedIP(chain[i]); ip != "" {
				return ip
			}
		}
		if ip := parseForwardedIP(r.Header.Get("X-Real-IP")); ip != "" {
			return ip
		}
	}
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		host = r.RemoteAddr
	}
	if !s.cfg.TrustProxy {
		s.warnIfProxyHeadersIgnored(r, host)
	}
	return host
}

// warnIfProxyHeadersIgnored says so, once, when requests look like they come
// through a proxy but the app has been told to ignore the proxy's headers.
//
// Without it the only symptom is that every player is recorded as the proxy's
// address - the throttle buckets them together and the audit log stops telling
// them apart - which is easy to miss until someone is locked out.
func (s *Server) warnIfProxyHeadersIgnored(r *http.Request, peer string) {
	if r.Header.Get("X-Forwarded-For") == "" && r.Header.Get("X-Real-IP") == "" {
		return
	}
	ip := net.ParseIP(peer)
	if ip == nil || !(ip.IsLoopback() || ip.IsPrivate() || ip.IsLinkLocalUnicast() || ip.IsUnspecified()) {
		return
	}
	if s.log == nil {
		return
	}
	s.warnProxyHeaders.Do(func() {
		s.log.Warn("forwarding headers are being ignored",
			"peer", peer,
			"hint", "this host looks like it sits behind a proxy; set WEB_TRUST_PROXY=1 so the throttles, the audit log and the session list see the real client address")
	})
}

// parseForwardedIP accepts a bare address as well as the "host:port" and
// "[v6]:port" shapes some proxies write, and returns "" for anything that is not
// an address at all. The canonical spelling is returned so that two ways of
// writing one address cannot end up in two throttle buckets.
func parseForwardedIP(v string) string {
	v = strings.TrimSpace(v)
	if v == "" {
		return ""
	}
	if ip := net.ParseIP(v); ip != nil {
		return ip.String()
	}
	if host, _, err := net.SplitHostPort(v); err == nil {
		if ip := net.ParseIP(host); ip != nil {
			return ip.String()
		}
	}
	return ""
}

// sameIP reports whether two strings name the same address, comparing the parsed
// values so that the spelling differences canonicalisation introduces (IPv6
// zero compression, IPv4-mapped forms) do not make one address look like two.
func sameIP(a, b string) bool {
	ia, ib := net.ParseIP(a), net.ParseIP(b)
	if ia == nil || ib == nil {
		return a == b
	}
	return ia.Equal(ib)
}

func (s *Server) parseUintPath(r *http.Request, name string) (uint32, bool) {
	raw := r.PathValue(name)
	if raw == "" {
		return 0, false
	}
	var v uint64
	for _, ch := range raw {
		if ch < '0' || ch > '9' {
			return 0, false
		}
		v = v*10 + uint64(ch-'0')
		if v > 1<<32-1 {
			return 0, false
		}
	}
	return uint32(v), true
}

func (s *Server) writeJSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	enc := json.NewEncoder(w)
	enc.SetIndent("", "  ")
	_ = enc.Encode(v)
}

func (s *Server) serverError(w http.ResponseWriter, r *http.Request, msg string, err error) {
	s.log.Error(msg, "path", r.URL.Path, "err", err)
	page := s.basePage(r, accountFrom(r.Context()), false)
	page.Title = page.T("err.serverError")
	page.addFlash("error", page.T("err.serverErrorHint"))
	s.rend.Render(w, http.StatusInternalServerError, "error", page)
}

func (s *Server) notFound(w http.ResponseWriter, r *http.Request) {
	page := s.basePage(r, accountFrom(r.Context()), false)
	page.Title = page.T("err.notFound")
	page.addFlash("error", page.T("err.notFoundHint"))
	s.rend.Render(w, http.StatusNotFound, "error", page)
}

func urlQueryEscape(s string) string {
	var b strings.Builder
	for _, r := range s {
		switch {
		case r >= 'a' && r <= 'z', r >= 'A' && r <= 'Z', r >= '0' && r <= '9',
			r == '-', r == '_', r == '.', r == '~', r == '/':
			b.WriteRune(r)
		default:
			b.WriteString("%")
			const hexDigits = "0123456789ABCDEF"
			b.WriteByte(hexDigits[r>>4&0xF])
			b.WriteByte(hexDigits[r&0xF])
		}
	}
	return b.String()
}

// contextWithTimeout derives a context with a deadline from the request.
func contextWithTimeout(r *http.Request, d time.Duration) (context.Context, context.CancelFunc) {
	return context.WithTimeout(r.Context(), d)
}

func cacheStatic(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Cache-Control", "public, max-age=3600")
		next.ServeHTTP(w, r)
	})
}
