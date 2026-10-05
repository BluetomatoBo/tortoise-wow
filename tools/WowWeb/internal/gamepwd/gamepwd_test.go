package gamepwd

import (
	"strconv"
	"strings"
	"testing"
	"time"
)

// The expected hashes below were produced independently with Python's hashlib
// using the core's rule: SHA1(UPPER_BASIC_LATIN(name) + ":" + UPPER_BASIC_LATIN(pass)),
// uppercase hex.
func TestHashMatchesCore(t *testing.T) {
	cases := []struct {
		username, password, want string
	}{
		{"test", "test", "3D0D99423E31FCC67A6745EC89D70D700344BC76"},
		{"Test", "PaSs", "DC2C258BC94F8A0D20626E5111260F11BB260CB4"},
		// Accented Latin and CJK are NOT uppercased - only a-z is.
		{"ÁÉÍ", "x", "503938BD745AE9101D8CBFD2D18B433B40DE9428"},
		{"玩家", "päss", "C35A6B8EB78F393D6F7BBB142FD3DB3591C2DE87"},
	}

	for _, tc := range cases {
		got, err := Hash(tc.username, tc.password)
		if err != nil {
			t.Fatalf("Hash(%q, %q): unexpected error: %v", tc.username, tc.password, err)
		}
		if got != tc.want {
			t.Errorf("Hash(%q, %q) = %s, want %s", tc.username, tc.password, got, tc.want)
		}
		if !Verify(tc.username, tc.password, tc.want) {
			t.Errorf("Verify(%q, %q) rejected the core's hash", tc.username, tc.password)
		}
		// The column collation is case-insensitive, so a lower-case hash must
		// verify too (e.g. rows written by other tools).
		if !Verify(tc.username, tc.password, strings.ToLower(tc.want)) {
			t.Errorf("Verify(%q, %q) rejected a lower-case hash", tc.username, tc.password)
		}
	}
}

func TestHashIsCaseInsensitiveForBasicLatin(t *testing.T) {
	upper, err := Hash("MiXeD", "PaSsWoRd")
	if err != nil {
		t.Fatal(err)
	}
	lower, err := Hash("mixed", "password")
	if err != nil {
		t.Fatal(err)
	}
	if upper != lower {
		t.Errorf("basic Latin case must not matter: %s != %s", upper, lower)
	}
}

func TestVerifyRejectsWrongPassword(t *testing.T) {
	h, err := Hash("player", "correct")
	if err != nil {
		t.Fatal(err)
	}
	if Verify("player", "wrong", h) {
		t.Error("Verify accepted an incorrect password")
	}
	if Verify("someoneelse", "correct", h) {
		t.Error("Verify accepted a different username")
	}
	if Verify("player", "correct", "") {
		t.Error("Verify accepted an empty stored hash")
	}
}

func TestNormalizeLimits(t *testing.T) {
	if _, err := Normalize("1234567890123456"); err != nil { // exactly 16
		t.Errorf("16 characters must be accepted, got %v", err)
	}
	if _, err := Normalize("12345678901234567"); err != ErrTooLong { // 17
		t.Errorf("17 characters must be rejected, got %v", err)
	}
	// The limit counts code points, not bytes: 16 CJK characters are 48 bytes
	// but still valid.
	if _, err := Normalize("玩家玩家玩家玩家玩家玩家玩家玩家"); err != nil {
		t.Errorf("16 CJK characters must be accepted, got %v", err)
	}
	if _, err := Normalize("玩家玩家玩家玩家玩家玩家玩家玩家玩"); err != ErrTooLong {
		t.Errorf("17 CJK characters must be rejected, got %v", err)
	}
	if _, err := Normalize("\xff\xfe"); err != ErrInvalidUTF8 {
		t.Errorf("invalid UTF-8 must be rejected, got %v", err)
	}
}

// RFC 6238 appendix B, truncated to the 6 digits the core uses.
func TestTOTPMatchesRFC6238(t *testing.T) {
	const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ" // base32("12345678901234567890")
	cases := []struct {
		unix int64
		want int
	}{
		{59, 287082},
		{1111111109, 81804},
		{1111111111, 50471},
		{1234567890, 5924},
		{2000000000, 279037},
		{20000000000, 353130},
	}

	for _, tc := range cases {
		got, err := TOTPCode(secret, time.Unix(tc.unix, 0).UTC())
		if err != nil {
			t.Fatalf("TOTPCode(%d): %v", tc.unix, err)
		}
		if got != tc.want {
			t.Errorf("TOTPCode(%d) = %d, want %d", tc.unix, got, tc.want)
		}
	}
}

func TestVerifyTOTPWindowAndLeadingZeros(t *testing.T) {
	const secret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
	// 1234567890 -> 005924; the core stores this as the integer 5924, so both
	// "5924" and "005924" must be accepted.
	now := time.Unix(1234567890, 0).UTC()

	if !VerifyTOTP(secret, "5924", now) {
		t.Error("must accept the un-padded code")
	}
	if !VerifyTOTP(secret, "005924", now) {
		t.Error("must accept the zero-padded code, as the core does")
	}
	if VerifyTOTP(secret, "000000", now) {
		t.Error("must reject a wrong code")
	}

	// One step of drift in either direction is accepted: the core's
	// ValidateToken() checks GenerateToken(secret, now-30), now and now+30.
	code := func(offset time.Duration) string {
		c, err := TOTPCode(secret, now.Add(offset))
		if err != nil {
			t.Fatalf("TOTPCode(%v): %v", offset, err)
		}
		return strconv.Itoa(c)
	}

	if !VerifyTOTP(secret, code(-totpStep), now) {
		t.Error("must accept the code from the previous step")
	}
	if !VerifyTOTP(secret, code(totpStep), now) {
		t.Error("must accept the code from the next step")
	}
	if VerifyTOTP(secret, code(3*totpStep), now) {
		t.Error("must reject codes beyond one step of drift")
	}
}

func TestSecretRoundTrip(t *testing.T) {
	secret, err := GenerateTOTPSecret()
	if err != nil {
		t.Fatal(err)
	}
	if err := ValidateTOTPSecret(secret); err != nil {
		t.Errorf("generated secret rejected: %v", err)
	}
	if len(secret) != 32 {
		t.Errorf("expected 32 Base32 characters, got %d", len(secret))
	}

	// Tolerate the variants users copy out of authenticator apps.
	if err := ValidateTOTPSecret(strings.ToLower(secret) + "===="); err != nil {
		t.Errorf("lower-case padded secret rejected: %v", err)
	}
	if err := ValidateTOTPSecret("not-base32!!"); err == nil {
		t.Error("must reject a non-Base32 secret")
	}
	if err := ValidateTOTPSecret(""); err == nil {
		t.Error("must reject an empty secret")
	}
}
