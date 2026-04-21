#!/bin/bash
set -euo pipefail

: "${BASE_URL:?BASE_URL must be set}"

# Generate OUT_FILE dynamically if not set
if [ -z "${OUT_FILE:-}" ]; then
    # Create filename from URL (remove protocol, replace special chars)
    url_slug=$(echo "$BASE_URL" | sed 's|https\?://||' | sed 's|[^a-zA-Z0-9]||g')
    timestamp=$(date +%Y%m%d-%H%M)
    OUT_FILE="tests/${url_slug}_${timestamp}.spec.js"
fi

if [ -f package-lock.json ]; then
    npm ci
else
    npm install
fi

mkdir -p "$(dirname "$OUT_FILE")"

export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 -ac +extension RANDR &

for i in $(seq 1 50); do
    xdpyinfo -display :99 >/dev/null 2>&1 && break
    sleep 0.1
done
xdpyinfo -display :99 >/dev/null 2>&1 || { echo "Xvfb not ready"; exit 1; }

openbox >/tmp/openbox.log 2>&1 &
x11vnc -display :99 -forever -nopw -shared -rfbport 5900 \
    -xkb -noxrecord -noxfixes -noxdamage \
    -bg -o /tmp/x11vnc.log
websockify --web=/usr/share/novnc/ 6080 localhost:5900 >/tmp/websockify.log 2>&1 &

echo "noVNC: http://localhost:6080/vnc.html"
echo "Recording to: $OUT_FILE"
npx playwright codegen -o "$OUT_FILE" "$BASE_URL"

# Replace absolute BASE_URL with relative paths
sed -i "s|'${BASE_URL}/|'/|g; s|'${BASE_URL}'|'/'|g" "$OUT_FILE"
echo "Replaced $BASE_URL with relative paths in $OUT_FILE"
