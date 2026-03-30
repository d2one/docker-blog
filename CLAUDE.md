# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker-based Hugo blog deployment for **d2one.ru**. Three services orchestrated via Docker Compose:

- **Traefik** — reverse proxy with automatic Let's Encrypt TLS via reg.ru DNS challenge
- **Nginx** — serves the static Hugo-built site from a shared volume
- **Hugo** — custom container that clones a Hugo blog repo, builds it, and runs a webhook server (port 9000) to trigger rebuilds on push events

The Hugo blog content lives in a separate repo: `https://github.com/d2one/d2one.github.io.git`. This repo only contains the deployment infrastructure.

## Architecture

```
Internet → Traefik (:80/:443) → Nginx (static files)
                               → Hugo webhook (/hooks/*)

Hugo container: clones blog repo → builds with hugo → outputs to shared volume → starts webhook listener
Webhook hit (GitHub X-Hub-Signature-256) → pulls latest → rebuilds hugo → nginx serves updated files
```

Traefik handles TLS cert provisioning using an exec-based DNS challenge solver (`update-dns.sh`) that calls the reg.ru API.

## Commands

All commands run from the `hugo/` directory using the Makefile:

```bash
make docker-build    # Build the hugo Docker image
make up              # docker compose up -d
make down            # docker compose down
make logs            # docker compose logs -f
make restart         # docker compose restart
make rebuild         # Rebuild hugo image and recreate hugo container
```

## Environment

Copy `.env.example` to `.env` and fill in:
- `REGRU_USERNAME` / `REGRU_PASSWORD` — reg.ru API credentials for DNS challenge
- `WEBHOOK_SECRET` — shared secret for the rebuild webhook (verified via GitHub HMAC signature)
