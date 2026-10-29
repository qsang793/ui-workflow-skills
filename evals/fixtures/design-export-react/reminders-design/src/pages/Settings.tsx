export default function Settings() {
  return (
    <form className="space-y-4 rounded-xl bg-white p-6 shadow-sm">
      <h2 className="text-lg font-semibold text-slate-800">Settings</h2>
      <label className="block text-sm text-slate-600">
        Notification time
        <input type="time" className="mt-1 block w-full rounded-lg border border-slate-300 p-2" />
      </label>
      <button type="submit" className="rounded-lg bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700">
        Save
      </button>
    </form>
  );
}
