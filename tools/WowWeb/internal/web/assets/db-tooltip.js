// Hover tooltips for item links.
//
// Every item link on a database page links to /db/items/{entry}; this fetches
// the same item rendered as a small box (/db/items/{entry}/tooltip, a fragment
// of the item template's markup) and floats it next to the pointer.
//
// A few decisions worth stating, because each one is a thing that goes wrong in
// tooltip code:
//
//   - The fetch waits for the pointer to rest. A loot table can list two hundred
//     items and sweeping the mouse across it must not fire two hundred requests.
//   - The answer is cached per entry, and a request in flight is aborted when
//     the pointer moves on, so a slow page cannot show the tooltip of the row
//     the pointer left three rows ago.
//   - The box is filled with the response body. That is server-rendered markup
//     for one item, escaped by html/template on the way out, fetched from the
//     same origin - the same content the item page shows. No part of it is built
//     here from a string, which is what keeps this from being an injection
//     surface.
//   - Nothing is loaded on a touch screen: there is no hover to answer, and a
//     tap already follows the link.
//   - The tooltip does not replace the link or change focus. Without this script
//     the pages read exactly as they did before.
(function () {
  "use strict";

  if (!window.fetch || !window.PointerEvent) {
    return;
  }
  if (window.matchMedia && window.matchMedia("(hover: none)").matches) {
    return;
  }

  var REST_MS = 140; // how long the pointer must stay on a link
  var MARGIN = 12;   // keep this far from the window edge
  var OFFSET = 14;   // and this far from the pointer

  var pathPattern = /^\/db\/items\/(\d+)\/?$/;
  var cache = new Map();
  var box = null;
  var timer = null;
  var pointer = null;
  var current = null;   // the link the box belongs to
  var controller = null;

  function itemEntry(link) {
    var match = pathPattern.exec(link.getAttribute("href") || "");
    return match ? match[1] : null;
  }

  // The host is the element this script positions; the tooltip markup inside it
  // carries the .tt class from the template. They must not be the same element:
  // a positioned box inside a positioned host escapes the host, and the host
  // then collapses because its only child is out of flow.
  function ensureBox() {
    if (!box) {
      box = document.createElement("div");
      box.className = "tt-host";
      box.setAttribute("aria-hidden", "true");
      document.body.appendChild(box);
    }
    return box;
  }

  function place(x, y) {
    var el = ensureBox();
    // Park it at the pointer first, then measure, then correct. The box has to
    // be laid out with its new content before its size means anything, and
    // measuring it where it happens to be left from the last hover would size it
    // against the previous tooltip's text.
    el.style.left = x + "px";
    el.style.top = y + "px";
    var rect = el.getBoundingClientRect();

    // Try the pointer's bottom-right, then the other side, then clamp. The
    // clamp is what keeps a box attached to a link that is half off the screen
    // from landing outside it: flipping alone only ever moves it by its own
    // size, which is not enough when the pointer is further out than that.
    var left = x + OFFSET;
    if (left + rect.width + MARGIN > window.innerWidth) {
      left = x - rect.width - OFFSET;
    }
    var top = y + OFFSET;
    if (top + rect.height + MARGIN > window.innerHeight) {
      top = y - rect.height - OFFSET;
    }

    var maxLeft = window.innerWidth - rect.width - MARGIN;
    var maxTop = window.innerHeight - rect.height - MARGIN;
    // A box taller than the window keeps its top margin and is simply cut off at
    // the bottom, rather than being pushed up until its first line is unreadable.
    left = Math.max(MARGIN, Math.min(left, maxLeft));
    top = Math.max(MARGIN, Math.min(top, Math.max(MARGIN, maxTop)));

    el.style.left = Math.round(left) + "px";
    el.style.top = Math.round(top) + "px";
  }

  // placeAtElement anchors the box to a link instead of to the pointer, which is
  // what keyboard focus needs: there is no pointer position to use.
  function placeAtElement(link) {
    var rect = link.getBoundingClientRect();
    place(rect.right, rect.bottom);
  }

  function show(link, html) {
    var el = ensureBox();
    if (current === link && el.innerHTML === html) {
      return;
    }
    el.innerHTML = html;
    el.style.display = "block";  // .tt-host is display: none until it has content
    current = link;
    if (pointer) {
      place(pointer.x, pointer.y);
    } else {
      placeAtElement(link);
    }
  }

  function hide() {
    if (timer) {
      clearTimeout(timer);
      timer = null;
    }
    if (controller) {
      controller.abort();
      controller = null;
    }
    if (current) {
      current = null;
    }
    if (box) {
      box.style.display = "none";
      box.innerHTML = "";
    }
  }

  function load(link, entry) {
    if (cache.has(entry)) {
      show(link, cache.get(entry));
      return;
    }
    if (controller) {
      controller.abort();
    }
    controller = new AbortController();
    var signal = controller.signal;
    fetch("/db/items/" + entry + "/tooltip", {
      signal: signal,
      headers: { "X-Requested-With": "db-tooltip" }
    })
      .then(function (response) {
        if (!response.ok) {
          throw new Error("tooltip " + response.status);
        }
        return response.text();
      })
      .then(function (html) {
        cache.set(entry, html);
        // The pointer may have left while this was in flight.
        if (!signal.aborted) {
          show(link, html);
        }
      })
      .catch(function () {
        // A tooltip is a convenience: a failed fetch leaves the link alone and
        // says nothing, rather than showing a broken box or an error.
      });
  }

  function linkFrom(event) {
    var node = event.target;
    if (!node || !node.closest) {
      return null;
    }
    var link = node.closest("a[href]");
    if (!link || link.classList.contains("tt-name")) {
      return null;
    }
    return itemEntry(link) ? link : null;
  }

  document.addEventListener("pointerover", function (event) {
    var link = linkFrom(event);
    if (!link) {
      return;
    }
    pointer = { x: event.clientX, y: event.clientY };
    if (current === link) {
      return;
    }
    if (timer) {
      clearTimeout(timer);
    }
    var entry = itemEntry(link);
    timer = setTimeout(function () {
      timer = null;
      load(link, entry);
    }, REST_MS);
  });

  document.addEventListener("pointermove", function (event) {
    pointer = { x: event.clientX, y: event.clientY };
  });

  document.addEventListener("pointerout", function (event) {
    if (linkFrom(event)) {
      hide();
    }
  });

  // Keyboard: focusing a link shows the same box, anchored to the link.
  document.addEventListener("focusin", function (event) {
    var link = linkFrom(event);
    pointer = null;
    if (link) {
      load(link, itemEntry(link));
    }
  });
  document.addEventListener("focusout", hide);

  // A tooltip left behind by a click or a scroll is worse than none.
  document.addEventListener("scroll", hide, true);
  window.addEventListener("resize", hide);
})();
