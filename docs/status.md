# Status

All three Scenarios are Beta until a real end-to-end pilot passes ([#13](https://github.com/qsang793/ui-workflow-skills/issues/13)).

No Scenario has passed a real end-to-end run. Behavioural evals cover the skills on small fixtures ([evals/README.md](../evals/README.md)), but:

- One real Lovable export has gone through the workflow, in a pilot that stopped before an approved Preview ([report](pilots/2026-11-01-scenario-c-pilot.md)). It was an easy one, with one plain CSS file. No Google AI Studio export has, and neither has a Lovable export built on Tailwind classes. The Port rules were also tried on one Screen of a Google Stitch export ([note](research/2026-10-31-stitch-source-only-port-spike.md)) and on fixtures.
- The eval sandbox cannot open local ports or install real frameworks, so it does not reach a Screen viewed in the running app, a real framework build, or a live tunnel or Vercel link.

Scenario C becomes Production once its pilot passes; Scenarios A and B stay Beta (ADR-0001). The first pilot covered only the early steps of v0.1.0: [pilots/2026-05-21-retrospective.md](pilots/2026-05-21-retrospective.md). The second ran Scenario C on a private project with an agent as Stakeholder and stopped before approval, so the next one needs another project and a person.
