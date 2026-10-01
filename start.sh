#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PROJECT_ROOT="$(pwd)"
PORT="${PORT:-3000}"
DIST="$PROJECT_ROOT"
WEB_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p "$WEB_DIR"
/usr/bin/time -p mkdir -p "/home/runner/work/_temp/omgithub-web"
/usr/bin/time -p test -f "$DIST/index.html"
if /usr/bin/time -p test -f "$PROJECT_ROOT/package.json"; then
  /usr/bin/time -p npm install --no-audit --no-fund
  if /usr/bin/time -p node -e "process.exit(JSON.parse(require('fs').readFileSync('package.json','utf8')).scripts?.build?0:1)"; then
    /usr/bin/time -p npm run build
  fi
  if /usr/bin/time -p test -d "$PROJECT_ROOT/dist"; then
    DIST="$PROJECT_ROOT/dist"
  fi
  /usr/bin/time -p test -f "$DIST/index.html"
fi
/usr/bin/time -p printf '%s' "{\"project\":\"$PROJECT_ROOT\",\"directory\":\"$DIST\"}" > "$WEB_DIR/deployment-output.json"
if [[ "$WEB_DIR/deployment-output.json" != "/home/runner/work/_temp/omgithub-web/deployment-output.json" ]]; then
  /usr/bin/time -p cp "$WEB_DIR/deployment-output.json" "/home/runner/work/_temp/omgithub-web/deployment-output.json"
fi
/usr/bin/time -p cat "$WEB_DIR/deployment-output.json"
/usr/bin/time -p python3 --version
exec /usr/bin/time -p python3 -m http.server "$PORT" --bind 0.0.0.0 --directory "$DIST"
