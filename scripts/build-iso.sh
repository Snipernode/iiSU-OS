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

prepare_isolinux_template() {
  local target_dir="${BUILD_ROOT}/config/bootloaders/isolinux"
  local source_dir="/usr/share/live/build/bootloaders/isolinux"

  if [[ ! -d "${source_dir}" ]]; then
    echo "Missing live-build ISOLINUX template: ${source_dir}" >&2
    exit 1
  fi

  install -d "${target_dir}"
  cp -a "${source_dir}/." "${target_dir}/"

  # Ubuntu's live-build template still points at old Syslinux paths.
  rm -f "${target_dir}/isolinux.bin" "${target_dir}/vesamenu.c32"
  install -m 0644 /usr/lib/ISOLINUX/isolinux.bin "${target_dir}/isolinux.bin"
  install -m 0644 /usr/lib/syslinux/modules/bios/vesamenu.c32 "${target_dir}/vesamenu.c32"
  install -m 0644 /usr/lib/syslinux/modules/bios/libcom32.c32 "${target_dir}/libcom32.c32"
  install -m 0644 /usr/lib/syslinux/modules/bios/libutil.c32 "${target_dir}/libutil.c32"
}

rebuild_iso_with_uefi() {
  local uefi_iso="${BUILD_ROOT}/binary.uefi.iso"

  if [[ ! -f "binary/boot/grub/grub_eltorito" ]]; then
    echo "Missing BIOS GRUB boot image in live-build binary tree." >&2
    exit 1
  fi

  if [[ ! -f "binary/boot/grub/efi.img" ]]; then
    echo "Missing UEFI GRUB boot image in live-build binary tree." >&2
    exit 1
  fi

  rm -f "${uefi_iso}"

  xorriso -as mkisofs \
    -J -l -cache-inodes -allow-multidot \
    -A "iiSU OS Lite" \
    -publisher "iiSU OS contributors" \
    -V "IISU_OS_LITE" \
    -r \
    -b boot/grub/grub_eltorito \
    -c boot.catalog \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    -e --interval:appended_partition_2:all:: \
    -no-emul-boot \
    -append_partition 2 0xef binary/boot/grub/efi.img \
    -appended_part_as_gpt \
    -partition_cyl_align all \
    -o "${uefi_iso}" \
    binary

  mv "${uefi_iso}" "${BUILD_ROOT}/binary.iso"
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
need_command grub-mkstandalone
need_command mkfs.vfat
need_command mmd
need_command mcopy

rm -rf "${BUILD_ROOT}"
mkdir -p "${BUILD_ROOT}" "${OUTPUT_DIR}"

cp -a "${LIVE_CONFIG}/." "${BUILD_ROOT}/"
prepare_isolinux_template

install -d "${BUILD_ROOT}/config/includes.chroot/opt/iisu-os"
cp -a "${REPO_ROOT}/shell" "${BUILD_ROOT}/config/includes.chroot/opt/iisu-os/shell"

install -d "${BUILD_ROOT}/config/includes.chroot/usr/local/bin"
install -m 0755 "${REPO_ROOT}/os/debian/iisu-os-session.sh" \
  "${BUILD_ROOT}/config/includes.chroot/usr/local/bin/iisu-os-session"
install -m 0755 "${REPO_ROOT}/os/debian/iisu-run-exe.sh" \
  "${BUILD_ROOT}/config/includes.chroot/usr/local/bin/iisu-run-exe"

find "${BUILD_ROOT}/auto" -type f -exec chmod 0755 {} +
find "${BUILD_ROOT}/config/hooks" -type f -exec chmod 0755 {} +
find "${BUILD_ROOT}/config/includes.chroot/usr/bin" -type f -exec chmod 0755 {} +

cd "${BUILD_ROOT}"
lb config
lb build
rebuild_iso_with_uefi

BUILT_ISO="$(find "${BUILD_ROOT}" -maxdepth 1 -type f -name '*.iso' | head -n 1)"

if [[ -z "${BUILT_ISO}" ]]; then
  echo "live-build finished without producing an ISO." >&2
  exit 1
fi

cp "${BUILT_ISO}" "${OUTPUT_DIR}/${ISO_NAME}"
sha256sum "${OUTPUT_DIR}/${ISO_NAME}" >"${OUTPUT_DIR}/${ISO_NAME}.sha256"

echo "Built ${OUTPUT_DIR}/${ISO_NAME}"
