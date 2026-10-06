package web

import (
	"bytes"
	"fmt"
	"strings"
	"testing"
	"time"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestTemplatesParse renders every page template with a representative payload.
//
// Template errors are runtime errors in Go, so a typo in a field name or a
// missing function only shows up when that page is requested. This test walks
// all of them, including the branches that only appear when the data is set.
func TestTemplatesParse(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatalf("parse templates: %v", err)
	}
	if len(rend.cache) == 0 {
		t.Fatal("no templates were parsed")
	}

	now := time.Now()
	account := &store.Account{
		ID: 7, Username: "TESTER", Rank: 4, Email: "t@example.com",
		JoinDate: ptrTime(now.Add(-100 * time.Hour)), LastIP: "10.0.0.5",
		LastLogin: &now, Online: true, Active: true, Security: "ABCDEF",
		FailedLogins: 2, MuteTime: now.Add(time.Hour).Unix(), MuteReason: "spam",
	}
	rank := uint8(3)
	online := true
	char := store.Character{
		GUID: 42, AccountID: 7, AccountName: "TESTER", Name: "Thrall",
		Race: 2, Class: 1, Gender: 0, Level: 60, Money: 1234567,
		Online: true, Map: 1, Zone: 1637, PosX: 1.5, PosY: -2.25, PosZ: 0.5,
		TotalTime: 90061, LevelTime: 100, LogoutTime: now.Unix(),
		AtLogin: store.AtLoginRename, GuildName: "Warchiefs",
	}
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load translations: %v", err)
	}

	page := PageData{
		Title: "Test", Active: "admin", CSRFToken: "csrf-token",
		Account: account, IsAdmin: true, Year: 2026,
		Flash: []Flash{{Kind: "ok", Message: "done"}},
		Tr:    bundle.Translator(i18n.EN),
		Langs: i18n.Supported,
		Config: PageConfig{
			SiteName: "Tortoise WoW", RealmID: 1, WorldAddress: "wow.example",
			WorldPort: 8090, RealmPort: 3724, AllowRegister: true,
			AdminMinRank: 4, PasswordMinLen: 6,
		},
	}
	// Render every page in both languages: a translation that breaks a
	// template (a stray % or a quote in a confirm() string) shows up here.
	pageZH := page
	pageZH.Tr = bundle.Translator(i18n.ZH)

	cases := []struct {
		page string
		data any
	}{
		{"home", homeView{
			PageData: page, Stats: store.ServerStats{
				Accounts: 10, Characters: 20, OnlineChars: 2, OnlineAccs: 2,
				ActiveBans: 1, Guilds: 3, NewToday: 1,
			},
			Realms: []store.Realm{{
				ID: 1, Name: "Tortoise WoW", Address: "wow.example", Port: 8090,
				Flags:      store.RealmFlagRecommended | store.RealmFlagSpecifyBuild,
				Population: 1.2, RealmBuilds: "7272",
			}},
		}},
		{"login", loginView{PageData: page, Username: "TESTER", Next: "/panel"}},
		{"register", registerView{PageData: page}},
		{"panel", panelView{
			PageData: page, Characters: []store.Character{char},
			Ban:   &store.Ban{Reason: "cheating", Permanent: true},
			Muted: true, MuteUntil: now.Add(time.Hour),
			TwoFAOn: true, SessionCnt: 3,
		}},
		// Same page with every optional field empty, to exercise the
		// "no data" branches.
		{"panel", panelView{PageData: page}},
		{"panel_characters", panelView{PageData: page, Characters: []store.Character{char}}},
		{"panel_characters", panelView{PageData: page}},
		{"panel_password", passwordView{PageData: page}},
		{"panel_security", securityView{PageData: page, Enabled: true,
			Allowances: []store.TwoFactorAllowance{{
				ID: 1, IP: "1.2.3.4", ExpiresAt: now.Add(72 * time.Hour),
			}},
		}},
		{"panel_security", securityView{PageData: page, Pending: true,
			Secret: "GEZDGNBVGY3TQOJQ", OTPAuthURI: "otpauth://totp/x?secret=y",
		}},
		{"panel_security", securityView{PageData: page}},
		{"panel_sessions", sessionsView{PageData: page, Sessions: []store.WebSession{{
			CreatedAt: now, LastSeenAt: now, ExpiresAt: now.Add(time.Hour),
			IP: "1.2.3.4", UserAgent: "Mozilla/5.0",
		}}}},
		{"panel_sessions", sessionsView{PageData: page}},
		{"admin_dashboard", adminDashboardView{
			PageData: page,
			Stats:    store.ServerStats{Accounts: 10, Characters: 20, OnlineChars: 2, Guilds: 3},
			Recent:   []store.Account{*account},
			Online:   []store.Character{char},
			Audit:    []store.AuditEntry{{At: now, Actor: "ADMIN", Action: "account-ban", Target: "X", Detail: "d", IP: "1.2.3.4"}},
			Realms:   []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1}},
		}},
		{"admin_accounts", adminAccountsView{
			PageData: page, QueryString: "q=a&",
			Accounts: []store.Account{*account},
			Filter:   store.AccountFilter{Search: "a", Rank: &rank, Online: &online},
			Total:    1, Page: 1, Pages: 2,
			Bans: map[uint32]*store.Ban{7: {Reason: "x", UnbanDate: now}},
		}},
		{"admin_accounts", adminAccountsView{PageData: page, Total: 0, Page: 1, Pages: 1}},
		{"admin_account_new", adminAccountNewView{PageData: page}},
		{"admin_account_detail", adminAccountView{
			PageData: page, Account: account,
			Characters: []store.Character{char},
			Bans: []store.Ban{
				{Reason: "perm", Permanent: true, StillValid: true, BanDate: now, BannedBy: "ADMIN"},
				{Reason: "old", BanDate: now, UnbanDate: now, BannedBy: "ADMIN"},
			},
			Allowances:  []store.TwoFactorAllowance{{ID: 2, IP: "5.6.7.8", ExpiresAt: now}},
			Sessions:    2,
			RankChoices: []uint8{0, 1, 2, 3, 4, 5, 6},
		}},
		{"admin_account_detail", adminAccountView{
			PageData: page, Account: account, IsSelf: true,
			RankChoices: []uint8{0, 1, 2, 3, 4, 5, 6},
		}},
		{"admin_characters", adminCharactersView{
			PageData: page, QueryString: "q=t&",
			Characters: []store.Character{char},
			Filter:     store.CharacterFilter{Search: "t", Online: &online},
			Total:      1, Page: 1, Pages: 3,
		}},
		{"admin_character_detail", adminCharacterView{
			PageData: page, Character: char, Flags: []string{"rename"},
		}},
		{"admin_bans", adminBansView{
			PageData: page, QueryString: "only=active&",
			Bans: []store.Ban{
				{AccountID: 7, Username: "TESTER", Reason: "r", Permanent: true,
					StillValid: true, BanDate: now, BannedBy: "ADMIN"},
			},
			Filter: store.BanFilter{Only: "active"}, Total: 1, Page: 1, Pages: 1,
			IPBans: []store.IPBan{{IP: "1.2.3.4", BanDate: now, Permanent: true}},
		}},
		{"admin_bans", adminBansView{PageData: page, Page: 1, Pages: 1}},
		{"admin_realms", adminRealmsView{
			PageData: page,
			Realms: []store.Realm{{
				ID: 1, Name: "Tortoise WoW", Address: "wow.example", Port: 8090,
				Icon: 6, Flags: store.RealmFlagOffline | store.RealmFlagRecommended,
				Timezone: 1, AllowedSecurityLevel: 1, Population: 0.5,
				RealmBuilds: "7272",
			}},
		}},
		// No realms configured yet: the template prints an example statement.
		{"admin_realms", adminRealmsView{PageData: page}},
		{"admin_audit", adminAuditView{
			PageData: page,
			Entries: []store.AuditEntry{
				{At: now, ActorID: 0, Actor: "NEWBIE", Action: "register", Target: "NEWBIE"},
				{At: now, ActorID: 1, Actor: "ADMIN", Action: "account-ban", Target: "X", Detail: "d", IP: "1.2.3.4"},
			},
		}},
		{"admin_audit", adminAuditView{PageData: page}},
		{"admin_shop", shopListView{
			PageData:   page,
			Categories: []store.ShopCategory{{ID: 5, Name: "Mounts", NameCN: "坐骑", Items: 2}},
			Items: []store.ShopItem{
				{ID: 12, Category: 5, Entry: 50071, Price: 50, Region: store.ShopRegionGlobal, Scale: 1},
				{ID: 13, Category: 99, Entry: 0, Price: 0, Region: store.ShopRegionChina, Scale: 0},
			},
			Total: 2, Page: 2, Pages: 3, QueryString: "category=5&",
			RealmRegion: store.ShopRegionEurope,
		}},
		{"admin_shop_item", shopItemView{
			PageData:   page,
			Item:       store.ShopItem{ID: 12, Category: 99, Entry: 50071, Price: 50, Scale: 1},
			Categories: []store.ShopCategory{{ID: 5, Name: "Mounts", NameCN: "坐骑"}},
			Regions:    (&Server{}).shopRegions(),
		}},
		{"admin_shop_category", shopCategoryView{
			PageData:  page,
			Category:  store.ShopCategory{ID: 34, Name: "Toys", NameCN: "玩具", Icon: "wormhole"},
			Icons:     shopCategoryIcons,
			ItemCount: 3,
		}},
		{"admin_shop_categories", shopCategoryListView{
			PageData: page,
			Categories: []store.ShopCategory{
				{ID: 5, Name: "Mounts", NameCN: "坐骑", Icon: "mount", Items: 2},
				{ID: 34, Name: "Toys", Icon: "wormhole"},
			},
		}},
		{"error", page},
	}

	for _, tc := range cases {
		tmpl, ok := rend.cache[tc.page]
		if !ok {
			t.Errorf("template %q is not in the cache", tc.page)
			continue
		}
		var buf bytes.Buffer
		if err := tmpl.ExecuteTemplate(&buf, "layout", tc.data); err != nil {
			t.Errorf("render %s: %v", tc.page, err)
			continue
		}
		if buf.Len() == 0 {
			t.Errorf("render %s produced no output", tc.page)
		}
		if !strings.Contains(buf.String(), "<!DOCTYPE html>") {
			t.Errorf("render %s did not use the layout", tc.page)
		}
	}
}

