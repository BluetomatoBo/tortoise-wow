// Package gamepwd replicates the account-name and password handling of the
// Tortoise WoW core so that accounts created here can log into the game, and
// accounts created by the game can log in here.
//
// Reference (core revision 4f4fcaa1):
//
//	AccountMgr::CreateAccount      src/game/AccountMgr.cpp
//	AccountMgr::normalizeString    src/game/AccountMgr.cpp
//	AccountMgr::CalculateShaPassHash src/game/AccountMgr.cpp
//
// The core does:
//
//	if (utf8length(username) > MAX_ACCOUNT_STR) -> "name too long"
//	normalizeString(username);   // uppercases basic Latin only, <= 16 chars
//	normalizeString(password);   // same
//	sha_pass_hash = hex(UPPER) of SHA1(normalizedUsername + ":" + normalizedPassword)
package gamepwd

import (
	"crypto/sha1"
	"encoding/hex"
	"errors"
	"fmt"
	"strings"
	"unicode/utf8"
)

// MaxAccountLength mirrors MAX_ACCOUNT_STR in src/game/AccountMgr.h.
const MaxAccountLength = 16

// Errors returned by Normalize. They map onto the core's AccountOpResult
// values (AOR_NAME_TOO_LONG, AOR_PASS_TOO_LONG, AOR_DB_INTERNAL_ERROR) so the
// HTTP layer can produce a message the player will recognise.
var (
	ErrInvalidUTF8 = errors.New("not a valid UTF-8 string")
	ErrTooLong     = errors.New("longer than 16 characters")
)

// Normalize mirrors AccountMgr::normalizeString().
//
// It fails when the input is not valid UTF-8 or is longer than 16 characters,
// and it uppercases *only* the basic Latin letters a-z. Everything else
// (accented Latin, Cyrillic, CJK, digits, punctuation) is passed through
// unchanged, because wcharToUpperOnlyLatin() only touches isBasicLatinCharacter.
//
// Note that the core also checks the raw length before normalizing; doing the
// length check here gives the same outcome for every input we can receive.
func Normalize(s string) (string, error) {
	if !utf8.ValidString(s) {
		return "", ErrInvalidUTF8
	}

	var b strings.Builder
	b.Grow(len(s))

	count := 0
	for _, r := range s {
		count++
		if count > MaxAccountLength {
			return "", ErrTooLong
		}
		if r >= 'a' && r <= 'z' {
			r -= 'a' - 'A' // wcharToUpperOnlyLatin
		}
		b.WriteRune(r)
	}

	return b.String(), nil
}

// Length returns the number of UTF-8 code points, matching utf8length().
func Length(s string) int {
	return utf8.RuneCountInString(s)
}

// Hash returns the value to store in account.sha_pass_hash.
//
// The core stores uppercase hex (hexEncodeByteArray emits '0'-'9' and 'A'-'F'),
// and MySQL compares the column case-insensitively, but we reproduce the exact
// format so that database dumps stay diff-clean.
func Hash(username, password string) (string, error) {
	u, err := Normalize(username)
	if err != nil {
		return "", fmt.Errorf("username: %w", err)
	}
	p, err := Normalize(password)
	if err != nil {
		return "", fmt.Errorf("password: %w", err)
	}
	return HashNormalized(u, p), nil
}

// HashNormalized hashes values that have already been through Normalize.
func HashNormalized(normalizedUsername, normalizedPassword string) string {
	sum := sha1.Sum([]byte(normalizedUsername + ":" + normalizedPassword))
	return strings.ToUpper(hex.EncodeToString(sum[:]))
}

// Verify reports whether password matches the stored hash for username.
//
// The comparison is constant-time-ish for our purposes (both sides are hashes
// of attacker-controlled input, and the stored value is not a secret that
// leaks through timing here), but use EqualFold because the column collation
// in the database is case-insensitive.
func Verify(username, password, storedHash string) bool {
	if storedHash == "" {
		return false
	}
	h, err := Hash(username, password)
	if err != nil {
		return false
	}
	return strings.EqualFold(h, storedHash)
}
