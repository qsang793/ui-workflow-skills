# Scenario C Design export is a visual reference, whatever its framework

Supersedes ADR-0002. Research (`docs/research/2026-10-27-design-tools-vercel-tunnels.md`) found that we cannot rely on getting plain HTML + CSS from a Design tool: Lovable offers no framework choice (TanStack Start, older apps React + Vite), Google AI Studio Build defaults to React with a Node server, and whether a prompt can force plain HTML is untested. ADR-0002's ingest rule would therefore reject most real Design exports. In Scenario C we accept any Design export and treat it as a visual reference: `design-port` reads its source statically, never installs, builds or runs it, extracts the look of each Screen (markup structure, style values with Tailwind resolved through the export's own config, design tokens mapped onto the project's existing ones, copy, displayed states, and interaction intent in plain English) and rebuilds it in the project's existing templates and styles. The export's runtime (state, hooks, routing, fetching, mock data, auth, backend, build config, dependencies) is never carried into the project, though it may be read to understand states and meaning. ADR-0002's objection still holds for translating components; it does not apply to extracting values that can be read from source. That source alone is enough to rebuild the look is an assumption, to be tested by Porting one Screen of a real Lovable export before `design-port` is finished.

## Considered Options

- Keep HTML + CSS only and rely on the Design prompt to force it: untested for AI Studio and not possible for Lovable, so the Stakeholder would stall at ingest.
- Accept React but build or run it to read rendered HTML: needs Node and running generated code on the Stakeholder's machine, and TanStack Start does not build to static files.

## Consequences

- The Design prompt for Scenario C asks for the look only and prefers plain HTML + CSS, but no longer forbids frameworks. It records Required behaviour for the planner.
- A Screen is found from what the export renders, not from file names. Ingest stops only when it can find no Screen and the Stakeholder cannot point to one; it also asks for one screenshot per Screen, which the Stakeholder may skip.
- The planner checks displayed data and actions. Missing backend for displayed data or Required behaviour is a Blocker; a design-only action without backend is dropped or shown disabled, as the Stakeholder decides. No control may look active without working.
- The Stakeholder views each Ported Screen in the running target app, locally, before approving it; only the Design export is never run.
- A value that cannot be resolved statically becomes the project's default token for that role, reported for approval; values that affect layout or usability need a screenshot or a question first.
- Icons come from the project's set or are inlined as SVG; no package is added.
