package web

import (
	"bytes"
	"log/slog"
	"net/http"
	"strings"
	"testing"

	"tortoiseweb/internal/config"
)

// requestWith builds a request as it reaches the app: the socket address of
// whoever connected (the proxy, in a proxied deployment) plus the forwarding
// headers that proxy wrote.
func requestWith(remote, xff, xRealIP string) *http.Request {
	r := &http.Request{RemoteAddr: remote, Header: http.Header{}}
	if xff != "" {
		r.Header.Set("X-Forwarded-For", xff)
	}
	if xRealIP != "" {
		r.Header.Set("X-Real-IP", xRealIP)
	}
	return r
}

// TestClientIPIgnoresForwardedHeadersWhenUntrusted is the deployment where the
// app is exposed directly: anyone can send these headers, so they must not
// decide who the caller is.
func TestClientIPIgnoresForwardedHeadersWhenUntrusted(t *testing.T) {
	s := &Server{cfg: config.Config{TrustProxy: false}}
	r := requestWith("10.1.2.3:5678", "1.2.3.4", "5.6.7.8")

	if got := s.clientIP(r); got != "10.1.2.3" {
		t.Errorf("clientIP = %q, want the socket address %q", got, "10.1.2.3")
	}
}

// TestClientIPBehindProxy is the proxied deployment, and it is the security
// case that matters: the proxy appends the address it actually saw to whatever
// the client sent, so only the *last* entry can be believed. A client that
// writes its own X-Forwarded-For is choosing an address the proxy will happily
// carry along to its left.
func TestClientIPBehindProxy(t *testing.T) {
	cases := []struct {
		name    string
		remote  string
		xff     string
		xRealIP string
		want    string
		wantWhy string
	}{
		{"no headers at all", "10.1.2.3:5678", "", "", "10.1.2.3", "socket"},
		{"single entry, as $proxy_add_x_forwarded_for writes it", "10.1.2.3:5678", "203.0.113.7", "", "203.0.113.7", "the only entry"},
		{"client sent its own XFF, proxy appended the real address", "10.1.2.3:5678", "1.2.3.4, 203.0.113.7", "", "203.0.113.7", "rightmost is what the proxy saw"},
		{"client invented a whole chain", "10.1.2.3:5678", "1.2.3.4, 5.6.7.8, 203.0.113.7", "", "203.0.113.7", "rightmost is what the proxy saw"},
		{"X-Real-IP only", "10.1.2.3:5678", "", "203.0.113.7", "203.0.113.7", "fallback header"},
		// The two disagree only when the proxy did not append to XFF, which means
		// it wrote (or overwrote) the entry itself - so that entry is its own
		// observation - while X-Real-IP may still be whatever the client sent.
		{"two headers disagree", "10.1.2.3:5678", "1.2.3.4", "203.0.113.7", "1.2.3.4", "the proxy owns the XFF entries it wrote"},
		{"address with a port on it", "10.1.2.3:5678", "203.0.113.7:44321", "", "203.0.113.7", "port stripped"},
		{"bracketed IPv6 with a port", "10.1.2.3:5678", "[2001:db8::1]:443", "", "2001:db8::1", "port stripped"},
		{"IPv4-mapped IPv6 collapses to the IPv4 spelling", "10.1.2.3:5678", "::ffff:203.0.113.7", "", "203.0.113.7", "one bucket per address"},
		{"prose instead of an address", "10.1.2.3:5678", "unknown", "", "10.1.2.3", "unparseable, so ignored"},
		{"prose in both headers", "10.1.2.3:5678", "unknown", "not-an-ip", "10.1.2.3", "unparseable, so ignored"},
		{"junk appended on the right, real address to its left", "10.1.2.3:5678", "203.0.113.7, unknown", "", "203.0.113.7", "first parseable from the right"},
		{"header far wider than a throttle key", "10.1.2.3:5678", strings.Repeat("a", 300), "", "10.1.2.3", "unparseable, so ignored"},
		{"empty entries from a doubled comma", "10.1.2.3:5678", ",, 203.0.113.7, ", "", "203.0.113.7", "empty entries skipped"},
	}

	s := &Server{cfg: config.Config{TrustProxy: true}}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := s.clientIP(requestWith(tc.remote, tc.xff, tc.xRealIP))
			if got != tc.want {
				t.Errorf("clientIP = %q, want %q (%s)", got, tc.want, tc.wantWhy)
			}
		})
	}
}

