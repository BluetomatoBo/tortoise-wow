package store_test

// Integration test for the store layer.
//
// It runs against a real MySQL/MariaDB server and is skipped unless a DSN is
// provided, so `go test ./...` stays green without a database:
//
//	export TW_TEST_DSN='root:root@tcp(127.0.0.1:3306)/tw_web_test?parseTime=true'
//	export TW_TEST_SCHEMA=/path/to/tortoise-wow/sql/create_databases.sql
//	go test ./internal/store/ -run Integration -v
//
// The fixture is generated from the real create_databases.sql instead of being
// hand written, so the test always reflects the actual game schema. The
// database named in the DSN is created from scratch and dropped at the end.

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"os"
	"regexp"
	"strings"
	"testing"
	"time"

	_ "github.com/go-sql-driver/mysql"

	"tortoiseweb/internal/config"
	"tortoiseweb/internal/gamepwd"
	"tortoiseweb/internal/store"
)

// tablesNeeded lists the game tables the store touches. Keeping this list
// explicit means the fixture stays small while still exercising every query.
var tablesNeeded = []string{
	"account", "account_banned", "account_twofactor_allowed", "realmcharacters",
	"realmlist", "ip_banned",
	"characters", "character_homebind", "guild", "guild_member",
	"character_action", "character_aura", "character_battleground_data",
	"character_gifts", "character_instance", "character_inventory",
	"character_queststatus", "character_reputation", "character_skills",
	"character_forgotten_skills", "character_spell", "character_spell_cooldown",
	"character_ticket", "character_pet", "character_social",
	"character_deleted_items", "group_instance", "guild_eventlog",
	"item_instance", "mail", "mail_items",
	// World content, read by the browser.
	"item_template", "spell_template", "quest_template", "creature_template",
	"gameobject_template",
	"locales_item", "locales_spell", "locales_quest", "locales_creature", "locales_gameobject",
	// Cross links, read by the relation lists on the item, creature and quest pages.
	"creature_loot_template", "gameobject_loot_template", "item_loot_template",
	"skinning_loot_template", "pickpocketing_loot_template", "reference_loot_template",
	"npc_vendor", "creature_questrelation", "creature_involvedrelation",
	"gameobject_questrelation", "gameobject_involvedrelation",
}

func testDSN(t *testing.T) string {
	t.Helper()
	dsn := os.Getenv("TW_TEST_DSN")
	if dsn == "" {
		t.Skip("TW_TEST_DSN is not set; skipping the database integration test")
	}
	return dsn
}

// createTableStatements pulls the CREATE TABLE block of each wanted table out
// of the real schema dump.
func createTableStatements(t *testing.T, schemaPath string, wanted []string) []string {
	t.Helper()

	raw, err := os.ReadFile(schemaPath)
	if err != nil {
		t.Fatalf("read schema %s: %v", schemaPath, err)
	}
	schema := string(raw)

	var statements []string
	for _, table := range wanted {
		// Match from "CREATE TABLE `name` (" through the terminating ENGINE=...;
		re := regexp.MustCompile(`(?s)CREATE TABLE ` + "`" + table + "`" +
			` \(.*?\n\) ENGINE=[^;]*;`)
		m := re.FindString(schema)
		if m == "" {
			t.Fatalf("table %q not found in %s", table, schemaPath)
		}
		// The shipped schema declares these tables MyISAM, which is what the
		// core historically used. Real deployments run them on InnoDB, and the
		// store opens a transaction in CreateAccount, so a MyISAM fixture
		// cannot exercise that code: with GTID enforcement on, MySQL refuses to
		// mix transactional and non-transactional tables in one transaction
		// (error 1785) and the test fails for a reason the production database
		// would never hit.
		//
		// Forcing InnoDB makes the fixture match what the store is actually
		// talking to. The schema has no foreign keys, so nothing is newly
		// enforced by the switch.
		m = regexp.MustCompile(`ENGINE=\w+`).ReplaceAllString(m, "ENGINE=InnoDB")
		// ROW_FORMAT=FIXED is a MyISAM-only option and InnoDB rejects it
		// outright; dropping it means "engine default", which is what a
		// converted table ends up with.
		m = regexp.MustCompile(` ?ROW_FORMAT=\w+`).ReplaceAllString(m, "")
		statements = append(statements, m)
	}
	return statements
}

