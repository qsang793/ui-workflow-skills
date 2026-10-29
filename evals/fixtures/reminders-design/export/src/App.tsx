import { useState } from "react";

type Reminder = { id: number; title: string; due: string; done: boolean };

const initialReminders: Reminder[] = [
  { id: 1, title: "Pay rent", due: "2026-11-01", done: false },
  { id: 2, title: "Call dentist", due: "2026-11-03", done: true },
  { id: 3, title: "Renew passport", due: "2026-11-10", done: false },
];

type View = "today" | "all" | "done";

export default function App() {
  const [view, setView] = useState<View>("today");
  const [reminders, setReminders] = useState(initialReminders);

  const markDone = (id: number) =>
    setReminders((rs) => rs.map((r) => (r.id === id ? { ...r, done: true } : r)));

  const Row = ({ r }: { r: Reminder }) => (
    <li className="flex items-center justify-between rounded-xl bg-white px-4 py-3 shadow-sm">
      <div>
        <p className={r.done ? "text-slate-400 line-through" : "font-medium text-slate-800"}>{r.title}</p>
        <p className="text-sm text-slate-500">Due {r.due}</p>
      </div>
      {!r.done && (
        <button onClick={() => markDone(r.id)} className="rounded-lg bg-emerald-600 px-3 py-1 text-white">
          Done
        </button>
      )}
    </li>
  );

  return (
    <main className="mx-auto max-w-xl p-6">
      <h1 className="mb-4 text-2xl font-semibold text-slate-900">Reminders</h1>
      <nav className="mb-6 flex gap-2">
        {(["today", "all", "done"] as View[]).map((v) => (
          <button
            key={v}
            onClick={() => setView(v)}
            className={view === v ? "rounded-full bg-slate-900 px-4 py-1 text-white" : "rounded-full px-4 py-1 text-slate-600"}
          >
            {v === "today" ? "Today" : v === "all" ? "All reminders" : "Done"}
          </button>
        ))}
      </nav>

      {view === "today" && (
        <ul className="space-y-2">
          {reminders.filter((r) => !r.done).map((r) => <Row key={r.id} r={r} />)}
        </ul>
      )}

      {view === "all" && (
        <ul className="space-y-2">
          {reminders.map((r) => <Row key={r.id} r={r} />)}
        </ul>
      )}

      {view === "done" && (
        <ul className="space-y-2">
          {reminders.filter((r) => r.done).map((r) => <Row key={r.id} r={r} />)}
        </ul>
      )}
    </main>
  );
}
