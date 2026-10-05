package config

import (
	"bufio"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"strings"
)

// EnvFileName is the file Load reads by default, relative to the working
// directory. Set WEB_ENV_FILE to point somewhere else, or to "off" to skip
// loading entirely and rely purely on the process environment.
const EnvFileName = ".env"

// loadDotEnv reads a KEY=VALUE file and adds the entries to the process
// environment.
//
// Variables that are already set are left untouched, so the real environment
// always wins over the file. This is the usual precedence for a service that
// can be configured either way: exporting DB_PASSWORD=... ./wowweb overrides
// whatever the file says, which matters when the file is a checked-in example.
func loadDotEnv(path string) error {
	f, err := os.Open(path)
	if err != nil {
		if errors.Is(err, fs.ErrNotExist) {
			return nil // not having a file is the normal case
		}
		return fmt.Errorf("open %s: %w", path, err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	line := 0
	for scanner.Scan() {
		line++
		key, value, err := parseDotEnvLine(scanner.Text())
		if err != nil {
			return fmt.Errorf("%s:%d: %w", path, line, err)
		}
		if key == "" {
			continue
		}
		if _, exists := os.LookupEnv(key); exists {
			continue
		}
		if err := os.Setenv(key, value); err != nil {
			return fmt.Errorf("%s:%d: %w", path, line, err)
		}
	}
	return scanner.Err()
}

// parseDotEnvLine splits one line. It returns empty values for blank lines and
// comments, which the caller skips.
func parseDotEnvLine(raw string) (key, value string, err error) {
	line := strings.TrimSpace(raw)

	// Strip a UTF-8 BOM if an editor added one to the first line.
	line = strings.TrimPrefix(line, "\ufeff")

	if line == "" || strings.HasPrefix(line, "#") {
		return "", "", nil
	}

	// Tolerate the "export KEY=VALUE" form that people copy out of a shell.
	line = strings.TrimPrefix(line, "export ")

	key, value, found := strings.Cut(line, "=")
	if !found {
		// A line without '=' is almost always a typo; saying so beats
		// silently ignoring it.
		return "", "", fmt.Errorf("expected KEY=VALUE, got %q", strings.TrimSpace(raw))
	}

	key = strings.TrimSpace(key)
	if key == "" {
		return "", "", fmt.Errorf("empty key in %q", strings.TrimSpace(raw))
	}
	// Reject anything that could not be an environment variable name, so a
	// stray line cannot create a variable with unexpected characters.
	for i, r := range key {
		valid := r == '_' ||
			(r >= 'A' && r <= 'Z') || (r >= 'a' && r <= 'z') ||
			(i > 0 && r >= '0' && r <= '9')
		if !valid {
			return "", "", fmt.Errorf("invalid character %q in key %q", r, key)
		}
	}

	value = strings.TrimSpace(value)

	// Strip matching quotes, honouring the usual escapes inside double quotes.
	if len(value) >= 2 {
		switch {
		case value[0] == '"' && value[len(value)-1] == '"':
			inner := value[1 : len(value)-1]
			inner = strings.ReplaceAll(inner, `\"`, `"`)
			inner = strings.ReplaceAll(inner, `\\`, `\`)
			inner = strings.ReplaceAll(inner, `\n`, "\n")
			inner = strings.ReplaceAll(inner, `\t`, "\t")
			value = inner
		case value[0] == '\'' && value[len(value)-1] == '\'':
			value = value[1 : len(value)-1]
		}
	}

	return key, value, nil
}
