const reminders = [
  { id: 1, title: "Call the dentist", done: false },
  { id: 2, title: "Pay rent", done: true },
];

export default function Today() {
  return (
    <section className="space-y-3">
      <h2 className="text-lg font-semibold text-slate-800">Today</h2>
      {reminders.map((r) => (
        <label key={r.id} className="flex items-center gap-3 rounded-xl bg-white p-4 shadow-sm">
          <input type="checkbox" defaultChecked={r.done} className="h-5 w-5 accent-indigo-600" />
          <span className={r.done ? "text-slate-400 line-through" : "text-slate-800"}>{r.title}</span>
        </label>
      ))}
    </section>
  );
}
