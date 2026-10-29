const reminders = [
  { id: 1, title: "Call the dentist", due: "Today" },
  { id: 3, title: "Renew passport", due: "Next week" },
];

export default function AllReminders() {
  return (
    <section>
      <h2 className="mb-3 text-lg font-semibold text-slate-800">All reminders</h2>
      <ul className="divide-y divide-slate-200 rounded-xl bg-white shadow-sm">
        {reminders.map((r) => (
          <li key={r.id} className="flex justify-between p-4">
            <span className="text-slate-800">{r.title}</span>
            <span className="text-sm text-slate-500">{r.due}</span>
          </li>
        ))}
      </ul>
    </section>
  );
}
