// Tabs are switched client-side; each tab is a view of the single page.
document.querySelectorAll(".tabs button").forEach((btn) => {
  btn.addEventListener("click", () => {
    document.querySelectorAll(".view").forEach((v) => (v.style.display = "none"));
    document.getElementById(btn.dataset.tab).style.display = "block";
  });
});

async function loadReminders() {
  const res = await fetch("/api/reminders");
  const reminders = await res.json();
  const today = document.getElementById("today");
  const all = document.getElementById("all");
  today.innerHTML = "";
  all.innerHTML = "";
  reminders.forEach((r) => {
    const row = `<div class="reminder ${r.done ? "done" : ""}">
      <span>${r.title} — ${r.due}</span>
      <button onclick="markDone(${r.id})">Done</button>
    </div>`;
    all.innerHTML += row;
    if (!r.done) today.innerHTML += row;
  });
}

async function markDone(id) {
  await fetch(`/api/reminders/${id}/done`, { method: "POST" });
  loadReminders();
}

document.getElementById("save").addEventListener("click", () => {
  alert("Saved " + document.getElementById("notify-time").value);
});

loadReminders();
