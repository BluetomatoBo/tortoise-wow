package store

import (
	"context"
	"database/sql"
	"errors"
)

// Realm mirrors one row of tw_logon.realmlist.
//
// The field meanings and the flags are documented in the table's COMMENT and
// in AuthSocket.cpp / RealmList.cpp:
//
//	id                     must match RealmID in mangosd.conf
//	name                   shown in the client's realm list (UNIQUE)
//	address/port           where the client connects: the world server, not realmd
//	icon                   realm type, overwritten by mangosd from GameType
//	realmflags             bitmask; 0x1 hidden, 0x2 offline, 0x4 show build,
//	                       0x20 new players, 0x40 recommended
//	timezone               realm category, overwritten by mangosd from RealmZone
//	allowedSecurityLevel   minimum account.rank allowed to enter
//	population             load indicator, written by the world server
//	realmbuilds            client builds, written by mangosd and never read
type Realm struct {
	ID                   uint32
	Name                 string
	Address              string
	Port                 int
	Icon                 uint8
	Flags                uint8
	Timezone             uint8
	AllowedSecurityLevel uint8
	Population           float64
	RealmBuilds          string
}

// RealmFlags bits, from enum RealmFlags in src/shared/Common.h.
const (
	RealmFlagInvalid      = 0x01 // hidden from the realm list
	RealmFlagOffline      = 0x02 // set/cleared by mangosd, do not set manually
	RealmFlagSpecifyBuild = 0x04 // append "(major,minor,bugfix)" to the name
	RealmFlagUnknown1     = 0x08
	RealmFlagUnknown2     = 0x10
	RealmFlagNewPlayers   = 0x20
	RealmFlagRecommended  = 0x40
	RealmFlagFull         = 0x80
)

// RealmFlagNames describes the flags the panel lets an administrator toggle.
// OFFLINE is intentionally absent: mangosd manages it, and writing it by hand
// makes the realm look down until the next world server start.
var RealmFlagNames = []struct {
	Bit  uint8
	Name string
	Help string
}{
	{RealmFlagInvalid, "Invalid", "Hide this realm from the client's realm list entirely."},
	{RealmFlagSpecifyBuild, "Show build", "Append the client build to the realm name."},
	{RealmFlagNewPlayers, "New players", "Mark the realm as recommended for new players."},
	{RealmFlagRecommended, "Recommended", "Mark the realm as recommended."},
}

func (s *Store) Realms(ctx context.Context) ([]Realm, error) {
	rows, err := s.Logon.QueryContext(ctx,
		`SELECT id, name, address, port, icon, realmflags, timezone,
		        allowedSecurityLevel, population, realmbuilds
		 FROM realmlist ORDER BY id`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []Realm
	for rows.Next() {
		var r Realm
		if err := rows.Scan(&r.ID, &r.Name, &r.Address, &r.Port, &r.Icon,
			&r.Flags, &r.Timezone, &r.AllowedSecurityLevel, &r.Population,
			&r.RealmBuilds); err != nil {
			return nil, err
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

func (s *Store) RealmByID(ctx context.Context, id uint32) (*Realm, error) {
	var r Realm
	err := s.Logon.QueryRowContext(ctx,
		`SELECT id, name, address, port, icon, realmflags, timezone,
		        allowedSecurityLevel, population, realmbuilds
		 FROM realmlist WHERE id = ?`, id).
		Scan(&r.ID, &r.Name, &r.Address, &r.Port, &r.Icon, &r.Flags,
			&r.Timezone, &r.AllowedSecurityLevel, &r.Population, &r.RealmBuilds)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, ErrNotFound
	}
	if err != nil {
		return nil, err
	}
	return &r, nil
}

// UpdateRealmNameAndAddress changes the fields the client uses to connect.
//
// icon and timezone are deliberately not editable: mangosd overwrites both on
// every start from GameType/RealmZone in mangosd.conf, so editing them here
// would silently revert.
func (s *Store) UpdateRealmNameAndAddress(ctx context.Context, id uint32, name, address string, port int) error {
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE realmlist SET name = ?, address = ?, port = ? WHERE id = ?`,
		truncate(name, 32), truncate(address, 32), port, id)
	if err != nil {
		if isDuplicate(err) {
			return ErrDuplicate
		}
		return err
	}
	return requireAffected(res)
}

// UpdateRealmFlags sets the realmflags bitmask, preserving the OFFLINE bit
// because that one belongs to mangosd.
func (s *Store) UpdateRealmFlags(ctx context.Context, id uint32, flags uint8) error {
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE realmlist SET realmflags = (realmflags & ?) | ? WHERE id = ?`,
		RealmFlagOffline, flags, id)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// SetRealmAllowedSecurityLevel controls who may enter the realm: accounts whose
// rank is below this value see it as locked (AuthSocket.cpp).
func (s *Store) SetRealmAllowedSecurityLevel(ctx context.Context, id uint32, level uint8) error {
	res, err := s.Logon.ExecContext(ctx,
		`UPDATE realmlist SET allowedSecurityLevel = ? WHERE id = ?`, level, id)
	if err != nil {
		return err
	}
	return requireAffected(res)
}

// RealmCharacterCounts returns realmcharacters rows, the per-realm counters the
// client shows next to each character list entry.
func (s *Store) RealmCharacterCounts(ctx context.Context, accountID uint32) (map[uint32]int, error) {
	rows, err := s.Logon.QueryContext(ctx,
		`SELECT realmid, numchars FROM realmcharacters WHERE acctid = ?`, accountID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	out := map[uint32]int{}
	for rows.Next() {
		var (
			realmID uint32
			n       int
		)
		if err := rows.Scan(&realmID, &n); err != nil {
			return nil, err
		}
		out[realmID] = n
	}
	return out, rows.Err()
}

// RealmPopulation returns the load figure the client displays for a realm.
func (s *Store) RealmPopulation(ctx context.Context, realmID uint32) (float64, error) {
	var pop float64
	err := s.Logon.QueryRowContext(ctx,
		`SELECT population FROM realmlist WHERE id = ?`, realmID).Scan(&pop)
	return pop, err
}

// RealmFlagLabels renders a flag mask for display.
func RealmFlagLabels(flags uint8) []string {
	var out []string
	if flags&RealmFlagInvalid != 0 {
		out = append(out, "invalid/hidden")
	}
	if flags&RealmFlagOffline != 0 {
		out = append(out, "offline")
	}
	if flags&RealmFlagSpecifyBuild != 0 {
		out = append(out, "show build")
	}
	if flags&RealmFlagNewPlayers != 0 {
		out = append(out, "new players")
	}
	if flags&RealmFlagRecommended != 0 {
		out = append(out, "recommended")
	}
	if flags&RealmFlagFull != 0 {
		out = append(out, "full")
	}
	return out
}
