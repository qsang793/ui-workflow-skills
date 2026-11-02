import ReactDOM from "react-dom/client";
import { createBrowserRouter, Navigate, RouterProvider } from "react-router-dom";
import TodayCompact from "./routes/TodayCompact";
import TodayCards from "./routes/TodayCards";
import TodayTimeline from "./routes/TodayTimeline";
import AllReminders from "./routes/AllReminders";
import Done from "./routes/Done";

const router = createBrowserRouter([
  { path: "/", element: <Navigate to="/today-compact" /> },
  { path: "/today-compact", element: <TodayCompact /> },
  { path: "/today-cards", element: <TodayCards /> },
  { path: "/today-timeline", element: <TodayTimeline /> },
  { path: "/all", element: <AllReminders /> },
  { path: "/done", element: <Done /> },
]);

ReactDOM.createRoot(document.getElementById("root")!).render(<RouterProvider router={router} />);
