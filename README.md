# iiSU OS

iiSU OS is a community-made console-style operating system project for low-end PCs.

The goal is simple: turn a small laptop or mini PC into a dedicated game-first machine that boots straight into an iiSU-style shell instead of a normal desktop.

## Important Notice

iiSU OS is not the original iiSU Android frontend.

This project is not made by the original iiSU team, does not represent them, and does not announce features for iiSU itself. It is a separate community OS project inspired by the idea of a clean, controller-friendly gaming interface.

## What It Does Right Now

- Boots into a full-screen iiSU OS shell.
- Targets low-end x86-64 PCs like the Acer Aspire One AO1-431 / Cloudbook 14 class hardware.
- Builds a Rufus-testable Debian-based ISO.
- Supports UEFI boot with Secure Boot disabled.
- Includes Wine support for 64-bit Windows `.exe` files.
- Keeps games, ROMs, BIOS files, and user content out of the repo.

## Target Hardware

The first target machine is:

- Acer Aspire One AO1-431 / Cloudbook 14 class hardware
- Intel Celeron N3050 or similar
- 2 GB RAM
- 32 GB or 64 GB eMMC storage
- 1366x768 display

Other x86-64 PCs may work, but this project is being shaped around lightweight hardware first.

## Try It On A USB Drive

Build the ISO from Windows with WSL installed:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-iso-wsl.ps1
```

The ISO will be created at:

```text
dist/iisu-os-lite-amd64-trixie.iso
```

Use Rufus with:

- Boot selection: the iiSU OS ISO
- Partition scheme: GPT
- Target system: UEFI, non-CSM
- File system: FAT32 if available
- Image mode: ISO mode first, DD mode only if ISO mode fails

On the Acer, disable Secure Boot, enable the `F12` boot menu, then choose the USB option that starts with `UEFI:`.

## Windows EXE Support

iiSU OS runs Windows `.exe` files through Wine:

```bash
iisu-run-exe /path/to/program.exe
```

This is not CPU emulation. Wine runs x86-64 Windows programs on the same x86-64 processor through a Windows compatibility layer.

Current limitation: this build targets 64-bit Windows `.exe` files. Many older 32-bit games need Wine32/i386 multiarch support, which is planned as a later milestone.

## What Is Not Included

- No games.
- No ROMs.
- No BIOS files.
- No Steam account setup.
- No Secure Boot signing yet.
- No guarantee that every Windows `.exe` works.

## Project Status

This is an early iiSU OS Lite prototype. It is not ready to replace a daily-use operating system.

The current milestone is to prove that a low-end PC can boot directly into a console-like shell, launch local content, and support a future game library interface.

## Useful Docs

- [Image Build Notes](docs/IMAGE-BUILD.md)
- [Rufus UEFI Test Plan](docs/RUFUS-UEFI-TEST.md)
- [Windows EXE Support](docs/WINDOWS-EXE-SUPPORT.md)
- [Acer AO1-431 Hardware Notes](docs/HARDWARE-AO1-431.md)
- [Legal Notice](docs/LEGAL-NOTICE.md)
- [Roadmap](docs/ROADMAP.md)

## License

iiSU OS is licensed under the MIT License. See [LICENSE](LICENSE).
