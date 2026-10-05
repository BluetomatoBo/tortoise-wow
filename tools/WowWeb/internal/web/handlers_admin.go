package web

import (
	"errors"
	"fmt"
	"net"
	"net/http"
	"strconv"
	"strings"
	"time"

	"tortoiseweb/internal/gamepwd"
	"tortoiseweb/internal/store"
)

// pageSize is shared by every paginated list in the admin area.
const pageSize = 25

// ---------------------------------------------------------------------------
// Dashboard
// ---------------------------------------------------------------------------

type adminDashboardView struct {
	PageData
	Stats      store.ServerStats
	Recent     []store.Account
	Online     []store.Character
	Audit      []store.AuditEntry
	Realms     []store.Realm
	ServerTime time.Time
}

func (s *Server) handleAdminDashboard(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()

	stats, err := s.store.Stats(ctx)
	if err != nil {
		s.serverError(w, r, "load stats", err)
		return
	}

	recent, _, err := s.store.ListAccounts(ctx, store.AccountFilter{Limit: 8})
	if err != nil {
		s.serverError(w, r, "recent accounts", err)
		return
	}

	online, _, err := s.store.ListCharacters(ctx, store.CharacterFilter{
		Online: boolPtr(true), Limit: 15,
	})
	if err != nil {
		s.serverError(w, r, "online characters", err)
		return
	}

	audit, err := s.store.RecentAudit(ctx, 10)
	if err != nil {
		s.log.Warn("load audit trail", "err", err)
	}

	realms, err := s.store.Realms(ctx)
	if err != nil {
		s.serverError(w, r, "load realms", err)
		return
	}

	page.Title = page.T("admin.title")
	page.Active = "admin"
	s.rend.Render(w, http.StatusOK, "admin_dashboard", adminDashboardView{
		PageData:   *page,
		Stats:      stats,
		Recent:     recent,
		Online:     online,
		Audit:      audit,
		Realms:     realms,
		ServerTime: time.Now(),
	})
}

// ---------------------------------------------------------------------------
// Account list
// ---------------------------------------------------------------------------

type adminAccountsView struct {
	PageData
	QueryString string
	Accounts    []store.Account
	Filter      store.AccountFilter
	Total       int
	Page        int
	Pages       int
	Bans        map[uint32]*store.Ban
}

func (s *Server) handleAdminAccounts(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	q := r.URL.Query()

	filter := store.AccountFilter{
		Search: strings.TrimSpace(q.Get("q")),
		Limit:  pageSize,
	}
	pageNum := atoiDefault(q.Get("page"), 1)
	if pageNum < 1 {
		pageNum = 1
	}
	filter.Offset = (pageNum - 1) * pageSize

	switch q.Get("state") {
	case "online":
		filter.Online = boolPtr(true)
	case "offline":
		filter.Online = boolPtr(false)
	case "banned":
		filter.Banned = boolPtr(true)
	case "disabled":
		filter.Active = boolPtr(false)
	}
	if rankStr := q.Get("rank"); rankStr != "" {
		if rank, err := strconv.Atoi(rankStr); err == nil && rank >= 0 && rank <= 6 {
			filter.Rank = uint8Ptr(uint8(rank))
		}
	}

	accounts, total, err := s.store.ListAccounts(ctx, filter)
	if err != nil {
		s.serverError(w, r, "list accounts", err)
		return
	}

	// One query for the bans of the listed accounts, so the table can show a
	// banned badge without N+1 round trips.
	var bans map[uint32]*store.Ban
	ids := make([]uint32, 0, len(accounts))
	for _, a := range accounts {
		ids = append(ids, a.ID)
	}
	if len(ids) > 0 {
		found, err := s.store.ActiveBansForAccounts(ctx, ids)
		if err != nil {
			s.log.Warn("load bans for account list", "err", err)
		}
		bans = found
	}

	page.Title = page.T("acct.title")
	page.Active = "admin-accounts"
	s.rend.Render(w, http.StatusOK, "admin_accounts", adminAccountsView{
		PageData:    *page,
		QueryString: baseQuery(r),
		Accounts:    accounts,
		Filter:      filter,
		Total:       total,
		Page:        pageNum,
		Pages:       pages(total, pageSize),
		Bans:        bans,
	})
}

