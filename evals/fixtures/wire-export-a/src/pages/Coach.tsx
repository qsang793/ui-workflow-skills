const streaks = [{ habit: "Morning run", days: 12 }];

async function askCoach(question: string) {
  const res = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: { Authorization: `Bearer ${import.meta.env.VITE_OPENAI_API_KEY}` },
    body: JSON.stringify({ input: question }),
  });
  return res.json();
}

export default function Coach() {
  return (
    <section>
      <h1>Coach</h1>
      <p>{streaks[0].habit}: {streaks[0].days} days</p>
      <button onClick={() => askCoach("How am I doing?")}>Ask the coach</button>
    </section>
  );
}
