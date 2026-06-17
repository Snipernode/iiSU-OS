# Windows EXE Support

iiSU OS Lite supports Windows `.exe` files through Wine.

This is not CPU emulation. On the Acer AO1-431 class hardware, Wine runs x86-64 Windows code on the same x86-64 CPU and provides a Windows API compatibility layer.

## What Works In This Milestone

- 64-bit Windows `.exe` files.
- Lightweight tools and older/low-end Windows games that work in Wine.
- Launching from a stable OS command:

```bash
iisu-run-exe /path/to/program.exe
```

The wrapper uses this Wine prefix by default:

```text
~/.local/share/iisu-os/wineprefix
```

Set `IISU_WINEPREFIX` to use a different prefix.

## What This Is Not

- It is not true Linux-native execution of Windows PE files.
- It is not Windows.
- It is not guaranteed compatibility for every `.exe`.
- It does not currently include 32-bit Windows/i386 support.

## 32-Bit EXE Support Later

Many older Windows games are 32-bit. Supporting them correctly requires adding Debian i386 multiarch packages such as `wine32:i386` during image build.

That should be a separate milestone because it increases ISO size and can break package resolution if the live-build chroot is not configured carefully before package installation.
