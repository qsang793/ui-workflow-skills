import { BellRing, Share2 } from "lucide-react";
import { ReminderRow } from "../components/ReminderRow";
import { Button } from "../components/ui/button";
import { useDesignTheme } from "@/lib/design-runtime";
import { useReminders } from "../lib/mock";

export default function Today() {
  const { reminders, status, markDone } = useReminders();
  // The Design tool supplies these at runtime; the module is not part of this export.
  const { railWidth, mutedText } = useDesignTheme();
  const open = reminders.filter((r) => !r.done);

  return (
    <main className="mx-auto max-w-[56rem] p-gutter">
      <header className="mb-6 flex items-start justify-between">
        <div>
          <h1 className="text-3xl font-semibold">Today</h1>
          <p className="font-display italic" style={{ color: mutedText }}>
            What needs you now
          </p>
        </div>
        <Button variant="quiet">
          <Share2 className="mr-1 inline h-4 w-4" />
          Share list
        </Button>
      </header>

      <div className="flex flex-col gap-6 md:flex-row">
        <section aria-label="Reminders" className="min-w-0 flex-1">
          {status === "loading" && <p className="text-ink/60">Fetching your reminders…</p>}
          {status === "error" && (
            <p role="alert" className="rounded-xl bg-red-50 px-4 py-3 text-red-700">
              We could not load your reminders.
            </p>
          )}
          {status === "ready" && open.length === 0 && (
            <p className="rounded-xl border border-dashed border-line px-4 py-8 text-center text-ink/60">
              Nothing due. Enjoy the calm.
            </p>
          )}
          {status === "ready" && open.length > 0 && (
            <ul className="space-y-2">
              {open.map((r) => (
                <ReminderRow key={r.id} reminder={r} onDone={markDone} />
              ))}
            </ul>
          )}
        </section>

        <aside style={{ width: railWidth }} className="shrink-0 rounded-xl bg-ink p-gutter text-white">
          <BellRing className="mb-2 h-5 w-5" />
          <h2 className="text-lg font-semibold">At a glance</h2>
          <p className="mt-1 text-sm">{open.length} open</p>
        </aside>
      </div>
    </main>
  );
}
