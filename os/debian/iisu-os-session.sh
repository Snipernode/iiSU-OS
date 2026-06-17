#!/usr/bin/env bash
set -euo pipefail

SHELL_ENTRY="${IISU_OS_SHELL_ENTRY:-/opt/iisu-os/shell/index.html}"
SHELL_URL="file://${SHELL_ENTRY}"

export DISPLAY="${DISPLAY:-:0}"
export XDG_SESSION_TYPE=x11

openbox-session >/tmp/iisu-openbox.log 2>&1 &

sleep 1

exec chromium \
  --kiosk "${SHELL_URL}" \
  --no-first-run \
  --disable-translate \
  --disable-features=Translate \
  --disable-session-crashed-bubble \
  --overscroll-history-navigation=0
