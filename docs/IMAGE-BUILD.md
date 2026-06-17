# Image Build Plan

This project now includes an early Debian live-build profile for a bootable ISO.

The target base is Debian 13 `trixie` for `amd64`.

## Manual Install Flow

1. Install Debian stable or Lubuntu on the target machine.
2. Create or keep a normal admin user.
3. Run the iiSU OS Lite installer script from `os/debian/install-iisu-os-lite.sh`.
4. Reboot.
5. The machine should auto-login to the `iisu` user and launch the shell.

## Future ISO Flow

The current image builder does this:

1. Builds a minimal Debian root filesystem.
2. Installs the live package list from `os/debian/live-build/config/package-lists/iisu-os.list.chroot`.
3. Copies the shell into `/opt/iisu-os/shell`.
4. Enables the kiosk session.
5. Outputs an ISO.

Possible tools:

- Debian live-build
- Calamares for graphical installation later
- systemd services for first-boot setup later

## Build The ISO From Windows

Run this from PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-iso-wsl.ps1
```

The script installs build dependencies inside WSL, then writes:

```text
dist/iisu-os-lite-amd64-trixie.iso
dist/iisu-os-lite-amd64-trixie.iso.sha256
```

The live-build working directory is `/tmp/iisu-os-live-build` because live-build refuses to run from a path containing spaces.

The current WSL build disables live-build's generated security mirror because the Ubuntu-packaged live-build version still emits the old Debian security suite format for `trixie`.

Automatic firmware discovery is also disabled because this live-build version tries to fetch a legacy `Contents-amd64.gz` path. Hardware firmware needed for the Acer target should be listed explicitly in `os/debian/live-build/config/package-lists/iisu-os.list.chroot`.

The live image pins `--initsystem systemd` so live-build installs `live-config-systemd` instead of the sysvinit backend.

The Debian installer is disabled with `--debian-installer false`; `none` is not accepted by the Ubuntu-packaged live-build version.

The build script also rewrites live-build's ISOLINUX template during the build because the packaged template points at old Syslinux paths. The replacement files come from the WSL packages `isolinux` and `syslinux-common`.

A small `/usr/bin/rsvg` compatibility wrapper is included because this live-build version calls the removed `rsvg` command while modern Debian provides `rsvg-convert`.

The live image uses GRUB2 instead of Syslinux or legacy GRUB because the Ubuntu-packaged live-build Syslinux stage still assumes legacy gfxboot files, and legacy GRUB still assumes removed `stage2_eltorito` files.

The image is emitted as a plain ISO instead of `iso-hybrid` because `isohybrid` is a Syslinux post-processor and fails against the GRUB2 boot image. Rufus can still write this ISO for UEFI testing.

UEFI boot support is added by `os/debian/live-build/config/hooks/0200-uefi-boot.binary`. That hook creates `boot/grub/efi.img` with a standard `EFI/BOOT/BOOTX64.EFI` loader and also exposes the loader at `/EFI/BOOT/BOOTX64.EFI` for Rufus ISO mode.

After live-build finishes, `scripts/build-iso.sh` rebuilds the final ISO with `xorriso -as mkisofs` so the boot catalog contains both the BIOS GRUB image and the UEFI EFI image. This avoids relying on unsupported extension variables in the old Ubuntu-packaged live-build scripts.

## Current Test Command

On Windows with WSL installed:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\smoke-test.ps1
```

On Linux or WSL directly:

```bash
bash tests/smoke-test.sh
```

This creates a non-destructive staged install at `build/stage-root`.

## Non-Goals For The First Image

- Do not bundle games.
- Do not bundle BIOS files.
- Do not require Steam login during OS installation.
- Do not require an online account for local library usage.
