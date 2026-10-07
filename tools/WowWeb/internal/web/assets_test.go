package web

import (
	"bytes"
	"regexp"
	"strings"
	"testing"
)

// TestAssetsAreVersioned covers the query string the layout puts on the
// stylesheet and the tooltip script.
//
// Static files are served with an hour of cache under a name that never changes,
// so a browser that loaded style.css before a deploy keeps it. The tooltip's
// layout lives in that file, which is how a deploy turns into "the tooltip looks
// broken until you hard-reload". The version is a hash of the files, so it
// changes when they do.
func TestAssetsAreVersioned(t *testing.T) {
	if !regexp.MustCompile(`^[0-9a-f]{8}$`).MatchString(assetVersion) {
		t.Fatalf("assetVersion = %q, want eight hex digits", assetVersion)
	}

	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}

	render := func(page string, view any) string {
		var buf bytes.Buffer
		if err := rend.cache[page].ExecuteTemplate(&buf, "layout", view); err != nil {
			t.Fatalf("%s: %v", page, err)
		}
		return buf.String()
	}

	style := regexp.MustCompile(`/assets/style\.css\?v=([0-9a-f]{8})`)
	script := regexp.MustCompile(`/assets/db-tooltip\.js\?v=([0-9a-f]{8})`)

	pageData := func(active string) PageData {
		return PageData{Title: "x", Active: active, Config: PageConfig{SiteName: "s"}}
	}

	// A database page carries both, under the same version.
	db := render("db_item", dbItemView{PageData: pageData("db")})
	styleV := style.FindStringSubmatch(db)
	scriptV := script.FindStringSubmatch(db)
	if styleV == nil {
		t.Errorf("the stylesheet is not versioned:\n%s", first(db, 400))
	}
	if scriptV == nil {
		t.Errorf("the tooltip script is not versioned:\n%s", first(db, 400))
	}
	if styleV != nil && scriptV != nil && styleV[1] != scriptV[1] {
		t.Errorf("one page asked for two versions: css %s, script %s", styleV[1], scriptV[1])
	}

	// A page with no item links does not load the script at all.
	home := render("home", homeView{PageData: pageData("home")})
	if style.FindString(home) == "" {
		t.Errorf("the stylesheet is not versioned on a non-db page:\n%s", first(home, 400))
	}
	if strings.Contains(home, "db-tooltip.js") {
		t.Errorf("a page with no item links loads the tooltip script:\n%s", first(home, 600))
	}
}

// first truncates a rendered page for an error message.
func first(s string, n int) string {
	if len(s) > n {
		return s[:n]
	}
	return s
}
