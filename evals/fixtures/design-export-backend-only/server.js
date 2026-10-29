const express = require("express");

const app = express();
app.use(express.json());

const reminders = [{ id: 1, title: "Call the dentist", done: false }];

app.get("/api/reminders", (req, res) => res.json(reminders));
app.post("/api/reminders", (req, res) => {
  const reminder = { id: reminders.length + 1, done: false, ...req.body };
  reminders.push(reminder);
  res.status(201).json(reminder);
});

app.listen(3001);
