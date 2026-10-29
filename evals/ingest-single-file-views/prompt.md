---
name: ingest-single-file-views
tags: [ingest, scenario-c, screens]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Skill, Read, Glob, Grep, Bash, Write, Edit]
---
Here's the code Google AI Studio gave me. Skip the screenshots.

`index.html`:

```html
<!doctype html>
<html lang="en">
  <body>
    <div id="root"></div>
    <script type="module" src="/index.tsx"></script>
  </body>
</html>
```

`index.tsx`:

```tsx
import { createRoot } from "react-dom/client";
import App from "./App";

createRoot(document.getElementById("root")!).render(<App />);
```

`App.tsx`:

```tsx
import { useState } from "react";

type View = "today" | "all" | "settings";

export default function App() {
  const [view, setView] = useState<View>("today");
  return (
    <div className="min-h-screen bg-slate-50">
      <nav className="flex gap-2 bg-indigo-600 p-4 text-white">
        <button onClick={() => setView("today")}>Today</button>
        <button onClick={() => setView("all")}>All reminders</button>
        <button onClick={() => setView("settings")}>Settings</button>
      </nav>
      {view === "today" && (
        <ul className="p-6">
          <li className="rounded-xl bg-white p-4 shadow-sm">Call the dentist</li>
        </ul>
      )}
      {view === "all" && (
        <table className="m-6 w-full rounded-xl bg-white">
          <tbody>
            <tr><td>Call the dentist</td><td>Today</td></tr>
            <tr><td>Renew passport</td><td>Next week</td></tr>
          </tbody>
        </table>
      )}
      {view === "settings" && (
        <form className="m-6 space-y-4 rounded-xl bg-white p-6">
          <label>Notification time <input type="time" /></label>
          <button className="rounded-lg bg-indigo-600 px-4 py-2 text-white">Save</button>
        </form>
      )}
    </div>
  );
}
```