// ---------------------------------------------------------------------------
// Create account
// ---------------------------------------------------------------------------

type adminAccountNewView struct {
	PageData
	Form struct {
		Username string
		Email    string
		Rank     uint8
	}
}

func (s *Server) handleAdminAccountNewForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	page.Title = page.T("acct.create")
	page.Active = "admin-accounts"
	s.rend.Render(w, http.StatusOK, "admin_account_new", adminAccountNewView{PageData: *page})
}

func (s *Server) handleAdminAccountNewSubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	username := strings.TrimSpace(r.PostFormValue("username"))
	password := r.PostFormValue("password")
	email := strings.TrimSpace(r.PostFormValue("email"))
	rank := uint8(clampInt(atoiDefault(r.PostFormValue("rank"), 0), 0, 6))

	view := adminAccountNewView{PageData: *page}
	view.Title = page.T("acct.create")
	view.Active = "admin-accounts"
	view.Form.Username = username
	view.Form.Email = email
	view.Form.Rank = rank

	fail := func(msg string) {
		view.addFlash("error", msg)
		s.rend.Render(w, http.StatusBadRequest, "admin_account_new", view)
	}

	if msg := s.validateNewAccount(page, username, password, password, email); msg != "" {
		fail(msg)
		return
	}
	// An administrator may not hand out a rank above their own.
	if rank > actor.Rank {
		fail(page.T("flash.err.createHigher"))
		return
	}

	acct, err := s.store.CreateAccount(ctx, username, password, email)
	switch {
	case errors.Is(err, store.ErrDuplicate):
		fail(page.T("flash.err.nameTaken"))
		return
	case err != nil:
		s.serverError(w, r, "create account", err)
		return
	}

	if rank > 0 {
		if err := s.store.SetRank(ctx, acct.ID, rank); err != nil {
			s.log.Error("set rank on new account", "id", acct.ID, "err", err)
		}
	}

	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-create", acct.Username,
		fmt.Sprintf("created account id=%d rank=%d", acct.ID, rank), s.clientIP(r))
	s.log.Info("admin created account", "actor", actor.Username,
		"username", acct.Username, "rank", rank)

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.accountCreated"), acct.Username))
	http.Redirect(w, r, fmt.Sprintf("/admin/accounts/%d", acct.ID), http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Account detail
// ---------------------------------------------------------------------------

type adminAccountView struct {
	PageData
	Account     *store.Account
	Characters  []store.Character
	Bans        []store.Ban
	Allowances  []store.TwoFactorAllowance
	Sessions    int
	IsSelf      bool
	RankChoices []uint8
}

func (s *Server) handleAdminAccountDetail(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	actor := accountFrom(ctx)

	id, ok := s.parseUintPath(r, "id")
	if !ok {
		s.notFound(w, r)
		return
	}

	acct, err := s.store.AccountByID(ctx, id)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return
	}
	if err != nil {
		s.serverError(w, r, "load account", err)
		return
	}

	chars, err := s.store.CharactersByAccount(ctx, acct.ID)
	if err != nil {
		s.serverError(w, r, "load characters", err)
		return
	}

	bans, _, err := s.store.ListBans(ctx, store.BanFilter{Search: acct.Username, Limit: 50})
	if err != nil {
		s.log.Warn("load bans", "err", err)
	}

	allowances, err := s.store.ListTwoFactorAllowances(ctx, acct.ID)
	if err != nil {
		s.log.Warn("load 2fa allowances", "err", err)
	}

	sessions, err := s.store.CountSessionsForAccount(ctx, acct.ID)
	if err != nil {
		s.log.Warn("count sessions", "err", err)
	}

	page.Title = page.T("acct.account") + " " + acct.Username
	page.Active = "admin-accounts"
	s.rend.Render(w, http.StatusOK, "admin_account_detail", adminAccountView{
		PageData:    *page,
		Account:     acct,
		Characters:  chars,
		Bans:        bans,
		Allowances:  allowances,
		Sessions:    sessions,
		IsSelf:      acct.ID == actor.ID,
		RankChoices: []uint8{0, 1, 2, 3, 4, 5, 6},
	})
}

// ---------------------------------------------------------------------------
// Account actions
// ---------------------------------------------------------------------------

