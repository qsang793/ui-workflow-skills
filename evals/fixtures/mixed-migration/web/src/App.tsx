import { useEffect, useState } from "react";

type Reminder = { id: number; title: string; done: boolean };

// New dashboard, started in React. Only this page has been moved so far.
export function App() {
  const [reminders, setReminders] = useState<Reminder[]>([]);
  useEffect(() => {
    fetch("/api/reminders").then((r) => r.json()).then(setReminders);
  }, []);
  return (
    <ul>
      {reminders.map((r) => (
        <li key={r.id}>{r.title}</li>
      ))}
    </ul>
  );
}
