package web

import "testing"

// TestJudgeLogin covers the sign-in policy.
//
// The policy is the part worth testing exhaustively: it decides when a player
// is refused, so an off-by-one either leaves a gap in the defence or locks
// people out early. It is a pure function, so these cases need no database.
func TestJudgeLogin(t *testing.T) {
	cases := []struct {
		name        string
		maxAddress  int
		maxAccount  int
		addressHits int
		accountHits int
		wantBlocked bool
		wantRule    string
	}{
		{"nothing counted", 10, 20, 0, 0, false, ruleNone},
		{"below both limits", 10, 20, 9, 19, false, ruleNone},
		{"address at the limit", 10, 20, 10, 0, true, ruleAddress},
		{"address above the limit", 10, 20, 11, 0, true, ruleAddress},
		{"account at the limit", 10, 20, 0, 20, true, ruleAccount},
		{"account above the limit", 10, 20, 0, 25, true, ruleAccount},
		{"both at the limit names the address", 10, 20, 10, 20, true, ruleAddress},

		// Zero disables a rule. An operator who cannot run the counters at all
		// must be able to switch a rule off rather than have it block everyone.
		{"address rule disabled", 0, 20, 9999, 0, false, ruleNone},
		{"account rule disabled", 10, 0, 0, 9999, false, ruleNone},
		{"both disabled", 0, 0, 9999, 9999, false, ruleNone},

		// A limit of 1 means the first failure blocks the next attempt.
		{"limit of one", 1, 1, 1, 0, true, ruleAddress},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			blocked, rule := judgeLogin(tc.maxAddress, tc.maxAccount, tc.addressHits, tc.accountHits)
			if blocked != tc.wantBlocked || rule != tc.wantRule {
				t.Errorf("judgeLogin(%d, %d, %d, %d) = (%v, %q), want (%v, %q)",
					tc.maxAddress, tc.maxAccount, tc.addressHits, tc.accountHits,
					blocked, rule, tc.wantBlocked, tc.wantRule)
			}
		})
	}
}

func TestJudgeRegister(t *testing.T) {
	for _, tc := range []struct {
		max   int
		count int
		want  bool
	}{
		{10, 0, false},
		{10, 9, false},
		{10, 10, true},
		{10, 11, true},
		{0, 9999, false}, // 0 disables the rule
	} {
		if got := judgeRegister(tc.max, tc.count); got != tc.want {
			t.Errorf("judgeRegister(%d, %d) = %v, want %v", tc.max, tc.count, got, tc.want)
		}
	}
}

// TestAccountBucketKey pins how a submitted name is turned into a counter key.
//
// The point is that one attacker cannot spread their guesses across spellings
// of the same name, and that no input - however malformed - escapes counting
// altogether.
func TestAccountBucketKey(t *testing.T) {
	cases := []struct {
		name string
		in   string
		want string
	}{
		{"already normal", "thrall", "thrall"},
		{"uppercase", "THRALL", "thrall"},
		{"mixed case", "Thrall", "thrall"},
		// Normalize does not trim, so this is where whitespace padding has to
		// be collapsed: without it, " thrall" would be a separate counter.
		{"surrounding space", "  thrall  ", "thrall"},
		{"tabs and newlines", "\tthrall\n", "thrall"},
		{"mixed case and space", " ThrAll ", "thrall"},
		// Non-ASCII is passed through by Normalize and case-folded here.
		{"unicode case folds", "ÜNTER", "ünter"},
		{"no name at all", "", "-"},
		{"only whitespace", "   ", "-"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := accountBucketKey(tc.in); got != tc.want {
				t.Errorf("accountBucketKey(%q) = %q, want %q", tc.in, got, tc.want)
			}
		})
	}

	// A name that cannot be normalised is still counted, so sending rubbish
	// cannot dodge the limit. It must come back non-empty and stable.
	t.Run("unusable input still yields a key", func(t *testing.T) {
		for _, in := range []string{"", "   ", "\x00\x01\x02", string(make([]byte, 400))} {
			got := accountBucketKey(in)
			if got == "" {
				t.Errorf("accountBucketKey(%q) returned an empty key", in)
			}
			if again := accountBucketKey(in); again != got {
				t.Errorf("accountBucketKey(%q) is not stable: %q then %q", in, got, again)
			}
		}
	})
}
