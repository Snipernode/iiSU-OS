# Acer Aspire One AO1-431 Target Notes

The AO1-431 / Cloudbook 14 class machine is useful as a low-end target because it forces the shell to stay lean.

Expected constraints:

- Low-power Intel Celeron CPU.
- Usually 2 GB RAM.
- Usually 32 GB or 64 GB eMMC.
- Integrated Intel graphics.
- 1366x768 display.
- Limited internal storage.

## Practical Rules

- Prefer lightweight Linux packages.
- Avoid GNOME, KDE Plasma, Electron, and large background services for the first image.
- Store ROMs and large media on SD card or USB storage.
- Keep the shell cache small and easy to rebuild.
- Use a browser kiosk shell first because it is simple and reliable.

## Recommended Base

Start with Debian stable minimal or Lubuntu minimal.

Debian gives more control. Lubuntu gives a faster first install. The long-term image builder should target Debian because it is easier to automate cleanly.
