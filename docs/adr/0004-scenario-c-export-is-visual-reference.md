# Scenario C Design export is a visual reference, whatever its framework

Supersedes ADR-0002. Research (`docs/research/2026-10-27-design-tools-vercel-tunnels.md`) found that neither supported Design tool returns plain HTML + CSS: Lovable offers no framework choice (TanStack Start, older apps React + Vite) and Google AI Studio Build defaults to React with a Node server, so ADR-0002's ingest rule would reject almost every real Design export. In Scenario C we therefore accept any Design export and treat it as a visual reference: `design-port` reads its source statically, never installs, builds or runs it, extracts the look of each Screen (markup structure, style values with Tailwind resolved through the export's own config, design tokens mapped onto the project's existing ones, copy, displayed states, and interaction intent in plain English) and rebuilds it in the project's existing templates and styles. Everything else in the export (state, hooks, routing, fetching, mock data, auth, backend, build config, dependencies) is discarded. ADR-0002's objection still holds for translating components; it does not apply to extracting values that can be read directly from source.

## Considered Options

- Keep HTML + CSS only and rely on the Design prompt to force it: untested for AI Studio and not possible for Lovable, so the Stakeholder would stall at ingest.
- Accept React but build it to static HTML first: needs Node and running generated code on the Stakeholder's machine, and TanStack Start does not build to static files.

## Consequences

- The Design prompt for Scenario C asks for the look only and prefers plain HTML + CSS, but no longer forbids frameworks.
- Ingest under Scenario C stops only when the Design export holds no Screen; it reports the framework it found.
- A Screen is a page or route of the export (or a named view inside one); the planner's Screens table points at its route file.
- Interactions that need data or behaviour the backend lacks are listed as "Not ported", never invented. Icons come from the project's set or are inlined as SVG; no package is added.
- Values that cannot be resolved statically are reported and replaced with the nearest existing token, not guessed.
