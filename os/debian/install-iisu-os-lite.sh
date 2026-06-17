#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
IISU_USER="${IISU_USER:-iisu}"
STAGE_ROOT="${IISU_OS_ROOT:-}"

target_path() {
  local absolute_path="$1"

  if [[ -n "${STAGE_ROOT}" ]]; then
    printf "%s/%s" "${STAGE_ROOT%/}" "${absolute_path#/}"
    return
  fi

  printf "%s" "${absolute_path}"
}

if [[ -z "${STAGE_ROOT}" && "${EUID}" -ne 0 ]]; then
  echo "Run this installer as root: sudo ./install-iisu-os-lite.sh" >&2
  echo "For a non-destructive test, set IISU_OS_ROOT to a staging directory." >&2
  exit 1
fi

INSTALL_DIR="$(target_path /opt/iisu-os)"
SESSION_BIN="$(target_path /usr/local/bin/iisu-os-session)"
XSESSION_DIR="$(target_path /usr/share/xsessions)"
SYSTEMD_GETTY_DIR="$(target_path /etc/systemd/system/getty@tty1.service.d)"
HOME_DIR="$(target_path "/home/${IISU_USER}")"
PROFILE_FILE="${HOME_DIR}/.bash_profile"

if [[ -z "${STAGE_ROOT}" ]]; then
  if ! id "${IISU_USER}" >/dev/null 2>&1; then
    useradd --create-home --shell /bin/bash "${IISU_USER}"
    passwd -d "${IISU_USER}" >/dev/null
  fi
else
  install -d "${HOME_DIR}"
fi

install -d "${INSTALL_DIR}/shell"
cp -R "${REPO_ROOT}/shell/." "${INSTALL_DIR}/shell/"

install -d "$(dirname "${SESSION_BIN}")"
install -m 0755 "${REPO_ROOT}/os/debian/iisu-os-session.sh" "${SESSION_BIN}"
install -d "${XSESSION_DIR}"
install -m 0644 "${REPO_ROOT}/os/debian/iisu-os.desktop" "${XSESSION_DIR}/iisu-os.desktop"

install -d "${SYSTEMD_GETTY_DIR}"
cat >"${SYSTEMD_GETTY_DIR}/iisu-os-autologin.conf" <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin ${IISU_USER} --noclear %I \$TERM
EOF

cat >"${PROFILE_FILE}" <<'EOF'
if [[ -z "${DISPLAY:-}" ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
  startx /usr/local/bin/iisu-os-session
fi
EOF

if [[ -z "${STAGE_ROOT}" ]]; then
  chown "${IISU_USER}:${IISU_USER}" "${PROFILE_FILE}"
  systemctl daemon-reload
  systemctl enable getty@tty1.service
  echo "iiSU OS Lite installed. Reboot to start the kiosk shell."
else
  echo "iiSU OS Lite staged at ${STAGE_ROOT}."
fi
