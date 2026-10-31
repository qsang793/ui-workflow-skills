const habits = [
  { id: 1, title: "Morning run", done: true },
  { id: 2, title: "Read 20 pages", done: false },
];

export default function Today() {
  return (
    <section>
      <h1>Today</h1>
      <ul>{habits.map((h) => <li key={h.id}>{h.title}</li>)}</ul>
    </section>
  );
}
