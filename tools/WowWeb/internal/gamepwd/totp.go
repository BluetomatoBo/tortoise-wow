package gamepwd

import (
	"crypto/hmac"
	"crypto/rand"
	"crypto/sha1"
	"crypto/subtle"
	"encoding/base32"
	"encoding/binary"
	"fmt"
	"net/url"
	"strconv"
	"strings"
	"time"
)

// The core's two-factor authentication (src/realmd/AuthSocket.cpp,
// GenerateToken/ValidateToken/VerifyPinData) is plain RFC 6238 TOTP:
//
//   - HMAC-SHA1
//   - 30 second time step
//   - 6 digits
//   - Base32 secret, stored verbatim in account.security
//
// ValidateToken() accepts the previous, current and next step, so any standard
// authenticator app producing the same secret generates accepted codes.
const (
	totpStep   = 30 * time.Second
	totpDigits = 6
)

// b32 is unpadded upper-case Base32, the shape the core writes into
// account.security and the shape authenticator apps expect.
var b32 = base32.StdEncoding.WithPadding(base32.NoPadding)

// GenerateTOTPSecret returns a fresh random Base32 secret.
//
// 20 bytes (160 bits) is the RFC 4226 recommendation for HMAC-SHA1 and encodes
// to 32 Base32 characters, which fits comfortably in account.security
// (varchar(255)).
func GenerateTOTPSecret() (string, error) {
	buf := make([]byte, 20)
	if _, err := rand.Read(buf); err != nil {
		return "", fmt.Errorf("generate secret: %w", err)
	}
	return b32.EncodeToString(buf), nil
}

// TOTPCode returns the 6 digit code for the given secret and time.
//
// The result is an int, not a zero-padded string, because the core computes
// `truncHash % 1000000` as a uint32 and therefore accepts "12345" and "012345"
// as the same code.
func TOTPCode(secret string, t time.Time) (int, error) {
	key, err := decodeSecret(secret)
	if err != nil {
		return 0, err
	}

	var counter [8]byte
	binary.BigEndian.PutUint64(counter[:], uint64(t.Unix()/int64(totpStep/time.Second)))

	mac := hmac.New(sha1.New, key)
	mac.Write(counter[:])
	sum := mac.Sum(nil)

	offset := sum[len(sum)-1] & 0x0F
	truncated := binary.BigEndian.Uint32(sum[offset:offset+4]) & 0x7FFFFFFF

	return int(truncated % 1_000_000), nil
}

// VerifyTOTP reports whether code is valid for secret, allowing one step of
// drift in either direction - the same window ValidateToken() uses.
func VerifyTOTP(secret, code string, now time.Time) bool {
	code = strings.TrimSpace(code)
	if code == "" {
		return false
	}
	// Leading zeros are not significant in the core's representation.
	want, err := strconv.Atoi(strings.TrimLeft(code, "0"))
	if err != nil {
		// A code of all zeros trims to "" and fails Atoi; treat it as 0.
		if strings.Trim(code, "0") == "" {
			want = 0
		} else {
			return false
		}
	}

	for _, delta := range []time.Duration{-totpStep, 0, totpStep} {
		got, err := TOTPCode(secret, now.Add(delta))
		if err != nil {
			return false
		}
		if subtle.ConstantTimeCompare([]byte(strconv.Itoa(got)), []byte(strconv.Itoa(want))) == 1 {
			return true
		}
	}
	return false
}

// ValidateTOTPSecret reports whether s is a usable Base32 secret. It is used
// before writing to account.security so a typo cannot lock an account out.
func ValidateTOTPSecret(s string) error {
	if s == "" {
		return fmt.Errorf("secret is empty")
	}
	key, err := decodeSecret(s)
	if err != nil {
		return err
	}
	if len(key) < 10 {
		return fmt.Errorf("secret is too short (%d bytes, need at least 10)", len(key))
	}
	return nil
}

func decodeSecret(secret string) ([]byte, error) {
	// Authenticator apps and the core both store upper-case without padding,
	// but be forgiving about case and whitespace on input.
	normalized := strings.ToUpper(strings.ReplaceAll(strings.TrimSpace(secret), " ", ""))
	normalized = strings.TrimRight(normalized, "=")
	key, err := b32.DecodeString(normalized)
	if err != nil {
		return nil, fmt.Errorf("secret is not valid Base32 (A-Z and 2-7): %w", err)
	}
	return key, nil
}

// TOTPProvisioningURI builds an otpauth:// URI for QR codes and manual entry.
func TOTPProvisioningURI(issuer, account, secret string) string {
	label := url.PathEscape(issuer + ":" + account)
	q := url.Values{}
	q.Set("secret", secret)
	q.Set("issuer", issuer)
	q.Set("algorithm", "SHA1")
	q.Set("digits", strconv.Itoa(totpDigits))
	q.Set("period", strconv.Itoa(int(totpStep/time.Second)))
	return "otpauth://totp/" + label + "?" + q.Encode()
}
