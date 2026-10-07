package web

import (
	"html/template"
	"strings"
)

// questText renders a prose column of quest_template (or its locales_quest
// counterpart) for a page.
//
// The client reads a few $-tokens inside these strings and the source data is
// written for it, not for a browser, so the raw value shows up as "word$B$Bword"
// in HTML. $B and $b are both a line break, and the corpus uses single $B as
// well as $B$B, so each token becomes exactly one <br> and pairs are left to
// render as the blank line the client draws.
//
// The player-specific tokens are deliberately not substituted: $N/$n is the
// reader's character name, $C/$c the class and $R/$r the race, none of which
// exist for an anonymous visitor to a public database page. Guessing at them
// would print a name the quest never had.
//
// Escaping runs before the substitution and the only markup in the result is
// the <br> inserted here, so a quest body that contains HTML stays text.
func questText(s string) template.HTML {
	e := template.HTMLEscapeString(s)
	e = strings.ReplaceAll(e, "$B", "<br>")
	e = strings.ReplaceAll(e, "$b", "<br>")
	return template.HTML(e)
}
