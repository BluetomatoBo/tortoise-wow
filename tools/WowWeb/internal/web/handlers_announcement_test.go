package web

import "testing"

// TestAlertDocument covers the transform between what an administrator types
// and what the game client's SimpleHTML widget receives.
//
// The client is not a browser: it renders a tiny tag subset and does not run
// scripts, but it will happily draw whatever markup it is handed. The body is
// therefore stored as plain text, and everything that reaches the client has to
// come out escaped.
func TestAlertDocument(t *testing.T) {
	cases := []struct {
		name string
		in   string
		want string
	}{
		{"empty", "", "<html><body></body></html>"},
		{"whitespace only", "   \n\n  \n", "<html><body></body></html>"},
		{"one line", "Server is up.", "<html><body><p>Server is up.</p></body></html>"},
		{"line break kept", "one\ntwo", "<html><body><p>one<br/>two</p></body></html>"},
		{"blank line splits paragraphs", "one\n\ntwo",
			"<html><body><p>one</p><p>two</p></body></html>"},
		{"crlf normalised", "one\r\n\r\ntwo",
			"<html><body><p>one</p><p>two</p></body></html>"},
		{"trailing spaces trimmed", "one   \ntwo  ",
			"<html><body><p>one<br/>two</p></body></html>"},
		{"markup escaped", `<script>alert(1)</script>`,
			"<html><body><p>&lt;script&gt;alert(1)&lt;/script&gt;</p></body></html>"},
		// html.EscapeString writes a quote as &#34;, which is the same
		// character reference as &quot; - either stops the attribute break.
		{"attribute break escaped", `"><b>x`,
			"<html><body><p>&#34;&gt;&lt;b&gt;x</p></body></html>"},
		{"ampersand escaped", "Tom & Jerry",
			"<html><body><p>Tom &amp; Jerry</p></body></html>"},
		{"chinese passes through", "服务器维护中",
			"<html><body><p>服务器维护中</p></body></html>"},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := alertDocument(tc.in); got != tc.want {
				t.Errorf("alertDocument(%q)\n got %q\nwant %q", tc.in, got, tc.want)
			}
		})
	}
}
