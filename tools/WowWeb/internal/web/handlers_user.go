package web

import (
	"fmt"
	"net/http"
	"time"

	"tortoiseweb/internal/gamepwd"
	"tortoiseweb/internal/store"
)

// ---------------------------------------------------------------------------
// Dashboard
// ---------------------------------------------------------------------------

type panelView struct {
	PageData
	Characters []store.Character
	Ban        *store.Ban
	Muted      bool
	MuteUntil  time.Time
	TwoFAOn    bool
	SessionCnt int
	CharCounts map[uint32]int
}

func (s *Server) handlePanel(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	acct := accountFrom(ctx)

	chars, err := s.store.CharactersByAccount(ctx, acct.ID)
	if err != nil {
		s.serverError(w, r, "load characters", err)
		return
	}

	ban, _ := s.store.ActiveBanFor(ctx, acct.ID)
	counts, _ := s.store.RealmCharacterCounts(ctx, acct.ID)
	sessions, _ := s.store.CountSessionsForAccount(ctx, acct.ID)

	page.Title = page.T("panel.myAccount")
	page.Active = "panel"
	s.rend.Render(w, http.StatusOK, "panel", panelView{
		PageData:   *page,
		Characters: chars,
		Ban:        ban,
		Muted:      acct.MuteTime > time.Now().Unix(),
		MuteUntil:  time.Unix(acct.MuteTime, 0),
		TwoFAOn:    acct.Security != "" && acct.Locked&store.LockFixedPIN != 0,
		SessionCnt: sessions,
		CharCounts: counts,
	})
}

func (s *Server) handlePanelCharacters(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	acct := accountFrom(ctx)

	chars, err := s.store.CharactersByAccount(ctx, acct.ID)
	if err != nil {
		s.serverError(w, r, "load characters", err)
		return
	}

	page.Title = page.T("chars.title")
	page.Active = "characters"
	s.rend.Render(w, http.StatusOK, "panel_characters", panelView{
		PageData:   *page,
		Characters: chars,
	})
}

