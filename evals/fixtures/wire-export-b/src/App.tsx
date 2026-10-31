import { reminders } from "./mock";

export default function App() {
  return (
    <main>
      <h1>Reminders</h1>
      <ul>
        {reminders.map((r) => (
          <li key={r.id}>{r.name}, {r.dueDate} {r.isDone ? "done" : <button>Done</button>}</li>
        ))}
      </ul>
    </main>
  );
}
