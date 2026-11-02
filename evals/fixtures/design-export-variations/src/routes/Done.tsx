import { reminders } from "../data";

export default function Done() {
  return (
    <main className="mx-auto max-w-xl p-8">
      <h1 className="mb-6 text-3xl font-semibold text-slate-900">Done</h1>
      <ul className="space-y-4">
        {reminders.filter((r) => r.done).map((r) => (
          <li key={r.id} className="rounded-2xl bg-white p-6 text-slate-400 line-through shadow">
            {r.title} · Due {r.due}
          </li>
        ))}
      </ul>
    </main>
  );
}