// loadTargetAccount resolves the {id} path value, writing an error response
// when it cannot.
func (s *Server) loadTargetAccount(w http.ResponseWriter, r *http.Request) (*store.Account, bool) {
	id, ok := s.parseUintPath(r, "id")
	if !ok {
		s.notFound(w, r)
		return nil, false
	}
	acct, err := s.store.AccountByID(r.Context(), id)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return nil, false
	}
	if err != nil {
		s.serverError(w, r, "load account", err)
		return nil, false
	}
	return acct, true
}

func (s *Server) backToAccount(w http.ResponseWriter, r *http.Request, id uint32) {
	http.Redirect(w, r, fmt.Sprintf("/admin/accounts/%d", id), http.StatusSeeOther)
}

func (s *Server) handleAdminSetRank(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}

	rank := uint8(clampInt(atoiDefault(r.PostFormValue("rank"), 0), 0, 6))

	// The same two rules the in-game `account set gmlevel` command enforces.
	if target.ID == actor.ID {
		s.setFlash(w, "error", page.T("flash.err.ownRank"))
		s.backToAccount(w, r, target.ID)
		return
	}
	if rank > actor.Rank {
		s.setFlash(w, "error", page.T("flash.err.grantHigher"))
		s.backToAccount(w, r, target.ID)
		return
	}

	if err := s.store.SetRank(ctx, target.ID, rank); err != nil {
		s.serverError(w, r, "set rank", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-set-rank", target.Username,
		fmt.Sprintf("rank %d -> %d", target.Rank, rank), s.clientIP(r))
	s.log.Info("admin changed rank", "actor", actor.Username,
		"target", target.Username, "rank", rank)

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.rankSet"),
		target.Username, page.RankName(rank), rank))
	s.backToAccount(w, r, target.ID)
}

func (s *Server) handleAdminResetPassword(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	newPassword := r.PostFormValue("password")
	if newPassword == "" {
		s.setFlash(w, "error", page.T("flash.err.supplyPassword"))
		s.backToAccount(w, r, target.ID)
		return
	}
	if _, err := gamepwd.Normalize(newPassword); err != nil {
		s.setFlash(w, "error", page.T("flash.err.passwordLong"))
		s.backToAccount(w, r, target.ID)
		return
	}

	if err := s.store.SetPassword(ctx, target.ID, newPassword); err != nil {
		s.serverError(w, r, "reset password", err)
		return
	}

	// The player is not the one asking here, so sign out every web session and
	// force the game client to re-authenticate.
	_ = s.store.DeleteSessionsForAccount(ctx, target.ID)
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-reset-password", target.Username,
		"password reset by administrator", s.clientIP(r))
	s.log.Info("admin reset password", "actor", actor.Username, "target", target.Username)

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.passwordReset"), target.Username))
	s.backToAccount(w, r, target.ID)
}

