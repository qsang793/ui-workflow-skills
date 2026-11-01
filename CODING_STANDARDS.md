# Coding standards

Read during review. Mechanical rules live in `scripts/validate.py`; these are the judgement calls.

## Evals

- A grader proves the outcome from what the run left behind. To prove "published as a preview", read the target the deploy got; a ban on `--prod` only supplements that, since the same outcome can come from a command with no flag.
- A case proves the path it names, so a run that stops early (missing login, missing tool) fails it. When a real tool cannot run in the sandbox, the fixture supplies a stand-in that behaves like the tool, including its surprising defaults.
- A fixture holds the shape of the failure it guards: a project with two checks to prove that both run.

## Skills

- A line that states how an external CLI or service behaves comes with a step that reads the result back, because defaults change between versions and project states.
