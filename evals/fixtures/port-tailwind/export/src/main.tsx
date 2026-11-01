import { createRoot } from "react-dom/client";
import { BrowserRouter, Route, Routes } from "react-router-dom";
import "./index.css";
import AllReminders from "./pages/AllReminders";
import Today from "./pages/Today";

createRoot(document.getElementById("root")!).render(
  <BrowserRouter>
    <Routes>
      <Route path="/" element={<Today />} />
      <Route path="/all" element={<AllReminders />} />
    </Routes>
  </BrowserRouter>,
);
