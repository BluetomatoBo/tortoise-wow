package web

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestSoleURL pins the rule that decides which lines become links.
//
// The client refuses an address it cannot open, and it refuses it silently, so
// emitting an anchor for one of those would produce a dead link. Everything here
// that is not a lone, openable address has to stay text.
func TestSoleURL(t *testing.T) {
	open := "http://twow.home.boym.me/notice"
	cases := []struct {
		name string
		in   string
		want string
	}{
		{"plain address", open, open},
		{"surrounding spaces", "  " + open + "  ", open},
		{"trailing chinese full stop", open + "。", open},
		{"trailing ascii full stop", open + ".", open},
		{"trailing closing bracket", open + "）", open},
		{"address with a path and a dash", "http://twow.home.boym.me/account/no-time",
			"http://twow.home.boym.me/account/no-time"},

		{"empty", "", ""},
		{"not a url", "服务器维护中", ""},
		{"no scheme", "twow.home.boym.me/notice", ""},
		{"https is refused by the client", "https://twow.home.boym.me/notice", ""},
		{"a port is refused by the client", "http://twow.home.boym.me:8080/notice", ""},
		{"a query is refused by the client", "http://twow.home.boym.me/notice?a=1", ""},
		{"an underscore is refused by the client", "http://twow.home.boym.me/a_b", ""},
		{"address inside a sentence", "详情见 " + open, ""},
		{"address followed by a word", open + " 查看", ""},
		{"two addresses on one line", open + " " + open, ""},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := soleURL(tc.in); got != tc.want {
				t.Errorf("soleURL(%q) = %q, want %q", tc.in, got, tc.want)
			}
		})
	}
}

// TestNoticeLines covers the normalisation both the panel and the web page use,
// so the two views cannot disagree about what is a paragraph.
func TestNoticeLines(t *testing.T) {
	got := noticeLines("one\r\n\r\ntwo   \n")
	want := []string{"one", "", "two", ""}
	if len(got) != len(want) {
		t.Fatalf("noticeLines gave %q, want %q", got, want)
	}
	for i := range want {
		if got[i] != want[i] {
			t.Errorf("line %d = %q, want %q", i, got[i], want[i])
		}
	}
}

// TestAccountNoticeReasonsAreReachable walks every reason the client can send a
// player here for, and checks that anything else is refused.
//
// The list is shared with the client patch - each AUTH_*_URL ends in one of
// these words - so a typo would show up as a 404 in a browser that the client
// just opened, with no other symptom.
func TestAccountNoticeReasonsAreReachable(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatalf("parse templates: %v", err)
	}
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load i18n: %v", err)
	}

	srv := &Server{rend: rend}
	pageFor := func() *PageData {
		return &PageData{
			Year: 2026,
			Tr:   bundle.Translator(i18n.EN),
			Config: PageConfig{
				SiteName: "Test Realm", RealmName: "Test Realm",
				WorldAddress: "203.0.113.7", WorldPort: 8090, RealmPort: 3724,
				AllowRegister: true,
			},
		}
	}
	call := func(reason string) *httptest.ResponseRecorder {
		t.Helper()
		r := httptest.NewRequest(http.MethodGet, "/account/"+reason, nil)
		r.SetPathValue("reason", reason)
		rec := httptest.NewRecorder()
		srv.handleAccountNotice(rec, r, pageFor())
		return rec
	}

	// Each reason names itself, so the page that explains a ban is not the one
	// that explains an unverified address.
	seen := map[string]string{}
	for _, reason := range accountNoticeReasons {
		rec := call(reason)
		if rec.Code != http.StatusOK {
			t.Fatalf("reason %q: status %d", reason, rec.Code)
		}
		body := rec.Body.String()
		want := bundle.Translator(i18n.EN).T("reason." + reason + ".title")
		if want == "" || !strings.Contains(body, want) {
			t.Errorf("reason %q: page does not carry its title %q", reason, want)
		}
		if prev, dup := seen[body]; dup {
			t.Errorf("reason %q renders the same page as %q", reason, prev)
		}
		seen[body] = reason

		// Public page, so it must not describe the realm.
		for _, leak := range []string{"203.0.113.7", "8090", ":3724"} {
			if strings.Contains(body, leak) {
				t.Errorf("reason %q leaks %q", reason, leak)
			}
		}
	}

	for _, bad := range []string{"", "banned2", "BANNED", "root", "no_time", "../banned"} {
		if rec := call(bad); rec.Code != http.StatusNotFound {
			t.Errorf("reason %q: status %d, want 404", bad, rec.Code)
		}
	}
}

// TestNoticePageRendersTheAnnouncement covers the page the panel's link opens.
//
// It is rendered directly rather than through the handler because the handler
// reads the database, and what is worth pinning here is the page: that the
// paragraphs and the link survive, and that nothing about the realm does.
func TestNoticePageRendersTheAnnouncement(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatalf("parse templates: %v", err)
	}
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load i18n: %v", err)
	}
	tr := bundle.Translator(i18n.EN)

	render := func(v noticeView) string {
		t.Helper()
		v.PageData = PageData{
			Year: 2026,
			Tr:   tr,
			Config: PageConfig{
				SiteName: "Test Realm", RealmName: "Test Realm",
				WorldAddress: "203.0.113.7", WorldPort: 8090, RealmPort: 3724,
				AllowRegister: true,
			},
		}
		rec := httptest.NewRecorder()
		rend.Render(rec, http.StatusOK, "notice", v)
		if rec.Code != http.StatusOK {
			t.Fatalf("render notice: status %d", rec.Code)
		}
		return rec.Body.String()
	}

	t.Run("with an announcement", func(t *testing.T) {
		body := render(noticeView{
			Announcement: store.Announcement{
				Enabled:   true,
				Title:     "维护公告",
				Body:      "第一行\nhttp://twow.home.boym.me/notice",
				UpdatedAt: time.Date(2026, 10, 6, 12, 0, 0, 0, time.UTC),
			},
			HasBody:    true,
			Paragraphs: []string{"第一行"},
			LinkURL:    "http://twow.home.boym.me/notice",
		})
		for _, want := range []string{"维护公告", "第一行", `href="http://twow.home.boym.me/notice"`} {
			if !strings.Contains(body, want) {
				t.Errorf("notice page is missing %q", want)
			}
		}
		for _, leak := range []string{"203.0.113.7", "8090", ":3724"} {
			if strings.Contains(body, leak) {
				t.Errorf("notice page leaks %q", leak)
			}
		}
	})

	t.Run("switched off", func(t *testing.T) {
		body := render(noticeView{Announcement: store.Announcement{Enabled: false}})
		if !strings.Contains(body, tr.T("notice.empty")) {
			t.Errorf("an empty announcement does not say so: %q", body)
		}
	})
}
