package config

import (
	"os"
	"path/filepath"
	"testing"
)

func TestParseDotEnvLine(t *testing.T) {
	cases := []struct {
		in      string
		key     string
		value   string
		wantErr bool
	}{
		{"", "", "", false},
		{"   ", "", "", false},
		{"# a comment", "", "", false},
		{"  # indented comment", "", "", false},
		{"KEY=value", "KEY", "value", false},
		{"  KEY = value  ", "KEY", "value", false},
		{"export KEY=value", "KEY", "value", false},
		{`KEY="quoted value"`, "KEY", "quoted value", false},
		{`KEY='single quoted'`, "KEY", "single quoted", false},
		{`KEY=""`, "KEY", "", false},
		// A '#' inside a value is data, not a comment.
		{`KEY=p@ss#word`, "KEY", "p@ss#word", false},
		// Connection strings contain ';' and ':' and must survive intact.
		{"DB_DSN=user:pass@tcp(host:3306)/db?parseTime=true", "DB_DSN",
			"user:pass@tcp(host:3306)/db?parseTime=true", false},
		{`KEY="a\"b"`, "KEY", `a"b`, false},
		{`KEY="line\nbreak"`, "KEY", "line\nbreak", false},
		// Errors
		{"NOEQUALS", "", "", true},
		{"=novalue", "", "", true},
		{"1BAD=x", "", "", true},
		{"BAD-KEY=x", "", "", true},
	}

	for _, tc := range cases {
		key, value, err := parseDotEnvLine(tc.in)
		if tc.wantErr {
			if err == nil {
				t.Errorf("parseDotEnvLine(%q): expected an error", tc.in)
			}
			continue
		}
		if err != nil {
			t.Errorf("parseDotEnvLine(%q): %v", tc.in, err)
			continue
		}
		if key != tc.key || value != tc.value {
			t.Errorf("parseDotEnvLine(%q) = (%q, %q), want (%q, %q)",
				tc.in, key, value, tc.key, tc.value)
		}
	}
}

func TestLoadDotEnv(t *testing.T) {
	dir := t.TempDir()
	path := filepath.Join(dir, ".env")
	content := `
# comment
FROM_FILE=yes
OVERRIDDEN=file
QUOTED="a value with spaces"
EMPTY=
`
	if err := os.WriteFile(path, []byte(content), 0o600); err != nil {
		t.Fatal(err)
	}

	// The environment must win over the file.
	t.Setenv("OVERRIDDEN", "env")

	// Clear the variables under test in case the outer environment has them.
	for _, key := range []string{"FROM_FILE", "QUOTED", "EMPTY"} {
		os.Unsetenv(key)
		t.Cleanup(func() { os.Unsetenv(key) })
	}

	if err := loadDotEnv(path); err != nil {
		t.Fatalf("loadDotEnv: %v", err)
	}

	if got := os.Getenv("FROM_FILE"); got != "yes" {
		t.Errorf("FROM_FILE = %q, want yes", got)
	}
	if got := os.Getenv("OVERRIDDEN"); got != "env" {
		t.Errorf("OVERRIDDEN = %q, want env (the real environment must win)", got)
	}
	if got := os.Getenv("QUOTED"); got != "a value with spaces" {
		t.Errorf("QUOTED = %q", got)
	}
	if _, ok := os.LookupEnv("EMPTY"); !ok {
		t.Error("EMPTY should be set (to an empty string)")
	}
}

func TestLoadDotEnvMissingFileIsNotAnError(t *testing.T) {
	if err := loadDotEnv(filepath.Join(t.TempDir(), "nope.env")); err != nil {
		t.Errorf("a missing file must not be an error, got %v", err)
	}
}

// TestLoadHonoursEnvFileSwitch checks that WEB_ENV_FILE can point at another
// file or disable loading.
func TestLoadHonoursEnvFileSwitch(t *testing.T) {
	dir := t.TempDir()
	alt := filepath.Join(dir, "alt.env")
	if err := os.WriteFile(alt, []byte("ALT_ONLY=1\n"), 0o600); err != nil {
		t.Fatal(err)
	}

	os.Unsetenv("ALT_ONLY")
	t.Cleanup(func() { os.Unsetenv("ALT_ONLY") })

	t.Setenv("WEB_ENV_FILE", alt)
	t.Setenv("DB_PASSWORD", "x") // so Load does not fail on the empty-password check
	if _, err := Load(); err != nil {
		t.Fatalf("Load: %v", err)
	}
	if os.Getenv("ALT_ONLY") != "1" {
		t.Error("WEB_ENV_FILE was not honoured")
	}
}
