// The backend is a public API on its own host; set VITE_API_URL to point elsewhere.
export const API_URL = import.meta.env.VITE_API_URL ?? "https://api.reminders.example.com";

export async function listReminders() {
  const res = await fetch(`${API_URL}/reminders`);
  if (!res.ok) throw new Error(`Could not load reminders (${res.status})`);
  return res.json();
}
