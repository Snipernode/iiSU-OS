const panels = {
  library: {
    kicker: "Library",
    title: "No games indexed yet.",
    body: "The first real service will scan local folders and generate a library index."
  },
  steam: {
    kicker: "Steam",
    title: "Steam linking is planned.",
    body: "The long-term goal is to import installed Steam games and launch them from this shell."
  },
  directs: {
    kicker: "iiSU OS Direct",
    title: "Direct archive lives here.",
    body: "Future announcements, feature videos, and creator spotlights can be archived inside the system."
  },
  "controller-lab": {
    kicker: "Controller Lab",
    title: "Controller personality comes later.",
    body: "Profiles, speaker effects, motion rules, and fall-detection jokes belong in this area."
  },
  settings: {
    kicker: "Settings",
    title: "System settings are not wired yet.",
    body: "The kiosk build will eventually expose Wi-Fi, Bluetooth, display, storage, updates, and power options."
  }
};

const clock = document.querySelector("#clock");
const tiles = Array.from(document.querySelectorAll(".tile"));
const panelKicker = document.querySelector("#panel-kicker");
const panelTitle = document.querySelector("#panel-title");
const panelBody = document.querySelector("#panel-body");

function updateClock() {
  const now = new Date();
  clock.textContent = now.toLocaleTimeString([], {
    hour: "2-digit",
    minute: "2-digit"
  });
}

function showPanel(panelName) {
  const panel = panels[panelName] ?? panels.library;

  panelKicker.textContent = panel.kicker;
  panelTitle.textContent = panel.title;
  panelBody.textContent = panel.body;

  for (const tile of tiles) {
    tile.classList.toggle("is-active", tile.dataset.panel === panelName);
  }
}

function moveFocus(direction) {
  const currentIndex = tiles.indexOf(document.activeElement);
  const fallbackIndex = tiles.findIndex((tile) => tile.classList.contains("is-active"));
  const index = currentIndex >= 0 ? currentIndex : fallbackIndex;
  const nextIndex = (index + direction + tiles.length) % tiles.length;

  tiles[nextIndex].focus();
  tiles[nextIndex].click();
}

for (const tile of tiles) {
  tile.addEventListener("click", () => showPanel(tile.dataset.panel));
}

window.addEventListener("keydown", (event) => {
  if (event.key === "ArrowRight" || event.key === "ArrowDown") {
    event.preventDefault();
    moveFocus(1);
  }

  if (event.key === "ArrowLeft" || event.key === "ArrowUp") {
    event.preventDefault();
    moveFocus(-1);
  }
});

updateClock();
setInterval(updateClock, 1000);
