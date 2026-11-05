# Status

All three Scenarios are Beta until a real end-to-end pilot passes ([#13](https://github.com/qsang793/ui-workflow-skills/issues/13)).

No Scenario has passed a real end-to-end run. Behavioural evals cover the skills on small fixtures ([evals/README.md](../evals/README.md)), but:

- Fixture evaluations cover selected workflow behavior; they do not establish comprehensive export compatibility or end-to-end acceptance. No Google AI Studio export, and no Lovable export built on Tailwind classes, has gone through the workflow outside fixtures.
- The eval sandbox cannot open local ports or install real frameworks, so it does not establish behavior in a running app, a framework build, or a live tunnel or Vercel link.

Scenario C becomes Production once its real end-to-end pilot passes; Scenarios A and B stay Beta (ADR-0001). Human usability remains unverified.
