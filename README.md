# Playwright Demo

Playwright-Tests ausführen und aufnehmen via Docker.

## Voraussetzungen

- Docker + Docker Compose
- Port 6080 frei (für Recording)
- `.env`-Datei mit `BASE_URL` (Ziel-System für Testausführung)

## Installation

```bash
git clone https://github.com/oxid-support/playwright-demo.git
cd playwright-demo
make build
```

## Befehle

| Befehl | Beschreibung |
|--------|--------------|
| `make build` | Docker-Image bauen (einmalig) |
| `make test` | Tests ausführen |
| `make record URL=...` | Recording starten |
| `make report` | HTML-Report öffnen |

## Workflow

```bash
# 1. Docker-Image bauen (einmalig)
make build

# 2. .env anlegen
echo "BASE_URL=https://mein-staging.example.com" > .env

# 3. Test aufnehmen
make record URL=https://mein-staging.example.com
# → Browser öffnen: http://localhost:6080/vnc.html
# → Durch die Seite klicken
# → Ctrl+C wenn fertig
# → Absolute URLs werden automatisch durch relative Pfade ersetzt

# 4. Test ausführen (nutzt BASE_URL aus .env)
make test

# 5. Bei Fehlern: Report anschauen
make report
```

## Base URL

Tests verwenden relative Pfade (z.B. `page.goto('/shop/admin')`). Beim Ausführen setzt Playwright automatisch die `BASE_URL` davor.

Jeder Entwickler legt seine eigene `.env` an (wird nicht committet):
```
BASE_URL=https://mein-staging.example.com
```

Beim Recording wird die `BASE_URL` automatisch durch relative Pfade ersetzt — die generierten Tests sind dadurch sofort auf jedem System lauffähig.

Beispiel: Entwickler A testet gegen `https://staging-a.example.com`, Entwickler B gegen `https://staging-b.example.com` — beide nutzen dieselben Testdateien.

## Konfiguration

`make record URL=...` speichert die URL in `.env`. Danach reicht `make record` ohne Parameter.

Der Dateiname wird automatisch generiert: `tests/{url}_{datum-uhrzeit}.spec.js`

Beispiel: `https://example.com` → `tests/examplecom_20260130-0815.spec.js`

Optional kann ein fester Dateiname in `.env` gesetzt werden:
```
OUT_FILE=tests/mein-test.spec.js
```
