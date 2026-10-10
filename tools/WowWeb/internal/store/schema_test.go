package store

import (
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"testing"
)

// The queries name columns through aliases (c.name, t.item, q.Title), and until a
// server sees them they are only strings. Two separate mistakes have shipped from
// that: an alias no FROM or JOIN introduces (caught by
// TestRelationQueriesBindEveryAlias) and a column the aliased table does not have,
// which is this test.
//
// It reads the game's own CREATE TABLE statements out of the repository's
// sql/base dumps and checks every "alias.column" a generated query uses against
// them. On a checkout of the tools alone the dumps are not there and the test
// skips, the way the MySQL integration test skips without a DSN.

// ddlDir is where the dumps live, relative to this package.
var ddlDir = filepath.Join("..", "..", "..", "..", "sql", "base")

// contentTables maps the aliases the content column lists use to the table they
// read. The column lists are SELECT lists without a FROM clause, so unlike the
// statements below there is nothing to read the mapping from. gsp is the
// gameobject list's spawn-count subquery.
var contentTables = map[string]string{
	"i":   "item_template",
	"s":   "spell_template",
	"q":   "quest_template",
	"c":   "creature_template",
	"g":   "gameobject_template",
	"gsp": "gameobject",
}

func TestQueriesNameRealColumns(t *testing.T) {
	schema := loadSchema(t)
	if schema == nil {
		t.Skipf("no game schema below %s", ddlDir)
	}

	// Every statement the relation layer builds, plus the four content column
	// lists with the table each of them reads.
	type subject struct {
		name    string
		sql     string
		aliases map[string]string
	}
	var subjects []subject
	for name, q := range relationQueries() {
		subjects = append(subjects, subject{name: name, sql: q, aliases: queryAliases(q)})
	}
	for _, loc := range []ContentLocale{ContentLocaleBase, ContentLocaleZH} {
		for _, columns := range []struct {
			name string
			text string
		}{
			{"item_template", itemColumns(loc)},
			{"spell_template", spellColumns(loc)},
			{"quest_template", questColumns(loc)},
			{"creature_template", creatureColumns(loc)},
			{"gameobject_template", gameObjectColumns(loc)},
		} {
			aliases := map[string]string{}
			for alias, table := range contentTables {
				aliases[alias] = table
			}
			subjects = append(subjects, subject{
				name: string(loc) + " " + columns.name, sql: columns.text, aliases: aliases})
		}
	}

	columnRef := regexp.MustCompile(`\b([a-z][a-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)`)
	checked, unknownTables := 0, map[string]bool{}
	for _, s := range subjects {
		for _, m := range columnRef.FindAllStringSubmatch(s.sql, -1) {
			alias, column := m[1], m[2]
			table, ok := s.aliases[alias]
			if !ok {
				continue // the alias test owns this case
			}
			columns, ok := schema[table]
			if !ok {
				unknownTables[table] = true
				continue
			}
			checked++
			if !columns[strings.ToLower(column)] {
				t.Errorf("%s: %s.%s does not exist on %s:\n%s",
					s.name, alias, column, table, s.sql)
			}
		}
	}
	if checked == 0 {
		t.Fatal("no column was checked; the schema parse or the alias map is broken")
	}
	if len(unknownTables) > 0 {
		names := make([]string, 0, len(unknownTables))
		for table := range unknownTables {
			names = append(names, table)
		}
		sort.Strings(names)
		t.Logf("no DDL for: %s", strings.Join(names, ", "))
	}
}

// queryAliases reads the alias -> table map out of a statement's FROM and JOIN
// clauses.
func queryAliases(q string) map[string]string {
	out := map[string]string{}
	for _, m := range regexp.MustCompile(`(?i)\b(?:FROM|JOIN)\s+([a-z_]+)\s+([a-z_]+)\b`).
		FindAllStringSubmatch(q, -1) {
		out[m[2]] = m[1]
	}
	return out
}

// loadSchema reads every CREATE TABLE in the dumps into table -> lowercased
// columns. It returns nil when the dumps are not there.
func loadSchema(t *testing.T) map[string]map[string]bool {
	t.Helper()
	files, err := filepath.Glob(filepath.Join(ddlDir, "*.sql"))
	if err != nil || len(files) == 0 {
		return nil
	}
	table := regexp.MustCompile("(?is)CREATE TABLE `([a-z0-9_]+)` \\((.*?)\\n\\)")
	column := regexp.MustCompile("^\\s*`([A-Za-z0-9_]+)`")
	out := map[string]map[string]bool{}
	for _, path := range files {
		data, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read %s: %v", path, err)
		}
		for _, m := range table.FindAllStringSubmatch(string(data), -1) {
			columns := map[string]bool{}
			for _, line := range strings.Split(m[2], "\n") {
				if c := column.FindStringSubmatch(line); c != nil {
					columns[strings.ToLower(c[1])] = true
				}
			}
			if len(columns) > 0 {
				out[strings.ToLower(m[1])] = columns
			}
		}
	}
	if len(out) < 100 {
		t.Fatalf("only %d tables parsed out of %s; the dump format changed", len(out), ddlDir)
	}
	return out
}
