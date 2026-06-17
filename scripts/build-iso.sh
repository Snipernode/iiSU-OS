#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_ROOT="${IISU_OS_BUILD_ROOT:-/tmp/iisu-os-live-build}"
OUTPUT_DIR="${REPO_ROOT}/dist"
LIVE_CONFIG="${REPO_ROOT}/os/debian/live-build"
ISO_NAME="iisu-os-lite-amd64-trixie.iso"

need_command() {
  local command_name="$1"

  if ! command -v "${command_name}" >/dev/null 2>&1; then
    echo "Missing required command: ${command_name}" >&2
    exit 1
  fi
}

case "${BUILD_ROOT}" in
  /tmp/iisu-os-live-build|/tmp/iisu-os-live-build/*) ;;
  *)
    echo "Refusing to clean unexpected build path: ${BUILD_ROOT}" >&2
    exit 1
    ;;
esac

need_command lb
need_command xorriso

rm -rf "${BUILD_ROOT}"
mkdir -p "${BUILD_ROOT}" "${OUTPUT_DIR}"

cp -a "${LIVE_CONFIG}/." "${BUILD_ROOT}/"

install -d "${BUILD_ROOT}/config/includes.chroot/opt/iisu-os"
cp -a "${REPO_ROOT}/shell" "${BUILD_ROOT}/config/includes.chroot/opt/iisu-os/shell"

install -d "${BUILD_ROOT}/config/includes.chroot/usr/local/bin"
install -m 0755 "${REPO_ROOT}/os/debian/iisu-os-session.sh" \
  "${BUILD_ROOT}/config/includes.chroot/usr/local/bin/iisu-os-session"

find "${BUILD_ROOT}/auto" -type f -exec chmod 0755 {} +
find "${BUILD_ROOT}/config/hooks" -type f -exec chmod 0755 {} +

cd "${BUILD_ROOT}"
lb config
lb build

BUILT_ISO="$(find "${BUILD_ROOT}" -maxdepth 1 -type f -name '*.iso' | head -n 1)"

if [[ -z "${BUILT_ISO}" ]]; then
  echo "live-build finished without producing an ISO." >&2
  exit 1
fi

cp "${BUILT_ISO}" "${OUTPUT_DIR}/${ISO_NAME}"
sha256sum "${OUTPUT_DIR}/${ISO_NAME}" >"${OUTPUT_DIR}/${ISO_NAME}.sha256"

echo "Built ${OUTPUT_DIR}/${ISO_NAME}"
