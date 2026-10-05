package i18n

import (
	"net/http"
	"sort"
	"strconv"
	"strings"
)

// CookieName is the cookie that remembers an explicit language choice. A
// leading "tw_" matches the session cookie.
const CookieName = "tw_lang"

// CookieMaxAge is one year, in seconds.
const CookieMaxAge = 365 * 24 * 60 * 60

// Detect decides which language to use for a request.
//
// Precedence:
//  1. an explicit choice in the language cookie,
//  2. the Accept-Language header,
//  3. the configured default.
func Detect(r *http.Request, configuredDefault Lang) Lang {
	if r == nil {
		return orDefault(configuredDefault)
	}

	if c, err := r.Cookie(CookieName); err == nil {
		if lang, ok := Parse(c.Value); ok {
			return lang
		}
	}

	if lang, ok := FromAcceptLanguage(r.Header.Get("Accept-Language")); ok {
		return lang
	}

	return orDefault(configuredDefault)
}

func orDefault(l Lang) Lang {
	if _, ok := Parse(string(l)); ok {
		return l
	}
	return Default
}

// Parse normalises a language tag to a supported language.
//
// It accepts the forms browsers and users produce: "zh", "zh-CN", "zh-Hans-CN",
// "zh_CN", "en-US", plus case variants.
func Parse(tag string) (Lang, bool) {
	tag = strings.ToLower(strings.TrimSpace(tag))
	if tag == "" {
		return "", false
	}

	// "zh-CN,en;q=0.8" style input: only the first tag matters here.
	if i := strings.IndexAny(tag, ",;"); i >= 0 {
		tag = tag[:i]
	}
	tag = strings.TrimSpace(tag)

	// Normalise the separator so "zh_CN" works too.
	tag = strings.ReplaceAll(tag, "_", "-")

	primary, _, _ := strings.Cut(tag, "-")

	switch primary {
	case "zh":
		// Both Simplified and Traditional Chinese are served by the same
		// catalogue; the site's wording is short enough that this is a
		// reasonable simplification for a game private server.
		return ZH, true
	case "en":
		return EN, true
	}

	// Exact match on a registered code, e.g. if someone adds "de".
	for _, m := range Supported {
		if strings.EqualFold(string(m.Code), tag) {
			return m.Code, true
		}
	}
	return "", false
}

// FromAcceptLanguage parses an Accept-Language header, honouring q-values.
func FromAcceptLanguage(header string) (Lang, bool) {
	if strings.TrimSpace(header) == "" {
		return "", false
	}

	type candidate struct {
		lang Lang
		q    float64
		pos  int
	}

	var candidates []candidate
	for i, part := range strings.Split(header, ",") {
		part = strings.TrimSpace(part)
		if part == "" {
			continue
		}
		tag, params, _ := strings.Cut(part, ";")

		q := 1.0
		for _, p := range strings.Split(params, ";") {
			p = strings.TrimSpace(p)
			if v, ok := strings.CutPrefix(p, "q="); ok {
				if parsed, err := strconv.ParseFloat(strings.TrimSpace(v), 64); err == nil {
					q = parsed
				}
			}
		}
		if q <= 0 {
			continue // q=0 means "not acceptable"
		}

		if lang, ok := Parse(tag); ok {
			candidates = append(candidates, candidate{lang: lang, q: q, pos: i})
		}
	}

	if len(candidates) == 0 {
		return "", false
	}

	// Highest q wins; ties go to the tag that appeared first.
	sort.SliceStable(candidates, func(i, j int) bool {
		if candidates[i].q != candidates[j].q {
			return candidates[i].q > candidates[j].q
		}
		return candidates[i].pos < candidates[j].pos
	})
	return candidates[0].lang, true
}

// SetCookie writes the language choice.
func SetCookie(w http.ResponseWriter, lang Lang, secure bool) {
	http.SetCookie(w, &http.Cookie{
		Name:     CookieName,
		Value:    string(lang),
		Path:     "/",
		HttpOnly: true,
		Secure:   secure,
		SameSite: http.SameSiteLaxMode,
		MaxAge:   CookieMaxAge,
	})
}