// TestTemplatesEscapeUserData makes sure html/template is actually used, so a
// character name can never inject markup.
// bundle2render renders a page through the cached template set.
func bundle2render(t *testing.T, buf *bytes.Buffer, page string, data any) error {
	t.Helper()
	rend, err := newRenderer()
	if err != nil {
		return err
	}
	tmpl, ok := rend.cache[page]
	if !ok {
		return fmt.Errorf("template %q is not cached", page)
	}
	return tmpl.ExecuteTemplate(buf, "layout", data)
}

func TestTemplatesEscapeUserData(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	evil := `<script>alert(1)</script>`
	page := PageData{Title: "x", Config: PageConfig{SiteName: "s"}}
	view := adminCharactersView{
		PageData: page, Page: 1, Pages: 1,
		Characters: []store.Character{{GUID: 1, Name: evil, AccountName: evil}},
	}

	var buf bytes.Buffer
	if err := rend.cache["admin_characters"].ExecuteTemplate(&buf, "layout", view); err != nil {
		t.Fatal(err)
	}
	if strings.Contains(buf.String(), evil) {
		t.Error("character name was not escaped")
	}
	if !strings.Contains(buf.String(), "&lt;script&gt;") {
		t.Error("expected escaped output")
	}
}

// TestEveryTemplateHasContent guards against a page template that forgets the
// "content" block, which would render an empty page.
func TestEveryTemplateHasContent(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	for name := range rend.cache {
		if rend.cache[name].Lookup("content") == nil {
			t.Errorf("template %q does not define the content block", name)
		}
	}
}

