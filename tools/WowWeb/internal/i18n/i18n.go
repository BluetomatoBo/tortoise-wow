// Package i18n holds the message catalogue and the lookup used by both the
// templates and the HTTP handlers.
//
// Design notes:
//
//   - Catalogues live in locales/*.json and are embedded in the binary, so
//     adding a language is a data change, not a code change.
//   - A missing key never renders as an empty string: the lookup falls back to
//     English, then to the key itself, so a gap is visible rather than silent.
//   - Translations are resolved per request from the PageData, NOT from a
//     package-level "current language". There is no global mutable state, so
//     concurrent requests in different languages cannot interfere.
package i18n

import (
	"embed"
	"encoding/json"
	"fmt"
	"sort"
	"strings"
)

//go:embed locales/*.json
var localeFS embed.FS

// Lang is a supported language code.
type Lang string

const (
	EN Lang = "en"
	ZH Lang = "zh"
)

// Default is the language used when nothing better can be determined.
const Default = EN

// Meta describes a language for the switcher and the <html lang> attribute.
type Meta struct {
	Code Lang
	// Name is the name in the language itself, so the switcher reads
	// naturally to speakers of that language.
	Name string
	// HTMLLang is the BCP-47 tag for <html lang="...">.
	HTMLLang string
}

// Supported lists the languages in switcher order.
var Supported = []Meta{
	{Code: EN, Name: "English", HTMLLang: "en"},
	{Code: ZH, Name: "中文", HTMLLang: "zh-Hans"},
}

// Bundle holds every loaded catalogue.
type Bundle struct {
	langs  map[Lang]map[string]string
	plural map[Lang]map[string]bool // base keys that have .one/.other forms
}

// Load reads the embedded catalogues.
//
// It fails when a file is malformed or when a language is missing keys present
// in the reference language, so an incomplete translation is caught at startup
// instead of showing up as an untranslated string in production.
func Load() (*Bundle, error) {
	b := &Bundle{
		langs:  map[Lang]map[string]string{},
		plural: map[Lang]map[string]bool{},
	}

	for _, meta := range Supported {
		path := "locales/" + string(meta.Code) + ".json"
		raw, err := localeFS.ReadFile(path)
		if err != nil {
			return nil, fmt.Errorf("read %s: %w", path, err)
		}
		flat := map[string]string{}
		if err := json.Unmarshal(raw, &flat); err != nil {
			return nil, fmt.Errorf("parse %s: %w", path, err)
		}
		b.langs[meta.Code] = flat

		plurals := map[string]bool{}
		for k := range flat {
			if base, ok := strings.CutSuffix(k, ".other"); ok {
				plurals[base] = true
			}
		}
		b.plural[meta.Code] = plurals
	}

	// Every language must cover the reference language's keys.
	ref := EN
	refKeys := make([]string, 0, len(b.langs[ref]))
	for k := range b.langs[ref] {
		refKeys = append(refKeys, k)
	}
	sort.Strings(refKeys)

	var problems []string
	for _, meta := range Supported {
		if meta.Code == ref {
			continue
		}
		for _, k := range refKeys {
			if _, ok := b.langs[meta.Code][k]; !ok {
				problems = append(problems, string(meta.Code)+": "+k)
			}
		}
	}
	if len(problems) > 0 {
		return nil, fmt.Errorf("missing %d translation(s):\n  %s",
			len(problems), strings.Join(problems, "\n  "))
	}

	return b, nil
}

// Translator resolves keys for one language. The zero value is usable and
// behaves like English, which keeps the tests simple.
type Translator struct {
	bundle *Bundle
	lang   Lang
}

// Translator returns a translator for lang, falling back to the default when
// the language is unknown.
func (b *Bundle) Translator(lang Lang) Translator {
	if b == nil {
		return Translator{lang: Default}
	}
	if _, ok := b.langs[lang]; !ok {
		lang = Default
	}
	return Translator{bundle: b, lang: lang}
}

// Lang reports the language actually in use (after the fallback).
func (t Translator) Lang() Lang {
	if t.lang == "" {
		return Default
	}
	return t.lang
}

// HTMLLang returns the BCP-47 tag for the <html> element.
func (t Translator) HTMLLang() string {
	for _, m := range Supported {
		if m.Code == t.Lang() {
			return m.HTMLLang
		}
	}
	return string(t.Lang())
}

// T looks up a key.
//
// Resolution order: the requested language, then English, then the key itself.
// Returning the key means a missing translation shows up as an obvious marker
// in the UI instead of rendering as blank.
func (t Translator) T(key string) string {
	if key == "" {
		return ""
	}
	if t.bundle != nil {
		if v, ok := t.bundle.langs[t.Lang()][key]; ok {
			return v
		}
		if v, ok := t.bundle.langs[EN][key]; ok {
			return v
		}
	}
	return key
}

// Tn looks up a plural form: key.one / key.other, falling back to T(key) when
// the key has no plural variants.
//
// Only English distinguishes singular from plural; languages that do not simply
// define both entries with the same text. The parity check in Load keeps the key
// sets identical, which is simpler than shipping a plural-rules engine.
func (t Translator) Tn(key string, n int) string {
	if t.bundle != nil && t.bundle.plural[t.Lang()][key] {
		if n == 1 {
			if v, ok := t.bundle.langs[t.Lang()][key+".one"]; ok {
				return v
			}
		}
		if v, ok := t.bundle.langs[t.Lang()][key+".other"]; ok {
			return v
		}
	}
	return t.T(key)
}

// Has reports whether a key exists, used by the catalogue tests.
func (b *Bundle) Has(lang Lang, key string) bool {
	if b == nil {
		return false
	}
	_, ok := b.langs[lang][key]
	return ok
}

// Keys returns every key of a language, sorted.
func (b *Bundle) Keys(lang Lang) []string {
	if b == nil {
		return nil
	}
	out := make([]string, 0, len(b.langs[lang]))
	for k := range b.langs[lang] {
		out = append(out, k)
	}
	sort.Strings(out)
	return out
}

// Count returns the number of entries in a language.
func (b *Bundle) Count(lang Lang) int {
	if b == nil {
		return 0
	}
	return len(b.langs[lang])
}
