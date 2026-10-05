package web

import (
	"errors"
	"fmt"
	"net/http"
	"net/mail"
	"strings"
	"time"

	"tortoiseweb/internal/gamepwd"
	"tortoiseweb/internal/store"
)

const minAccountNameLen = 3

// ---------------------------------------------------------------------------
// Home / status
// ---------------------------------------------------------------------------

type homeView struct {
	PageData
	Stats      store.ServerStats
	Realms     []store.Realm
	RealmCount int
}

func (s *Server) handleHome(w http.ResponseWriter, r *http.Request, page *PageData) {
	page.Title = "Home"
	page.Active = "home"

	// Server state and connection details are for signed-in players only, so
	// the queries are skipped entirely for everyone else rather than being
	// loaded and then hidden by the template.
	view := homeView{PageData: *page}
	if page.Account != nil {
		ctx := r.Context()
		stats, err := s.store.Stats(ctx)
		if err != nil {
			s.serverError(w, r, "load stats", err)
			return
		}
		realms, err := s.store.Realms(ctx)
		if err != nil {
			s.serverError(w, r, "load realms", err)
			return
		}
		view.Stats = stats
		view.Realms = realms
		view.RealmCount = len(realms)
	}

	s.rend.Render(w, http.StatusOK, "home", view)
}

func (s *Server) handleHealth(w http.ResponseWriter, r *http.Request) {
	ctx, cancel := contextWithTimeout(r, 3*time.Second)
	defer cancel()

	status := map[string]any{"status": "ok"}
	if err := s.store.Logon.PingContext(ctx); err != nil {
		status["status"] = "degraded"
		status["logon"] = err.Error()
	}
	if err := s.store.Char.PingContext(ctx); err != nil {
		status["status"] = "degraded"
		status["characters"] = err.Error()
	}

	code := http.StatusOK
	if status["status"] != "ok" {
		code = http.StatusServiceUnavailable
	}
	s.writeJSON(w, code, status)
}

// handleAPIStatus is a small JSON endpoint for external monitoring or a Discord
// bot.
//
// It is anonymous by design, so it deliberately does not carry the realm's
// address or port. Those are the one thing on this site worth hiding from a
// stranger: a public list of where the realm lives is an invitation to scan or
// flood it. Signed-in players get them on the home page instead. The fields
// that remain describe load and liveness, which is what a status widget or a
// monitoring probe actually needs.
func (s *Server) handleAPIStatus(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	stats, err := s.store.Stats(ctx)
	if err != nil {
		s.writeJSON(w, http.StatusInternalServerError, map[string]string{"error": err.Error()})
		return
	}
	realms, err := s.store.Realms(ctx)
	if err != nil {
		s.writeJSON(w, http.StatusInternalServerError, map[string]string{"error": err.Error()})
		return
	}

	type realmJSON struct {
		ID         uint32  `json:"id"`
		Name       string  `json:"name"`
		Population float64 `json:"population"`
		Flags      uint8   `json:"realmflags"`
		Online     bool    `json:"online"`
	}
	out := make([]realmJSON, 0, len(realms))
	for _, rlm := range realms {
		out = append(out, realmJSON{
			ID: rlm.ID, Name: rlm.Name,
			Population: rlm.Population, Flags: rlm.Flags,
			// realmd marks a realm offline in the flag bit when the world
			// server is not connected.
			Online: rlm.Flags&store.RealmFlagOffline == 0,
		})
	}

	s.writeJSON(w, http.StatusOK, map[string]any{
		"realm_name":     s.cfg.RealmName,
		"accounts":       stats.Accounts,
		"characters":     stats.Characters,
		"players_online": stats.OnlineChars,
		"guilds":         stats.Guilds,
		"realms":         out,
		"registration":   s.cfg.AllowRegister,
	})
}

// ---------------------------------------------------------------------------
// Registration
// ---------------------------------------------------------------------------

type registerView struct {
	PageData
	Form struct {
		Username string
		Email    string
	}
}

func (s *Server) handleRegisterForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	if acct := accountFrom(r.Context()); acct != nil {
		http.Redirect(w, r, "/panel", http.StatusSeeOther)
		return
	}
	if !s.cfg.AllowRegister {
		page.Title = page.T("flash.registerClosed")
		page.addFlash("info", page.T("flash.registerClosed"))
		s.rend.Render(w, http.StatusForbidden, "error", page)
		return
	}
	page.Title = "Create account"
	page.Active = "register"
	s.rend.Render(w, http.StatusOK, "register", registerView{PageData: *page})
}

