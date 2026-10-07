package web

import (
	"bytes"
	"fmt"
	"strings"
	"testing"
	"time"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestTemplatesParse renders every page template with a representative payload.
//
// Template errors are runtime errors in Go, so a typo in a field name or a
// missing function only shows up when that page is requested. This test walks
// all of them, including the branches that only appear when the data is set.
func TestTemplatesParse(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatalf("parse templates: %v", err)
	}
	if len(rend.cache) == 0 {
		t.Fatal("no templates were parsed")
	}

	now := time.Now()
	account := &store.Account{
		ID: 7, Username: "TESTER", Rank: 4, Email: "t@example.com",
		JoinDate: ptrTime(now.Add(-100 * time.Hour)), LastIP: "10.0.0.5",
		LastLogin: &now, Online: true, Active: true, Security: "ABCDEF",
		FailedLogins: 2, MuteTime: now.Add(time.Hour).Unix(), MuteReason: "spam",
	}
	rank := uint8(3)
	online := true

	// Filter values the database browser cases pass by pointer: a zero would be
	// indistinguishable from "no filter", which is exactly what the pointer is
	// for.
	quality, class := uint8(4), uint8(2)
	minLevel, maxLevel := uint8(30), uint8(60)
	school, ctype := uint8(2), uint8(7)
	char := store.Character{
		GUID: 42, AccountID: 7, AccountName: "TESTER", Name: "Thrall",
		Race: 2, Class: 1, Gender: 0, Level: 60, Money: 1234567,
		Online: true, Map: 1, Zone: 1637, PosX: 1.5, PosY: -2.25, PosZ: 0.5,
		TotalTime: 90061, LevelTime: 100, LogoutTime: now.Unix(),
		AtLogin: store.AtLoginRename, GuildName: "Warchiefs",
	}
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load translations: %v", err)
	}

	page := PageData{
		Title: "Test", Active: "admin", CSRFToken: "csrf-token",
		Account: account, IsAdmin: true, Year: 2026,
		Flash: []Flash{{Kind: "ok", Message: "done"}},
		Tr:    bundle.Translator(i18n.EN),
		Langs: i18n.Supported,
		Config: PageConfig{
			SiteName: "Tortoise WoW", RealmID: 1, WorldAddress: "wow.example",
			WorldPort: 8090, RealmPort: 3724, AllowRegister: true,
			AdminMinRank: 4, PasswordMinLen: 6,
		},
	}
	// Render every page in both languages: a translation that breaks a
	// template (a stray % or a quote in a confirm() string) shows up here.
	pageZH := page
	pageZH.Tr = bundle.Translator(i18n.ZH)

	cases := []struct {
		page string
		data any
	}{
		{"home", homeView{
			PageData: page, Stats: store.ServerStats{
				Accounts: 10, Characters: 20, OnlineChars: 2, OnlineAccs: 2,
				ActiveBans: 1, Guilds: 3, NewToday: 1,
			},
			Realms: []store.Realm{{
				ID: 1, Name: "Tortoise WoW", Address: "wow.example", Port: 8090,
				Flags:      store.RealmFlagRecommended | store.RealmFlagSpecifyBuild,
				Population: 1.2, RealmBuilds: "7272",
			}},
		}},
		{"login", loginView{PageData: page, Username: "TESTER", Next: "/panel"}},
		{"register", registerView{PageData: page}},
		{"panel", panelView{
			PageData: page, Characters: []store.Character{char},
			Ban:   &store.Ban{Reason: "cheating", Permanent: true},
			Muted: true, MuteUntil: now.Add(time.Hour),
			TwoFAOn: true, SessionCnt: 3,
		}},
		// Same page with every optional field empty, to exercise the
		// "no data" branches.
		{"panel", panelView{PageData: page}},
		{"panel_characters", panelView{PageData: page, Characters: []store.Character{char}}},
		{"panel_characters", panelView{PageData: page}},
		{"panel_password", passwordView{PageData: page}},
		{"panel_security", securityView{PageData: page, Enabled: true,
			Allowances: []store.TwoFactorAllowance{{
				ID: 1, IP: "1.2.3.4", ExpiresAt: now.Add(72 * time.Hour),
			}},
		}},
		{"panel_security", securityView{PageData: page, Pending: true,
			Secret: "GEZDGNBVGY3TQOJQ", OTPAuthURI: "otpauth://totp/x?secret=y",
		}},
		{"panel_security", securityView{PageData: page}},
		{"panel_sessions", sessionsView{PageData: page, Sessions: []store.WebSession{{
			CreatedAt: now, LastSeenAt: now, ExpiresAt: now.Add(time.Hour),
			IP: "1.2.3.4", UserAgent: "Mozilla/5.0",
		}}}},
		{"panel_sessions", sessionsView{PageData: page}},
		{"admin_dashboard", adminDashboardView{
			PageData: page,
			Stats:    store.ServerStats{Accounts: 10, Characters: 20, OnlineChars: 2, Guilds: 3},
			Recent:   []store.Account{*account},
			Online:   []store.Character{char},
			Audit:    []store.AuditEntry{{At: now, Actor: "ADMIN", Action: "account-ban", Target: "X", Detail: "d", IP: "1.2.3.4"}},
			Realms:   []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1}},
		}},
		{"admin_accounts", adminAccountsView{
			PageData: page, QueryString: "q=a&",
			Accounts: []store.Account{*account},
			Filter:   store.AccountFilter{Search: "a", Rank: &rank, Online: &online},
			Total:    1, Page: 1, Pages: 2,
			Bans: map[uint32]*store.Ban{7: {Reason: "x", UnbanDate: now}},
		}},
		{"admin_accounts", adminAccountsView{PageData: page, Total: 0, Page: 1, Pages: 1}},
		{"admin_account_new", adminAccountNewView{PageData: page}},
		{"admin_account_detail", adminAccountView{
			PageData: page, Account: account,
			Characters: []store.Character{char},
			Bans: []store.Ban{
				{Reason: "perm", Permanent: true, StillValid: true, BanDate: now, BannedBy: "ADMIN"},
				{Reason: "old", BanDate: now, UnbanDate: now, BannedBy: "ADMIN"},
			},
			Allowances:  []store.TwoFactorAllowance{{ID: 2, IP: "5.6.7.8", ExpiresAt: now}},
			Sessions:    2,
			RankChoices: []uint8{0, 1, 2, 3, 4, 5, 6},
		}},
		{"admin_account_detail", adminAccountView{
			PageData: page, Account: account, IsSelf: true,
			RankChoices: []uint8{0, 1, 2, 3, 4, 5, 6},
		}},
		{"admin_characters", adminCharactersView{
			PageData: page, QueryString: "q=t&",
			Characters: []store.Character{char},
			Filter:     store.CharacterFilter{Search: "t", Online: &online},
			Total:      1, Page: 1, Pages: 3,
		}},
		{"admin_character_detail", adminCharacterView{
			PageData: page, Character: char, Flags: []string{"rename"},
		}},
		{"admin_bans", adminBansView{
			PageData: page, QueryString: "only=active&",
			Bans: []store.Ban{
				{AccountID: 7, Username: "TESTER", Reason: "r", Permanent: true,
					StillValid: true, BanDate: now, BannedBy: "ADMIN"},
			},
			Filter: store.BanFilter{Only: "active"}, Total: 1, Page: 1, Pages: 1,
			IPBans: []store.IPBan{{IP: "1.2.3.4", BanDate: now, Permanent: true}},
		}},
		{"admin_bans", adminBansView{PageData: page, Page: 1, Pages: 1}},
		{"admin_realms", adminRealmsView{
			PageData: page,
			Realms: []store.Realm{{
				ID: 1, Name: "Tortoise WoW", Address: "wow.example", Port: 8090,
				Icon: 6, Flags: store.RealmFlagOffline | store.RealmFlagRecommended,
				Timezone: 1, AllowedSecurityLevel: 1, Population: 0.5,
				RealmBuilds: "7272",
			}},
		}},
		// No realms configured yet: the template prints an example statement.
		{"admin_realms", adminRealmsView{PageData: page}},
		{"admin_audit", adminAuditView{
			PageData: page,
			Entries: []store.AuditEntry{
				{At: now, ActorID: 0, Actor: "NEWBIE", Action: "register", Target: "NEWBIE"},
				{At: now, ActorID: 1, Actor: "ADMIN", Action: "account-ban", Target: "X", Detail: "d", IP: "1.2.3.4"},
			},
		}},
		{"admin_audit", adminAuditView{PageData: page}},
		{"admin_shop", shopListView{
			PageData:   page,
			Categories: []store.ShopCategory{{ID: 5, Name: "Mounts", NameCN: "坐骑", Items: 2}},
			Items: []store.ShopItem{
				{ID: 12, Category: 5, Entry: 50071, Price: 50, Region: store.ShopRegionGlobal, Scale: 1},
				{ID: 13, Category: 99, Entry: 0, Price: 0, Region: store.ShopRegionChina, Scale: 0},
			},
			Total: 2, Page: 2, Pages: 3, QueryString: "category=5&",
			RealmRegion: store.ShopRegionEurope,
		}},
		{"admin_shop_item", shopItemView{
			PageData:   page,
			Item:       store.ShopItem{ID: 12, Category: 99, Entry: 50071, Price: 50, Scale: 1},
			Categories: []store.ShopCategory{{ID: 5, Name: "Mounts", NameCN: "坐骑"}},
			Regions:    (&Server{}).shopRegions(),
		}},
		{"admin_shop_category", shopCategoryView{
			PageData:  page,
			Category:  store.ShopCategory{ID: 34, Name: "Toys", NameCN: "玩具", Icon: "wormhole"},
			Icons:     shopCategoryIcons,
			ItemCount: 3,
		}},
		{"admin_shop_categories", shopCategoryListView{
			PageData: page,
			Categories: []store.ShopCategory{
				{ID: 5, Name: "Mounts", NameCN: "坐骑", Icon: "mount", Items: 2},
				{ID: 34, Name: "Toys", Icon: "wormhole"},
			},
		}},
		// The database browser: the landing page, one list and one detail page
		// per kind, plus the unified search. Every optional field is set on one
		// case and left empty on the next, so both branches of the templates
		// are executed.
		{"db_home", dbHomeView{PageData: page, Counts: store.ContentCounts{
			Items: 20123, Spells: 34210, Quests: 5678, Creatures: 41230,
		}}},
		{"db_search", dbSearchView{PageData: page, Query: "sword",
			Results: []store.ContentSearchResult{
				{Kind: "item", Entry: 1234, Name: "Fine Sword", Subtitle: ""},
				{Kind: "spell", Entry: 133, Name: "火球术", Subtitle: "等级 1"},
				{Kind: "quest", Entry: 5, Name: "A Quest", Subtitle: "30"},
				{Kind: "creature", Entry: 80117, Name: "发疯的战斗鸡", Subtitle: ""},
			}}},
		{"db_search", dbSearchView{PageData: page}},
		{"db_items", dbItemsView{
			PageData: page, Search: "sword", Total: 3, Page: 2, Pages: 4,
			QueryString: "q=sword&", FilterQuality: &quality, FilterClass: &class,
			FilterMin: &minLevel, FilterMax: &maxLevel,
			Items: []store.ContentItem{
				{Entry: 1234, Name: "Fine Sword", Description: "A fine sword", Quality: 4,
					Class: 2, ItemLevel: 50, RequiredLevel: 45},
				{Entry: 5, Name: "Rusty Screw", Quality: 0, Class: 7, ItemLevel: 0},
			}}},
		{"db_items", dbItemsView{PageData: page, Total: 0, Page: 1, Pages: 1}},
		{"db_item", dbItemView{PageData: page, Item: store.ContentItem{
			Entry: 1234, Name: "Fine Sword", Description: "A fine sword", Quality: 4,
			Class: 2, SubClass: 7, DisplayID: 2213, ItemLevel: 50, RequiredLevel: 45,
			InventoryType: 21, BuyPrice: 12000, SellPrice: 2400, Stackable: 1, MaxCount: 1,
			Armor: 0, Block: 0, Delay: 2600, DamageMin: 10, DamageMax: 20, Bonding: 2,
			SetID: 0, StartQuest: 0, PageText: 0, Flags: 0,
			Stats:       []store.ContentItemStat{{Type: 7, Value: 15}, {Type: 4, Value: -3}},
			Resistances: []store.ContentItemResistance{{School: 3, Value: 5}},
			Spells:      []store.ContentItemSpell{{Slot: 1, SpellID: 133, Trigger: 0, Charges: -5}},
		}}},
		// A plain item: no damage, no stats, no spells, no description.
		{"db_item", dbItemView{PageData: page, Item: store.ContentItem{
			Entry: 5, Name: "Rusty Screw", Quality: 1, Class: 7, Bonding: 0, Stackable: 20,
		}}},
		{"db_spells", dbSpellsView{
			PageData: page, Search: "fire", Total: 2, Page: 1, Pages: 1,
			FilterSchool: &school, FilterMin: &minLevel, FilterMax: &maxLevel,
			Spells: []store.ContentSpell{
				{Entry: 133, Name: "Fireball", NameSubtext: "Rank 1", School: 2,
					SpellLevel: 30, ManaCost: 95, ProcChance: 100, CastingTimeIndex: 1},
				{Entry: 9, Name: "Frostbolt", School: 4, SpellLevel: 4},
			}}},
		{"db_spells", dbSpellsView{PageData: page, Total: 0, Page: 1, Pages: 1}},
		{"db_spell", dbSpellView{PageData: page, Spell: store.ContentSpell{
			Entry: 133, Name: "Fireball", NameSubtext: "Rank 1", Description: "Hurls a fiery ball",
			AuraDescription: "Burning", School: 2, SpellLevel: 30, BaseLevel: 24, MaxLevel: 36,
			ManaCost: 95, ManaCostPercentage: 0, CastingTimeIndex: 1, DurationIndex: 0, RangeIndex: 4,
			PowerType: 0, ProcChance: 100, StackAmount: 0, SpellIconID: 36, SpellFamilyName: 3,
			CustomFlags: 0,
			Effects: []store.ContentSpellEffect{
				{Slot: 1, Effect: 2, BasePoints: 9, DieSides: 3, AuraName: 0, MiscValue: 0, TriggerSpell: 0},
				{Slot: 2, Effect: 6, BasePoints: -1, DieSides: 1, AuraName: 3, MiscValue: 126, TriggerSpell: 12654},
			},
		}}},
		{"db_spell", dbSpellView{PageData: page, Spell: store.ContentSpell{Entry: 9, Name: "Frostbolt"}}},
		{"db_item", dbItemView{
			PageData: page,
			Item:     store.ContentItem{Entry: 80119, Name: "Mechanical Drumstick", Quality: 2},
			Relations: &store.ItemRelations{
				DroppedBy:        []store.ContentDrop{{Entry: 80117, Name: "Haywire Battlechicken", Kind: store.DropCreature, Chance: 12.5, MinCount: 1, MaxCount: 2}},
				FoundIn:          []store.ContentDrop{{Entry: 4001, Name: "Wanted Poster", Kind: store.DropGameObject, Chance: 100}},
				ContainedIn:      []store.ContentDrop{{Entry: 50071, Name: "Sturdy Lockbox", Kind: store.DropItem, Chance: 3.5}},
				SkinnedFrom:      []store.ContentDrop{{Entry: 80117, Name: "Haywire Battlechicken", Kind: store.DropCreature, Chance: 40}},
				PickpocketedFrom: []store.ContentDrop{{Entry: 80117, Name: "Haywire Battlechicken", Kind: store.DropCreature, Chance: 5}},
				SoldBy:           []store.ContentDrop{{Entry: 80117, Name: "Haywire Battlechicken", Kind: store.DropCreature}},
				RequiredBy:       []store.ContentQuestRef{{Entry: 80104, Title: "The Other White Mech", Count: 5}},
				RewardedBy: []store.ContentQuestRef{
					{Entry: 80104, Title: "The Other White Mech", Count: 1},
					{Entry: 5, Title: "A Quest", Count: 1, Choice: true},
				},
				Truncated: []string{"db.droppedBy", "db.soldBy"},
			},
		}},
		{"db_quests", dbQuestsView{
			PageData: page, Search: "mech", Total: 1, Page: 1, Pages: 1,
			FilterMin: &minLevel, FilterMax: &maxLevel,
			Quests: []store.ContentQuest{
				{Entry: 80104, Title: "The Other White Mech", QuestLevel: 30, MinLevel: 28},
				{Entry: 5, Title: "A Quest"},
			}}},
		{"db_quests", dbQuestsView{PageData: page, Total: 0, Page: 1, Pages: 1}},
		{"db_quest", dbQuestView{
			PageData: page, HasDetails: true, HasObjectives: true, HasReward: true, HasEnd: true,
			ObjectiveText: []string{"Collect five drumsticks", "Return to the chicken"},
			Quest: store.ContentQuest{
				Entry: 80104, Title: "The Other White Mech", QuestLevel: 30, MinLevel: 28,
				MaxLevel: 0, Type: 0, ZoneOrSort: 0, SuggestedPlayers: 0,
				QuestFlags: 0, SpecialFlags: 0, PrevQuestID: 80099, NextQuestID: 0,
				PointMapID: 1, PointX: 10.5, PointY: -20.25,
				Details: "Text", Objectives: "Text", OfferRewardText: "Text", EndText: "Text",
				RewXP: 2500, RewOrReqMoney: 1200,
				RequiredItems: []store.ContentItemCount{{Entry: 80119, Count: 5, Name: "Mechanical Drumstick"}},
				RequiredMobs: []store.ContentCreatureCount{
					{Entry: 80117, Count: 5},
					{Entry: 1234, IsGameObject: true, Count: 1},
				},
				RewardItems: []store.ContentItemCount{{Entry: 80119, Count: 1, Name: "Mechanical Drumstick"}},
				ChoiceItems: []store.ContentItemCount{{Entry: 50071, Count: 1}, {Entry: 50072, Count: 1, Name: "Other"}},
			},
			Relations: &store.QuestRelations{
				Starts: []store.ContentSourceRef{
					{Entry: 80117, Name: "Haywire Battlechicken", Kind: store.DropCreature},
					{Entry: 4001, Name: "Wanted Poster", Kind: store.DropGameObject},
				},
				Ends: []store.ContentSourceRef{{Entry: 80117, Name: "Haywire Battlechicken", Kind: store.DropCreature}},
			}}},
		// The same page with nothing filled in at all.
		{"db_quest", dbQuestView{PageData: page, Quest: store.ContentQuest{Entry: 5, Title: "A Quest"}}},
		{"db_npcs", dbCreaturesView{
			PageData: page, Search: "chicken", Total: 2, Page: 3, Pages: 5,
			QueryString: "type=7&", FilterType: &ctype, FilterMin: &minLevel, FilterMax: &maxLevel,
			Creatures: []store.ContentCreature{
				{Entry: 80117, Name: "Haywire Battlechicken", SubName: "", LevelMin: 2, LevelMax: 2,
					Rank: 0, Type: 7, Faction: 35, LootID: 80117, Scale: 1},
				{Entry: 2, Name: "Spawn Point", LevelMin: 60, LevelMax: 60, Type: 7},
			}}},
		{"db_npcs", dbCreaturesView{PageData: page, Total: 0, Page: 1, Pages: 1}},
		{"db_npc", dbCreatureView{PageData: page, Creature: store.ContentCreature{
			Entry: 80117, Name: "Haywire Battlechicken", SubName: "Elite Chicken",
			LevelMin: 2, LevelMax: 3, Rank: 1, Type: 9, Faction: 35, NPCFlags: 0x81,
			LootID: 80117, GossipMenuID: 12, VendorID: 80117, TrainerType: 0,
			Scale: 1.25, GoldMin: 0, GoldMax: 25, Civilian: 1, RacialLeader: 0,
			DynamicFlags: 0, AIName: "EventAI", ScriptName: "npc_haywire",
		}, Relations: &store.CreatureRelations{
			StartsQuests: []store.ContentQuestRef{{Entry: 80104, Title: "The Other White Mech"}},
			EndsQuests:   []store.ContentQuestRef{{Entry: 5, Title: "A Quest"}},
			Drops: []store.ContentLootItem{
				{Entry: 80119, Name: "Mechanical Drumstick", Chance: 12.5, MinCount: 1, MaxCount: 2},
				{Entry: 50071, Name: "Sturdy Lockbox", Chance: 0.5, MinCount: 1, MaxCount: 1, Via: 30016, QuestOnly: true},
			},
			Skins:       []store.ContentLootItem{{Entry: 2318, Name: "Light Leather", Chance: 100, MinCount: 1, MaxCount: 1}},
			Pickpockets: []store.ContentLootItem{{Entry: 117, Name: "Tough Jerky", Chance: 25, MinCount: 1, MaxCount: 1}},
			Sells:       []store.ContentLootItem{{Entry: 117, Name: "Tough Jerky", Chance: 100}, {Entry: 4540, Name: "Tough Hunk of Bread", Chance: 100}},
			Truncated:   []string{"db.sells"},
		},
		}},
		{"db_npc", dbCreatureView{PageData: page, Creature: store.ContentCreature{
			Entry: 2, Name: "Spawn Point", LevelMin: 60, LevelMax: 60, Type: 7, Scale: 1,
		}}},
		{"error", page},
	}

	for _, tc := range cases {
		tmpl, ok := rend.cache[tc.page]
		if !ok {
			t.Errorf("template %q is not in the cache", tc.page)
			continue
		}
		var buf bytes.Buffer
		if err := tmpl.ExecuteTemplate(&buf, "layout", tc.data); err != nil {
			t.Errorf("render %s: %v", tc.page, err)
			continue
		}
		if buf.Len() == 0 {
			t.Errorf("render %s produced no output", tc.page)
		}
		if !strings.Contains(buf.String(), "<!DOCTYPE html>") {
			t.Errorf("render %s did not use the layout", tc.page)
		}
	}
}

