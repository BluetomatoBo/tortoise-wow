# Build the account website and ship a small runtime image.
#
#   docker build -t tortoise-wow-web ./wowweb
#
# The service only needs network access to the game databases; it does not need
# the client data or any of the core binaries.

ARG GO_VERSION=1.22

# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------
FROM golang:${GO_VERSION}-alpine AS builder

WORKDIR /src

# Cache the module download separately from the source.
COPY go.mod go.sum* ./
RUN go mod download

COPY . .

ARG VERSION=dev
RUN CGO_ENABLED=0 go build \
        -trimpath \
        -ldflags "-s -w -X main.version=${VERSION}" \
        -o /out/wowweb ./cmd/wowweb

# ---------------------------------------------------------------------------
# Runtime
# ---------------------------------------------------------------------------
FROM alpine:3.20

RUN apk add --no-cache ca-certificates tzdata curl \
 && adduser -D -u 10001 wowweb

COPY --from=builder /out/wowweb /usr/local/bin/wowweb

USER wowweb
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -fsS http://127.0.0.1:8080/healthz >/dev/null || exit 1

ENTRYPOINT ["/usr/local/bin/wowweb"]
