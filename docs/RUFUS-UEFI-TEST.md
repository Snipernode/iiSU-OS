# Rufus UEFI Test Plan

iiSU OS now has an early live-build ISO path.

Use this checklist after building `dist/iisu-os-lite-amd64-trixie.iso`.

## Rufus Settings

Recommended first test:

- Boot selection: iiSU OS ISO/image
- Partition scheme: GPT
- Target system: UEFI, non-CSM
- File system: FAT32 if Rufus allows it
- Cluster size: default
- Image mode: DD mode is preferred for current test builds. If Rufus shows NTFS for ISO mode, cancel and use DD mode instead.

## Acer AO1-431 Firmware Steps

1. Back up anything important from the Acer.
2. Plug in AC power.
3. Insert the Rufus-created USB drive.
4. Power on and press `F2` for firmware setup.
5. Enable the `F12` boot menu if it is disabled.
6. Disable Secure Boot for early iiSU OS test builds.
7. Save and reboot.
8. Press `F12`.
9. Choose the USB entry that starts with `UEFI:`.

## Pass Criteria

The UEFI smoke test passes if:

- The firmware shows the USB as a UEFI boot option.
- The bootloader starts without falling back to legacy BIOS/CSM.
- The iiSU OS shell starts or the installer reaches its first screen.

## Fail Criteria

The test fails if:

- Only a non-UEFI USB entry appears.
- Secure Boot blocks the bootloader.
- The bootloader starts but cannot find the Linux kernel or root filesystem.
- The system reaches a black screen before logs can be collected.

## Notes

Secure Boot support should be treated as a later milestone. The first target is unsigned UEFI boot with Secure Boot disabled.
