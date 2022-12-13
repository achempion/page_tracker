//
// Data structure
//

var presence = {
  url: window.location.href,
  presence_ms: 0,
  uuid: uuidv4(),
  last_sync: last_sync(),
};

//
// Presence logic
//

const pause = function () {
  updateElapsed();
  presence.last_sync = undefined;

  sync();
};

const resume = function (e) {
  if (presence.url == window.location.href) {
    presence.last_sync = presence.last_sync || last_sync();
  } else {
    // url changed. sync current page
    updateElapsed();
    sync();

    // set new presence
    if (e == "patch") {
      // treat patch actions in one liveview as same pageview
      presence.url = window.location.href;
    } else {
      presence = {
        url: window.location.href,
        presence_ms: 0,
        last_sync: last_sync(),
        uuid: uuidv4(),
      };
    }

    sync();
  }
};

const sync = function () {
  if (presence.presence_ms == 0) return;

  window.page_view_channel.push("sync", presence);
};

const updateElapsed = function () {
  if (!presence.last_sync) return;

  presence.presence_ms = presence.presence_ms + Date.now() - presence.last_sync;
  presence.last_sync = last_sync();
};

//
// Event bindings
//

setInterval(function () {
  if (!presence.last_sync) return;

  updateElapsed();
  sync();
}, 2000);

window.addEventListener("focus", resume);
window.addEventListener("blur", pause);
window.addEventListener("beforeunload", pause);
window.addEventListener("load", resume);
window.addEventListener("phx:page-loading-stop", function (e) {
  if (
    e?.type == "phx:page-loading-stop" &&
    ["patch", "redirect"].includes(e.detail.kind)
  ) {
    resume(e.detail.kind);
  }
});

//
// Helpers
//

function uuidv4() {
  return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, (c) =>
    (
      c ^
      (crypto.getRandomValues(new Uint8Array(1))[0] & (15 >> (c / 4)))
    ).toString(16)
  );
}

function last_sync() {
  return document.hasFocus() ? Date.now() : undefined;
}