func TestIntegration(t *testing.T) {
	dsn := testDSN(t)

	schemaPath := os.Getenv("TW_TEST_SCHEMA")
	if schemaPath == "" {
		schemaPath = "../../../sql/create_databases.sql"
	}
	if _, err := os.Stat(schemaPath); err != nil {
		t.Skipf("schema file %s not found; set TW_TEST_SCHEMA", schemaPath)
	}

	// --- prepare the database ------------------------------------------------
	admin, err := sql.Open("mysql", dsn)
	if err != nil {
		t.Fatalf("open: %v", err)
	}
	defer admin.Close()

	ctx := context.Background()
	if err := admin.PingContext(ctx); err != nil {
		t.Fatalf("ping %s: %v", dsn, err)
	}

	const dbName = "tw_web_test"
	for _, stmt := range []string{
		"DROP DATABASE IF EXISTS " + dbName,
		"CREATE DATABASE " + dbName + " DEFAULT CHARACTER SET utf8mb4",
	} {
		if _, err := admin.ExecContext(ctx, stmt); err != nil {
			t.Fatalf("%s: %v", stmt, err)
		}
	}
	defer func() {
		_, _ = admin.ExecContext(ctx, "DROP DATABASE IF EXISTS "+dbName)
	}()

	db, err := sql.Open("mysql", strings.Replace(dsn, "/"+dbDatabase(dsn), "/"+dbName, 1))
	if err != nil {
		t.Fatalf("open test db: %v", err)
	}
	defer db.Close()

	for _, stmt := range createTableStatements(t, schemaPath, tablesNeeded) {
		if _, err := db.ExecContext(ctx, stmt); err != nil {
			t.Fatalf("create table: %v\n%s", err, stmt)
		}
	}

	// Seed a realm: CreateAccount mirrors its rows into realmcharacters.
	if _, err := db.ExecContext(ctx,
		"INSERT INTO realmlist (id, name, address, port) VALUES (1, 'Test', '127.0.0.1', 8090)"); err != nil {
		t.Fatalf("seed realmlist: %v", err)
	}

	// --- wire up the store ---------------------------------------------------
	cfg := config.Config{
		DBUser: "root", DBPassword: "root", DBHost: "127.0.0.1", DBPort: 3306,
		DBLogon: dbName, DBChar: dbName, DBWorld: dbName, DBLogs: dbName,
		RealmID: 1,
	}
	// Rebuild the DSN parts from the provided DSN so credentials come from the
	// environment rather than being hard coded.
	cfg = withDSN(t, cfg, dsn, dbName)

	st, err := store.Open(ctx, cfg)
	if err != nil {
		t.Fatalf("store.Open: %v", err)
	}
	defer st.Close()

	if err := st.EnsureSchema(ctx); err != nil {
		t.Fatalf("EnsureSchema: %v", err)
	}
	// EnsureSchema must be idempotent.
	if err := st.EnsureSchema(ctx); err != nil {
		t.Fatalf("EnsureSchema (second run): %v", err)
	}

	// --- accounts ------------------------------------------------------------
	var created *store.Account
	t.Run("CreateAccount", func(t *testing.T) {
		acct, err := st.CreateAccount(ctx, "TestUser", "Secret123", "a@b.c")
		if err != nil {
			t.Fatalf("CreateAccount: %v", err)
		}
		created = acct

		if acct.Username != "TESTUSER" {
			t.Errorf("username = %q, want TESTUSER (the core uppercases basic Latin)", acct.Username)
		}
		if acct.Rank != 0 || !acct.Active {
			t.Errorf("new account should be an active rank 0 player, got rank=%d active=%v",
				acct.Rank, acct.Active)
		}

		// The stored hash must be the one the game client would produce.
		var stored string
		if err := db.QueryRowContext(ctx,
			"SELECT sha_pass_hash FROM account WHERE id = ?", acct.ID).Scan(&stored); err != nil {
			t.Fatal(err)
		}
		want := gamepwd.HashNormalized("TESTUSER", "SECRET123")
		if stored != want {
			t.Errorf("sha_pass_hash = %s, want %s", stored, want)
		}
		if !strings.EqualFold(stored, strings.ToUpper(stored)) {
			t.Error("hash should be stored as uppercase hex, like the core does")
		}

		// realmcharacters must have been mirrored, otherwise the client shows
		// no character slots for the realm.
		var n int
		if err := db.QueryRowContext(ctx,
			"SELECT COUNT(*) FROM realmcharacters WHERE acctid = ?", acct.ID).Scan(&n); err != nil {
			t.Fatal(err)
		}
		if n != 1 {
			t.Errorf("realmcharacters rows = %d, want 1", n)
		}
	})

	t.Run("CreateAccount duplicate", func(t *testing.T) {
		_, err := st.CreateAccount(ctx, "testuser", "other", "")
		if !errors.Is(err, store.ErrDuplicate) {
			t.Errorf("err = %v, want ErrDuplicate (the name is case insensitive)", err)
		}
	})

	t.Run("VerifyLogin", func(t *testing.T) {
		// Correct credentials, in any case.
		for _, u := range []string{"TestUser", "TESTUSER", "testuser"} {
			acct, err := st.VerifyLogin(ctx, u, "Secret123")
			if err != nil {
				t.Fatalf("VerifyLogin(%q): %v", u, err)
			}
			if acct.ID != created.ID {
				t.Errorf("VerifyLogin(%q) returned id %d, want %d", u, acct.ID, created.ID)
			}
		}

		if _, err := st.VerifyLogin(ctx, "TESTUSER", "wrong"); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("wrong password: err = %v, want ErrNotFound", err)
		}
		if _, err := st.VerifyLogin(ctx, "nosuchuser", "x"); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("unknown user: err = %v, want ErrNotFound", err)
		}

		// failed_logins goes up on a bad password and back to zero on the next
		// good one. The wrong-password attempt above is the only failure here,
		// so the counter must read 1 at this point: the assertion used to say 0,
		// which could not hold because this subtest never signs in again after
		// the failure.
		readFails := func() uint32 {
			t.Helper()
			var n uint32
			if err := db.QueryRowContext(ctx,
				"SELECT failed_logins FROM account WHERE id = ?", created.ID).Scan(&n); err != nil {
				t.Fatal(err)
			}
			return n
		}
		if n := readFails(); n != 1 {
			t.Errorf("failed_logins = %d, want 1 after one bad password", n)
		}

		// And a successful sign-in clears it, which is the other half of the
		// behaviour the comment above describes.
		if _, err := st.VerifyLogin(ctx, "TESTUSER", "Secret123"); err != nil {
			t.Fatalf("VerifyLogin after failure: %v", err)
		}
		if n := readFails(); n != 0 {
			t.Errorf("failed_logins = %d, want 0 after a successful sign-in", n)
		}
	})

	t.Run("SetPassword", func(t *testing.T) {
		if err := st.SetPassword(ctx, created.ID, "NewSecret"); err != nil {
			t.Fatalf("SetPassword: %v", err)
		}
		if _, err := st.VerifyLogin(ctx, "TESTUSER", "NewSecret"); err != nil {
			t.Errorf("new password rejected: %v", err)
		}
		if _, err := st.VerifyLogin(ctx, "TESTUSER", "Secret123"); !errors.Is(err, store.ErrNotFound) {
			t.Error("old password still accepted")
		}
		// v/s must be cleared so a running client cannot keep the old session.
		var v, s sql.NullString
		if err := db.QueryRowContext(ctx,
			`SELECT v, s FROM account WHERE id = ?`, created.ID).Scan(&v, &s); err != nil {
			t.Fatal(err)
		}
		if (v.Valid && v.String != "") || (s.Valid && s.String != "") {
			t.Errorf("v/s should be cleared, got v=%q s=%q", v.String, s.String)
		}
	})

	// --- listing and filters -------------------------------------------------
	t.Run("ListAccounts", func(t *testing.T) {
		if _, err := st.CreateAccount(ctx, "Second", "secret", "second@example.com"); err != nil {
			t.Fatal(err)
		}

		all, total, err := st.ListAccounts(ctx, store.AccountFilter{})
		if err != nil {
			t.Fatal(err)
		}
		if total != 2 || len(all) != 2 {
			t.Errorf("total=%d len=%d, want 2/2", total, len(all))
		}

		found, _, err := st.ListAccounts(ctx, store.AccountFilter{Search: "second"})
		if err != nil {
			t.Fatal(err)
		}
		if len(found) != 1 || found[0].Username != "SECOND" {
			t.Errorf("search returned %d rows: %+v", len(found), found)
		}

		// Search must match email too.
		found, _, err = st.ListAccounts(ctx, store.AccountFilter{Search: "second@example"})
		if err != nil {
			t.Fatal(err)
		}
		if len(found) != 1 {
			t.Errorf("email search returned %d rows, want 1", len(found))
		}

		rank := uint8(0)
		found, _, err = st.ListAccounts(ctx, store.AccountFilter{Rank: &rank})
		if err != nil {
			t.Fatal(err)
		}
		if len(found) != 2 {
			t.Errorf("rank filter returned %d rows, want 2", len(found))
		}
	})

	t.Run("SetRank and SetActive", func(t *testing.T) {
		if err := st.SetRank(ctx, created.ID, 4); err != nil {
			t.Fatalf("SetRank: %v", err)
		}
		acct, err := st.AccountByID(ctx, created.ID)
		if err != nil {
			t.Fatal(err)
		}
		if acct.Rank != 4 {
			t.Errorf("rank = %d, want 4", acct.Rank)
		}

		if err := st.SetActive(ctx, created.ID, false); err != nil {
			t.Fatalf("SetActive(false): %v", err)
		}
		acct, _ = st.AccountByID(ctx, created.ID)
		if acct.Active {
			t.Error("account should be inactive")
		}
		if err := st.SetActive(ctx, created.ID, true); err != nil {
			t.Fatalf("SetActive(true): %v", err)
		}
	})

	// --- bans ----------------------------------------------------------------
	t.Run("BanAccount", func(t *testing.T) {
		if err := st.BanAccount(ctx, created.ID, 24*time.Hour, "testing", "ADMIN", 1); err != nil {
			t.Fatalf("BanAccount: %v", err)
		}

		ban, err := st.ActiveBanFor(ctx, created.ID)
		if err != nil {
			t.Fatalf("ActiveBanFor: %v", err)
		}
		if ban.Permanent {
			t.Error("a 24h ban must not be permanent")
		}
		if !ban.StillValid {
			t.Error("ban should be in effect")
		}

		banned := true
		list, _, err := st.ListAccounts(ctx, store.AccountFilter{Banned: &banned})
		if err != nil {
			t.Fatal(err)
		}
		if len(list) != 1 || list[0].ID != created.ID {
			t.Errorf("banned filter returned %d rows: %+v", len(list), list)
		}

		// The batch lookup used by the list view must agree.
		bans, err := st.ActiveBansForAccounts(ctx, []uint32{created.ID})
		if err != nil {
			t.Fatal(err)
		}
		if bans[created.ID] == nil {
			t.Error("ActiveBansForAccounts missed the ban")
		}

		if err := st.UnbanAccount(ctx, created.ID); err != nil {
			t.Fatalf("UnbanAccount: %v", err)
		}
		if _, err := st.ActiveBanFor(ctx, created.ID); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("after unban: err = %v, want ErrNotFound", err)
		}
	})

	t.Run("PermanentBan", func(t *testing.T) {
		// account_banned is keyed by (id, bandate), and UnbanAccount only flips
		// `active` - it keeps the row. So a second ban of the same account in
		// the same second is a duplicate key, not a new ban. This subtest wants
		// a fresh permanent ban to inspect, so the earlier row is removed first;
		// reusing a ban issued one second ago would test nothing new anyway.
		if _, err := db.ExecContext(ctx,
			"DELETE FROM account_banned WHERE id = ?", created.ID); err != nil {
			t.Fatal(err)
		}

		// duration 0 is the permanent marker: bandate == unbandate.
		if err := st.BanAccount(ctx, created.ID, 0, "forever", "ADMIN", 1); err != nil {
			t.Fatal(err)
		}
		ban, err := st.ActiveBanFor(ctx, created.ID)
		if err != nil {
			t.Fatal(err)
		}
		if !ban.Permanent {
			t.Error("a zero duration ban must be permanent")
		}
		if !ban.StillValid {
			t.Error("a permanent ban must always be in effect")
		}
		if err := st.UnbanAccount(ctx, created.ID); err != nil {
			t.Fatal(err)
		}
	})

	t.Run("BanIP", func(t *testing.T) {
		if err := st.BanIP(ctx, "203.0.113.9", 0, "testing", "ADMIN"); err != nil {
			t.Fatalf("BanIP: %v", err)
		}
		ips, err := st.ListIPBans(ctx)
		if err != nil {
			t.Fatal(err)
		}
		if len(ips) != 1 || ips[0].IP != "203.0.113.9" || !ips[0].Permanent {
			t.Errorf("ListIPBans = %+v", ips)
		}
		// Re-banning the same address must replace, not duplicate the row.
		if err := st.BanIP(ctx, "203.0.113.9", time.Hour, "again", "ADMIN"); err != nil {
			t.Fatal(err)
		}
		ips, _ = st.ListIPBans(ctx)
		if len(ips) != 1 {
			t.Errorf("re-banning produced %d rows, want 1", len(ips))
		}
		if err := st.UnbanIP(ctx, "203.0.113.9"); err != nil {
			t.Fatal(err)
		}
	})

	// --- mutes ---------------------------------------------------------------
	t.Run("Mute", func(t *testing.T) {
		until := time.Now().Add(2 * time.Hour).Truncate(time.Second)
		if err := st.SetMute(ctx, created.ID, until, "spamming", "ADMIN"); err != nil {
			t.Fatalf("SetMute: %v", err)
		}
		acct, err := st.AccountByID(ctx, created.ID)
		if err != nil {
			t.Fatal(err)
		}
		if acct.MuteTime != until.Unix() {
			t.Errorf("mutetime = %d, want %d (unix seconds)", acct.MuteTime, until.Unix())
		}
		if acct.MuteReason != "spamming" || acct.MuteBy != "ADMIN" {
			t.Errorf("mute metadata = %q/%q", acct.MuteReason, acct.MuteBy)
		}

		if err := st.ClearMute(ctx, created.ID); err != nil {
			t.Fatal(err)
		}
		acct, _ = st.AccountByID(ctx, created.ID)
		if acct.MuteTime != 0 {
			t.Errorf("mutetime = %d, want 0", acct.MuteTime)
		}
	})

	// --- two factor ----------------------------------------------------------
	t.Run("TwoFactor", func(t *testing.T) {
		secret, err := gamepwd.GenerateTOTPSecret()
		if err != nil {
			t.Fatal(err)
		}
		if err := st.SetTOTP(ctx, created.ID, secret); err != nil {
			t.Fatalf("SetTOTP: %v", err)
		}
		acct, _ := st.AccountByID(ctx, created.ID)
		if acct.Security != secret {
			t.Errorf("security = %q, want %q", acct.Security, secret)
		}
		if acct.Locked&store.LockFixedPIN == 0 {
			t.Error("FIXED_PIN flag should be set, otherwise realmd does not prompt")
		}

		// ValidateTOTPSecret must reject junk before it reaches the database.
		if err := st.SetTOTP(ctx, created.ID, "not-base32!!"); err == nil {
			t.Error("SetTOTP accepted an invalid secret")
		}

		// Pending setup round trip.
		pending, _ := gamepwd.GenerateTOTPSecret()
		if err := st.SavePendingSecret(ctx, created.ID, pending, time.Minute); err != nil {
			t.Fatalf("SavePendingSecret: %v", err)
		}
		got, err := st.PendingSecret(ctx, created.ID)
		if err != nil || got != pending {
			t.Errorf("PendingSecret = %q, %v; want %q", got, err, pending)
		}
		if err := st.DeletePendingSecret(ctx, created.ID); err != nil {
			t.Fatal(err)
		}
		if _, err := st.PendingSecret(ctx, created.ID); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("after delete: %v, want ErrNotFound", err)
		}

		if err := st.ClearTOTP(ctx, created.ID); err != nil {
			t.Fatalf("ClearTOTP: %v", err)
		}
		acct, _ = st.AccountByID(ctx, created.ID)
		if acct.Security != "" {
			t.Errorf("security = %q, want empty", acct.Security)
		}
		if acct.Locked&store.LockFixedPIN != 0 {
			t.Error("FIXED_PIN should be cleared")
		}
	})

	t.Run("TwoFactorAllowances", func(t *testing.T) {
		if _, err := db.ExecContext(ctx,
			`INSERT INTO account_twofactor_allowed (ip_address, account_id, expires_at)
			 VALUES ('198.51.100.7', ?, ?)`,
			created.ID, time.Now().Add(24*time.Hour).Unix()); err != nil {
			t.Fatal(err)
		}
		list, err := st.ListTwoFactorAllowances(ctx, created.ID)
		if err != nil {
			t.Fatal(err)
		}
		if len(list) != 1 {
			t.Fatalf("got %d allowances, want 1", len(list))
		}
		if err := st.RevokeTwoFactorAllowance(ctx, list[0].ID, created.ID); err != nil {
			t.Fatalf("RevokeTwoFactorAllowance: %v", err)
		}
		if list, _ = st.ListTwoFactorAllowances(ctx, created.ID); len(list) != 0 {
			t.Errorf("allowance not removed")
		}
	})

	// --- sessions ------------------------------------------------------------
	t.Run("Sessions", func(t *testing.T) {
		token, csrf, err := st.CreateSession(ctx, created.ID, time.Hour, "10.0.0.1", "test-agent")
		if err != nil {
			t.Fatalf("CreateSession: %v", err)
		}
		if token == "" || csrf == "" {
			t.Fatal("empty token or csrf")
		}

		sess, err := st.SessionByToken(ctx, token)
		if err != nil {
			t.Fatalf("SessionByToken: %v", err)
		}
		if sess.AccountID != created.ID || sess.CSRFToken != csrf {
			t.Errorf("session mismatch: %+v", sess)
		}

		// The raw token must not be stored.
		var stored string
		if err := db.QueryRowContext(ctx,
			"SELECT token_hash FROM web_sessions WHERE account_id = ?", created.ID).Scan(&stored); err != nil {
			t.Fatal(err)
		}
		if stored == token {
			t.Error("the cookie value is stored verbatim; it should be hashed")
		}

		if n, err := st.CountSessionsForAccount(ctx, created.ID); err != nil || n != 1 {
			t.Errorf("CountSessionsForAccount = %d, %v; want 1", n, err)
		}

		// Expiry must hide the session.
		_, expired, err := st.CreateSession(ctx, created.ID, -time.Minute, "10.0.0.2", "old")
		if err != nil {
			t.Fatal(err)
		}
		if _, err := st.SessionByToken(ctx, expired); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("expired session: %v, want ErrNotFound", err)
		}

		token2, _, err := st.CreateSession(ctx, created.ID, time.Hour, "10.0.0.3", "other")
		if err != nil {
			t.Fatal(err)
		}
		if err := st.DeleteSessionsExcept(ctx, created.ID, token); err != nil {
			t.Fatal(err)
		}
		if _, err := st.SessionByToken(ctx, token); err != nil {
			t.Errorf("the kept session was deleted: %v", err)
		}
		if _, err := st.SessionByToken(ctx, token2); !errors.Is(err, store.ErrNotFound) {
			t.Error("the other session should have been deleted")
		}

		if err := st.DeleteSessionsForAccount(ctx, created.ID); err != nil {
			t.Fatal(err)
		}
		if n, _ := st.CountSessionsForAccount(ctx, created.ID); n != 0 {
			t.Errorf("sessions left = %d, want 0", n)
		}
	})

	// --- realms --------------------------------------------------------------
	t.Run("Realms", func(t *testing.T) {
		if err := st.UpdateRealmNameAndAddress(ctx, 1, "My Realm", "example.com", 8090); err != nil {
			t.Fatalf("UpdateRealmNameAndAddress: %v", err)
		}
		if err := st.UpdateRealmFlags(ctx, 1, store.RealmFlagRecommended|store.RealmFlagSpecifyBuild); err != nil {
			t.Fatalf("UpdateRealmFlags: %v", err)
		}
		if err := st.SetRealmAllowedSecurityLevel(ctx, 1, 2); err != nil {
			t.Fatalf("SetRealmAllowedSecurityLevel: %v", err)
		}

		r, err := st.RealmByID(ctx, 1)
		if err != nil {
			t.Fatal(err)
		}
		if r.Name != "My Realm" || r.Address != "example.com" || r.Port != 8090 {
			t.Errorf("realm = %+v", r)
		}
		if r.Flags&store.RealmFlagRecommended == 0 || r.Flags&store.RealmFlagSpecifyBuild == 0 {
			t.Errorf("flags = 0x%02X", r.Flags)
		}
		if r.AllowedSecurityLevel != 2 {
			t.Errorf("allowedSecurityLevel = %d, want 2", r.AllowedSecurityLevel)
		}

		// The OFFLINE bit belongs to mangosd; writing flags must preserve it.
		if _, err := db.ExecContext(ctx,
			"UPDATE realmlist SET realmflags = realmflags | ? WHERE id = 1", store.RealmFlagOffline); err != nil {
			t.Fatal(err)
		}
		if err := st.UpdateRealmFlags(ctx, 1, store.RealmFlagNewPlayers); err != nil {
			t.Fatal(err)
		}
		r, _ = st.RealmByID(ctx, 1)
		if r.Flags&store.RealmFlagOffline == 0 {
			t.Error("the offline bit was cleared; mangosd owns it")
		}
		if r.Flags&store.RealmFlagNewPlayers == 0 {
			t.Error("the new flag was not set")
		}
	})

	// --- characters ----------------------------------------------------------
	var charGUID uint32
	t.Run("Characters", func(t *testing.T) {
		res, err := db.ExecContext(ctx,
			`INSERT INTO characters (guid, account, name, race, class, gender, level, money)
			 VALUES (1, ?, 'Tester', 1, 1, 0, 42, 12345)`, created.ID)
		if err != nil {
			t.Fatal(err)
		}
		if _, err := res.RowsAffected(); err != nil {
			t.Fatal(err)
		}
		charGUID = 1

		if _, err := db.ExecContext(ctx,
			`INSERT INTO character_homebind (guid, map, zone, position_x, position_y, position_z)
			 VALUES (?, 0, 12, -8949.95, -132.493, 83.5312)`, charGUID); err != nil {
			t.Fatal(err)
		}

		chars, err := st.CharactersByAccount(ctx, created.ID)
		if err != nil {
			t.Fatalf("CharactersByAccount: %v", err)
		}
		if len(chars) != 1 {
			t.Fatalf("got %d characters, want 1", len(chars))
		}
		if chars[0].Name != "Tester" || chars[0].Level != 42 || chars[0].Money != 12345 {
			t.Errorf("character = %+v", chars[0])
		}
		if chars[0].AccountName != "TESTUSER" {
			t.Errorf("account name join = %q, want TESTUSER", chars[0].AccountName)
		}

		found, total, err := st.ListCharacters(ctx, store.CharacterFilter{Search: "test"})
		if err != nil {
			t.Fatal(err)
		}
		if total != 1 || len(found) != 1 {
			t.Errorf("search: total=%d len=%d", total, len(found))
		}

		minLevel := uint8(50)
		if _, total, err = st.ListCharacters(ctx, store.CharacterFilter{MinLevel: &minLevel}); err != nil {
			t.Fatal(err)
		} else if total != 0 {
			t.Errorf("minLevel filter returned %d, want 0", total)
		}
	})

	t.Run("Unstick", func(t *testing.T) {
		// Move the character somewhere else first.
		if _, err := db.ExecContext(ctx,
			`UPDATE characters SET map = 1, position_x = 1, position_y = 2, position_z = 3 WHERE guid = ?`,
			charGUID); err != nil {
			t.Fatal(err)
		}
		if err := st.Unstick(ctx, charGUID); err != nil {
			t.Fatalf("Unstick: %v", err)
		}

		ch, err := st.CharacterByGUID(ctx, charGUID)
		if err != nil {
			t.Fatal(err)
		}
		if ch.Map != 0 {
			t.Errorf("map = %d, want 0 (homebind)", ch.Map)
		}
		if ch.PosX > -8949 || ch.PosX < -8951 {
			t.Errorf("position_x = %f, want the homebind value", ch.PosX)
		}

		// Refused while online.
		if _, err := db.ExecContext(ctx,
			"UPDATE characters SET online = 1 WHERE guid = ?", charGUID); err != nil {
			t.Fatal(err)
		}
		if err := st.Unstick(ctx, charGUID); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("unstick while online: err = %v, want ErrNotFound", err)
		}
		if _, err := db.ExecContext(ctx,
			"UPDATE characters SET online = 0 WHERE guid = ?", charGUID); err != nil {
			t.Fatal(err)
		}
	})

	t.Run("AtLoginFlags", func(t *testing.T) {
		if err := st.RenameCharacter(ctx, charGUID); err != nil {
			t.Fatalf("RenameCharacter: %v", err)
		}
		ch, _ := st.CharacterByGUID(ctx, charGUID)
		if ch.AtLogin&store.AtLoginRename == 0 {
			t.Error("the rename flag was not set")
		}
		if err := st.SetAtLoginFlag(ctx, charGUID, store.AtLoginRename, false); err != nil {
			t.Fatal(err)
		}
		ch, _ = st.CharacterByGUID(ctx, charGUID)
		if ch.AtLogin&store.AtLoginRename != 0 {
			t.Error("the rename flag was not cleared")
		}
	})

	t.Run("DeleteAccount", func(t *testing.T) {
		victim, err := st.CreateAccount(ctx, "Victim", "secret", "")
		if err != nil {
			t.Fatal(err)
		}
		if _, err := db.ExecContext(ctx,
			`INSERT INTO characters (guid, account, name, race, class, gender, level)
			 VALUES (2, ?, 'Victimchar', 1, 1, 0, 1)`, victim.ID); err != nil {
			t.Fatal(err)
		}
		if _, err := db.ExecContext(ctx,
			`INSERT INTO character_homebind (guid, map, zone) VALUES (2, 0, 12)`); err != nil {
			t.Fatal(err)
		}
		if _, err := db.ExecContext(ctx,
			`INSERT INTO character_inventory (guid, bag, slot, item) VALUES (2, 0, 0, 1)`); err != nil {
			t.Fatal(err)
		}

		chars, err := st.CharactersByAccount(ctx, victim.ID)
		if err != nil {
			t.Fatal(err)
		}
		if err := st.DeleteAccount(ctx, victim.ID, chars); err != nil {
			t.Fatalf("DeleteAccount: %v", err)
		}

		if _, err := st.AccountByID(ctx, victim.ID); !errors.Is(err, store.ErrNotFound) {
			t.Errorf("account still present: %v", err)
		}
		var n int
		if err := db.QueryRowContext(ctx,
			"SELECT COUNT(*) FROM characters WHERE guid = 2").Scan(&n); err != nil {
			t.Fatal(err)
		}
		if n != 0 {
			t.Error("character row survived")
		}
		if err := db.QueryRowContext(ctx,
			"SELECT COUNT(*) FROM character_homebind WHERE guid = 2").Scan(&n); err != nil {
			t.Fatal(err)
		}
		if n != 0 {
			t.Error("character_homebind row survived")
		}
		if err := db.QueryRowContext(ctx,
			"SELECT COUNT(*) FROM realmcharacters WHERE acctid = ?", victim.ID).Scan(&n); err != nil {
			t.Fatal(err)
		}
		if n != 0 {
			t.Error("realmcharacters rows survived")
		}
	})

	t.Run("Stats", func(t *testing.T) {
		stats, err := st.Stats(ctx)
		if err != nil {
			t.Fatalf("Stats: %v", err)
		}
		// TESTUSER and SECOND are left at this point.
		if stats.Accounts != 2 {
			t.Errorf("accounts = %d, want 2", stats.Accounts)
		}
		if stats.Characters != 1 {
			t.Errorf("characters = %d, want 1", stats.Characters)
		}
	})

	t.Run("Audit", func(t *testing.T) {
		if err := st.Audit(ctx, created.ID, "TESTUSER", "account-ban", "SECOND", "detail", "1.2.3.4"); err != nil {
			t.Fatalf("Audit: %v", err)
		}
		entries, err := st.RecentAudit(ctx, 10)
		if err != nil {
			t.Fatal(err)
		}
		if len(entries) != 1 {
			t.Fatalf("got %d audit entries, want 1", len(entries))
		}
		if entries[0].Action != "account-ban" || entries[0].Actor != "TESTUSER" {
			t.Errorf("entry = %+v", entries[0])
		}
	})

	t.Run("ThrottleCountsArePerKindAndBucket", func(t *testing.T) {
		for i := 0; i < 3; i++ {
			if err := st.ThrottleRecord(ctx, store.ThrottleRegister, "198.51.100.1"); err != nil {
				t.Fatal(err)
			}
		}
		n, err := st.ThrottleCount(ctx, store.ThrottleRegister, "198.51.100.1", 10*time.Minute)
		if err != nil {
			t.Fatal(err)
		}
		if n != 3 {
			t.Errorf("attempts = %d, want 3", n)
		}
		if other, _ := st.ThrottleCount(ctx, store.ThrottleRegister, "198.51.100.2", 10*time.Minute); other != 0 {
			t.Errorf("attempts for another address = %d, want 0", other)
		}
		// The same key under a different kind is a different counter, which is
		// what keeps the sign-in rules from eating the sign-up budget.
		if cross, _ := st.ThrottleCount(ctx, store.ThrottleLoginIP, "198.51.100.1", 10*time.Minute); cross != 0 {
			t.Errorf("cross-kind count = %d, want 0", cross)
		}
	})

	t.Run("ThrottleWindowExpires", func(t *testing.T) {
		if err := st.ThrottleRecord(ctx, store.ThrottleLoginAccount, "someone"); err != nil {
			t.Fatal(err)
		}
		// A zero-length window looks back no time at all, so nothing can be
		// inside it. This is how a rule that has aged out behaves.
		if n, _ := st.ThrottleCount(ctx, store.ThrottleLoginAccount, "someone", 0); n != 0 {
			t.Errorf("count inside a zero window = %d, want 0", n)
		}
		if n, _ := st.ThrottleCount(ctx, store.ThrottleLoginAccount, "someone", time.Hour); n != 1 {
			t.Errorf("count inside an hour = %d, want 1", n)
		}
	})

	t.Run("ThrottleKeyIsCaseAndSpaceInsensitive", func(t *testing.T) {
		if err := st.ThrottleRecord(ctx, store.ThrottleLoginAccount, "  Thrall  "); err != nil {
			t.Fatal(err)
		}
		// The store folds case and trims, so the three spellings share a row.
		for _, spelling := range []string{"THRALL", "thrall", "Thrall"} {
			n, _ := st.ThrottleCount(ctx, store.ThrottleLoginAccount, spelling, time.Hour)
			if n != 1 {
				t.Errorf("count for %q = %d, want 1 (should share one bucket)", spelling, n)
			}
		}
	})

	t.Run("ThrottleClearDropsOnlyThatBucket", func(t *testing.T) {
		key := "clear-me"
		for i := 0; i < 2; i++ {
			if err := st.ThrottleRecord(ctx, store.ThrottleLoginAccount, key); err != nil {
				t.Fatal(err)
			}
		}
		if err := st.ThrottleRecord(ctx, store.ThrottleLoginIP, key); err != nil {
			t.Fatal(err)
		}

		if err := st.ThrottleClear(ctx, store.ThrottleLoginAccount, key); err != nil {
			t.Fatal(err)
		}
		if n, _ := st.ThrottleCount(ctx, store.ThrottleLoginAccount, key, time.Hour); n != 0 {
			t.Errorf("account count after clear = %d, want 0", n)
		}
		// A successful sign-in clears the account bucket only. The per-address
		// counter has to survive it, or one valid account would let an attacker
		// reset their own failures.
		if n, _ := st.ThrottleCount(ctx, store.ThrottleLoginIP, key, time.Hour); n != 1 {
			t.Errorf("address count after clear = %d, want 1", n)
		}
	})

	t.Run("PruneThrottleDropsOldRows", func(t *testing.T) {
		const ip = "203.0.113.9"
		if err := st.ThrottleRecord(ctx, store.ThrottleLoginIP, ip); err != nil {
			t.Fatal(err)
		}

		// Just recorded, so it is well inside an hour and must survive.
		if err := st.PruneThrottle(ctx, time.Hour); err != nil {
			t.Fatal(err)
		}
		if n, _ := st.ThrottleCount(ctx, store.ThrottleLoginIP, ip, time.Hour); n != 1 {
			t.Errorf("count after a one-hour prune = %d, want 1", n)
		}

		// Age the row past the cutoff and prune again. Backdating is done here
		// rather than relying on a zero-length window: `at` is a DATETIME with
		// second precision, so a row written and pruned inside the same second
		// is neither older nor younger and the comparison is a coin toss.
		if _, err := db.ExecContext(ctx,
			`UPDATE web_throttle SET at = NOW() - INTERVAL 2 DAY
			 WHERE kind = ? AND bucket = ?`, store.ThrottleLoginIP, ip); err != nil {
			t.Fatal(err)
		}
		if err := st.PruneThrottle(ctx, 24*time.Hour); err != nil {
			t.Fatal(err)
		}
		if n, _ := st.ThrottleCount(ctx, store.ThrottleLoginIP, ip, 7*24*time.Hour); n != 0 {
			t.Errorf("count after pruning a two-day-old row = %d, want 0", n)
		}
	})

	// --- world content browsing ----------------------------------------------
	//
	// The browser reads item_template and friends directly, so this is where the
	// queries meet a real MySQL: column names, the numbered stat/spell columns,
	// the signed game-object column, NULL text and the locale join.
	t.Run("WorldContent", func(t *testing.T) {
		for _, stmt := range []string{
			`INSERT INTO item_template (entry, name, description, quality, class, subclass,
				item_level, required_level, inventory_type, buy_price, sell_price,
				stat_type1, stat_value1, frost_res, spellid_1, spelltrigger_1, spellcharges_1)
			 VALUES (1, 'Fine Sword', 'A fine sword', 4, 2, 7, 50, 45, 21, 12000, 2400, 7, 15, 5, 133, 0, -5)`,
			`INSERT INTO item_template (entry, name, description, quality, class, item_level)
			 VALUES (2, 'Rusty Screw', '', 1, 7, 5)`,
			// Needed by the quest below, so the name lookup has something to find.
			`INSERT INTO item_template (entry, name, description, quality, class, item_level)
			 VALUES (80119, 'Mechanical Drumstick', '', 1, 15, 1)`,
			`INSERT INTO locales_item (entry, name_loc4, description_loc4)
			 VALUES (1, '精良的剑', '一把好剑'), (80119, '机械鸡腿', NULL)`,
			`INSERT INTO spell_template (entry, name, nameSubtext, description, auraDescription,
				school, spellLevel, manaCost, effect1, effectBasePoints1, effectDieSides1)
			 VALUES (1, 'Fireball', 'Rank 1', 'Hurls a fiery ball', '', 4, 30, 95, 2, 9, 3)`,
			`INSERT INTO locales_spell (entry, name_loc4, nameSubtext_loc4)
			 VALUES (1, '火球术', '等级 1')`,
			`INSERT INTO quest_template (entry, Title, QuestLevel, MinLevel,
				ReqItemId1, ReqItemCount1, ReqCreatureOrGOId1, ReqCreatureOrGOCount1,
				ReqCreatureOrGOId2, ReqCreatureOrGOCount2, RewChoiceItemId1, RewChoiceItemCount1)
			 VALUES (1, 'The Other White Mech', 30, 28, 80119, 5, 80117, 5, -1234, 1, 80119, 1)`,
			`INSERT INTO locales_quest (entry, Title_loc4) VALUES (1, '另一只白鸡')`,
			`INSERT INTO creature_template (entry, name, subname, level_min, level_max, type, loot_id)
			 VALUES (80117, 'Haywire Battlechicken', '', 2, 2, 7, 80117)`,
			// A NULL subname: the page must print nothing rather than fail to scan.
			`INSERT INTO creature_template (entry, name, level_min, level_max, type)
			 VALUES (2, 'Spawn Point', 60, 60, 7)`,
			`INSERT INTO locales_creature (entry, name_loc4, subname_loc4)
			 VALUES (80117, '发疯的战斗鸡', '')`,
			`INSERT INTO gameobject_template (entry, type, displayId, name)
			 VALUES (4001, 2, 1, 'Wanted Poster')`,
			`INSERT INTO locales_gameobject (entry, name_loc4) VALUES (4001, '通缉告示')`,

			// Loot, in all four shapes the walker has to tell apart:
			//   a direct drop, a drop that only arrives through a reference, the
			//   same item stored a second time inside a nested reference, and a
			//   quest-only drop whose chance is stored negative.
			`INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (80117, 80119, 25, 0, 1, 2)`,
			`INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (80117, 30016, 50, 0, -30016, 1)`,
			`INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (80117, 30017, 40, 0, -30017, 1)`,
			`INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (80117, 2, -100, 0, 1, 1)`,
			`INSERT INTO reference_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (30016, 80119, 100, 0, 1, 3)`,
			`INSERT INTO reference_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (30017, 30016, 50, 0, -30016, 1)`,
			`INSERT INTO skinning_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (80117, 2, 100, 0, 1, 1)`,
			`INSERT INTO pickpocketing_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (80117, 1, 10, 0, 1, 1)`,
			`INSERT INTO gameobject_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (4001, 1, 100, 0, 1, 1)`,
			`INSERT INTO item_loot_template (entry, item, ChanceOrQuestChance, groupid, mincountOrRef, maxcount)
			 VALUES (1, 2, 5, 0, 1, 1)`,
			`INSERT INTO npc_vendor (entry, slot, item) VALUES (80117, 1, 1)`,
			`INSERT INTO creature_questrelation (id, quest) VALUES (80117, 1)`,
			`INSERT INTO creature_involvedrelation (id, quest) VALUES (80117, 1)`,
			`INSERT INTO gameobject_questrelation (id, quest) VALUES (4001, 1)`,
			// The quest hands out a choice reward as well, which is a second set
			// of columns on the same row.
			`INSERT INTO quest_template (entry, Title, QuestLevel, MinLevel, RewItemId1, RewItemCount1, RewChoiceItemId1, RewChoiceItemCount1)
			 VALUES (2, 'A Quest', 5, 1, 2, 3, 1, 1)`,
			`INSERT INTO locales_quest (entry, Title_loc4) VALUES (2, '一个任务')`,
		} {
			if _, err := db.ExecContext(ctx, stmt); err != nil {
				t.Fatalf("seed %s: %v", stmt, err)
			}
		}

		zh, base := store.ContentLocaleZH, store.ContentLocaleBase

		t.Run("Counts", func(t *testing.T) {
			counts := st.ContentCountsFor(ctx)
			if counts.Items != 3 || counts.Spells != 1 || counts.Quests != 2 || counts.Creatures != 2 {
				t.Errorf("counts = %+v", counts)
			}
		})

		t.Run("Item", func(t *testing.T) {
			it, err := st.ContentItem(ctx, zh, 1)
			if err != nil {
				t.Fatalf("ContentItem: %v", err)
			}
			if it.Name != "精良的剑" || it.Description != "一把好剑" {
				t.Errorf("item name/description = %q / %q, want the loc4 columns", it.Name, it.Description)
			}
			if it.Quality != 4 || it.Class != 2 || it.ItemLevel != 50 || it.BuyPrice != 12000 {
				t.Errorf("item columns are off: %+v", it)
			}
			if len(it.Stats) != 1 || it.Stats[0].Type != 7 || it.Stats[0].Value != 15 {
				t.Errorf("stats = %+v", it.Stats)
			}
			if len(it.Resistances) != 1 || it.Resistances[0].School != 3 || it.Resistances[0].Value != 5 {
				t.Errorf("resistances = %+v", it.Resistances)
			}
			if len(it.Spells) != 1 || it.Spells[0].SpellID != 133 || it.Spells[0].Slot != 1 || it.Spells[0].Charges != -5 {
				t.Errorf("item spells = %+v", it.Spells)
			}

			// The same row read without a locale must not show the translation.
			plain, err := st.ContentItem(ctx, base, 1)
			if err != nil {
				t.Fatalf("ContentItem base: %v", err)
			}
			if plain.Name != "Fine Sword" {
				t.Errorf("base name = %q, want Fine Sword", plain.Name)
			}

			if _, err := st.ContentItem(ctx, zh, 424242); !errors.Is(err, store.ErrNotFound) {
				t.Errorf("missing item error = %v, want ErrNotFound", err)
			}
		})

		t.Run("ItemList", func(t *testing.T) {
			// Searching the translated name has to match too, which is the whole
			// point of joining the locale table into the filter.
			items, total, err := st.ContentItems(ctx, zh, store.ContentItemFilter{Search: "精良"})
			if err != nil {
				t.Fatalf("ContentItems: %v", err)
			}
			if total != 1 || len(items) != 1 || items[0].Name != "精良的剑" {
				t.Errorf("search by translated name returned total=%d items=%+v", total, items)
			}

			items, total, err = st.ContentItems(ctx, zh, store.ContentItemFilter{Search: "sword"})
			if err != nil {
				t.Fatalf("ContentItems: %v", err)
			}
			if total != 1 || items[0].Name != "精良的剑" {
				t.Errorf("search by base name returned total=%d items=%+v", total, items)
			}

			quality := uint8(1)
			_, total, err = st.ContentItems(ctx, zh, store.ContentItemFilter{Quality: &quality})
			if err != nil {
				t.Fatalf("ContentItems: %v", err)
			}
			if total != 2 {
				t.Errorf("quality 1 matched %d items, want the two common ones", total)
			}

			// Paging must not repeat a row.
			first, _, err := st.ContentItems(ctx, zh, store.ContentItemFilter{Limit: 1, Offset: 0})
			if err != nil {
				t.Fatalf("ContentItems page 1: %v", err)
			}
			second, _, err := st.ContentItems(ctx, zh, store.ContentItemFilter{Limit: 1, Offset: 1})
			if err != nil {
				t.Fatalf("ContentItems page 2: %v", err)
			}
			if len(first) != 1 || len(second) != 1 || first[0].Entry == second[0].Entry {
				t.Errorf("paging returned %+v then %+v", first, second)
			}
		})

		t.Run("Spell", func(t *testing.T) {
			sp, err := st.ContentSpell(ctx, zh, 1)
			if err != nil {
				t.Fatalf("ContentSpell: %v", err)
			}
			if sp.Name != "火球术" || sp.NameSubtext != "等级 1" {
				t.Errorf("spell name/subtext = %q / %q", sp.Name, sp.NameSubtext)
			}
			if sp.School != 4 || sp.SpellLevel != 30 || sp.ManaCost != 95 {
				t.Errorf("spell columns are off: %+v", sp)
			}
			if len(sp.Effects) != 1 || sp.Effects[0].Slot != 1 || sp.Effects[0].BasePoints != 9 {
				t.Errorf("effects = %+v", sp.Effects)
			}
		})

		t.Run("Quest", func(t *testing.T) {
			q, err := st.ContentQuest(ctx, zh, 1)
			if err != nil {
				t.Fatalf("ContentQuest: %v", err)
			}
			if q.Title != "另一只白鸡" || q.QuestLevel != 30 {
				t.Errorf("quest title/level = %q / %d", q.Title, q.QuestLevel)
			}
			if len(q.RequiredItems) != 1 || q.RequiredItems[0].Entry != 80119 || q.RequiredItems[0].Count != 5 {
				t.Fatalf("required items = %+v", q.RequiredItems)
			}
			if q.RequiredItems[0].Name != "机械鸡腿" {
				t.Errorf("required item name = %q, want the loc4 name", q.RequiredItems[0].Name)
			}
			if len(q.ChoiceItems) != 1 || q.ChoiceItems[0].Name != "机械鸡腿" {
				t.Errorf("choice items = %+v", q.ChoiceItems)
			}
			if len(q.RequiredMobs) != 2 {
				t.Fatalf("required mobs = %+v, want a creature and a game object", q.RequiredMobs)
			}
			if q.RequiredMobs[0].IsGameObject || q.RequiredMobs[0].Entry != 80117 {
				t.Errorf("positive entry = %+v, want creature 80117", q.RequiredMobs[0])
			}
			if !q.RequiredMobs[1].IsGameObject || q.RequiredMobs[1].Entry != 1234 {
				t.Errorf("negative entry = %+v, want game object 1234", q.RequiredMobs[1])
			}
		})

		t.Run("Creature", func(t *testing.T) {
			c, err := st.ContentCreature(ctx, zh, 80117)
			if err != nil {
				t.Fatalf("ContentCreature: %v", err)
			}
			if c.Name != "发疯的战斗鸡" || c.LevelMin != 2 || c.Type != 7 || c.LootID != 80117 {
				t.Errorf("creature = %+v", c)
			}

			// A NULL subname must read as empty, not fail the scan.
			other, err := st.ContentCreature(ctx, zh, 2)
			if err != nil {
				t.Fatalf("ContentCreature with a NULL subname: %v", err)
			}
			if other.SubName != "" {
				t.Errorf("NULL subname = %q, want empty", other.SubName)
			}

			ctype := uint8(7)
			_, total, err := st.ContentCreatures(ctx, zh, store.ContentCreatureFilter{Type: &ctype})
			if err != nil {
				t.Fatalf("ContentCreatures: %v", err)
			}
			if total != 2 {
				t.Errorf("type 7 matched %d creatures, want 2", total)
			}
		})

		t.Run("Search", func(t *testing.T) {
			kinds := func(term string) map[string]string {
				out := map[string]string{}
				for _, r := range st.ContentSearch(ctx, zh, term) {
					out[r.Kind] = r.Name
				}
				return out
			}

			if got := kinds("精良"); got["item"] != "精良的剑" {
				t.Errorf("searching the translated name found %+v", got)
			}
			if got := kinds("sword"); got["item"] != "精良的剑" {
				t.Errorf("searching the base name found %+v", got)
			}
			if got := kinds("火球"); got["spell"] != "火球术" {
				t.Errorf("spell search found %+v", got)
			}
			if got := kinds("mech"); got["quest"] != "另一只白鸡" {
				t.Errorf("quest search found %+v", got)
			}
			// A pasted entry has to work on every kind.
			if got := kinds("80117"); got["creature"] != "发疯的战斗鸡" {
				t.Errorf("entry search found %+v", got)
			}
		})

		t.Run("ItemRelations", func(t *testing.T) {
			rel, err := st.ItemRelations(ctx, store.ContentLocaleZH, 80119)
			if err != nil {
				t.Fatal(err)
			}

			// One direct row and two that arrive through references: 30016 holds
			// the item outright, and 30017 holds 30016, so the deeper row has to
			// carry the product of both hops (40% x 50% = 20%).
			if len(rel.DroppedBy) != 3 {
				t.Fatalf("dropped by = %+v, want 3 rows", rel.DroppedBy)
			}
			byEntry := map[uint32]store.ContentDrop{}
			for _, d := range rel.DroppedBy {
				byEntry[d.Via] = d
				if d.Name != "发疯的战斗鸡" {
					t.Errorf("drop source %d name = %q, want the Chinese name", d.Entry, d.Name)
				}
			}
			if got := byEntry[0]; got.Chance != 25 || got.MinCount != 1 || got.MaxCount != 2 {
				t.Errorf("direct drop = %+v, want 25%% of 1-2", got)
			}
			if got := byEntry[30016]; got.Chance != 50 || got.MaxCount != 3 {
				t.Errorf("single hop = %+v, want 50%% of up to 3", got)
			}
			if got := byEntry[30017]; got.Chance != 20 {
				t.Errorf("nested hop chance = %v, want 20", got.Chance)
			}

			if len(rel.ContainedIn) != 1 || rel.ContainedIn[0].Entry != 1 {
				t.Errorf("contained in = %+v, want the one container", rel.ContainedIn)
			}
			if len(rel.FoundIn) != 1 || rel.FoundIn[0].Name != "通缉告示" {
				t.Errorf("found in = %+v, want the gameobject", rel.FoundIn)
			}

			// A vendor row has no chance to report.
			if len(rel.SoldBy) != 1 || rel.SoldBy[0].Entry != 80117 || rel.SoldBy[0].Chance != 0 {
				t.Errorf("sold by = %+v", rel.SoldBy)
			}

			// Quest 1 asks for five of the item, and quest 2 hands out three.
			var required, rewarded uint16
			for _, q := range rel.RequiredBy {
				if q.Entry == 1 {
					required = q.Count
				}
			}
			for _, q := range rel.RewardedBy {
				if q.Entry == 2 {
					rewarded = q.Count
				}
			}
			if required != 5 {
				t.Errorf("required count = %d, want 5", required)
			}
			if rewarded != 3 {
				t.Errorf("rewarded count = %d, want 3", rewarded)
			}
		})

		t.Run("ItemRelationsChoiceReward", func(t *testing.T) {
			// The choice columns are a second set of pairs on the same row, so
			// this is the case that catches a scan reading them in the wrong
			// order.
			rel, err := st.ItemRelations(ctx, store.ContentLocaleBase, 1)
			if err != nil {
				t.Fatal(err)
			}
			var found bool
			for _, q := range rel.RewardedBy {
				if q.Entry == 2 && q.Choice && q.Count == 1 {
					found = true
				}
			}
			if !found {
				t.Errorf("choice reward missing from %+v", rel.RewardedBy)
			}
		})

		t.Run("CreatureRelations", func(t *testing.T) {
			rel, err := st.CreatureRelations(ctx, store.ContentLocaleZH, 80117)
			if err != nil {
				t.Fatal(err)
			}
			if len(rel.StartsQuests) != 1 || rel.StartsQuests[0].Title != "另一只白鸡" {
				t.Errorf("starts = %+v", rel.StartsQuests)
			}
			if len(rel.EndsQuests) != 1 {
				t.Errorf("ends = %+v", rel.EndsQuests)
			}

			// Direct rows first, then what the references expand to: two direct
			// rows (the item and a quest-only one), then the item again from
			// 30016 and once more through 30017.
			if len(rel.Drops) != 4 {
				t.Fatalf("drops = %+v, want 4 rows", rel.Drops)
			}
			if rel.Drops[0].Entry != 2 || !rel.Drops[0].QuestOnly || rel.Drops[0].Chance != 100 {
				t.Errorf("quest-only drop = %+v", rel.Drops[0])
			}
			for _, it := range rel.Drops {
				if it.Entry == 80119 && it.Name != "机械鸡腿" {
					t.Errorf("loot item %d name = %q, want the Chinese name", it.Entry, it.Name)
				}
			}
			if len(rel.Skins) != 1 || rel.Skins[0].Entry != 2 {
				t.Errorf("skins = %+v", rel.Skins)
			}
			if len(rel.Pickpockets) != 1 || rel.Pickpockets[0].Entry != 1 {
				t.Errorf("pickpockets = %+v", rel.Pickpockets)
			}
			if len(rel.Sells) != 1 || rel.Sells[0].Name != "精良的剑" {
				t.Errorf("sells = %+v", rel.Sells)
			}
		})

		t.Run("QuestRelations", func(t *testing.T) {
			rel, err := st.QuestRelations(ctx, store.ContentLocaleZH, 1)
			if err != nil {
				t.Fatal(err)
			}
			var creatureGiver, goGiver bool
			for _, s := range rel.Starts {
				switch s.Kind {
				case store.DropCreature:
					creatureGiver = s.Entry == 80117 && s.Name == "发疯的战斗鸡"
				case store.DropGameObject:
					goGiver = s.Entry == 4001 && s.Name == "通缉告示"
				}
			}
			if !creatureGiver || !goGiver {
				t.Errorf("starts = %+v, want both a creature and a gameobject", rel.Starts)
			}
			if len(rel.Ends) != 1 || rel.Ends[0].Entry != 80117 {
				t.Errorf("ends = %+v", rel.Ends)
			}
		})
	})
}

