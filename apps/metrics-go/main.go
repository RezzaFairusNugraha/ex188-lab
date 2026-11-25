package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"runtime"
	"strings"
	"syscall"
	"time"
)

var startedAt = time.Now()

func readScrapeToken() string {
	path := os.Getenv("SCRAPE_TOKEN_FILE")
	if path == "" {
		path = "/run/secrets/scrape_token"
	}
	raw, err := os.ReadFile(path)
	if err != nil {
		return strings.TrimSpace(os.Getenv("SCRAPE_TOKEN"))
	}
	return strings.TrimSpace(string(raw))
}

func main() {
	port := os.Getenv("METRICS_PORT")
	if port == "" {
		port = "9090"
	}
	svc := os.Getenv("SERVICE_NAME")
	if svc == "" {
		svc = "metrics-go"
	}
	token := readScrapeToken()

	mux := http.NewServeMux()
	mux.HandleFunc("/healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"status":  "ok",
			"service": svc,
			"uid":     os.Getuid(),
		})
	})

	mux.HandleFunc("/metrics", func(w http.ResponseWriter, r *http.Request) {
		if token != "" {
			q := r.URL.Query().Get("token")
			hdr := strings.TrimPrefix(r.Header.Get("Authorization"), "Bearer ")
			if q != token && hdr != token {
				http.Error(w, "unauthorized", http.StatusUnauthorized)
				return
			}
		}
		w.Header().Set("Content-Type", "text/plain; version=0.0.4")
		uptime := time.Since(startedAt).Seconds()
		fmt.Fprintf(w, "# HELP ex188_up Service health gauge\n")
		fmt.Fprintf(w, "# TYPE ex188_up gauge\n")
		fmt.Fprintf(w, "ex188_up{service=%q} 1\n", svc)
		fmt.Fprintf(w, "ex188_uptime_seconds{service=%q} %.2f\n", svc, uptime)
		fmt.Fprintf(w, "ex188_goroutines{service=%q} %d\n", svc, runtime.NumGoroutine())
	})

	srv := &http.Server{
		Addr:              "0.0.0.0:" + port,
		Handler:           mux,
		ReadHeaderTimeout: 5 * time.Second,
	}

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGTERM, syscall.SIGINT)
	go func() {
		<-stop
		log.Printf("INFO: shutting down %s cleanly", svc)
		os.Exit(0)
	}()

	log.Printf("INFO: %s listening on 0.0.0.0:%s (uid=%d)", svc, port, os.Getuid())
	if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		log.Fatalf("FATAL: %v", err)
	}
}
