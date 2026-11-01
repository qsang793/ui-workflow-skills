import type { ButtonHTMLAttributes } from "react";

const VARIANTS = {
  primary: "bg-accent text-white hover:bg-accent/90 disabled:opacity-50",
  quiet: "border border-line text-ink hover:bg-line/40 disabled:opacity-50",
};

type Props = ButtonHTMLAttributes<HTMLButtonElement> & { variant?: keyof typeof VARIANTS };

export function Button({ variant = "primary", className = "", ...rest }: Props) {
  return (
    <button
      {...rest}
      className={`rounded-full px-3 py-1.5 text-sm font-semibold transition-colors focus:outline-none ${VARIANTS[variant]} ${className}`}
    />
  );
}
