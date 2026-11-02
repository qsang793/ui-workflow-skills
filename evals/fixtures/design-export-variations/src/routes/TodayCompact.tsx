import { reminders } from "../data";

export default function TodayCompact() {
  return (
    <main className="mx-auto max-w-xl p-4">
      <h1 className="mb-2 text-lg font-semibold text-slate-900">Today</h1>
      <ul className="divide-y divide-slate-200">
        {reminders.filter((r) => !r.done).map((r) => (
          <li key={r.id} className="flex items-center justify-between py-2 text-sm">
            <span>{r.title} · Due {r.due}</span>
            <button className="text-emerald-700">Done</button>
          </li>
        ))}
      </ul>
    </main>
  );
}
