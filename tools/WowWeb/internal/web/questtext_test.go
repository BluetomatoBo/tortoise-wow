package web

import (
	"bytes"
	"strings"
	"testing"

	"tortoiseweb/internal/store"
)

// TestQuestTextLineBreaks covers the client's line-break tokens.
//
// The quest corpus writes both $B and $b, and mixes single tokens with $B$B, so
// each token has to become exactly one break: dropping one merges two
// paragraphs, and "fixing" a single $B into a pair would add a blank line the
// client never draws.
func TestQuestTextLineBreaks(t *testing.T) {
	cases := []struct {
		name string
		in   string
		want string
	}{
		{"no token", "plain text", "plain text"},
		{"double", "one$B$Btwo", "one<br><br>two"},
		{"single kept single", "one$Btwo", "one<br>two"},
		{"lowercase b", "one$btwo", "one<br>two"},
		{"trailing", "one$B", "one<br>"},
		{"mixed case of the same token", "a$B$bb", "a<br><br>b"},
	}
	for _, tc := range cases {
		if got := string(questText(tc.in)); got != tc.want {
			t.Errorf("%s: questText(%q) = %q, want %q", tc.name, tc.in, got, tc.want)
		}
	}
}

// TestQuestTextKeepsPlayerTokens documents what is left alone: on a public page
// there is no reader name, class or race to substitute, and inventing one would
// print a name the quest never had.
func TestQuestTextKeepsPlayerTokens(t *testing.T) {
	const in = "$N, speak to $C about your $R training."
	if got := string(questText(in)); got != in {
		t.Errorf("questText(%q) = %q, want it unchanged", in, got)
	}
}

// TestQuestTextEscapesMarkup is the security half: the value comes from the
// database, and the only HTML allowed through is the <br> this helper inserts.
func TestQuestTextEscapesMarkup(t *testing.T) {
	got := string(questText(`<script>alert(1)</script>`))
	if strings.Contains(got, "<script>") {
		t.Errorf("script tag survived: %q", got)
	}
	if !strings.Contains(got, "&lt;script&gt;") {
		t.Errorf("expected escaped markup, got %q", got)
	}

	got = string(questText(`quote " and apostrophe ' and amp &`))
	for _, bad := range []string{`"`, `'`} {
		if strings.Contains(got, bad) {
			t.Errorf("unescaped %s in %q", bad, got)
		}
	}
	// $B in the same string is still a break, and the escaping of the rest is
	// not undone by it.
	if got := string(questText(`a < b$Bc > d`)); got != "a &lt; b<br>c &gt; d" {
		t.Errorf("mixed escaping and breaks = %q", got)
	}
}

// TestQuestPageRendersBreaks checks the wiring: the quest page has to use the
// helper, otherwise the fix above never reaches a reader.
func TestQuestPageRendersBreaks(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	page := PageData{Title: "x", Config: PageConfig{SiteName: "s"}}
	view := dbQuestView{
		PageData: page,
		Quest: store.ContentQuest{
			Entry: 1, Title: "T", Details: "one$B$Btwo", Objectives: "three$Bfour",
		},
		HasDetails: true, HasObjectives: true,
	}

	var buf bytes.Buffer
	if err := rend.cache["db_quest"].ExecuteTemplate(&buf, "layout", view); err != nil {
		t.Fatal(err)
	}
	out := buf.String()
	if strings.Contains(out, "$B") {
		t.Errorf("quest page still prints the raw line-break token:\n%s", out)
	}
	if !strings.Contains(out, "one<br><br>two") {
		t.Errorf("details did not render its break:\n%s", out)
	}
	if !strings.Contains(out, "three<br>four") {
		t.Errorf("objectives did not render its break:\n%s", out)
	}
}
