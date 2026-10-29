import { listReminders } from "./api.js";

const list = document.getElementById("reminders");

function addItem(text) {
  const li = document.createElement("li");
  li.textContent = text;
  list.append(li);
}

listReminders()
  .then((reminders) => reminders.forEach((r) => addItem(`${r.title} — ${r.due}`)))
  .catch((err) => addItem(err.message));
