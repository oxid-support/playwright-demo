#!/bin/bash
set -euo pipefail

if [ -f package-lock.json ]; then
    npm ci
else
    npm install
fi

npm test