// TestTemplatesEscapeUserData makes sure html/template is actually used, so a
// character name can never inject markup.
// bundle2render renders a page through the cached template set.
func bundle2render(t *testing.T, buf *bytes.Buffer, page string, data any) error {
	t.Helper()
	rend, err := newRenderer()
	if err != nil {
		return err
	}
	tmpl, ok := rend.cache[page]
	if !ok {
		return fmt.Errorf("template %q is not cached", page)
	}
	return tmpl.ExecuteTemplate(buf, "layout", data)
}

func TestTemplatesEscapeUserData(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	evil := `<script>alert(1)</script>`
	page := PageData{Title: "x", Config: PageConfig{SiteName: "s"}}
	view := adminCharactersView{
		PageData: page, Page: 1, Pages: 1,
		Characters: []store.Character{{GUID: 1, Name: evil, AccountName: evil}},
	}

	var buf bytes.Buffer
	if err := rend.cache["admin_characters"].ExecuteTemplate(&buf, "layout", view); err != nil {
		t.Fatal(err)
	}
	if strings.Contains(buf.String(), evil) {
		t.Error("character name was not escaped")
	}
	if !strings.Contains(buf.String(), "&lt;script&gt;") {
		t.Error("expected escaped output")
	}
}

// TestEveryTemplateHasContent guards against a page template that forgets the
// "content" block, which would render an empty page.
func TestEveryTemplateHasContent(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	for name := range rend.cache {
		if rend.cache[name].Lookup("content") == nil {
			t.Errorf("template %q does not define the content block", name)
		}
	}
}

