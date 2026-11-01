import { useEffect, useState } from "react";

export type Reminder = { id: number; title: string; due: string; done: boolean; assignee: string };

const MOCK: Reminder[] = [
  { id: 1, title: "Water the ferns", due: "2026-11-02", done: false, assignee: "Mai" },
  { id: 2, title: "Book the vet", due: "2026-11-04", done: false, assignee: "Tuan" },
  { id: 3, title: "Return library books", due: "2026-10-30", done: true, assignee: "Mai" },
];

export function useReminders() {
  const [reminders, setReminders] = useState<Reminder[]>([]);
  const [status, setStatus] = useState<"loading" | "error" | "ready">("loading");
  useEffect(() => {
    const timer = setTimeout(() => {
      setReminders(MOCK);
      setStatus("ready");
    }, 300);
    return () => clearTimeout(timer);
  }, []);
  const markDone = (id: number) =>
    setReminders((rs) => rs.map((r) => (r.id === id ? { ...r, done: true } : r)));
  return { reminders, status, markDone };
}
