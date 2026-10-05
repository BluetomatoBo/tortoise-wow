package store

import (
	"context"
	"math/rand/v2"
	"strings"
	"time"
)

// Throttle kinds. Each kind is an independent counter, so a rule for one cannot
// exhaust another.
const (
	// ThrottleLoginIP counts failed sign-ins from one address. This is the
	// first line of defence: one machine guessing passwords.
	ThrottleLoginIP = "login-ip"

	// ThrottleLoginAccount counts failed sign-ins against one account name,
	// regardless of where they come from. This is the backstop for a
	// distributed attempt, where every request comes from a different address
	// and the per-address counter never rises.
	//
	// It is keyed by the *submitted* name, not by an account id, so a filled
	// bucket does not reveal whether that account exists.
	ThrottleLoginAccount = "login-account"

	// ThrottleRegister counts sign-up submissions from one address. Every
	// attempt counts, not just the successful ones: probing which names are
	// taken, or hammering the validation, is the same abuse as mass-creating
	// accounts.
	ThrottleRegister = "register"
)

// maxThrottleBucket is the column width. Addresses and account names are both
// truncated into it.
const maxThrottleBucket = 64

// pruneOneIn controls how often old rows are cleared. Pruning on every insert
// would double the write cost of an endpoint that is already under attack, so
// it is done occasionally instead. The value is a probability denominator: one
// insert in every pruneOneIn triggers it.
const pruneOneIn = 64

// throttleBucket normalises a key so the same client always lands on one row.
//
// Addresses arrive trimmed and may be IPv6 (up to 45 characters). Account names
// are case-insensitive in this game, so they are lowered: guessing "Thrall" and
// "thrall" is one attack, not two.
func throttleBucket(key string) string {
	return truncate(strings.ToLower(strings.TrimSpace(key)), maxThrottleBucket)
}

// ThrottleCount reports how many events of this kind were recorded for the
// bucket inside the window.
//
// A missing table means the schema has not been created yet, which must not
// lock anybody out, so it reports zero.
func (s *Store) ThrottleCount(ctx context.Context, kind, bucket string, window time.Duration) (int, error) {
	var n int
	err := s.Logon.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM web_throttle
		 WHERE kind = ? AND bucket = ? AND at > NOW() - INTERVAL ? SECOND`,
		kind, throttleBucket(bucket), int(window.Seconds())).Scan(&n)
	if err != nil {
		if isMissingTable(err) {
			return 0, nil
		}
		return 0, err
	}
	return n, nil
}

// ThrottleRecord notes one event and occasionally prunes old rows.
//
// The bucket is written even when the account does not exist, so the set of
// buckets in this table says nothing about the set of real accounts.
func (s *Store) ThrottleRecord(ctx context.Context, kind, bucket string) error {
	if _, err := s.Logon.ExecContext(ctx,
		`INSERT INTO web_throttle (kind, bucket, at) VALUES (?, ?, NOW())`,
		kind, throttleBucket(bucket)); err != nil {
		return err
	}
	if rand.IntN(pruneOneIn) == 0 {
		// Best effort: a failure here only means the table keeps growing.
		_ = s.PruneThrottle(ctx, 24*time.Hour)
	}
	return nil
}

// ThrottleClear forgets everything recorded for one bucket.
//
// Only ever used for the account bucket after a *successful* sign-in: proving
// ownership is what clears the counter. The per-address counter is deliberately
// left alone, so an attacker holding one valid account cannot use it to reset
// their own failures.
func (s *Store) ThrottleClear(ctx context.Context, kind, bucket string) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_throttle WHERE kind = ? AND bucket = ?`,
		kind, throttleBucket(bucket))
	return err
}

// PruneThrottle drops rows older than the given age, keeping the table bounded.
func (s *Store) PruneThrottle(ctx context.Context, olderThan time.Duration) error {
	_, err := s.Logon.ExecContext(ctx,
		`DELETE FROM web_throttle WHERE at < NOW() - INTERVAL ? SECOND`,
		int(olderThan.Seconds()))
	return err
}