func (s *Server) handleRegisterSubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.cfg.AllowRegister {
		http.Error(w, "registration disabled", http.StatusForbidden)
		return
	}
	if err := r.ParseForm(); err != nil {
		http.Error(w, "bad form", http.StatusBadRequest)
		return
	}

	ctx := r.Context()
	ip := s.clientIP(r)

	username := strings.TrimSpace(r.PostFormValue("username"))
	password := r.PostFormValue("password")
	confirm := r.PostFormValue("password2")
	email := strings.TrimSpace(r.PostFormValue("email"))

	view := registerView{PageData: *page}
	view.Title = "Create account"
	view.Active = "register"
	view.Form.Username = username
	view.Form.Email = email

	renderErr := func(msg string) {
		view.addFlash("error", msg)
		s.rend.Render(w, http.StatusBadRequest, "register", view)
	}

	// Rate limit by address, checked before any validation work so an abusive
	// client gets the cheapest possible answer.
	//
	// The attempt is recorded below regardless of how it ends. Counting only
	// successful sign-ups - which an earlier version did - leaves the two
	// cheaper abuses wide open: probing which names are free, and hammering the
	// validation.
	blocked, terr := s.registerThrottle(ctx, ip)
	if terr != nil {
		s.noteThrottleCheckFailure("register", terr)
	} else if blocked {
		s.log.Warn("registration throttled", "ip", ip)
		http.Error(w, page.T("flash.err.tooManyAttempts"), http.StatusTooManyRequests)
		return
	}
	defer s.recordRegisterAttempt(ctx, ip)

	if msg := s.validateNewAccount(page, username, password, confirm, email); msg != "" {
		renderErr(msg)
		return
	}

	if s.cfg.MaxAccounts > 0 {
		count, err := s.store.AccountCount(ctx)
		if err != nil {
			s.serverError(w, r, "count accounts", err)
			return
		}
		if count >= s.cfg.MaxAccounts {
			renderErr(page.T("flash.err.accountLimit"))
			return
		}
	}

	acct, err := s.store.CreateAccount(ctx, username, password, email)
	switch {
	case errors.Is(err, store.ErrDuplicate):
		renderErr(page.T("flash.err.nameTaken"))
		return
	case errors.Is(err, gamepwd.ErrTooLong), errors.Is(err, gamepwd.ErrInvalidUTF8):
		renderErr(page.T("flash.err.usernameLong"))
		return
	case err != nil:
		s.serverError(w, r, "create account", err)
		return
	}

	_ = s.store.Audit(ctx, 0, acct.Username, "register", acct.Username,
		"self-registration from "+ip, ip)

	s.log.Info("account registered", "username", acct.Username, "id", acct.ID, "ip", ip)

	// Log the new player straight in.
	if token, csrf, err := s.store.CreateSession(ctx, acct.ID, s.cfg.SessionTTL, ip, r.UserAgent()); err == nil {
		_ = csrf
		s.setSessionCookie(w, token)
	} else {
		s.log.Error("create session after register", "err", err)
	}

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.welcome"), acct.Username))
	http.Redirect(w, r, "/panel", http.StatusSeeOther)
}

// validateNewAccount returns an error message, or "" when the input is fine.
func (s *Server) validateNewAccount(page *PageData, username, password, confirm, email string) string {
	if username == "" {
		return page.T("flash.err.username")
	}
	if password == "" {
		return page.T("flash.err.password")
	}
	if password != confirm {
		return page.T("flash.err.passwordMismatch")
	}

	// The account name must survive the core's normalization unchanged enough
	// to be typeable in the game client, so the web form is stricter than the
	// core: ASCII letters, digits, underscore and dash only.
	if len(username) < minAccountNameLen {
		return fmt.Sprintf(page.T("flash.err.usernameShort"), minAccountNameLen)
	}
	for _, ch := range username {
		switch {
		case ch >= 'a' && ch <= 'z', ch >= 'A' && ch <= 'Z',
			ch >= '0' && ch <= '9', ch == '_', ch == '-':
		default:
			return page.T("flash.err.usernameChars")
		}
	}

	normalized, err := gamepwd.Normalize(username)
	if err != nil {
		return page.T("flash.err.usernameLong")
	}
	if len(normalized) < minAccountNameLen {
		return fmt.Sprintf(page.T("flash.err.usernameShort"), minAccountNameLen)
	}

	if _, err := gamepwd.Normalize(password); err != nil {
		return page.T("flash.err.passwordLong")
	}
	if len(password) < s.cfg.PasswordMinLen {
		return fmt.Sprintf(page.T("flash.err.passwordShort"), s.cfg.PasswordMinLen)
	}
	if strings.EqualFold(username, password) {
		return page.T("flash.err.passwordSame")
	}

	if email != "" {
		if _, err := mail.ParseAddress(email); err != nil {
			return page.T("flash.err.emailInvalid")
		}
	} else if s.cfg.RequireEmail {
		return page.T("flash.err.emailRequired")
	}

	return ""
}

