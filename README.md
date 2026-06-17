# iiSU OS

iiSU OS is a community operating-system shell concept for dedicated retro and PC game machines.

This project is not the original iiSU Android frontend, is not made by the iiSU team, and does not represent their roadmap. The goal here is to build a Linux-based system that feels like a console: boot directly into a game-first shell, keep the desktop hidden, and make the whole machine feel like one coherent gaming environment.

## Current Direction

This repo is starting directly at stages 3 and 4:

1. Build an installable iiSU OS Lite setup for low-end PCs.
2. Build a native iiSU OS shell instead of depending on Android.

Stages 1 and 2, the Android-x86 prototype and launcher-only appliance mode, are intentionally skipped.

## Target Machine

Initial target:

- Acer Aspire One AO1-431 / Cloudbook 14 class hardware
- Intel Celeron N3050 or similar
- 2 GB RAM
- 32 GB or 64 GB eMMC
- 1366x768 display

The shell should stay lightweight enough for this hardware. Avoid heavy desktop stacks unless they are strictly needed.

## Repo Layout

- `shell/` contains the first iiSU OS shell prototype.
- `os/debian/` contains Linux kiosk-session and installation files.
- `docs/` contains roadmap, hardware, legal, Windows `.exe`, and image-build notes.

## Run The Shell Prototype

Open `shell/index.html` in a browser.

On the target OS image, the kiosk session will launch the same shell full-screen from `/opt/iisu-os/shell/index.html`.

## Test The Install Layout

On Windows with WSL installed:

```powershell
powershell -ExecutionPolicy Bypass -File .\tests\smoke-test.ps1
```

On Linux or WSL directly:

```bash
bash tests/smoke-test.sh
```

The smoke test stages a fake install at `build/stage-root`. It does not modify bootloaders, disks, users, or system services.

## Build A Rufus-Testable ISO

On Windows with WSL installed:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-iso-wsl.ps1
```

Expected output:

```text
dist/iisu-os-lite-amd64-trixie.iso
dist/iisu-os-lite-amd64-trixie.iso.sha256
```

## License

This repository is licensed under the MIT License. See `LICENSE`.
