# iiSU OS Shell

This is the first native iiSU OS shell prototype.

It is intentionally plain HTML, CSS, and JavaScript:

- no build step
- no package manager
- works locally in a browser
- can run in a Linux kiosk session

Open `index.html` to test it.

The next implementation step is adding real launcher actions through a small local service, such as a Python, Go, or Rust process that starts emulators and indexes the library.