// ---------------------------------------------------------------------------
// Login / logout
// ---------------------------------------------------------------------------

type loginView struct {
	PageData
	Username string
	Next     string
}

func (s *Server) handleLoginForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	if accountFrom(r.Context()) != nil {
		http.Redirect(w, r, s.safeNext(r.URL.Query().Get("next")), http.StatusSeeOther)
		return
	}
	page.Title = "Sign in"
	page.Active = "login"
	s.rend.Render(w, http.StatusOK, "login", loginView{
		PageData: *page,
		Next:     r.URL.Query().Get("next"),
	})
}

func (s *Server) handleLoginSubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if err := r.ParseForm(); err != nil {
		http.Error(w, "bad form", http.StatusBadRequest)
		return
	}

	ctx := r.Context()
	ip := s.clientIP(r)
	username := strings.TrimSpace(r.PostFormValue("username"))
	password := r.PostFormValue("password")
	next := s.safeNext(r.PostFormValue("next"))

	view := loginView{PageData: *page, Username: username, Next: next}
	view.Title = "Sign in"
	view.Active = "login"

	fail := func(msg string, status int) {
		view.addFlash("error", msg)
		s.rend.Render(w, status, "login", view)
	}

	// Refuse before touching the password. The hash comparison is the most
	// expensive thing this endpoint does, and under attack it is the thing that
	// must not be reached.
	//
	// The wording and status do not depend on whether the account exists, so a
	// throttled response cannot be used to probe for names.
	blocked, rule, terr := s.loginThrottle(ctx, ip, username)
	if terr != nil {
		s.noteThrottleCheckFailure("login", terr)
	} else if blocked {
		s.log.Warn("web login throttled", "username", username, "ip", ip, "rule", rule)
		fail(page.T("flash.err.tooManyAttempts"), http.StatusTooManyRequests)
		return
	}

	acct, err := s.store.VerifyLogin(ctx, username, password)
	switch {
	case errors.Is(err, store.ErrNotFound):
		// Deliberately vague: do not reveal whether the account exists.
		s.recordLoginFailure(ctx, ip, username)
		s.log.Info("failed web login", "username", username, "ip", ip)
		fail(page.T("flash.err.badCredentials"), http.StatusUnauthorized)
		return
	case err != nil:
		s.serverError(w, r, "verify login", err)
		return
	}

	if !acct.Active {
		// The password was right, so this is not a guess. It is not counted.
		fail(page.T("flash.err.accountDisabled"), http.StatusUnauthorized)
		return
	}

	// Proving the password clears the per-account counter, so a player who
	// mistyped a few times is not left throttled. The per-address counter is
	// deliberately kept: otherwise one valid account would let an attacker
	// reset their own failures.
	s.clearLoginFailures(ctx, username)

	token, _, err := s.store.CreateSession(ctx, acct.ID, s.cfg.SessionTTL, ip, r.UserAgent())
	if err != nil {
		s.serverError(w, r, "create session", err)
		return
	}
	s.setSessionCookie(w, token)
	s.log.Info("web login", "username", acct.Username, "id", acct.ID, "ip", ip)
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.signedIn"), acct.Username))
	http.Redirect(w, r, next, http.StatusSeeOther)
}

func (s *Server) handleLogout(w http.ResponseWriter, r *http.Request, page *PageData) {
	if cookie, err := r.Cookie(sessionCookieName); err == nil {
		_ = s.store.DeleteSessionByToken(r.Context(), cookie.Value)
	}
	s.clearSessionCookie(w)
	s.setFlash(w, "info", page.T("flash.signedOut"))
	http.Redirect(w, r, "/", http.StatusSeeOther)
}

// safeNext keeps redirects on this site: an attacker must not be able to use
// ?next= to bounce a freshly logged-in user to another host.
func (s *Server) safeNext(next string) string {
	if next == "" {
		return "/panel"
	}
	if !strings.HasPrefix(next, "/") || strings.HasPrefix(next, "//") {
		return "/panel"
	}
	return next
}

func itoa(n int) string {
	if n == 0 {
		return "0"
	}
	var buf [20]byte
	i := len(buf)
	for n > 0 {
		i--
		buf[i] = byte('0' + n%10)
		n /= 10
	}
	return string(buf[i:])
}
