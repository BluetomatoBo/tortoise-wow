package i18n

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestParse(t *testing.T) {
	cases := []struct {
		in     string
		want   Lang
		wantOK bool
	}{
		{"en", EN, true},
		{"EN", EN, true},
		{"en-US", EN, true},
		{"en_GB", EN, true},
		{"zh", ZH, true},
		{"ZH", ZH, true},
		// Browsers send these forms for Simplified and Traditional Chinese.
		{"zh-CN", ZH, true},
		{"zh-Hans", ZH, true},
		{"zh-Hans-CN", ZH, true},
		{"zh-TW", ZH, true},
		{"zh_CN", ZH, true},
		{" zh ", ZH, true},
		// Only the first tag is considered.
		{"zh-CN,en;q=0.8", ZH, true},
		{"en;q=0.9", EN, true},
		// Unsupported languages are rejected so the caller can fall back.
		{"de", "", false},
		{"fr-FR", "", false},
		{"", "", false},
		{"   ", "", false},
	}

	for _, tc := range cases {
		got, ok := Parse(tc.in)
		if ok != tc.wantOK {
			t.Errorf("Parse(%q) ok = %v, want %v", tc.in, ok, tc.wantOK)
			continue
		}
		if ok && got != tc.want {
			t.Errorf("Parse(%q) = %q, want %q", tc.in, got, tc.want)
		}
	}
}

func TestFromAcceptLanguage(t *testing.T) {
	cases := []struct {
		in     string
		want   Lang
		wantOK bool
	}{
		{"zh-CN,zh;q=0.9,en;q=0.8", ZH, true},
		{"en-US,en;q=0.9", EN, true},
		{"en;q=0.5,zh;q=0.9", ZH, true}, // higher q wins
		{"de;q=0.9,en;q=0.1", EN, true}, // unsupported entries are skipped
		{"de,fr", "", false},            // nothing we support
		{"", "", false},                 // no header
		{"*", "", false},                // wildcard is not a language
		{"zh;q=0", "", false},           // q=0 means "not acceptable"
		{"en;q=0,zh;q=0.3", ZH, true},   // the unacceptable one is dropped
		{"zh;q=0.5,en;q=0.5", ZH, true}, // tie: first tag wins
		{"de;q=0.9,en;q=0.9,zh;q=0.1", EN, true},
	}

	for _, tc := range cases {
		got, ok := FromAcceptLanguage(tc.in)
		if ok != tc.wantOK {
			t.Errorf("FromAcceptLanguage(%q) ok = %v, want %v (got %q)", tc.in, ok, tc.wantOK, got)
			continue
		}
		if ok && got != tc.want {
			t.Errorf("FromAcceptLanguage(%q) = %q, want %q", tc.in, got, tc.want)
		}
	}
}

func TestDetect(t *testing.T) {
	// 1. The cookie beats the header.
	r := httptest.NewRequest(http.MethodGet, "/", nil)
	r.Header.Set("Accept-Language", "en-US,en;q=0.9")
	r.AddCookie(&http.Cookie{Name: CookieName, Value: "zh"})
	if got := Detect(r, EN); got != ZH {
		t.Errorf("cookie should win: got %q, want %q", got, ZH)
	}

	// 2. The header is used when there is no cookie.
	r = httptest.NewRequest(http.MethodGet, "/", nil)
	r.Header.Set("Accept-Language", "zh-CN,zh;q=0.9")
	if got := Detect(r, EN); got != ZH {
		t.Errorf("header should win: got %q, want %q", got, ZH)
	}

	// 3. Otherwise the configured default applies.
	r = httptest.NewRequest(http.MethodGet, "/", nil)
	r.Header.Set("Accept-Language", "de")
	if got := Detect(r, ZH); got != ZH {
		t.Errorf("default should apply: got %q, want %q", got, ZH)
	}

	// 4. A bogus cookie is ignored rather than trusted.
	r = httptest.NewRequest(http.MethodGet, "/", nil)
	r.Header.Set("Accept-Language", "zh")
	r.AddCookie(&http.Cookie{Name: CookieName, Value: "xx"})
	if got := Detect(r, EN); got != ZH {
		t.Errorf("bogus cookie should fall through to the header: got %q", got)
	}

	// 5. A bogus default falls back to the built-in default.
	r = httptest.NewRequest(http.MethodGet, "/", nil)
	if got := Detect(r, Lang("nonsense")); got != Default {
		t.Errorf("bogus default: got %q, want %q", got, Default)
	}

	// 6. A nil request must not panic.
	if got := Detect(nil, ZH); got != ZH {
		t.Errorf("nil request: got %q, want %q", got, ZH)
	}
}

func TestSetCookie(t *testing.T) {
	w := httptest.NewRecorder()
	SetCookie(w, ZH, true)

	cookies := w.Result().Cookies()
	if len(cookies) != 1 {
		t.Fatalf("expected one cookie, got %d", len(cookies))
	}
	c := cookies[0]
	if c.Name != CookieName || c.Value != "zh" {
		t.Errorf("cookie = %s=%s", c.Name, c.Value)
	}
	if !c.HttpOnly {
		t.Error("the language cookie should be HttpOnly")
	}
	if !c.Secure {
		t.Error("Secure was requested but not set")
	}
	// It must be readable by the server on the next request.
	r := httptest.NewRequest(http.MethodGet, "/", nil)
	r.AddCookie(c)
	if got := Detect(r, EN); got != ZH {
		t.Errorf("round trip failed: got %q", got)
	}
}
