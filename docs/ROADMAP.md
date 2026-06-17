# Roadmap

## Stage 3: iiSU OS Lite

Goal: make a low-end PC boot directly into the iiSU OS shell.

Planned work:

- Use Debian or Lubuntu as the base system.
- Create a dedicated `iisu` user with automatic login.
- Start a kiosk session instead of a normal desktop.
- Launch the iiSU OS shell from `/opt/iisu-os/shell/index.html`.
- Add emulator launch profiles later.
- Add a simple library scanner later.
- Add update hooks later.

This is not a full custom Linux distribution yet. It is a repeatable install profile that turns a normal Linux install into an iiSU OS appliance.

## Stage 4: Native iiSU OS Shell

Goal: build our own shell so iiSU OS does not depend on Android.

Initial shell principles:

- Gamepad-first navigation.
- Fast on 2 GB RAM hardware.
- No account requirement for local library usage.
- Clear separation between iiSU OS and the original iiSU project.
- Local games, Steam games, emulator entries, Direct archive, settings, and power controls in one UI.

First prototype:

- Static HTML/CSS/JS.
- No build tooling.
- Launchable in any browser.
- Suitable for a Linux kiosk session.

Later versions can move to a stronger native stack if the prototype outgrows static web tech.
