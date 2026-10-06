package web

import (
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"testing"

	"tortoiseweb/internal/config"
	"tortoiseweb/internal/store"
)

// TestRoutesAreRegistered checks that every documented path and method resolves
// to a handler.
//
// Go's ServeMux only reports a routing mistake at request time, and a wrong
// method produces a confusing 405 instead of a 404, so this walks the full
// route table. The handlers are resolved but never executed, which is why a nil
// store is fine here.
func TestRoutesAreRegistered(t *testing.T) {
	srv, err := New(config.Config{RealmName: "Test", AdminMinRank: 4}, (*store.Store)(nil),
		slog.New(slog.NewTextHandler(io.Discard, nil)))
	if err != nil {
		t.Fatalf("New: %v", err)
	}

	routes := []struct {
		method string
		path   string
	}{
		// public
		{"GET", "/"},
		{"GET", "/healthz"},
		{"GET", "/api/status"},
		{"GET", "/register"},
		{"POST", "/register"},
		{"GET", "/login"},
		{"POST", "/login"},
		{"POST", "/logout"},
		// Fetched by the game client's login screen, so it must stay reachable
		// without a session.
		{"GET", "/alert"},
		// Where the client's links land, likewise reachable without a session:
		// the player who needs them is the one who could not sign in.
		{"GET", "/notice"},
		{"GET", "/account/banned"},
		{"GET", "/account/suspended"},
		{"GET", "/account/no-time"},
		{"GET", "/account/verify"},
		{"GET", "/assets/style.css"},

		// player area
		{"GET", "/panel"},
		{"GET", "/panel/password"},
		{"POST", "/panel/password"},
		{"GET", "/panel/characters"},
		{"POST", "/panel/characters/42/unstick"},
		{"GET", "/panel/security"},
		{"POST", "/panel/security/enable"},
		{"POST", "/panel/security/confirm"},
		{"POST", "/panel/security/disable"},
		{"POST", "/panel/security/revoke"},
		{"GET", "/panel/sessions"},
		{"POST", "/panel/sessions/revoke"},

		// administration
		{"GET", "/admin"},
		{"GET", "/admin/accounts"},
		{"GET", "/admin/accounts/new"},
		{"POST", "/admin/accounts/new"},
		{"GET", "/admin/accounts/7"},
		{"POST", "/admin/accounts/7/rank"},
		{"POST", "/admin/accounts/7/password"},
		{"POST", "/admin/accounts/7/email"},
		{"POST", "/admin/accounts/7/active"},
		{"POST", "/admin/accounts/7/ban"},
		{"POST", "/admin/accounts/7/unban"},
		{"POST", "/admin/accounts/7/mute"},
		{"POST", "/admin/accounts/7/unmute"},
		{"POST", "/admin/accounts/7/reset-2fa"},
		{"POST", "/admin/accounts/7/delete"},
		{"GET", "/admin/characters"},
		{"GET", "/admin/characters/42"},
		{"POST", "/admin/characters/42/rename"},
		{"POST", "/admin/characters/42/unstick"},
		{"POST", "/admin/characters/42/atlogin"},
		{"POST", "/admin/characters/42/level"},
		{"GET", "/admin/bans"},
		{"POST", "/admin/bans/ip"},
		{"POST", "/admin/bans/ip/remove"},
		{"GET", "/admin/announcement"},
		{"POST", "/admin/announcement"},
		{"GET", "/admin/realms"},
		{"POST", "/admin/realms/1"},
		{"POST", "/admin/realms/1/flags"},
		{"POST", "/admin/realms/1/security"},
		{"GET", "/admin/audit"},
	}

	for _, r := range routes {
		req := httptest.NewRequest(r.method, r.path, nil)
		_, pattern := srv.mux.Handler(req)
		if pattern == "" {
			t.Errorf("%s %s is not routed", r.method, r.path)
		}
	}
}

// TestWrongMethodIsRejected makes sure a POST-only action cannot be triggered by
// a GET, which matters for anything that changes state.
func TestWrongMethodIsRejected(t *testing.T) {
	srv, err := New(config.Config{RealmName: "Test", AdminMinRank: 4}, (*store.Store)(nil),
		slog.New(slog.NewTextHandler(io.Discard, nil)))
	if err != nil {
		t.Fatal(err)
	}

	// Note: /panel/password is deliberately absent - it serves the form on GET
	// and processes it on POST.
	postOnly := []string{
		"/logout",
		"/panel/security/enable",
		"/panel/security/disable",
		"/admin/accounts/7/ban",
		"/admin/accounts/7/delete",
		"/admin/realms/1/flags",
	}
	for _, path := range postOnly {
		req := httptest.NewRequest(http.MethodGet, path, nil)
		if _, pattern := srv.mux.Handler(req); pattern != "" {
			t.Errorf("GET %s resolved to %q; state-changing routes must be POST only", path, pattern)
		}
	}
}

// TestUnknownPathIsNotRouted guards against a catch-all pattern swallowing every
// request, which would turn 404s into confusing errors.
func TestUnknownPathIsNotRouted(t *testing.T) {
	srv, err := New(config.Config{RealmName: "Test", AdminMinRank: 4}, (*store.Store)(nil),
		slog.New(slog.NewTextHandler(io.Discard, nil)))
	if err != nil {
		t.Fatal(err)
	}
	for _, path := range []string{"/nope", "/admin/nope", "/panel/nope"} {
		req := httptest.NewRequest(http.MethodGet, path, nil)
		if _, pattern := srv.mux.Handler(req); pattern != "" {
			t.Errorf("GET %s unexpectedly resolved to %q", path, pattern)
		}
	}
}

// TestPathValuesParse documents that parseUintPath accepts digits only, so a
// non-numeric or overflowing {id} is rejected before it reaches a query.
func TestPathValuesParse(t *testing.T) {
	srv, _ := New(config.Config{}, (*store.Store)(nil),
		slog.New(slog.NewTextHandler(io.Discard, nil)))

	cases := []struct {
		value  string
		want   uint32
		wantOK bool
	}{
		{"0", 0, true},
		{"42", 42, true},
		{"4294967295", 4294967295, true}, // max uint32
		{"4294967296", 0, false},         // one past max uint32
		{"", 0, false},
		{"abc", 0, false},
		{"12a", 0, false},
		{"-1", 0, false},
		{"1.5", 0, false},
	}

	for _, tc := range cases {
		req := httptest.NewRequest(http.MethodGet, "/", nil)
		req.SetPathValue("id", tc.value)

		got, ok := srv.parseUintPath(req, "id")
		if ok != tc.wantOK {
			t.Errorf("parseUintPath(%q) ok = %v, want %v", tc.value, ok, tc.wantOK)
			continue
		}
		if ok && got != tc.want {
			t.Errorf("parseUintPath(%q) = %d, want %d", tc.value, got, tc.want)
		}
	}
}

func lastSegment(path string) string {
	for i := len(path) - 1; i >= 0; i-- {
		if path[i] == '/' {
			return path[i+1:]
		}
	}
	return path
}
