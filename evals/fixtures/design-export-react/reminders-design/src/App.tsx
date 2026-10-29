import { BrowserRouter, NavLink, Route, Routes } from "react-router-dom";
import Today from "./pages/Today";
import AllReminders from "./pages/AllReminders";
import Settings from "./pages/Settings";

const tab = "px-4 py-2 rounded-lg text-sm font-medium";

export default function App() {
  return (
    <BrowserRouter>
      <header className="flex items-center justify-between bg-indigo-600 px-6 py-4 text-white">
        <h1 className="text-xl font-semibold">Reminders</h1>
        <nav className="flex gap-2">
          <NavLink to="/" className={tab}>Today</NavLink>
          <NavLink to="/all" className={tab}>All reminders</NavLink>
          <NavLink to="/settings" className={tab}>Settings</NavLink>
        </nav>
      </header>
      <main className="mx-auto max-w-2xl p-6">
        <Routes>
          <Route path="/" element={<Today />} />
          <Route path="/all" element={<AllReminders />} />
          <Route path="/settings" element={<Settings />} />
        </Routes>
      </main>
    </BrowserRouter>
  );
}
