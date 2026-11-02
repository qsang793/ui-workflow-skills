import { reminders } from "../data";

export default function AllReminders() {
  return (
    <main className="mx-auto max-w-xl p-8">
      <h1 className="mb-6 text-3xl font-semibold text-slate-900">All reminders</h1>
      <ul className="space-y-4">
        {reminders.map((r) => (
          <li key={r.id} className="rounded-2xl bg-white p-6 shadow">
            <p className={r.done ? "text-slate-400 line-through" : "text-lg font-medium text-slate-800"}>{r.title}</p>
            <p className="text-sm text-slate-500">Due {r.due}</p>
            {!r.done && <button className="mt-4 rounded-lg bg-emerald-600 px-4 py-2 text-white">Done</button>}
          </li>
        ))}
      </ul>
    </main>
  );
}