func (s *Server) handleAdminSetEmail(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	email := strings.TrimSpace(r.PostFormValue("email"))

	if err := s.store.SetEmail(ctx, target.ID, email); err != nil {
		s.serverError(w, r, "set email", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-set-email", target.Username,
		"email set to "+email, s.clientIP(r))
	s.setFlash(w, "ok", page.T("flash.ok.emailUpdated"))
	s.backToAccount(w, r, target.ID)
}

func (s *Server) handleAdminSetActive(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	if target.ID == actor.ID {
		s.setFlash(w, "error", page.T("flash.err.ownDisable"))
		s.backToAccount(w, r, target.ID)
		return
	}

	active := r.PostFormValue("active") == "1"
	if err := s.store.SetActive(ctx, target.ID, active); err != nil {
		s.serverError(w, r, "set active", err)
		return
	}

	action := "account-disable"
	msg := fmt.Sprintf(page.T("flash.ok.accountDisabled"), target.Username)
	if active {
		action = "account-enable"
		msg = fmt.Sprintf(page.T("flash.ok.accountEnabled"), target.Username)
	}
	if !active {
		_ = s.store.DeleteSessionsForAccount(ctx, target.ID)
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, action, target.Username, msg, s.clientIP(r))
	s.log.Info("admin set account active", "actor", actor.Username,
		"target", target.Username, "active", active)

	s.setFlash(w, "ok", msg)
	s.backToAccount(w, r, target.ID)
}

func (s *Server) handleAdminBan(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	if target.ID == actor.ID {
		s.setFlash(w, "error", page.T("flash.err.ownBan"))
		s.backToAccount(w, r, target.ID)
		return
	}
	// Do not let an administrator ban someone more senior than themselves.
	if target.Rank >= actor.Rank {
		s.setFlash(w, "error", page.T("flash.err.banHigher"))
		s.backToAccount(w, r, target.ID)
		return
	}

	duration, err := parseDuration(r.PostFormValue("duration"))
	if err != nil {
		s.setFlash(w, "error", page.T("flash.err.badDuration"))
		s.backToAccount(w, r, target.ID)
		return
	}
	reason := strings.TrimSpace(r.PostFormValue("reason"))
	if reason == "" {
		reason = "no reason given"
	}

	if err := s.store.BanAccount(ctx, target.ID, duration, reason,
		actor.Username, uint8(s.cfg.RealmID)); err != nil {
		s.serverError(w, r, "ban account", err)
		return
	}
	_ = s.store.DeleteSessionsForAccount(ctx, target.ID)
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-ban", target.Username,
		fmt.Sprintf("duration=%s reason=%s", duration, reason), s.clientIP(r))
	s.log.Info("admin banned account", "actor", actor.Username,
		"target", target.Username, "duration", duration.String(), "reason", reason)

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.banned"), target.Username))
	s.backToAccount(w, r, target.ID)
}

