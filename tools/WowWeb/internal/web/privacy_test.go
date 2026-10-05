package web

import (
	"net/http/httptest"
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestAnonymousVisitorSeesNoRealmDetails covers the rule that a signed-out
// visitor is told what the site is and how to join, but nothing about where the
// realm lives or how busy it is.
//
// The address and port are the reason: a public page that lists them is an
// invitation to scan or flood the realm, so they must not appear anywhere an
// anonymous request can reach - the home page, the footer, or the status API.
func TestAnonymousVisitorSeesNoRealmDetails(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatalf("parse templates: %v", err)
	}
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load i18n: %v", err)
	}

	const (
		worldAddr = "203.0.113.7"
		worldPort = 8090
		loginPort = 3724
	)

	pageData := func(acct *store.Account) PageData {
		return PageData{
			Year:    2026,
			Tr:      bundle.Translator(i18n.EN),
			Account: acct,
			Config: PageConfig{
				SiteName: "Test Realm", RealmName: "Test Realm",
				WorldAddress: worldAddr, WorldPort: worldPort, RealmPort: loginPort,
				PasswordMinLen: 6, SessionTTLHours: 1,
			},
		}
	}

	stats := store.ServerStats{Accounts: 12, Characters: 34, OnlineChars: 5, OnlineAccs: 4, Guilds: 3, ActiveBans: 2}
	realms := []store.Realm{{
		ID: 1, Name: "Test Realm", Address: worldAddr, Port: worldPort,
		Flags: store.RealmFlagRecommended,
	}}

	render := func(acct *store.Account) string {
		t.Helper()
		rec := httptest.NewRecorder()
		rend.Render(rec, 200, "home", homeView{
			PageData: pageData(acct), Stats: stats, Realms: realms, RealmCount: len(realms),
		})
		if rec.Code != 200 {
			t.Fatalf("render home: status %d", rec.Code)
		}
		return rec.Body.String()
	}

	t.Run("anonymous", func(t *testing.T) {
		body := render(nil)
		for _, leak := range []string{
			worldAddr, "8090", ":3724",
			// the stat cards
			">12<", ">34<", ">5<", ">4<", ">3<", ">2<",
			// and their headings
			"Players online", "Accounts", "Characters", "Active bans",
		} {
			if strings.Contains(body, leak) {
				t.Errorf("anonymous home page contains %q", leak)
			}
		}
		// It should still explain what the site is and offer a way in.
		if !strings.Contains(body, "Test Realm") {
			t.Error("anonymous home page does not name the site")
		}
		if !strings.Contains(body, "/register") && !strings.Contains(body, "/login") {
			t.Error("anonymous home page offers neither registration nor sign-in")
		}
	})

	t.Run("signed in", func(t *testing.T) {
		body := render(&store.Account{ID: 7, Username: "TESTER", Rank: 0})
		for _, want := range []string{worldAddr, "8090", "3724"} {
			if !strings.Contains(body, want) {
				t.Errorf("signed-in home page is missing %q", want)
			}
		}
		for _, want := range []string{">12<", ">34<", ">5<"} {
			if !strings.Contains(body, want) {
				t.Errorf("signed-in home page is missing the stat %q", want)
			}
		}
	})
}