// dbDatabase extracts the database name from a go-sql-driver DSN, so the test
// can swap it for its own scratch database.
func dbDatabase(dsn string) string {
	slash := strings.LastIndex(dsn, "/")
	if slash < 0 {
		return ""
	}
	rest := dsn[slash+1:]
	if q := strings.Index(rest, "?"); q >= 0 {
		rest = rest[:q]
	}
	return rest
}

// withDSN rebuilds the connection details from the supplied DSN.
func withDSN(t *testing.T, base config.Config, dsn, database string) config.Config {
	t.Helper()

	// user:pass@tcp(host:port)/db?params
	//
	// The password part is greedy on purpose: a real password may contain '@',
	// and the driver treats the last '@tcp(' as the separator. Matching only
	// up to the first '@' made the whole suite unrunnable for those servers.
	m := regexp.MustCompile(`^([^:]+):(.*)@tcp\(([^:]+):(\d+)\)`).FindStringSubmatch(dsn)
	if m == nil {
		t.Fatalf("cannot parse DSN %q; expected user:pass@tcp(host:port)/db", dsn)
	}

	base.DBUser = m[1]
	base.DBPassword = m[2]
	base.DBHost = m[3]
	if _, err := fmt.Sscanf(m[4], "%d", &base.DBPort); err != nil {
		t.Fatalf("bad port %q: %v", m[4], err)
	}
	base.DBLogon, base.DBChar, base.DBWorld, base.DBLogs = database, database, database, database
	return base
}
