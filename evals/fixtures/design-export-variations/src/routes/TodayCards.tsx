import { reminders } from "../data";

export default function TodayCards() {
  return (
    <main className="mx-auto max-w-xl p-8">
      <h1 className="mb-6 text-3xl font-semibold text-slate-900">Today</h1>
      <ul className="space-y-4">
        {reminders.filter((r) => !r.done).map((r) => (
          <li key={r.id} className="rounded-2xl bg-white p-6 shadow">
            <p className="text-lg font-medium text-slate-800">{r.title}</p>
            <p className="mb-4 text-sm text-slate-500">Due {r.due}</p>
            <button className="rounded-lg bg-emerald-600 px-4 py-2 text-white">Done</button>
          </li>
        ))}
      </ul>
    </main>
  );
}