func (s *Server) handleAdminUnban(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	if err := s.store.UnbanAccount(ctx, target.ID); err != nil {
		s.serverError(w, r, "unban account", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-unban", target.Username,
		"all bans cleared", s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.unbanned"), target.Username))
	s.backToAccount(w, r, target.ID)
}

func (s *Server) handleAdminMute(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}

	hours := clampInt(atoiDefault(r.PostFormValue("hours"), 24), 1, 24*365)
	reason := strings.TrimSpace(r.PostFormValue("reason"))
	if reason == "" {
		reason = "no reason given"
	}

	until := time.Now().Add(time.Duration(hours) * time.Hour)
	if err := s.store.SetMute(ctx, target.ID, until, reason, actor.Username); err != nil {
		s.serverError(w, r, "mute account", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-mute", target.Username,
		fmt.Sprintf("until=%s reason=%s", until.Format(time.RFC3339), reason), s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.muted"), target.Username, hours))
	s.backToAccount(w, r, target.ID)
}

func (s *Server) handleAdminUnmute(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	if err := s.store.ClearMute(ctx, target.ID); err != nil {
		s.serverError(w, r, "unmute account", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-unmute", target.Username,
		"mute cleared", s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.unmuted"), target.Username))
	s.backToAccount(w, r, target.ID)
}

// handleAdminReset2FA is the recovery path for a player who lost their
// authenticator. Without it a stolen or broken device means a dead account.
func (s *Server) handleAdminReset2FA(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	// Removing a second factor weakens the target's account, so require a rank
	// strictly above theirs.
	if target.ID != actor.ID && target.Rank >= actor.Rank {
		s.setFlash(w, "error", page.T("flash.err.reset2faHigher"))
		s.backToAccount(w, r, target.ID)
		return
	}

	if err := s.store.ClearTOTP(ctx, target.ID); err != nil {
		s.serverError(w, r, "reset 2fa", err)
		return
	}
	_ = s.store.RevokeAllTwoFactorAllowances(ctx, target.ID)
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "2fa-reset", target.Username,
		"authenticator cleared by administrator", s.clientIP(r))
	s.log.Warn("admin reset 2fa", "actor", actor.Username, "target", target.Username)

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.twoFaReset"), target.Username))
	s.backToAccount(w, r, target.ID)
}

// handleAdminDeleteAccount removes the account and every character on it.
func (s *Server) handleAdminDeleteAccount(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	target, ok := s.loadTargetAccount(w, r)
	if !ok {
		return
	}
	if target.ID == actor.ID {
		s.setFlash(w, "error", page.T("flash.err.ownDelete"))
		s.backToAccount(w, r, target.ID)
		return
	}
	if target.Rank >= actor.Rank {
		s.setFlash(w, "error", page.T("flash.err.deleteHigher"))
		s.backToAccount(w, r, target.ID)
		return
	}
	// Deleting destroys characters, so require the operator to type the name.
	if strings.TrimSpace(r.PostFormValue("confirm")) != target.Username {
		s.setFlash(w, "error", page.T("flash.err.confirmName"))
		s.backToAccount(w, r, target.ID)
		return
	}

	chars, err := s.store.CharactersByAccount(ctx, target.ID)
	if err != nil {
		s.serverError(w, r, "load characters", err)
		return
	}
	if err := s.store.DeleteAccount(ctx, target.ID, chars); err != nil {
		s.serverError(w, r, "delete account", err)
		return
	}

	_ = s.store.Audit(ctx, actor.ID, actor.Username, "account-delete", target.Username,
		fmt.Sprintf("deleted account id=%d with %d characters", target.ID, len(chars)),
		s.clientIP(r))
	s.log.Warn("admin deleted account", "actor", actor.Username,
		"target", target.Username, "characters", len(chars))

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.accountDeleted"), target.Username, len(chars)))
	http.Redirect(w, r, "/admin/accounts", http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Characters
// ---------------------------------------------------------------------------

type adminCharactersView struct {
	PageData
	QueryString string
	Characters  []store.Character
	Filter      store.CharacterFilter
	Total       int
	Page        int
	Pages       int
}

func (s *Server) handleAdminCharacters(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	q := r.URL.Query()

	filter := store.CharacterFilter{
		Search: strings.TrimSpace(q.Get("q")),
		Limit:  pageSize,
	}
	pageNum := atoiDefault(q.Get("page"), 1)
	if pageNum < 1 {
		pageNum = 1
	}
	filter.Offset = (pageNum - 1) * pageSize

	if q.Get("online") == "1" {
		filter.Online = boolPtr(true)
	}
	if lvl := q.Get("minlevel"); lvl != "" {
		if n, err := strconv.Atoi(lvl); err == nil && n > 0 && n <= 60 {
			filter.MinLevel = uint8Ptr(uint8(n))
		}
	}

	chars, total, err := s.store.ListCharacters(ctx, filter)
	if err != nil {
		s.serverError(w, r, "list characters", err)
		return
	}

	page.Title = page.T("achar.title")
	page.Active = "admin-characters"
	s.rend.Render(w, http.StatusOK, "admin_characters", adminCharactersView{
		PageData:    *page,
		QueryString: baseQuery(r),
		Characters:  chars,
		Filter:      filter,
		Total:       total,
		Page:        pageNum,
		Pages:       pages(total, pageSize),
	})
}

type adminCharacterView struct {
	PageData
	Character store.Character
	Ban       *store.Ban
	Flags     []string
}

func (s *Server) handleAdminCharacterDetail(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()

	guid, ok := s.parseUintPath(r, "guid")
	if !ok {
		s.notFound(w, r)
		return
	}
	ch, err := s.store.CharacterByGUID(ctx, guid)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return
	}
	if err != nil {
		s.serverError(w, r, "load character", err)
		return
	}

	ban, _ := s.store.ActiveBanFor(ctx, ch.AccountID)

	page.Title = ch.Name
	page.Active = "admin-characters"
	s.rend.Render(w, http.StatusOK, "admin_character_detail", adminCharacterView{
		PageData:  *page,
		Character: *ch,
		Ban:       ban,
		Flags:     page.AtLoginLabels(ch.AtLogin),
	})
}

func (s *Server) loadTargetCharacter(w http.ResponseWriter, r *http.Request) (*store.Character, bool) {
	guid, ok := s.parseUintPath(r, "guid")
	if !ok {
		s.notFound(w, r)
		return nil, false
	}
	ch, err := s.store.CharacterByGUID(r.Context(), guid)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return nil, false
	}
	if err != nil {
		s.serverError(w, r, "load character", err)
		return nil, false
	}
	return ch, true
}

func (s *Server) backToCharacter(w http.ResponseWriter, r *http.Request, guid uint32) {
	http.Redirect(w, r, fmt.Sprintf("/admin/characters/%d", guid), http.StatusSeeOther)
}

func (s *Server) handleAdminCharacterRename(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	ch, ok := s.loadTargetCharacter(w, r)
	if !ok {
		return
	}

	if err := s.store.RenameCharacter(ctx, ch.GUID); err != nil {
		s.serverError(w, r, "force rename", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "character-rename", ch.Name,
		fmt.Sprintf("forced rename for guid=%d", ch.GUID), s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.renameQueued"), ch.Name))
	s.backToCharacter(w, r, ch.GUID)
}

func (s *Server) handleAdminCharacterUnstick(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	ch, ok := s.loadTargetCharacter(w, r)
	if !ok {
		return
	}
	if ch.Online {
		s.setFlash(w, "error", page.T("flash.err.characterOnlineAdmin"))
		s.backToCharacter(w, r, ch.GUID)
		return
	}

	if err := s.store.Unstick(ctx, ch.GUID); err != nil {
		s.log.Error("admin unstick failed", "guid", ch.GUID, "err", err)
		s.setFlash(w, "error", page.T("flash.err.unstickFailed")+" "+err.Error())
	} else {
		_ = s.store.Audit(ctx, actor.ID, actor.Username, "character-unstick", ch.Name,
			fmt.Sprintf("moved to homebind for guid=%d", ch.GUID), s.clientIP(r))
		s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.unstuck"), ch.Name))
	}
	s.backToCharacter(w, r, ch.GUID)
}

func (s *Server) handleAdminCharacterAtLogin(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	ch, ok := s.loadTargetCharacter(w, r)
	if !ok {
		return
	}

	flagName := r.PostFormValue("flag")
	var flag uint32
	var flagLabel string
	switch flagName {
	case "reset_spells":
		flag = store.AtLoginResetSpells
		flagLabel = page.T("achar.detail.flagResetSpells")
	case "reset_talents":
		flag = store.AtLoginResetTalents
		flagLabel = page.T("achar.detail.flagResetTalents")
	case "rename":
		flag = store.AtLoginRename
		flagLabel = page.T("achar.detail.flagRename")
	default:
		s.setFlash(w, "error", page.T("flash.err.unknownFlag"))
		s.backToCharacter(w, r, ch.GUID)
		return
	}

	enabled := r.PostFormValue("enabled") == "1"
	if err := s.store.SetAtLoginFlag(ctx, ch.GUID, flag, enabled); err != nil {
		s.serverError(w, r, "set at_login flag", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "character-atlogin", ch.Name,
		fmt.Sprintf("%s flag %s", flagName, enabledState(enabled)), s.clientIP(r))

	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.flagApplied"),
		flagLabel, page.FlagState(enabled), ch.Name))
	s.backToCharacter(w, r, ch.GUID)
}

func (s *Server) handleAdminCharacterLevel(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	ch, ok := s.loadTargetCharacter(w, r)
	if !ok {
		return
	}
	level := clampInt(atoiDefault(r.PostFormValue("level"), int(ch.Level)), 1, 60)

	if err := s.store.SetCharacterLevel(ctx, ch.GUID, uint8(level)); err != nil {
		s.serverError(w, r, "set level", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "character-level", ch.Name,
		fmt.Sprintf("level %d -> %d", ch.Level, level), s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.levelSet"), ch.Name, level))
	s.backToCharacter(w, r, ch.GUID)
}

// ---------------------------------------------------------------------------
// Bans
// ---------------------------------------------------------------------------

type adminBansView struct {
	PageData
	QueryString string
	Bans        []store.Ban
	Filter      store.BanFilter
	Total       int
	Page        int
	Pages       int
	IPBans      []store.IPBan
}

func (s *Server) handleAdminBans(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	q := r.URL.Query()

	filter := store.BanFilter{
		Search: strings.TrimSpace(q.Get("q")),
		Only:   q.Get("only"),
		Limit:  pageSize,
	}
	if filter.Only == "" {
		filter.Only = "active"
	}
	pageNum := atoiDefault(q.Get("page"), 1)
	if pageNum < 1 {
		pageNum = 1
	}
	filter.Offset = (pageNum - 1) * pageSize

	bans, total, err := s.store.ListBans(ctx, filter)
	if err != nil {
		s.serverError(w, r, "list bans", err)
		return
	}

	ipBans, err := s.store.ListIPBans(ctx)
	if err != nil {
		s.log.Warn("list ip bans", "err", err)
	}

	page.Title = page.T("bans.title")
	page.Active = "admin-bans"
	s.rend.Render(w, http.StatusOK, "admin_bans", adminBansView{
		PageData:    *page,
		QueryString: baseQuery(r),
		Bans:        bans,
		Filter:      filter,
		Total:       total,
		Page:        pageNum,
		Pages:       pages(total, pageSize),
		IPBans:      ipBans,
	})
}

func (s *Server) handleAdminBanIP(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	ip := strings.TrimSpace(r.PostFormValue("ip"))
	if net.ParseIP(ip) == nil {
		s.setFlash(w, "error", page.T("flash.err.badIP"))
		http.Redirect(w, r, "/admin/bans", http.StatusSeeOther)
		return
	}
	if ip == s.clientIP(r) {
		s.setFlash(w, "error", page.T("flash.err.ownIP"))
		http.Redirect(w, r, "/admin/bans", http.StatusSeeOther)
		return
	}

	duration, err := parseDuration(r.PostFormValue("duration"))
	if err != nil {
		s.setFlash(w, "error", page.T("flash.err.badDurationShort"))
		http.Redirect(w, r, "/admin/bans", http.StatusSeeOther)
		return
	}
	reason := strings.TrimSpace(r.PostFormValue("reason"))
	if reason == "" {
		reason = "no reason given"
	}

	if err := s.store.BanIP(ctx, ip, duration, reason, actor.Username); err != nil {
		s.serverError(w, r, "ban ip", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "ip-ban", ip,
		fmt.Sprintf("duration=%s reason=%s", duration, reason), s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.ipBanned"), ip))
	http.Redirect(w, r, "/admin/bans", http.StatusSeeOther)
}

func (s *Server) handleAdminUnbanIP(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	ip := strings.TrimSpace(r.PostFormValue("ip"))
	if err := s.store.UnbanIP(ctx, ip); err != nil {
		s.serverError(w, r, "unban ip", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "ip-unban", ip, "ip ban removed", s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.ipUnbanned"), ip))
	http.Redirect(w, r, "/admin/bans", http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Realms
// ---------------------------------------------------------------------------

type adminRealmsView struct {
	PageData
	Realms []store.Realm
}

func (s *Server) handleAdminRealms(w http.ResponseWriter, r *http.Request, page *PageData) {
	realms, err := s.store.Realms(r.Context())
	if err != nil {
		s.serverError(w, r, "load realms", err)
		return
	}

	page.Title = page.T("realm.title")
	page.Active = "admin-realms"
	s.rend.Render(w, http.StatusOK, "admin_realms", adminRealmsView{
		PageData: *page,
		Realms:   realms,
	})
}

func (s *Server) handleAdminRealmUpdate(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	id, ok := s.parseUintPath(r, "id")
	if !ok {
		s.notFound(w, r)
		return
	}

	name := strings.TrimSpace(r.PostFormValue("name"))
	address := strings.TrimSpace(r.PostFormValue("address"))
	port := clampInt(atoiDefault(r.PostFormValue("port"), s.cfg.WorldPort), 1, 65535)

	if name == "" || address == "" {
		s.setFlash(w, "error", page.T("flash.err.realmEmpty"))
		http.Redirect(w, r, "/admin/realms", http.StatusSeeOther)
		return
	}

	err := s.store.UpdateRealmNameAndAddress(ctx, id, name, address, port)
	switch {
	case errors.Is(err, store.ErrDuplicate):
		s.setFlash(w, "error", page.T("flash.err.realmNameTaken"))
	case errors.Is(err, store.ErrNotFound):
		s.notFound(w, r)
		return
	case err != nil:
		s.serverError(w, r, "update realm", err)
		return
	default:
		_ = s.store.Audit(ctx, actor.ID, actor.Username, "realm-update",
			fmt.Sprintf("realm:%d", id),
			fmt.Sprintf("%s -> %s:%d", name, address, port), s.clientIP(r))
		s.setFlash(w, "ok", page.T("flash.ok.realmUpdated"))
	}
	http.Redirect(w, r, "/admin/realms", http.StatusSeeOther)
}

func (s *Server) handleAdminRealmFlags(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	id, ok := s.parseUintPath(r, "id")
	if !ok {
		s.notFound(w, r)
		return
	}

	// Rebuild the flag mask from the submitted checkboxes. OFFLINE is managed
	// by mangosd and is never part of the form.
	var flags uint8
	for _, flag := range store.RealmFlagNames {
		if r.PostFormValue(fmt.Sprintf("flag_%d", flag.Bit)) == "1" {
			flags |= flag.Bit
		}
	}

	if err := s.store.UpdateRealmFlags(ctx, id, flags); err != nil {
		s.serverError(w, r, "update realm flags", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "realm-flags",
		fmt.Sprintf("realm:%d", id), fmt.Sprintf("flags=0x%02X", flags), s.clientIP(r))
	s.setFlash(w, "ok", page.T("flash.ok.realmFlagsUpdated"))
	http.Redirect(w, r, "/admin/realms", http.StatusSeeOther)
}

func (s *Server) handleAdminRealmSecurity(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	id, ok := s.parseUintPath(r, "id")
	if !ok {
		s.notFound(w, r)
		return
	}
	level := uint8(clampInt(atoiDefault(r.PostFormValue("level"), 0), 0, 6))

	if err := s.store.SetRealmAllowedSecurityLevel(ctx, id, level); err != nil {
		s.serverError(w, r, "set realm security level", err)
		return
	}
	// Audit details are stored in English on purpose: the log is a record of
	// what happened, and it stays searchable no matter which language the
	// administrator was using.
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "realm-security",
		fmt.Sprintf("realm:%d", id),
		fmt.Sprintf("allowedSecurityLevel=%d (%s)", level, store.RankName(level)),
		s.clientIP(r))

	if level == 0 {
		s.setFlash(w, "ok", page.T("flash.ok.realmOpen"))
	} else {
		s.setFlash(w, "ok", fmt.Sprintf(page.T("flash.ok.realmRestricted"), level, page.RankName(level)))
	}
	http.Redirect(w, r, "/admin/realms", http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Audit
// ---------------------------------------------------------------------------

type adminAuditView struct {
	PageData
	Entries []store.AuditEntry
}

func (s *Server) handleAdminAudit(w http.ResponseWriter, r *http.Request, page *PageData) {
	entries, err := s.store.RecentAudit(r.Context(), 200)
	if err != nil {
		s.serverError(w, r, "load audit log", err)
		return
	}
	page.Title = page.T("audit.title")
	page.Active = "admin-audit"
	s.rend.Render(w, http.StatusOK, "admin_audit", adminAuditView{
		PageData: *page,
		Entries:  entries,
	})
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

func boolPtr(v bool) *bool { return &v }

func uint8Ptr(v uint8) *uint8 { return &v }

func atoiDefault(s string, def int) int {
	if s == "" {
		return def
	}
	n, err := strconv.Atoi(strings.TrimSpace(s))
	if err != nil {
		return def
	}
	return n
}

func clampInt(v, lo, hi int) int {
	if v < lo {
		return lo
	}
	if v > hi {
		return hi
	}
	return v
}

func pages(total, per int) int {
	if per <= 0 {
		return 1
	}
	n := (total + per - 1) / per
	if n < 1 {
		return 1
	}
	return n
}

// parseDuration accepts "0" (permanent) or a number of hours.
func parseDuration(raw string) (time.Duration, error) {
	raw = strings.TrimSpace(raw)
	if raw == "" || raw == "0" {
		return 0, nil // permanent: the core marks this with bandate == unbandate
	}
	hours, err := strconv.Atoi(raw)
	if err != nil {
		return 0, err
	}
	if hours < 0 {
		return 0, errors.New("negative duration")
	}
	if hours > 24*365*10 {
		return 0, errors.New("duration too long")
	}
	return time.Duration(hours) * time.Hour, nil
}

// baseQuery returns the current query string without the page parameter, so
// pagination links keep the active filters.
func baseQuery(r *http.Request) string {
	q := r.URL.Query()
	q.Del("page")
	if len(q) == 0 {
		return ""
	}
	return q.Encode() + "&"
}

func enabledState(on bool) string {
	if on {
		return "set"
	}
	return "cleared"
}
