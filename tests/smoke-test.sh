#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAGE_ROOT="${REPO_ROOT}/build/stage-root"

assert_file() {
  local path="$1"

  if [[ ! -f "${path}" ]]; then
    echo "Missing expected file: ${path}" >&2
    exit 1
  fi
}

assert_contains() {
  local path="$1"
  local pattern="$2"

  if ! grep -Fq -- "${pattern}" "${path}"; then
    echo "Expected '${pattern}' in ${path}" >&2
    exit 1
  fi
}

case "${STAGE_ROOT}" in
  "${REPO_ROOT}/build/stage-root") ;;
  *)
    echo "Refusing to clean unexpected stage path: ${STAGE_ROOT}" >&2
    exit 1
    ;;
esac

rm -rf "${STAGE_ROOT}"
mkdir -p "${STAGE_ROOT}"

bash -n "${REPO_ROOT}/os/debian/install-iisu-os-lite.sh"
bash -n "${REPO_ROOT}/os/debian/iisu-os-session.sh"

IISU_OS_ROOT="${STAGE_ROOT}" bash "${REPO_ROOT}/os/debian/install-iisu-os-lite.sh" >/tmp/iisu-os-smoke-install.log

assert_file "${STAGE_ROOT}/opt/iisu-os/shell/index.html"
assert_file "${STAGE_ROOT}/opt/iisu-os/shell/styles.css"
assert_file "${STAGE_ROOT}/opt/iisu-os/shell/app.js"
assert_file "${STAGE_ROOT}/usr/local/bin/iisu-os-session"
assert_file "${STAGE_ROOT}/usr/share/xsessions/iisu-os.desktop"
assert_file "${STAGE_ROOT}/etc/systemd/system/getty@tty1.service.d/iisu-os-autologin.conf"
assert_file "${STAGE_ROOT}/home/iisu/.bash_profile"

assert_contains "${STAGE_ROOT}/opt/iisu-os/shell/index.html" '<link rel="stylesheet" href="./styles.css">'
assert_contains "${STAGE_ROOT}/opt/iisu-os/shell/index.html" '<script src="./app.js"></script>'
assert_contains "${STAGE_ROOT}/usr/local/bin/iisu-os-session" '--kiosk'
assert_contains "${STAGE_ROOT}/usr/share/xsessions/iisu-os.desktop" 'Exec=/usr/local/bin/iisu-os-session'
assert_contains "${STAGE_ROOT}/etc/systemd/system/getty@tty1.service.d/iisu-os-autologin.conf" 'ExecStart=-/sbin/agetty --autologin iisu'
assert_contains "${STAGE_ROOT}/home/iisu/.bash_profile" 'startx /usr/local/bin/iisu-os-session'

echo "Smoke test passed. Staged install is at: ${STAGE_ROOT}"
