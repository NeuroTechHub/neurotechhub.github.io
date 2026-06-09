(function () {
  function todayISO() {
    var d = new Date();
    var y = d.getFullYear();
    var m = String(d.getMonth() + 1).padStart(2, "0");
    var day = String(d.getDate()).padStart(2, "0");
    return y + "-" + m + "-" + day;
  }

  function classifyGrid(grid, mode) {
    var limitAttr = grid.dataset.classifyLimit;
    var limit = limitAttr ? parseInt(limitAttr, 10) : Infinity;
    var today = todayISO();
    var cards = Array.prototype.slice.call(grid.querySelectorAll(".event-card"));
    var kept = 0;
    cards.forEach(function (card) {
      var d = card.dataset.eventDate;
      var dateMatch = mode === "upcoming" ? d >= today : d < today;
      if (d && dateMatch && kept < limit) {
        kept++;
      } else {
        card.setAttribute("data-classifier-hidden", "true");
      }
    });
    grid.classList.remove("needs-classify");
    return kept;
  }

  function classifyEventCtas() {
    var today = todayISO();
    document.querySelectorAll("[data-event-cta]").forEach(function (w) {
      var d = w.dataset.eventDate;
      var isPast = !!d && d < today;
      w.querySelectorAll("[data-show-when]").forEach(function (el) {
        var when = el.dataset.showWhen;
        var show =
          (when === "upcoming" && !isPast) || (when === "past" && isPast);
        if (!show) el.style.display = "none";
      });
      w.classList.remove("needs-classify");
    });
  }

  function run() {
    document
      .querySelectorAll('[data-classify="upcoming"]')
      .forEach(function (g) {
        var count = classifyGrid(g, "upcoming");
        var emptyId = g.dataset.emptyState;
        if (count === 0 && emptyId) {
          var empty = document.getElementById(emptyId);
          g.style.display = "none";
          if (empty) empty.style.display = "";
        }
      });
    document.querySelectorAll('[data-classify="past"]').forEach(function (g) {
      classifyGrid(g, "past");
    });
    classifyEventCtas();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", run);
  } else {
    run();
  }
})();
