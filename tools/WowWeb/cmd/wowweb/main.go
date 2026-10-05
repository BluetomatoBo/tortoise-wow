// Command wowweb is the account website for a Tortoise WoW (MaNGOS) server.
//
// It talks directly to the game databases the core already uses, so it needs
// no changes on the server side: registration writes the same SHA-1 password
// hash the client authenticates with, and every administrative action reuses
// the columns the core reads (account.rank, account_banned, realmlist, ...).
//
//	go build ./cmd/wowweb
//	DB_PASSWORD=secret ./wowweb
package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	_ "github.com/go-sql-driver/mysql"

	"tortoiseweb/internal/config"
	"tortoiseweb/internal/store"
	"tortoiseweb/internal/web"
)

// version is injected at build time with
// -ldflags "-X main.version=$(git describe --tags)".
var version = "dev"

func main() {
	showVersion := flag.Bool("version", false, "print the version and exit")
	flag.Parse()

	if *showVersion {
		fmt.Printf("wowweb %s\n", version)
		return
	}

	logger := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelInfo,
	}))

	if err := run(logger); err != nil {
		logger.Error("startup failed", "err", err)
		os.Exit(1)
	}
}

func run(logger *slog.Logger) error {
	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("configuration: %w", err)
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	startupCtx, cancel := context.WithTimeout(ctx, 30*time.Second)
	defer cancel()

	st, err := store.Open(startupCtx, cfg)
	if err != nil {
		return fmt.Errorf("database: %w", err)
	}
	defer st.Close()

	// Create the service's own tables. Core tables are never touched.
	if err := st.EnsureSchema(startupCtx); err != nil {
		return fmt.Errorf("schema: %w", err)
	}
	logger.Info("database ready",
		"logon", cfg.DBLogon, "character", cfg.DBChar, "world", cfg.DBWorld)

	srv, err := web.New(cfg, st, logger)
	if err != nil {
		return fmt.Errorf("http server: %w", err)
	}

	httpServer := &http.Server{
		Addr:              cfg.ListenAddr,
		Handler:           srv.Handler(),
		ReadHeaderTimeout: 10 * time.Second,
		ReadTimeout:       30 * time.Second,
		WriteTimeout:      60 * time.Second,
		IdleTimeout:       2 * time.Minute,
	}

	// Housekeeping: drop expired sessions and stale setup rows.
	go func() {
		ticker := time.NewTicker(30 * time.Minute)
		defer ticker.Stop()
		for {
			select {
			case <-ctx.Done():
				return
			case <-ticker.C:
				pruneCtx, pruneCancel := context.WithTimeout(ctx, 30*time.Second)
				if n, err := st.PruneSessions(pruneCtx); err != nil {
					logger.Warn("prune sessions", "err", err)
				} else if n > 0 {
					logger.Debug("pruned sessions", "count", n)
				}
				if err := st.PrunePendingSecrets(pruneCtx); err != nil {
					logger.Warn("prune pending 2fa setups", "err", err)
				}
				// Rate-limit counters are only read inside a window of at most
				// an hour, so a day of history is more than enough; dropping
				// the rest keeps the table from growing without bound.
				if err := st.PruneThrottle(pruneCtx, 24*time.Hour); err != nil {
					logger.Warn("prune throttle counters", "err", err)
				}
				pruneCancel()
			}
		}
	}()

	errCh := make(chan error, 1)
	go func() {
		logger.Info("listening",
			"addr", cfg.ListenAddr,
			"realm", cfg.RealmName,
			"admin_min_rank", cfg.AdminMinRank,
			"registration", cfg.AllowRegister,
			"login_limit", fmt.Sprintf("%d/%s per address, %d/%s per account",
				cfg.LoginMaxAttempts, cfg.LoginWindow,
				cfg.LoginAccountMaxAttempts, cfg.LoginAccountWindow),
			"register_limit", fmt.Sprintf("%d/%s per address",
				cfg.RegisterMaxAttempts, cfg.RegisterWindow))
		if err := httpServer.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			errCh <- err
		}
	}()

	select {
	case err := <-errCh:
		return fmt.Errorf("listen: %w", err)
	case <-ctx.Done():
		logger.Info("shutting down")
	}

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer shutdownCancel()
	if err := httpServer.Shutdown(shutdownCtx); err != nil {
		return fmt.Errorf("shutdown: %w", err)
	}
	return nil
}
