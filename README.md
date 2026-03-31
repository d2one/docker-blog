# docker-blog

Docker-based Hugo blog deployment with automatic TLS and webhook-triggered rebuilds.

## Architecture

```
Internet → Traefik (:80/:443) → Nginx (static files)
                               → Hugo webhook (/hooks/*)
```

Three services orchestrated via Docker Compose:

- **Traefik** — reverse proxy, automatic Let's Encrypt TLS via reg.ru DNS challenge
- **Nginx** — serves static Hugo-built site
- **Hugo** — clones blog repo, builds it, runs webhook server for auto-redeploy on push

## Quick start

```bash
cp .env.example .env
# fill in all variables

make build-hugo
make up
```

## Commands

```bash
make build-hugo   # Build the hugo Docker image
make up           # Start all services
make down         # Stop all services
make logs         # Follow logs
make restart      # Restart all services
make rebuild      # Rebuild hugo image and recreate container
```

## Webhook

GitHub sends push events to `https://<DOMAIN>/hooks/redeploy`. Authentication via HMAC-SHA256 signature (`X-Hub-Signature-256` header).

GitHub repo settings: **Settings → Webhooks → Add webhook**
- Payload URL: `https://<DOMAIN>/hooks/redeploy`
- Content type: `application/json`
- Secret: same value as `WEBHOOK_SECRET` in `.env`

## Environment variables

| Variable | Description |
|----------|-------------|
| `DOMAIN` | Domain name for the blog |
| `HUGO_REPO_URL` | Git URL of the Hugo blog repository |
| `REGRU_USERNAME` | reg.ru API username |
| `REGRU_PASSWORD` | reg.ru API password |
| `WEBHOOK_SECRET` | Shared secret for GitHub webhook HMAC verification |
