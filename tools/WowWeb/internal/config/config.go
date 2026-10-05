// Package config holds the web service configuration.
//
// Everything is settable through environment variables so the service can run
// next to mangosd/realmd without a config file. The database defaults match the
// docker-compose setup in this repository.
package config

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"
)

type Config struct {
	// HTTP
	ListenAddr string
	BaseURL    string // used in links/emails, e.g. https://example.com
	TrustProxy bool   // trust X-Forwarded-For / X-Real-IP

	// Database connection parts (shared by all four databases)
	DBHost     string
	DBPort     int
	DBUser     string
	DBPassword string

	DBLogon string
	DBWorld string
	DBChar  string
	DBLogs  string

	// Realm
	RealmID   int
	RealmName string

	// The world server address shown to players on the status page.
	WorldAddress string
	WorldPort    int
	RealmPort    int

	// Language
	DefaultLang string // default UI language: "en" or "zh"

	// Access control
	AdminMinRank   int  // account.rank needed for /admin (4 = Administrator)
	AllowRegister  bool // allow public self-registration
	RequireEmail   bool
	MaxAccounts    int // 0 = unlimited
	SessionTTL     time.Duration
	SessionSecure  bool // set the cookie Secure flag (behind HTTPS)
	PasswordMinLen int
}

// Load reads the configuration from the environment.
//
// A ".env" file in the working directory is loaded first, unless
// WEB_ENV_FILE says otherwise ("off" disables it). Variables already present
// in the environment take precedence over the file.
func Load() (Config, error) {
	switch envFile := env("WEB_ENV_FILE", EnvFileName); envFile {
	case "off", "none", "-":
		// Nothing to do: use the process environment only.
	default:
		if err := loadDotEnv(envFile); err != nil {
			return Config{}, err
		}
	}

	c := Config{
		ListenAddr:    env("WEB_LISTEN", ":8080"),
		BaseURL:       strings.TrimRight(env("WEB_BASE_URL", ""), "/"),
		TrustProxy:    envBool("WEB_TRUST_PROXY", false),
		DBHost:        env("DB_HOST", "127.0.0.1"),
		DBPort:        envInt("DB_PORT", 3306),
		DBUser:        env("DB_USER", "mangos"),
		DBPassword:    env("DB_PASSWORD", "mangos"),
		DBLogon:       env("DB_LOGON_NAME", "tw_logon"),
		DBWorld:       env("DB_WORLD_NAME", "tw_world"),
		DBChar:        env("DB_CHAR_NAME", "tw_char"),
		DBLogs:        env("DB_LOGS_NAME", "tw_logs"),
		RealmID:       envInt("REALM_ID", 1),
		RealmName:     env("REALM_NAME", "Tortoise WoW"),
		WorldAddress:  env("WORLD_ADDRESS", ""),
		WorldPort:     envInt("WORLD_PORT", 8090),
		RealmPort:     envInt("REALM_PORT", 3724),
		DefaultLang:   strings.ToLower(env("DEFAULT_LANG", "en")),
		AdminMinRank:  envInt("ADMIN_MIN_RANK", 4),
		AllowRegister: envBool("ALLOW_REGISTER", true),
		RequireEmail:  envBool("REQUIRE_EMAIL", false),

		MaxAccounts:    envInt("MAX_ACCOUNTS", 0),
		SessionTTL:     time.Duration(envInt("SESSION_TTL_HOURS", 24*7)) * time.Hour,
		SessionSecure:  envBool("SESSION_SECURE", false),
		PasswordMinLen: envInt("PASSWORD_MIN_LEN", 4),
	}

	if c.DBPassword == "" {
		return c, fmt.Errorf("DB_PASSWORD must not be empty")
	}
	if c.AdminMinRank < 1 || c.AdminMinRank > 6 {
		return c, fmt.Errorf("ADMIN_MIN_RANK must be between 1 and 6, got %d", c.AdminMinRank)
	}
	if c.MaxAccounts < 0 {
		return c, fmt.Errorf("MAX_ACCOUNTS must not be negative")
	}
	if c.DefaultLang != "en" && c.DefaultLang != "zh" {
		return c, fmt.Errorf("DEFAULT_LANG must be \"en\" or \"zh\", got %q", c.DefaultLang)
	}
	return c, nil
}

// DSN builds a go-sql-driver DSN for one of the game databases.
//
// parseTime lets us scan TIMESTAMP/DATETIME columns straight into time.Time.
// The core stores zero dates ('0000-00-00 00:00:00') in several columns, so
// parseTime is used together with a NULL-safe scan helper in the store package
// rather than relying on it unconditionally.
func (c Config) DSN(database string) string {
	return fmt.Sprintf(
		"%s:%s@tcp(%s:%d)/%s?parseTime=true&loc=Local&charset=utf8mb4&collation=utf8mb4_general_ci&multiStatements=false&interpolateParams=false&timeout=10s&readTimeout=30s&writeTimeout=30s",
		c.DBUser, c.DBPassword, c.DBHost, c.DBPort, database,
	)
}

func env(key, fallback string) string {
	if v, ok := os.LookupEnv(key); ok && v != "" {
		return v
	}
	return fallback
}

func envInt(key string, fallback int) int {
	v, ok := os.LookupEnv(key)
	if !ok || v == "" {
		return fallback
	}
	n, err := strconv.Atoi(strings.TrimSpace(v))
	if err != nil {
		return fallback
	}
	return n
}

func envBool(key string, fallback bool) bool {
	v, ok := os.LookupEnv(key)
	if !ok || v == "" {
		return fallback
	}
	switch strings.ToLower(strings.TrimSpace(v)) {
	case "1", "true", "yes", "on":
		return true
	case "0", "false", "no", "off":
		return false
	default:
		return fallback
	}
}
