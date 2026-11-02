import { reminders } from "../data";

export default function TodayTimeline() {
  return (
    <main className="mx-auto max-w-xl bg-slate-900 p-8 text-slate-100">
      <h1 className="mb-6 text-2xl font-light">Today</h1>
      <ol className="border-l border-slate-600 pl-6">
        {reminders.filter((r) => !r.done).map((r) => (
          <li key={r.id} className="mb-8">
            <p className="text-xs uppercase text-slate-400">Due {r.due}</p>
            <p className="mb-2 text-lg">{r.title}</p>
            <button className="mr-2 rounded bg-emerald-500 px-3 py-1 text-slate-900">Done</button>
            <button onClick={() => alert("Snoozed for one hour")} className="rounded border border-slate-500 px-3 py-1">Snooze</button>
          </li>
        ))}
      </ol>
    </main>
  );
}
