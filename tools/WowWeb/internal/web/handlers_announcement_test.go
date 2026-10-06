package web

import (
	"strings"
	"testing"
)

// TestAlertDocument covers the transform between what an administrator types
// and what the game client receives.
//
// Two things about the client are easy to get wrong and produce no error
// anywhere: the response must open with SERVERALERT:, and the markup is parsed
// line by line, so tags sharing a line with text are shown literally. These
// cases pin both.
func TestAlertDocument(t *testing.T) {
	t.Run("always starts with the prefix", func(t *testing.T) {
		for _, in := range []string{"", "   ", "text", "<html>", "line\nline"} {
			got := alertDocument(in)
			if !strings.HasPrefix(got, "SERVERALERT:") {
				t.Errorf("alertDocument(%q) does not start with the prefix: %q", in, got)
			}
		}
	})

	t.Run("every tag gets its own line", func(t *testing.T) {
		got := alertDocument("hello")
		want := "SERVERALERT:<html>\n<body>\n<p>hello</p>\n</body>\n</html>\n"
		if got != want {
			t.Errorf("alertDocument(%q)\n got %q\nwant %q", "hello", got, want)
		}
	})

	t.Run("no line carries both a tag and other markup", func(t *testing.T) {
		// The failure this guards against: "<html><body><p>x</p>" on one line,
		// which the client renders as literal text.
		got := alertDocument("first\n\nsecond")
		for _, line := range strings.Split(got, "\n") {
			trimmed := strings.TrimSpace(line)
			if strings.HasPrefix(trimmed, "<html>") && trimmed != "<html>" {
				t.Errorf("line %q has content after <html>", line)
			}
			if strings.Count(trimmed, "</p>") > 1 {
				t.Errorf("line %q packs several paragraphs", line)
			}
			if strings.Contains(trimmed, "</p>") && !strings.HasPrefix(trimmed, "<p>") {
				t.Errorf("line %q has text before its tag", line)
			}
		}
	})

	cases := []struct {
		name string
		in   string
		want string
	}{
		{"empty", "", "SERVERALERT:<html>\n<body>\n</body>\n</html>\n"},
		{"whitespace only", "   \n\n  \n", "SERVERALERT:<html>\n<body>\n</body>\n</html>\n"},
		{"one line", "Server is up.",
			"SERVERALERT:<html>\n<body>\n<p>Server is up.</p>\n</body>\n</html>\n"},
		{"two lines", "one\ntwo",
			"SERVERALERT:<html>\n<body>\n<p>one</p>\n<p>two</p>\n</body>\n</html>\n"},
		{"blank line becomes a rule", "one\n\ntwo",
			"SERVERALERT:<html>\n<body>\n<p>one</p>\n<br/>\n<p>two</p>\n</body>\n</html>\n"},
		{"leading blank lines are dropped", "\n\none",
			"SERVERALERT:<html>\n<body>\n<p>one</p>\n</body>\n</html>\n"},
		{"crlf normalised", "one\r\n\r\ntwo",
			"SERVERALERT:<html>\n<body>\n<p>one</p>\n<br/>\n<p>two</p>\n</body>\n</html>\n"},
		{"trailing spaces trimmed", "one   \ntwo  ",
			"SERVERALERT:<html>\n<body>\n<p>one</p>\n<p>two</p>\n</body>\n</html>\n"},

		// The text comes from an administrator, and the client's SimpleHTML
		// widget is not a browser, but it will draw whatever markup it is
		// handed - so the body never passes through as HTML.
		{"markup escaped", "<script>alert(1)</script>",
			"SERVERALERT:<html>\n<body>\n<p>&lt;script&gt;alert(1)&lt;/script&gt;</p>\n</body>\n</html>\n"},
		{"ampersand escaped", "Tom & Jerry",
			"SERVERALERT:<html>\n<body>\n<p>Tom &amp; Jerry</p>\n</body>\n</html>\n"},

		{"chinese passes through", "服务器维护中",
			"SERVERALERT:<html>\n<body>\n<p>服务器维护中</p>\n</body>\n</html>\n"},

		// A line that is nothing but an address becomes a link, in the shape the
		// client's own eula.html uses - three lines, the anchor alone in the
		// middle. This is the panel's "more information": the frame has no
		// button of its own, only this SimpleHTML field, whose
		// OnHyperlinkClick calls LaunchURL(arg1).
		{"address on its own line becomes a link",
			"服务器维护中\nhttp://twow.home.boym.me/notice",
			"SERVERALERT:<html>\n<body>\n<p>服务器维护中</p>\n" +
				"<p>\n<a href=\"http://twow.home.boym.me/notice\">http://twow.home.boym.me/notice</a>\n</p>\n" +
				"</body>\n</html>\n"},
		{"trailing chinese full stop is not part of the address",
			"http://twow.home.boym.me/notice。",
			"SERVERALERT:<html>\n<body>\n" +
				"<p>\n<a href=\"http://twow.home.boym.me/notice\">http://twow.home.boym.me/notice</a>\n</p>\n" +
				"</body>\n</html>\n"},

		// The client refuses these, so they stay text. An anchor would look
		// clickable and do nothing, which is worse than plain text.
		{"an address with a port is not linked",
			"http://172.18.1.6:8080/alert",
			"SERVERALERT:<html>\n<body>\n<p>http://172.18.1.6:8080/alert</p>\n</body>\n</html>\n"},
		{"https is not linked", "https://twow.home.boym.me/notice",
			"SERVERALERT:<html>\n<body>\n<p>https://twow.home.boym.me/notice</p>\n</body>\n</html>\n"},
		{"an address inside a sentence is not linked",
			"详情见 http://twow.home.boym.me/notice",
			"SERVERALERT:<html>\n<body>\n<p>详情见 http://twow.home.boym.me/notice</p>\n</body>\n</html>\n"},

		// The game's own colour codes are part of the markup vocabulary and
		// must survive, because |cAARRGGBB...|r is how an announcement colours
		// anything.
		{"wow colour codes kept", "|cffff0000维护中|r",
			"SERVERALERT:<html>\n<body>\n<p>|cffff0000维护中|r</p>\n</body>\n</html>\n"},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := alertDocument(tc.in); got != tc.want {
				t.Errorf("alertDocument(%q)\n got %q\nwant %q", tc.in, got, tc.want)
			}
		})
	}
}
