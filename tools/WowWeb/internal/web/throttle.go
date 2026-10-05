package web

import (
	"context"
	"strings"

	"tortoiseweb/internal/gamepwd"
	"tortoiseweb/internal/store"
)

// Rate limiting for the two anonymous endpoints that take a password or create
// an account.
//
// Design notes:
//
//   - The counters live in the database, not in a map guarded by a mutex, so
//     they survive a restart and are shared by every process behind the load
//     balancer. A limit an attacker can reset by waiting for a deploy is not a
//     limit.
//
//   - The check happens *before* the password is verified, so a blocked request
//     costs two COUNT queries and never reaches the hash comparison. The
//     endpoint is meant to stay cheap under attack.
//
//   - A block reads the same to the client whether or not the account exists:
//     buckets are keyed by the submitted name, and a failed guess is recorded
//     for a name that does not exist just the same. Nothing here can be used to
//     probe which accounts are real.
//
//   - Two rules guard sign-in. Per-address catches one machine guessing
//     passwords. Per-account catches a distributed attempt, where every request
//     comes from a fresh address and the per-address counter never rises.
//     Neither alone is enough, and the per-account rule is set deliberately
//     looser so that a stranger cannot lock a known player out of the website
//     by failing a handful of sign-ins with that player's name.
//
//   - A successful sign-in clears the account bucket and leaves the address
//     bucket alone. Proving ownership of the account is what clears the
//     per-account counter; the per-address counter must not be resettable by
//     someone who holds one valid account.

// emptyAccountKey is the shared bucket for submissions with no usable name.
//
// They all land together, which is correct: an empty name is one kind of
// attempt, not many.
const emptyAccountKey = "-"

// accountBucketKey turns a submitted account name into a counter key, so that
// every spelling of one name shares a bucket and an attacker cannot get a fresh
// counter by changing the case or adding spaces.
//
// One wrinkle: gamepwd.Normalize mirrors the core, which uppercases the basic
// Latin letters only and leaves everything else - accents, Cyrillic, CJK -
// alone, and does not trim. Trimming and a final lowercasing happen here, so
// "Thrall", " THRALL " and "thrall" are one attack, not three.
//
// A name that cannot be normalised at all (too long, invalid UTF-8) is still
// counted: the limit must not be dodgeable by sending rubbish.
func accountBucketKey(username string) string {
	trimmed := strings.TrimSpace(username)
	if normalized, err := gamepwd.Normalize(trimmed); err == nil {
		trimmed = normalized
	}
	key := strings.ToLower(trimmed)
	if key == "" {
		return emptyAccountKey
	}
	return key
}

// Rules that can refuse a sign-in, named for the log.
const (
	ruleNone    = ""
	ruleAddress = "address"
	ruleAccount = "account"
)

// judgeLogin is the whole sign-in policy: given how many failures have been
// counted, is this request refused, and by which rule?
//
// It is a pure function so the policy can be tested directly, without a
// database and without going through HTTP. The zero value of a limit disables
// that rule.
//
// Order matters only for the log line; either rule refusing is enough.
func judgeLogin(maxPerAddress, accountMax int, addressCount, accountCount int) (blocked bool, rule string) {
	if maxPerAddress > 0 && addressCount >= maxPerAddress {
		return true, ruleAddress
	}
	if accountMax > 0 && accountCount >= accountMax {
		return true, ruleAccount
	}
	return false, ruleNone
}

// loginThrottle reads both counters and applies judgeLogin.
//
// A database failure is not treated as "blocked": losing the throttle table
// must not lock every player out of the website. The caller logs it instead and
// lets the request through.
func (s *Server) loginThrottle(ctx context.Context, ip, username string) (blocked bool, rule string, err error) {
	addressCount := 0
	if s.cfg.LoginMaxAttempts > 0 {
		if addressCount, err = s.store.ThrottleCount(ctx, store.ThrottleLoginIP, ip,
			s.cfg.LoginWindow); err != nil {
			return false, ruleNone, err
		}
	}

	accountCount := 0
	if s.cfg.LoginAccountMaxAttempts > 0 {
		key := accountBucketKey(username)
		if accountCount, err = s.store.ThrottleCount(ctx, store.ThrottleLoginAccount, key,
			s.cfg.LoginAccountWindow); err != nil {
			return false, ruleNone, err
		}
	}

	blocked, rule = judgeLogin(s.cfg.LoginMaxAttempts, s.cfg.LoginAccountMaxAttempts,
		addressCount, accountCount)
	return blocked, rule, nil
}

// recordLoginFailure notes one failed sign-in against both rules.
func (s *Server) recordLoginFailure(ctx context.Context, ip, username string) {
	_ = s.store.ThrottleRecord(ctx, store.ThrottleLoginIP, ip)
	_ = s.store.ThrottleRecord(ctx, store.ThrottleLoginAccount, accountBucketKey(username))
}

// clearLoginFailures forgets the per-account failures after a successful
// sign-in. The per-address counter is intentionally left standing.
func (s *Server) clearLoginFailures(ctx context.Context, username string) {
	_ = s.store.ThrottleClear(ctx, store.ThrottleLoginAccount, accountBucketKey(username))
}

// registerThrottle reports whether this sign-up should be refused. Every
// submission counts, not only the successful ones: probing which names are
// taken, or hammering the validation, is the same abuse as mass-creating
// accounts.
func (s *Server) registerThrottle(ctx context.Context, ip string) (bool, error) {
	if s.cfg.RegisterMaxAttempts <= 0 {
		return false, nil
	}
	n, err := s.store.ThrottleCount(ctx, store.ThrottleRegister, ip, s.cfg.RegisterWindow)
	if err != nil {
		return false, err
	}
	return judgeRegister(s.cfg.RegisterMaxAttempts, n), nil
}

// judgeRegister is the sign-up policy, pure for the same reason as judgeLogin.
func judgeRegister(max int, count int) bool {
	return max > 0 && count >= max
}

// recordRegisterAttempt counts one sign-up submission.
func (s *Server) recordRegisterAttempt(ctx context.Context, ip string) {
	_ = s.store.ThrottleRecord(ctx, store.ThrottleRegister, ip)
}

// noteThrottleCheckFailure logs a throttle lookup that failed.
//
// A database failure is never treated as "blocked": losing the throttle table
// must not lock every player out of the website, so the request is allowed
// through and the failure is logged instead.
func (s *Server) noteThrottleCheckFailure(what string, err error) {
	s.log.Error(what+" throttle check failed", "err", err)
}
