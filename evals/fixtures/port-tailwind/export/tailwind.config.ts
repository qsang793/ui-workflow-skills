import type { Config } from "tailwindcss";

export default {
  content: ["./index.html", "./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        canvas: "hsl(var(--canvas))",
        ink: "hsl(var(--ink))",
        line: "hsl(var(--line))",
        accent: "#0f766e",
      },
      spacing: { gutter: "1.75rem" },
      fontFamily: {
        display: ["Fraunces", "serif"],
        body: ["Inter", "sans-serif"],
      },
      borderRadius: { full: "0.75rem" },
    },
  },
} satisfies Config;