// TestClientIPIgnoresAClientChosenAddress is the regression the header order was
// reversed for: on a proxied deployment, a request carrying its own
// X-Forwarded-For used to be attributed to that address. Rotating it on every
// request puts each attempt in a fresh bucket, which switches off the
// per-address sign-in and sign-up limits.
func TestClientIPIgnoresAClientChosenAddress(t *testing.T) {
	s := &Server{cfg: config.Config{TrustProxy: true}}
	real := "203.0.113.7"

	for _, forged := range []string{"1.2.3.4", "8.8.8.8", "2001:db8::1"} {
		r := requestWith("10.1.2.3:5678", forged+", "+real, "")
		if got := s.clientIP(r); got != real {
			t.Errorf("clientIP with X-Forwarded-For %q = %q, want the address the proxy saw (%q)", forged+", "+real, got, real)
		}
	}
}

// TestClientIPWarnsAboutAnIgnoredProxy covers the silent half of the
// misconfiguration: the app keeps working, it just records the wrong address for
// everybody. The warning is the only clue an operator gets, so it has to appear
// for a proxied deployment and stay quiet for a direct one.
func TestClientIPWarnsAboutAnIgnoredProxy(t *testing.T) {
	cases := []struct {
		name       string
		remote     string
		xff        string
		wantWarned bool
	}{
		{"private peer with forwarded headers", "10.1.2.3:5678", "203.0.113.7", true},
		{"loopback peer with forwarded headers", "127.0.0.1:5678", "203.0.113.7", true},
		{"private peer, header is just X-Real-IP", "10.1.2.3:5678", "", true},
		{"public peer, so no proxy of ours is in front", "203.0.113.9:5678", "1.2.3.4", false},
		{"private peer but no headers", "10.1.2.3:5678", "", false},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			var buf bytes.Buffer
			s := &Server{
				cfg: config.Config{TrustProxy: false},
				log: slog.New(slog.NewTextHandler(&buf, nil)),
			}
			r := requestWith(tc.remote, tc.xff, "")
			if tc.name == "private peer, header is just X-Real-IP" {
				r = requestWith(tc.remote, "", "203.0.113.7")
			}

			// The address is still the socket's, trusted headers or not.
			if got := s.clientIP(r); got != strings.Split(tc.remote, ":")[0] {
				t.Errorf("clientIP = %q, want the socket address", got)
			}

			warned := strings.Contains(buf.String(), "forwarding headers are being ignored")
			if warned != tc.wantWarned {
				t.Errorf("warned = %v, want %v (log: %q)", warned, tc.wantWarned, buf.String())
			}

			// A busy server must not repeat it for every request it serves.
			s.clientIP(r)
			if n := strings.Count(buf.String(), "forwarding headers are being ignored"); n > 1 {
				t.Errorf("warning logged %d times, want at most once", n)
			}
		})
	}
}

func TestSameIP(t *testing.T) {
	cases := []struct {
		a, b string
		want bool
	}{
		{"203.0.113.7", "203.0.113.7", true},
		{"203.0.113.7", "203.0.113.8", false},
		{"2001:0db8:0000:0000:0000:0000:0000:0001", "2001:db8::1", true},
		{"::ffff:203.0.113.7", "203.0.113.7", true},
		{"2001:db8::1", "203.0.113.7", false},
		{"unknown", "unknown", true},
		{"unknown", "203.0.113.7", false},
	}

	for _, tc := range cases {
		if got := sameIP(tc.a, tc.b); got != tc.want {
			t.Errorf("sameIP(%q, %q) = %v, want %v", tc.a, tc.b, got, tc.want)
		}
	}
}