// handlePanelUnstick moves one of the player's own characters to its homebind
// position. Refused while the character is online, because the world server
// would write its in-memory position back on logout.
func (s *Server) handlePanelUnstick(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	acct := accountFrom(ctx)

	guid, ok := s.parseUintPath(r, "guid")
	if !ok {
		s.notFound(w, r)
		return
	}

	owner, err := s.store.CharacterAccountID(ctx, guid)
	if err != nil {
		s.notFound(w, r)
		return
	}
	if owner != acct.ID {
		// Do not confirm that the character exists.
		s.log.Warn("unstick attempt on foreign character",
			"account", acct.Username, "guid", guid)
		s.notFound(w, r)
		return
	}

	ch, err := s.store.CharacterByGUID(ctx, guid)
	if err != nil {
		s.notFound(w, r)
		return
	}
	if ch.Online {
		s.setFlash(w, "error", page.T("flash.err.characterOnline"))
		http.Redirect(w, r, "/panel/characters", http.StatusSeeOther)
		return
	}

	if err := s.store.Unstick(ctx, guid); err != nil {
		s.log.Error("unstick failed", "guid", guid, "err", err)
		s.setFlash(w, "error", page.T("flash.err.unstickFailed"))
	} else {
		_ = s.store.Audit(ctx, acct.ID, acct.Username, "unstick-self",
			fmt.Sprintf("character:%d", guid), "player self-service unstick", s.clientIP(r))
		s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.unstuck"), ch.Name))
	}
	http.Redirect(w, r, "/panel/characters", http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Password
// ---------------------------------------------------------------------------

type passwordView struct {
	PageData
}

func (s *Server) handlePasswordForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	page.Title = page.T("passwd.title")
	page.Active = "password"
	s.rend.Render(w, http.StatusOK, "panel_password", passwordView{PageData: *page})
}

func (s *Server) handlePasswordSubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	acct := accountFrom(ctx)

	current := r.PostFormValue("current_password")
	next := r.PostFormValue("new_password")
	confirm := r.PostFormValue("new_password2")

	page.Title = page.T("passwd.title")
	page.Active = "password"
	view := passwordView{PageData: *page}

	fail := func(msg string) {
		view.addFlash("error", msg)
		s.rend.Render(w, http.StatusBadRequest, "panel_password", view)
	}

	if current == "" || next == "" {
		fail(page.T("flash.err.fillAll"))
		return
	}
	if next != confirm {
		fail(page.T("flash.err.passwordMismatch"))
		return
	}
	if _, err := gamepwd.Normalize(next); err != nil {
		fail(page.T("flash.err.passwordLong"))
		return
	}
	if len(next) < s.cfg.PasswordMinLen {
		fail(fmt.Sprintf(page.T("flash.err.passwordShort"), s.cfg.PasswordMinLen))
		return
	}
	if next == current {
		fail(page.T("flash.err.newPasswordSame"))
		return
	}

	// Re-authenticate with the current password before changing it.
	if _, err := s.store.VerifyLogin(ctx, acct.Username, current); err != nil {
		s.log.Info("failed password change attempt", "account", acct.Username, "ip", s.clientIP(r))
		fail(page.T("flash.err.currentPassword"))
		return
	}

	if err := s.store.SetPassword(ctx, acct.ID, next); err != nil {
		s.serverError(w, r, "set password", err)
		return
	}

	// Other browsers must not keep a session that was opened with the old
	// password. The caller's own session stays valid.
	if cookie, err := r.Cookie(sessionCookieName); err == nil {
		_ = s.store.DeleteSessionsExcept(ctx, acct.ID, cookie.Value)
	} else {
		_ = s.store.DeleteSessionsForAccount(ctx, acct.ID)
	}

	_ = s.store.Audit(ctx, acct.ID, acct.Username, "password-change", acct.Username,
		"changed own password", s.clientIP(r))

	s.log.Info("password changed", "account", acct.Username, "ip", s.clientIP(r))
	s.setFlash(w, "ok", page.T("flash.ok.passwordChanged"))
	http.Redirect(w, r, "/panel", http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Two-factor authentication
// ---------------------------------------------------------------------------

type securityView struct {
	PageData
	Enabled    bool
	Secret     string
	OTPAuthURI string
	Allowances []store.TwoFactorAllowance
	Pending    bool
}

func (s *Server) handleSecurity(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	acct := accountFrom(ctx)

	allowances, err := s.store.ListTwoFactorAllowances(ctx, acct.ID)
	if err != nil {
		s.serverError(w, r, "list 2fa allowances", err)
		return
	}

	enabled := acct.Security != "" && acct.Locked&store.LockFixedPIN != 0
	page.Title = page.T("sec.title")
	page.Active = "security"

	view := securityView{
		PageData:   *page,
		Enabled:    enabled,
		Allowances: allowances,
	}

	// A freshly generated secret is shown until the user confirms it with a
	// valid code. The secret lives in web_totp_setup, not in account.security,
	// so an abandoned setup leaves the account untouched.
	if !enabled {
		if secret, err := s.store.PendingSecret(ctx, acct.ID); err == nil {
			view.Secret = secret
			view.Pending = true
			view.OTPAuthURI = gamepwd.TOTPProvisioningURI(s.cfg.RealmName, acct.Username, secret)
		}
	}
	s.rend.Render(w, http.StatusOK, "panel_security", view)
}

// handleSecurityEnable generates a secret and shows it for confirmation.
func (s *Server) handleSecurityEnable(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	acct := accountFrom(ctx)

	secret, err := gamepwd.GenerateTOTPSecret()
	if err != nil {
		s.serverError(w, r, "generate secret", err)
		return
	}
	if err := s.store.PrunePendingSecrets(ctx); err != nil {
		s.log.Warn("prune pending 2fa setups", "err", err)
	}
	if err := s.store.SavePendingSecret(ctx, acct.ID, secret, 15*time.Minute); err != nil {
		s.serverError(w, r, "store pending secret", err)
		return
	}
	http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
}

// handleSecurityConfirm activates a pending secret once the user enters a code
// that the secret actually produces.
func (s *Server) handleSecurityConfirm(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	acct := accountFrom(ctx)

	secret, err := s.store.PendingSecret(ctx, acct.ID)
	if err != nil {
		s.setFlash(w, "error", page.T("flash.err.setupExpired"))
		http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
		return
	}

	code := r.PostFormValue("code")
	if !gamepwd.VerifyTOTP(secret, code, time.Now()) {
		s.log.Info("2fa confirm failed", "account", acct.Username, "ip", s.clientIP(r))
		s.setFlash(w, "error", page.T("flash.err.invalidCodeRetry"))
		http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
		return
	}

	if err := s.store.SetTOTP(ctx, acct.ID, secret); err != nil {
		s.serverError(w, r, "enable totp", err)
		return
	}
	if err := s.store.DeletePendingSecret(ctx, acct.ID); err != nil {
		s.log.Warn("delete pending secret", "err", err)
	}
	_ = s.store.Audit(ctx, acct.ID, acct.Username, "2fa-enable", acct.Username,
		"enabled authenticator", s.clientIP(r))

	s.log.Info("2fa enabled", "account", acct.Username, "ip", s.clientIP(r))
	s.setFlash(w, "ok", page.T("flash.ok.twoFaOn"))
	http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
}

// handleSecurityDisable turns the authenticator off.
func (s *Server) handleSecurityDisable(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	acct := accountFrom(ctx)

	if code := r.PostFormValue("code"); acct.Security != "" {
		// Require a valid code, so knowing the session cookie is not enough to
		// remove the second factor.
		if !gamepwd.VerifyTOTP(acct.Security, code, time.Now()) {
			s.setFlash(w, "error", page.T("flash.err.invalidCode"))
			http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
			return
		}
	}

	if err := s.store.ClearTOTP(ctx, acct.ID); err != nil {
		s.serverError(w, r, "clear totp", err)
		return
	}
	_ = s.store.RevokeAllTwoFactorAllowances(ctx, acct.ID)
	_ = s.store.Audit(ctx, acct.ID, acct.Username, "2fa-disable", acct.Username,
		"disabled authenticator", s.clientIP(r))

	s.setFlash(w, "ok", page.T("flash.ok.twoFaOff"))
	http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
}

func (s *Server) handleSecurityRevokeIP(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	acct := accountFrom(ctx)

	id := parseUintOrZero(r.PostFormValue("allowance_id"))
	if id == 0 {
		s.setFlash(w, "error", page.T("flash.err.invalidEntry"))
		http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
		return
	}
	if err := s.store.RevokeTwoFactorAllowance(ctx, id, acct.ID); err != nil {
		s.log.Error("revoke 2fa allowance", "id", id, "err", err)
		s.setFlash(w, "error", page.T("flash.err.revokeFailed"))
	} else {
		s.setFlash(w, "ok", page.T("flash.ok.trustedRemoved"))
	}
	http.Redirect(w, r, "/panel/security", http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Sessions
// ---------------------------------------------------------------------------

type sessionsView struct {
	PageData
	CurrentToken string
	Sessions     []store.WebSession
}

func (s *Server) handlePanelSessions(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	acct := accountFrom(ctx)

	list, err := s.store.SessionsForAccount(ctx, acct.ID)
	if err != nil {
		s.serverError(w, r, "list sessions", err)
		return
	}

	page.Title = page.T("sess.title")
	page.Active = "sessions"
	s.rend.Render(w, http.StatusOK, "panel_sessions", sessionsView{
		PageData: *page,
		Sessions: list,
	})
}

// handleSessionRevoke signs out every other browser, or all of them.
func (s *Server) handleSessionRevoke(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	acct := accountFrom(ctx)

	cookie, err := r.Cookie(sessionCookieName)
	if err != nil {
		http.Redirect(w, r, "/login", http.StatusSeeOther)
		return
	}

	if r.PostFormValue("all") == "1" {
		if err := s.store.DeleteSessionsForAccount(ctx, acct.ID); err != nil {
			s.serverError(w, r, "delete sessions", err)
			return
		}
		s.clearSessionCookie(w)
		s.setFlash(w, "info", page.T("flash.ok.allSignedOut"))
		http.Redirect(w, r, "/login", http.StatusSeeOther)
		return
	}

	if err := s.store.DeleteSessionsExcept(ctx, acct.ID, cookie.Value); err != nil {
		s.serverError(w, r, "delete other sessions", err)
		return
	}
	s.setFlash(w, "ok", page.T("flash.ok.othersSignedOut"))
	http.Redirect(w, r, "/panel/sessions", http.StatusSeeOther)
}

func parseUintOrZero(s string) uint64 {
	var v uint64
	for _, ch := range s {
		if ch < '0' || ch > '9' {
			return 0
		}
		v = v*10 + uint64(ch-'0')
		if v > 1<<40 {
			return 0
		}
	}
	return v
}
