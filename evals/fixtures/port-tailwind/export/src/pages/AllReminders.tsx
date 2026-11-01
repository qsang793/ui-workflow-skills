import { ReminderRow } from "../components/ReminderRow";
import { useReminders } from "../lib/mock";

export default function AllReminders() {
  const { reminders, markDone } = useReminders();
  return (
    <main className="mx-auto max-w-[56rem] p-gutter">
      <h1 className="mb-1 text-3xl font-semibold">All reminders</h1>
      <p className="mb-6 text-ink/60">Everything on your list</p>
      <ul className="space-y-2">
        {reminders.map((r) => (
          <ReminderRow key={r.id} reminder={r} onDone={markDone} />
        ))}
      </ul>
    </main>
  );
}
