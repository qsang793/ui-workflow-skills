import { Check, Clock } from "lucide-react";
import { Button } from "./ui/button";
import type { Reminder } from "../lib/mock";

type Props = { reminder: Reminder; onDone: (id: number) => void };

export function ReminderRow({ reminder, onDone }: Props) {
  const snooze = () => {
    // interaction: push this reminder to tomorrow
    console.log("snooze", reminder.id);
  };
  return (
    <li className="flex items-center justify-between gap-3 rounded-xl border border-line bg-white px-gutter py-3 shadow-sm">
      <div>
        <p className="font-semibold">{reminder.title}</p>
        <p className="text-sm text-ink/60">Due {reminder.due}</p>
      </div>
      <div className="flex gap-2">
        <Button variant="quiet" onClick={snooze}>
          <Clock className="mr-1 inline h-4 w-4" />
          Snooze
        </Button>
        <Button onClick={() => onDone(reminder.id)}>
          <Check className="mr-1 inline h-4 w-4" />
          Done
        </Button>
      </div>
    </li>
  );
}
