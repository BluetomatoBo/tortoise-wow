package i18n

import "testing"

// TestCataloguesLoadAndMatch is the guard rail for the whole translation:
// Load() rejects a language that is missing keys present in English, so this
// fails the build (well, the test run) instead of shipping a half-translated
// page.
func TestCataloguesLoadAndMatch(t *testing.T) {
	b, err := Load()
	if err != nil {
		t.Fatalf("Load: %v", err)
	}

	enCount := b.Count(EN)
	if enCount == 0 {
		t.Fatal("the English catalogue is empty")
	}
	t.Logf("en: %d keys, zh: %d keys", enCount, b.Count(ZH))

	for _, meta := range Supported {
		if got := b.Count(meta.Code); got != enCount {
			t.Errorf("%s has %d keys, want %d (the same as English)", meta.Code, got, enCount)
		}
		for _, key := range b.Keys(EN) {
			if !b.Has(meta.Code, key) {
				t.Errorf("%s is missing key %q", meta.Code, key)
			}
		}
	}
}

// TestNoEmptyTranslations catches a key that exists but was left blank.
func TestNoEmptyTranslations(t *testing.T) {
	b, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	for _, meta := range Supported {
		for _, key := range b.Keys(meta.Code) {
			if b.langs[meta.Code][key] == "" {
				t.Errorf("%s: key %q is empty", meta.Code, key)
			}
		}
	}
}

// TestOrphanKeys catches a translation for a key that English does not have,
// which usually means a typo in the key name.
func TestOrphanKeys(t *testing.T) {
	b, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	for _, meta := range Supported {
		if meta.Code == EN {
			continue
		}
		for _, key := range b.Keys(meta.Code) {
			if !b.Has(EN, key) {
				t.Errorf("%s has key %q that English does not define", meta.Code, key)
			}
		}
	}
}

// TestLookupAndFallback covers the resolution order.
func TestLookupAndFallback(t *testing.T) {
	b, err := Load()
	if err != nil {
		t.Fatal(err)
	}

	en := b.Translator(EN)
	zh := b.Translator(ZH)

	if en.T("nav.home") != "Home" {
		t.Errorf("en nav.home = %q", en.T("nav.home"))
	}
	if zh.T("nav.home") != "首页" {
		t.Errorf("zh nav.home = %q", zh.T("nav.home"))
	}
	// The two must actually differ, otherwise the catalogue is not wired up.
	if en.T("nav.home") == zh.T("nav.home") {
		t.Error("English and Chinese resolve to the same text")
	}

	// An unknown language falls back to the default.
	unknown := b.Translator("de")
	if unknown.Lang() != Default {
		t.Errorf("unknown language resolved to %q, want %q", unknown.Lang(), Default)
	}

	// A missing key returns the key itself so the gap is visible.
	if got := en.T("no.such.key"); got != "no.such.key" {
		t.Errorf("missing key = %q, want the key back", got)
	}
	if got := en.T(""); got != "" {
		t.Errorf("empty key = %q, want empty", got)
	}
}

func TestPlural(t *testing.T) {
	b, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	en := b.Translator(EN)
	zh := b.Translator(ZH)

	if got := en.Tn("home.guilds", 1); got != "guild" {
		t.Errorf("en Tn(1) = %q, want guild", got)
	}
	if got := en.Tn("home.guilds", 3); got != "guilds" {
		t.Errorf("en Tn(3) = %q, want guilds", got)
	}
	// Chinese has no plural distinction; both forms are the same.
	if zh.Tn("home.guilds", 1) != zh.Tn("home.guilds", 3) {
		t.Error("Chinese plural forms should be identical")
	}
	// A key without plural variants falls back to the plain lookup.
	if got := en.Tn("nav.home", 5); got != "Home" {
		t.Errorf("Tn on a non-plural key = %q", got)
	}
}

func TestHTMLLang(t *testing.T) {
	b, _ := Load()
	if got := b.Translator(ZH).HTMLLang(); got != "zh-Hans" {
		t.Errorf("zh HTMLLang = %q", got)
	}
	if got := b.Translator(EN).HTMLLang(); got != "en" {
		t.Errorf("en HTMLLang = %q", got)
	}
}

// TestZeroTranslatorIsUsable keeps the helper types safe to use in tests that
// do not build a bundle.
func TestZeroTranslatorIsUsable(t *testing.T) {
	var tr Translator
	if tr.Lang() != Default {
		t.Errorf("zero Lang = %q", tr.Lang())
	}
	if tr.T("nav.home") != "nav.home" {
		t.Errorf("zero T = %q, want the key", tr.T("nav.home"))
	}
}
