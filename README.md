# Playwright via Docker Compose (inkl. Recording im Container)

Dieses Setup läuft **plattformunabhängig** über Docker (Windows/macOS/Linux).  
Es gibt zwei Compose-Services:

- **`pw`** – führt Playwright-Tests **headless** aus
- **`pw_record`** – startet eine **virtuelle GUI** (Xvfb) + **noVNC** und öffnet `playwright codegen` zum **Aufnehmen** von Tests


## Voraussetzungen

- Docker + Docker Compose (Plugin)
- Port **6080** lokal frei (für noVNC Recording) – oder Port im Compose anpassen


## 1) Container initial installieren (Build)

```bash
docker compose build
```

## 2) In den Container einloggen (Shell)

Interaktive Shell im Test-Container:

```bash
docker compose run --rm pw bash
```

## 3) Alle Tests ausführen

```bash
docker compose run --rm pw
```

### Tests auflisten (Discovery prüfen)

```bash
docker compose run --rm pw bash -lc "npx playwright test --list"
```

### Nur eine Datei ausführen

```bash
docker compose run --rm pw bash -lc "npx playwright test tests/<datei>.spec.js --reporter=list"
```

### HTML-Report

Nach einem Lauf liegt der Report (typisch) auf dem Host im Ordner:

- `playwright-report/index.html`

Einfach lokal im Browser öffnen.



## 4) Test recorden (Codegen) – komplett im Container

### 4.1 Recorder starten

Wichtig: `--service-ports` ist nötig, damit `6080` nach außen gemappt wird.

```bash
docker compose run --rm --service-ports pw_record
```

Im Terminal sollte stehen:

- `noVNC: http://localhost:6080/vnc.html`
- `Recording to: tests/<...>.spec.js` (oder ähnlich)

### 4.2 noVNC öffnen

Im Host-Browser öffnen:

- `http://localhost:6080/vnc.html`

Du siehst einen Linux-Desktop im Browser. Dort öffnet Playwright Chromium + Inspector (Codegen).

### 4.3 Aufnehmen

- Klicke/Tippe dich durch deine Seite
- Optional im Inspector Assertions erzeugen (sichtbar, Text vorhanden, URL passt)
- Playwright schreibt währenddessen den Test in die konfigurierte Datei

### 4.4 Recording beenden

Im Terminal, in dem `pw_record` läuft:

- `Ctrl + C`

### 4.5 Aufgenommenen Test ausführen

```bash
docker compose run --rm pw bash -lc "npx playwright test tests/<dein-test>.spec.js --reporter=list"
```

## Kurzliste (Cheatsheet)

```bash
docker compose build
docker compose run --rm pw
docker compose run --rm pw bash
docker compose run --rm pw bash -lc "npx playwright test --list"
docker compose run --rm --service-ports pw_record
```