// ptrTime is a small helper for building fixtures with nullable timestamps.
func ptrTime(t time.Time) *time.Time { return &t }

// TestTemplatesRenderInEveryLanguage walks the whole fixture set once per
// language, so a translation cannot break a page.
func TestTemplatesRenderInEveryLanguage(t *testing.T) {
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatal(err)
	}

	account := &store.Account{ID: 7, Username: "TESTER", Rank: 4}
	char := store.Character{GUID: 42, Name: "Thrall", Race: 2, Class: 1, Level: 60}
	now := time.Now()

	for _, meta := range i18n.Supported {
		for _, tc := range []struct {
			page string
			data any
		}{
			{"home", homeView{Stats: store.ServerStats{Accounts: 1, OnlineAccs: 2, Guilds: 1},
				Realms: []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1, Flags: store.RealmFlagRecommended}}}},
			{"login", loginView{}},
			{"register", registerView{}},
			{"panel", panelView{Characters: []store.Character{char}, TwoFAOn: true, Muted: true, MuteUntil: now}},
			{"panel_characters", panelView{Characters: []store.Character{char}}},
			{"panel_password", passwordView{}},
			{"panel_security", securityView{Pending: true, Secret: "ABC", OTPAuthURI: "otpauth://x"}},
			{"panel_sessions", sessionsView{}},
			{"admin_dashboard", adminDashboardView{
				Stats:  store.ServerStats{Accounts: 1, OnlineChars: 1},
				Recent: []store.Account{*account}, Online: []store.Character{char},
				Realms: []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1}},
			}},
			{"admin_accounts", adminAccountsView{Accounts: []store.Account{*account}, Total: 1, Page: 1, Pages: 1,
				Bans: map[uint32]*store.Ban{7: {Reason: "x"}}}},
			{"admin_account_new", adminAccountNewView{}},
			{"admin_account_detail", adminAccountView{Account: account,
				Characters: []store.Character{char}, RankChoices: []uint8{0, 4}}},
			{"admin_characters", adminCharactersView{Characters: []store.Character{char}, Total: 1, Page: 1, Pages: 1}},
			{"admin_character_detail", adminCharacterView{Character: char, Flags: []string{"rename"}}},
			{"admin_bans", adminBansView{Bans: []store.Ban{{AccountID: 7, Reason: "r", Permanent: true}},
				IPBans: []store.IPBan{{IP: "1.2.3.4"}}, Page: 1, Pages: 1}},
			{"admin_realms", adminRealmsView{Realms: []store.Realm{{ID: 1, Name: "R", Address: "a", Port: 1,
				AllowedSecurityLevel: 2, Flags: store.RealmFlagRecommended}}}},
			{"admin_announcement", adminAnnouncementView{
				Announcement: store.Announcement{Enabled: true, Title: "Notice",
					Body: "line one\n\nline two", UpdatedAt: now, UpdatedBy: "ADMIN"},
				Endpoint: "https://example.com/alert", HasBody: true}},
			{"admin_audit", adminAuditView{Entries: []store.AuditEntry{{Actor: "A", Action: "x"}}}},
			{"error", PageData{Title: "T"}},
		} {
			pd := PageData{Year: 2026, Tr: bundle.Translator(meta.Code), Langs: i18n.Supported,
				Config: PageConfig{SiteName: "S", PasswordMinLen: 6, SessionTTLHours: 1,
					DefaultLang: string(meta.Code)},
				Account: account}
			// Inject the page data into the view struct through reflection-free
			// means: every view embeds PageData as its first field, so set it by
			// rebuilding the struct is not possible generically. Instead the
			// fixtures above start zero and we fill the embedded field via the
			// typed switch below.
			data := withPageData(tc.data, pd)
			if data == nil {
				t.Fatalf("%s: unhandled view type", tc.page)
			}

			var buf bytes.Buffer
			if err := bundle2render(t, &buf, tc.page, data); err != nil {
				t.Errorf("%s [%s]: %v", tc.page, meta.Code, err)
			}
		}
	}
}

// withPageData copies pd into the PageData embedded in a view struct.
func withPageData(view any, pd PageData) any {
	switch v := view.(type) {
	case homeView:
		v.PageData = pd
		return v
	case loginView:
		v.PageData = pd
		return v
	case registerView:
		v.PageData = pd
		return v
	case panelView:
		v.PageData = pd
		return v
	case passwordView:
		v.PageData = pd
		return v
	case securityView:
		v.PageData = pd
		return v
	case sessionsView:
		v.PageData = pd
		return v
	case adminDashboardView:
		v.PageData = pd
		return v
	case adminAccountsView:
		v.PageData = pd
		return v
	case adminAccountNewView:
		v.PageData = pd
		return v
	case adminAccountView:
		v.PageData = pd
		return v
	case adminCharactersView:
		v.PageData = pd
		return v
	case adminCharacterView:
		v.PageData = pd
		return v
	case adminBansView:
		v.PageData = pd
		return v
	case adminRealmsView:
		v.PageData = pd
		return v
	case adminAuditView:
		v.PageData = pd
		return v
	case adminAnnouncementView:
		v.PageData = pd
		return v
	case PageData:
		return pd
	default:
		return nil
	}
}