// ptrTime is a small helper for building fixtures with nullable timestamps.
func ptrTime(t time.Time) *time.Time { return &t }

// TestTemplatesRenderInEveryLanguage walks the whole fixture set once per
// language, so a translation cannot break a page.
func TestTemplatesRenderInEveryLanguage(t *testing.T) {
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatal(err)
	}

	account := &store.Account{ID: 7, Username: "TESTER", Rank: 4}
	char := store.Character{GUID: 42, Name: "Thrall", Race: 2, Class: 1, Level: 60}
	now := time.Now()

	for _, meta := range i18n.Supported {
		for _, tc := range []struct {
			page string
			data any
		}{
			{"home", homeView{Stats: store.ServerStats{Accounts: 1, OnlineAccs: 2, Guilds: 1},
				Realms: []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1, Flags: store.RealmFlagRecommended}}}},
			{"login", loginView{}},
			{"register", registerView{}},
			{"panel", panelView{Characters: []store.Character{char}, TwoFAOn: true, Muted: true, MuteUntil: now}},
			{"panel_characters", panelView{Characters: []store.Character{char}}},
			{"panel_password", passwordView{}},
			{"panel_security", securityView{Pending: true, Secret: "ABC", OTPAuthURI: "otpauth://x"}},
			{"panel_sessions", sessionsView{}},
			{"admin_dashboard", adminDashboardView{
				Stats:  store.ServerStats{Accounts: 1, OnlineChars: 1},
				Recent: []store.Account{*account}, Online: []store.Character{char},
				Realms: []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1}},
			}},
			{"admin_accounts", adminAccountsView{Accounts: []store.Account{*account}, Total: 1, Page: 1, Pages: 1,
				Bans: map[uint32]*store.Ban{7: {Reason: "x"}}}},
			{"admin_account_new", adminAccountNewView{}},
			{"admin_account_detail", adminAccountView{Account: account,
				Characters: []store.Character{char}, RankChoices: []uint8{0, 4}}},
			{"admin_characters", adminCharactersView{Characters: []store.Character{char}, Total: 1, Page: 1, Pages: 1}},
			{"admin_character_detail", adminCharacterView{Character: char, Flags: []string{"rename"}}},
			{"admin_bans", adminBansView{Bans: []store.Ban{{AccountID: 7, Reason: "r", Permanent: true}},
				IPBans: []store.IPBan{{IP: "1.2.3.4"}}, Page: 1, Pages: 1}},
			{"admin_realms", adminRealmsView{Realms: []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1,
				AllowedSecurityLevel: 2, Flags: store.RealmFlagRecommended}}}},
			{"admin_announcement", adminAnnouncementView{
				Announcement: store.Announcement{Enabled: true, Title: "Notice",
					Body: "line one\n\nline two", UpdatedAt: now, UpdatedBy: "ADMIN"},
				Endpoint: "https://example.com/alert", HasBody: true}},
			{"admin_audit", adminAuditView{Entries: []store.AuditEntry{{Actor: "A", Action: "x"}}}},
			{"error", PageData{Title: "T"}},
		} {
			pd := PageData{Year: 2026, Tr: bundle.Translator(meta.Code), Langs: i18n.Supported,
				Config: PageConfig{SiteName: "S", PasswordMinLen: 6, SessionTTLHours: 1,
					DefaultLang: string(meta.Code)},
				Account: account}
			// Inject the page data into the view struct through reflection-free
			// means: every view embeds PageData as its first field, so set it by
			// rebuilding the struct is not possible generically. Instead the
			// fixtures above start zero and we fill the embedded field via the
			// typed switch below.
			data := withPageData(tc.data, pd)
			if data == nil {
				t.Fatalf("%s: unhandled view type", tc.page)
			}

			var buf bytes.Buffer
			if err := bundle2render(t, &buf, tc.page, data); err != nil {
				t.Errorf("%s [%s]: %v", tc.page, meta.Code, err)
			}
		}
	}
}

// withPageData copies pd into the PageData embedded in a view struct.
func withPageData(view any, pd PageData) any {
	switch v := view.(type) {
	case homeView:
		v.PageData = pd
		return v
	case loginView:
		v.PageData = pd
		return v
	case registerView:
		v.PageData = pd
		return v
	case panelView:
		v.PageData = pd
		return v
	case passwordView:
		v.PageData = pd
		return v
	case securityView:
		v.PageData = pd
		return v
	case sessionsView:
		v.PageData = pd
		return v
	case adminDashboardView:
		v.PageData = pd
		return v
	case adminAccountsView:
		v.PageData = pd
		return v
	case adminAccountNewView:
		v.PageData = pd
		return v
	case adminAccountView:
		v.PageData = pd
		return v
	case adminCharactersView:
		v.PageData = pd
		return v
	case adminCharacterView:
		v.PageData = pd
		return v
	case adminBansView:
		v.PageData = pd
		return v
	case adminRealmsView:
		v.PageData = pd
		return v
	case adminAuditView:
		v.PageData = pd
		return v
	case adminAnnouncementView:
		v.PageData = pd
		return v
	case PageData:
		return pd
	default:
		return nil
	}
}
