/* Simple stateful demo for a Group Holding Area */
(function () {
  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

  const listEl = $("#inmateList");
  const capacityBar = $("#capacityBar");
  const capacityText = $("#capacityText");
  const summaryText = $("#summaryText");
  const maxCapacityInput = $("#maxCapacity");
  const searchInput = $("#searchInput");
  const riskFilter = $("#riskFilter");
  const showProcessing = $("#showProcessing");
  const addBtn = $("#addBtn");
  const moveToProcessingBtn = $("#moveToProcessingBtn");
  const releaseBtn = $("#releaseBtn");

  const dialog = $("#inmateDialog");
  const form = $("#inmateForm");
  const dialogTitle = $("#dialogTitle");

  /*** Data ***/
  let state = {
    inmates: [],
    selected: new Set(),
    maxCapacity: Number(maxCapacityInput.value) || 12
  };

  async function loadData() {
    try {
      // Try loading external data.json
      const res = await fetch("./data.json", { cache: "no-store" });
      if (!res.ok) throw new Error("no data.json");
      const data = await res.json();
      state.inmates = normalize(data.inmates || []);
    } catch {
      // Fallback to inline seed data to avoid CORS/file-origin issues
      const seed = JSON.parse($("#seed-data").textContent);
      state.inmates = normalize(seed.inmates || []);
    }
    render();
  }

  function normalize(arr) {
    const now = new Date();
    return arr.map(x => ({
      id: x.id || crypto.randomUUID(),
      name: x.name || "Unknown",
      booking: x.booking || "",
      risk: x.risk || "low",
      notes: x.notes || "",
      status: x.status || "holding",
      checkIn: x.checkIn ? new Date(x.checkIn) : now
    }));
  }

  /*** Rendering ***/
  function render() {
    const q = searchInput.value.trim().toLowerCase();
    const risk = riskFilter.value;
    const includeProcessing = showProcessing.checked;

    const filtered = state.inmates.filter(x => {
      const matchesText =
        !q ||
        x.name.toLowerCase().includes(q) ||
        x.booking.toLowerCase().includes(q) ||
        x.notes.toLowerCase().includes(q);
      const matchesRisk = !risk || x.risk === risk;
      const matchesStatus =
        includeProcessing ? true : x.status === "holding";
      return matchesText && matchesRisk && matchesStatus;
    });

    listEl.innerHTML = "";
    filtered
      .sort((a, b) => a.checkIn - b.checkIn) // earliest first
      .forEach(item => listEl.appendChild(renderCard(item)));

    updateCapacity();
    updateSummary();
  }

  function renderCard(item) {
    const li = document.createElement("li");
    li.className = `card card--${item.risk} ${item.status !== "holding" ? "card--processing" : ""}`;
    li.dataset.id = item.id;

    const checked = state.selected.has(item.id) ? "checked" : "";
    li.innerHTML = `
      <div class="card__row">
        <label class="checkbox">
          <input type="checkbox" data-select ${checked} />
          <span></span>
        </label>
        <div class="card__title">
          <strong>${escapeHtml(item.name)}</strong>
          <span class="muted">Booking ${escapeHtml(item.booking)}</span>
        </div>
        <span class="pill pill--${item.risk}" title="Risk">${item.risk}</span>
      </div>
      <div class="card__row">
        <span class="muted" data-since="${item.checkIn.toISOString()}">—</span>
        <span class="muted">Status: ${item.status}</span>
      </div>
      <div class="card__notes">${escapeHtml(item.notes || "—")}</div>
      <div class="card__actions">
        <button class="btn btn--tiny" data-action="edit">Edit</button>
        ${
          item.status === "holding"
            ? '<button class="btn btn--tiny" data-action="toProcessing">To Processing</button>'
            : '<button class="btn btn--tiny" data-action="toHolding">Back to Holding</button>'
        }
        <button class="btn btn--tiny btn--danger" data-action="release">Release</button>
      </div>
    `;

    // Events
    li.addEventListener("change", (e) => {
      if (e.target.matches("[data-select]")) {
        if (e.target.checked) state.selected.add(item.id);
        else state.selected.delete(item.id);
        updateSummary();
      }
    });
    li.addEventListener("click", (e) => {
      const btn = e.target.closest("[data-action]");
      if (!btn) return;
      const action = btn.dataset.action;
      if (action === "edit") openEdit(item);
      if (action === "toProcessing") setStatus(item.id, "processing");
      if (action === "toHolding") setStatus(item.id, "holding");
      if (action === "release") remove(item.id);
    });

    return li;
  }

  function updateCapacity() {
    const holdingCount = state.inmates.filter(x => x.status === "holding").length;
    const max = state.maxCapacity || 1;
    const pct = Math.min(100, Math.round((holdingCount / max) * 100));

    capacityBar.style.width = pct + "%";
    capacityBar.dataset.level = pct >= 100 ? "full" : pct >= 80 ? "warn" : "ok";
    capacityText.textContent = `${holdingCount} / ${max} occupied`;
  }

  function updateSummary() {
    const count = state.selected.size;
    summaryText.textContent = `${count} selected`;
  }

  function tickTimers() {
    const now = Date.now();
    $$("[data-since]").forEach(el => {
      const since = new Date(el.getAttribute("data-since")).getTime();
      const diffMs = Math.max(0, now - since);
      el.textContent = "In area: " + humanize(diffMs);
    });
  }

  function humanize(ms) {
    const s = Math.floor(ms / 1000);
    const h = Math.floor(s / 3600);
    const m = Math.floor((s % 3600) / 60);
    const rem = s % 60;
    if (h) return `${h}h ${m}m`;
    if (m) return `${m}m ${rem}s`;
    return `${rem}s`;
  }

  /*** CRUD helpers ***/
  function openAdd() {
    dialogTitle.textContent = "Add Inmate";
    form.reset();
    form.id.value = "";
    dialog.showModal();
  }
  function openEdit(item) {
    dialogTitle.textContent = "Edit Inmate";
    form.name.value = item.name;
    form.booking.value = item.booking;
    form.risk.value = item.risk;
    form.notes.value = item.notes;
    form.id.value = item.id;
    dialog.showModal();
  }
  function saveFromForm(e) {
    e.preventDefault();
    const f = new FormData(form);
    const id = f.get("id");
    const data = {
      id: id || crypto.randomUUID(),
      name: String(f.get("name") || "").trim(),
      booking: String(f.get("booking") || "").trim(),
      risk: String(f.get("risk") || "low"),
      notes: String(f.get("notes") || "").trim(),
      status: "holding",
      checkIn: new Date()
    };
    if (!data.name || !data.booking) return;

    const idx = state.inmates.findIndex(x => x.id === id);
    if (idx >= 0) {
      // keep existing status/checkIn
      data.status = state.inmates[idx].status;
      data.checkIn = state.inmates[idx].checkIn;
      state.inmates[idx] = data;
    } else {
      state.inmates.push(data);
    }
    dialog.close();
    render();
  }

  function setStatus(id, status) {
    const item = state.inmates.find(x => x.id === id);
    if (!item) return;
    item.status = status;
    render();
  }

  function remove(id) {
    state.inmates = state.inmates.filter(x => x.id !== id);
    state.selected.delete(id);
    render();
  }

  // Bulk actions
  function bulkSetStatus(status) {
    state.selected.forEach(id => {
      const item = state.inmates.find(x => x.id === id);
      if (item) item.status = status;
    });
    state.selected.clear();
    render();
  }
  function bulkRelease() {
    state.inmates = state.inmates.filter(x => !state.selected.has(x.id));
    state.selected.clear();
    render();
  }

  /*** Events ***/
  addBtn.addEventListener("click", openAdd);
  moveToProcessingBtn.addEventListener("click", () => bulkSetStatus("processing"));
  releaseBtn.addEventListener("click", bulkRelease);
  form.addEventListener("submit", saveFromForm);

  [searchInput, riskFilter, showProcessing].forEach(el =>
    el.addEventListener("input", render)
  );
  maxCapacityInput.addEventListener("input", () => {
    state.maxCapacity = Math.max(1, Number(maxCapacityInput.value) || 1);
    updateCapacity();
  });

  // Start
  loadData();
  setInterval(tickTimers, 1000);

  /*** Util ***/
  function escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, s => ({
      "&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"
    }[s]));
  }
})();
