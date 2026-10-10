package web

import (
	"bytes"
	"crypto/sha256"
	"embed"
	"encoding/hex"
	"fmt"
	"html/template"
	"io/fs"
	"net/http"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

//go:embed templates/*.html assets/* assets/icons assets/maps dbcnames.txt mapzones.txt zonefix.txt zonegrid.txt
var templateFS embed.FS

// renderer caches one parsed template set per page.
//
// Each page is parsed together with the shared layout and partials, so a page
// template only has to define the "content" block. Parsing is done once at
// startup rather than per request.
type renderer struct {
	mu    sync.RWMutex
	cache map[string]*template.Template
	funcs template.FuncMap
}

func newRenderer() (*renderer, error) {
	r := &renderer{
		cache: map[string]*template.Template{},
		funcs: templateFuncs(),
	}

	entries, err := fs.Glob(templateFS, "templates/*.html")
	if err != nil {
		return nil, err
	}

	for _, path := range entries {
		name := strings.TrimSuffix(strings.TrimPrefix(path, "templates/"), ".html")
		// layout.html and partials.html are included by every page.
		if name == "layout" || name == "partials" {
			continue
		}
		tmpl, err := r.parse(name)
		if err != nil {
			return nil, fmt.Errorf("parse template %s: %w", name, err)
		}
		r.cache[name] = tmpl
	}
	return r, nil
}

func (r *renderer) parse(page string) (*template.Template, error) {
	return template.New(page).Funcs(r.funcs).ParseFS(templateFS,
		"templates/layout.html",
		"templates/partials.html",
		"templates/"+page+".html",
	)
}

// Render writes a page. A missing template is a programming error and panics in
// development; in production it returns a 500 with a plain message.
func (r *renderer) Render(w http.ResponseWriter, status int, page string, data any) {
	r.mu.RLock()
	tmpl, ok := r.cache[page]
	r.mu.RUnlock()
	if !ok {
		http.Error(w, "template "+page+" not found", http.StatusInternalServerError)
		return
	}

	// Render into a buffer first: a template error halfway through would
	// otherwise emit a truncated page together with a wrong status code.
	var buf bytes.Buffer
	if err := tmpl.ExecuteTemplate(&buf, "layout", data); err != nil {
		http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(status)
	_, _ = buf.WriteTo(w)
}

// RenderFragment writes a page template's content block on its own, without the
// layout around it.
//
// That is what the hover tooltips are: the same markup a page would show, but as
// a piece of HTML a script can drop next to a link. It is a separate method
// rather than a flag on Render so a fragment can never accidentally come out as
// a full page, which would nest <html> inside <div>.
func (r *renderer) RenderFragment(w http.ResponseWriter, page string, data any) {
	r.mu.RLock()
	tmpl, ok := r.cache[page]
	r.mu.RUnlock()
	if !ok {
		http.Error(w, "template "+page+" not found", http.StatusInternalServerError)
		return
	}

	var buf bytes.Buffer
	if err := tmpl.ExecuteTemplate(&buf, "content", data); err != nil {
		http.Error(w, "template error: "+err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_, _ = buf.WriteTo(w)
}

// assetVersion is a short hash of the embedded stylesheet, script and zone maps,
// appended to their URLs as a query string.
//
// Static assets are served with an hour of cache and their names do not change
// between builds, so without this a returning visitor keeps the old style.css
// after a deploy - and a tooltip whose layout changed in that deploy arrives
// looking broken until somebody thinks to hard-reload. The map images are in here
// for the same reason and a sharper one: they are seventeen megabytes of artwork
// at fixed paths, and after the maps were fixed a visitor with a cached corner
// tile would keep seeing exactly the bug that was fixed.
//
// The hash is over the file contents, so a URL changes exactly when a file does.
var assetVersion = func() string {
	names, err := fs.Glob(templateFS, "assets/*")
	if err != nil {
		return "dev"
	}
	maps, err := fs.Glob(templateFS, "assets/maps/*.png")
	if err != nil {
		return "dev"
	}
	names = append(names, maps...)
	sort.Strings(names)
	h := sha256.New()
	for _, name := range names {
		b, err := templateFS.ReadFile(name)
		if err != nil {
			continue
		}
		h.Write(b)
	}
	return hex.EncodeToString(h.Sum(nil))[:8]
}()

func templateFuncs() template.FuncMap {
	return template.FuncMap{
		// asset builds a versioned URL for an embedded static file, so a deploy
		// that changes one reaches the browsers that cached the old one.
		"asset": func(name string) string {
			return "/assets/" + name + "?v=" + assetVersion
		},

		// Presentation-only helpers. Display names (rank, race, class, flags)
		// are methods on PageData instead, because they need the request's
		// language and the FuncMap is shared by every request.
		"playtime": store.FormatPlaytime,
		"coins":    store.CoinsFromCopper,
		"badge": func(b Badge) string {
			if b.Class == "" {
				return "pill"
			}
			return "pill " + b.Class
		},

		// timeFmt renders a nullable time, or a dash when the value is NULL or
		// a zero date (which the core writes in several columns).
		"timeFmt": func(t *time.Time) string {
			if t == nil || t.IsZero() {
				return "-"
			}
			return t.Format("2006-01-02 15:04")
		},
		"timeFmtShort": func(t time.Time) string {
			if t.IsZero() {
				return "-"
			}
			return t.Format("2006-01-02 15:04")
		},
		"unixTime": func(sec int64) string {
			if sec <= 0 {
				return "-"
			}
			return time.Unix(sec, 0).Format("2006-01-02 15:04")
		},

		// questtext turns the client's line-break tokens ($B/$b) into real
		// breaks, so quest prose reads as sentences rather than as
		// "word$B$Bword". See questtext.go for what it deliberately leaves.
		"questtext": questText,

		// dict builds a map from alternating key/value arguments, so a
		// {{template}} call can carry more than the single value html/template
		// allows. It reports a malformed call instead of rendering half a row.
		"dict": func(kv ...any) (map[string]any, error) {
			if len(kv)%2 != 0 {
				return nil, fmt.Errorf("dict: got %d arguments, want key/value pairs", len(kv))
			}
			out := make(map[string]any, len(kv)/2)
			for i := 0; i < len(kv); i += 2 {
				key, ok := kv[i].(string)
				if !ok {
					return nil, fmt.Errorf("dict: key %v is not a string", kv[i])
				}
				out[key] = kv[i+1]
			}
			return out, nil
		},

		// Gameobjects have their own browser now (/db/objects); an entry with
		// no page of its own comes back empty and the template renders it as
		// plain text. The kind is taken as any because a template passes the
		// literal "item" as a string while the store hands over a typed
		// DropKind.
		"dbpath": func(kind any, entry uint32) string {
			switch store.DropKind(fmt.Sprint(kind)) {
			case store.DropCreature:
				return "/db/npcs/" + strconv.FormatUint(uint64(entry), 10)
			case store.DropItem:
				return "/db/items/" + strconv.FormatUint(uint64(entry), 10)
			case store.DropGameObject:
				return "/db/objects/" + strconv.FormatUint(uint64(entry), 10)
			default:
				return ""
			}
		},

		// list renders a []string as a comma separated list, or a dash.
		"list": func(items []string) string {
			if len(items) == 0 {
				return "-"
			}
			return strings.Join(items, ", ")
		},
		// has reports whether a bit is set. The mask may be a uint8
		// (realmlist.realmflags) or a uint32 (characters.at_login).
		"has": func(mask, flag any) bool {
			return toUint64(mask)&toUint64(flag) != 0
		},

		// percent formats the realm load indicator. The world server stores
		// population as (online / PlayerLimit) * 2, so 2.0 is a full realm.
		"percent": func(v float64) string {
			p := v / 2 * 100
			if p > 100 {
				p = 100
			}
			if p < 0 {
				p = 0
			}
			return fmt.Sprintf("%.0f%%", p)
		},

		// Pointer helpers for the filter forms, which carry *bool / *uint8.
		"deref": func(p *uint8) uint8 {
			if p == nil {
				return 0
			}
			return *p
		},
		"isTrue":  func(p *bool) bool { return p != nil && *p },
		"isFalse": func(p *bool) bool { return p != nil && !*p },
		"isSet":   func(p *uint8) bool { return p != nil },
		"isSetB":  func(p *bool) bool { return p != nil },

		"add": func(a, b int) int { return a + b },
		// dbResultPath links one search hit to its detail page.
		"dbResultPath": func(r store.ContentSearchResult) string {
			return dbKindPath(r.Kind) + "/" + itoa(int(r.Entry))
		},
		"sub": func(a, b int) int { return a - b },
		// regionName renders the shop's ShopRegion enum so a template can build
		// the key shop.region.<name>.
		"regionName": store.ShopRegionName,
		"seq": func(n int) []int {
			out := make([]int, 0, n)
			for i := 0; i < n; i++ {
				out = append(out, i)
			}
			return out
		},
	}
}

// toUint64 accepts the small integer types templates pass around.
func toUint64(v any) uint64 {
	switch n := v.(type) {
	case uint8:
		return uint64(n)
	case uint16:
		return uint64(n)
	case uint32:
		return uint64(n)
	case uint64:
		return n
	case int:
		return uint64(n)
	default:
		return 0
	}
}

// PageData is embedded in every template payload.
type PageData struct {
	Title     string
	Active    string // nav highlight
	Flash     []Flash
	CSRFToken string
	Account   *store.Account // nil when not logged in
	IsAdmin   bool
	Config    PageConfig
	Year      int

	// Translation for this request. Templates call .T / .Tn directly, and
	// $ .T inside a range, so no package-level "current language" is needed
	// and concurrent requests in different languages cannot interfere.
	Tr    i18n.Translator
	Langs []i18n.Meta
}

// T translates a key.
func (p PageData) T(key string) string { return p.Tr.T(key) }

// Tn picks the singular or plural form of a key.
func (p PageData) Tn(key string, n int) string { return p.Tr.Tn(key, n) }

// Lang is the language code in use.
func (p PageData) Lang() i18n.Lang { return p.Tr.Lang() }

// RankName renders an account rank.
func (p PageData) RankName(rank uint8) string {
	if rank > 6 {
		return p.T("rank.unknown")
	}
	return p.T("rank." + itoa(int(rank)))
}

// RaceName renders a character race.
func (p PageData) RaceName(race uint8) string {
	key := "race." + itoa(int(race))
	if v := p.Tr.T(key); v != key {
		return v
	}
	return "#" + itoa(int(race))
}

// ClassName renders a character class.
func (p PageData) ClassName(class uint8) string {
	key := "class." + itoa(int(class))
	if v := p.Tr.T(key); v != key {
		return v
	}
	return "#" + itoa(int(class))
}

// GenderName renders a character gender.
func (p PageData) GenderName(gender uint8) string {
	key := "gender." + itoa(int(gender))
	if v := p.Tr.T(key); v != key {
		return v
	}
	return "#" + itoa(int(gender))
}

// AtLoginLabels renders the pending at_login flags
// (enum AtLoginFlags in src/game/Objects/Player.h).
func (p PageData) AtLoginLabels(atLogin uint32) []string {
	var out []string
	if atLogin&store.AtLoginRename != 0 {
		out = append(out, p.T("atlogin.rename"))
	}
	if atLogin&store.AtLoginResetSpells != 0 {
		out = append(out, p.T("atlogin.resetSpells"))
	}
	if atLogin&store.AtLoginResetTalents != 0 {
		out = append(out, p.T("atlogin.resetTalents"))
	}
	if atLogin&store.AtLoginFirst != 0 {
		out = append(out, p.T("atlogin.first"))
	}
	return out
}

// RealmFlagLabels renders the realmflags bitmask (enum RealmFlags).
func (p PageData) RealmFlagLabels(flags uint8) []string {
	var out []string
	for _, f := range []struct {
		bit uint8
		key string
	}{
		{store.RealmFlagInvalid, "rflag.invalid"},
		{store.RealmFlagOffline, "rflag.offline"},
		{store.RealmFlagSpecifyBuild, "rflag.build"},
		{store.RealmFlagNewPlayers, "rflag.newPlayers"},
		{store.RealmFlagRecommended, "rflag.recommended"},
		{store.RealmFlagFull, "rflag.full"},
	} {
		if flags&f.bit != 0 {
			out = append(out, p.T(f.key))
		}
	}
	return out
}

// Badge is a small status pill rendered by the "badge" partial.
type Badge struct {
	Label string
	Class string
}

// RankBadge renders the coloured rank pill.
func (p PageData) RankBadge(rank uint8) Badge {
	class := ""
	switch rank {
	case 1, 2, 3:
		class = "pill-staff"
	case 4, 5:
		class = "pill-staff pill-strong"
	}
	return Badge{Label: p.RankName(rank), Class: class}
}

// AccountState renders the online/offline/disabled pill.
func (p PageData) AccountState(acct store.Account) Badge {
	switch {
	case !acct.Active:
		return Badge{Label: p.T("common.disabled"), Class: "pill-danger"}
	case acct.Online:
		return Badge{Label: p.T("acct.online"), Class: "pill-ok"}
	default:
		return Badge{Label: p.T("acct.offline")}
	}
}

// CharacterState renders the online pill for a character.
func (p PageData) CharacterState(online bool) Badge {
	if online {
		return Badge{Label: p.T("chars.online"), Class: "pill-ok"}
	}
	return Badge{}
}

// FlagState renders the queue/clear word used by the at_login action.
func (p PageData) FlagState(on bool) string {
	if on {
		return p.T("msg.flagSet")
	}
	return p.T("msg.flagCleared")
}

// QueueState renders the queue/clear word used by the at_login action.
func (p PageData) QueueState(on bool) string {
	if on {
		return p.T("msg.stateQueued")
	}
	return p.T("msg.stateCleared")
}

// RealmFlagOptionView pairs a realm flag bit with its translated name and help.
type RealmFlagOptionView struct {
	Bit  uint8
	Name string
	Help string
}

// RealmFlagOptions returns the flags an administrator may toggle.
//
// OFFLINE is deliberately excluded: mangosd owns that bit, and writing it by
// hand makes the realm look down until the next world server start.
func (p PageData) RealmFlagOptions() []RealmFlagOptionView {
	keys := []struct {
		bit  uint8
		base string
	}{
		{store.RealmFlagInvalid, "rflag.opt.invalid"},
		{store.RealmFlagSpecifyBuild, "rflag.opt.build"},
		{store.RealmFlagNewPlayers, "rflag.opt.newPlayers"},
		{store.RealmFlagRecommended, "rflag.opt.recommended"},
	}
	out := make([]RealmFlagOptionView, 0, len(keys))
	for _, k := range keys {
		out = append(out, RealmFlagOptionView{
			Bit:  k.bit,
			Name: p.T(k.base + ".name"),
			Help: p.T(k.base + ".help"),
		})
	}
	return out
}

type PageConfig struct {
	SiteName        string
	RealmName       string
	RealmID         int
	WorldAddress    string
	WorldPort       int
	RealmPort       int
	AllowRegister   bool
	RequireEmail    bool
	DefaultLang     string
	AdminMinRank    int
	SessionTTLHours int
	PasswordMinLen  int
}

// Flash is a one-shot message shown after a redirect.
type Flash struct {
	Kind    string // "ok" | "error" | "info"
	Message string
}

func (p *PageData) addFlash(kind, msg string) {
	if msg == "" {
		return
	}
	p.Flash = append(p.Flash, Flash{Kind: kind, Message: msg})
}
