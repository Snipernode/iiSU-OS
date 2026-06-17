#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage: iisu-run-exe /path/to/program.exe [args...]

Runs a Windows x86-64 .exe through Wine. This is not CPU emulation; it is a
Windows API compatibility layer on the same x86-64 hardware.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 64
fi

exe_path="$1"
shift

if [[ ! -f "${exe_path}" ]]; then
  echo "Windows executable not found: ${exe_path}" >&2
  exit 66
fi

if ! command -v wine >/dev/null 2>&1; then
  echo "Wine is not installed. Install the iiSU OS Windows compatibility package set." >&2
  exit 69
fi

export WINEPREFIX="${IISU_WINEPREFIX:-${HOME}/.local/share/iisu-os/wineprefix}"
mkdir -p "$(dirname "${WINEPREFIX}")"

exec wine "${exe_path}" "$@"
