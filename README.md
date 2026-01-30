# Playwright Demo

Playwright-Tests ausführen und aufnehmen via Docker.

## Voraussetzungen

- Docker + Docker Compose
- Port 6080 frei (für Recording)

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

# 2. Test aufnehmen
make record URL=https://example.com
# → Browser öffnen: http://localhost:6080/vnc.html
# → Durch die Seite klicken
# → Ctrl+C wenn fertig

# 3. Generierten Test prüfen/anpassen
# → tests/*.spec.js editieren

# 4. Test ausführen
make test

# 5. Bei Fehlern: Report anschauen
make report
```

## Konfiguration

`make record URL=...` speichert die URL in `.env`. Danach reicht `make record` ohne Parameter.

Der Dateiname wird automatisch generiert: `tests/{url}_{datum-uhrzeit}.spec.js`

Beispiel: `https://example.com` → `tests/httpsexamplecom_20260130-0815.spec.js`
