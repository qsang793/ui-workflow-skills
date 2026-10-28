# UI Workflow

A skill bundle that lets a non-technical person drive UI improvement of an existing or new project, using an external AI design tool for the visuals and Claude Code for everything around it.

## People

**Stakeholder**:
The non-technical person who drives the workflow, answers the interview and approves the result.
_Avoid_: Boss, sếp, user (ambiguous with End user)

**End user**:
A person who uses the project's UI once it ships.
_Avoid_: User, customer

**Developer**:
The technical person the Stakeholder escalates to when a skill stops on a Blocker.
_Avoid_: Dev, engineer

## Workflow

**Scenario**:
One of three paths a UI improvement can take, chosen once at the start: A (Greenfield, no frontend yet), B (Stack migration, rewrite the frontend in a new stack), C (Keep stack, restyle the frontend in its current stack).
_Avoid_: Mode, track, kịch bản (in English docs)

**Design tool**:
The external AI app where the Stakeholder generates the new UI, such as Lovable or Google AI Studio.
_Avoid_: Lovable (as a generic name)

**Design prompt**:
The paste-ready prompt the bundle assembles for the Design tool.
_Avoid_: Lovable prompt, brief (the interview is the brief; the prompt is its output)

**Design export**:
The code the Design tool returns, whatever its framework, staged inside the project for the next steps. In Scenario C it is a visual reference only: its look is Ported, its runtime is discarded.
_Avoid_: Lovable export, output, mockup

**Screen**:
One page or route of the Design export, or one named view inside it, Ported as a unit.
_Avoid_: Component, page (when a route holds several views)

**Workflow state**:
The persisted record of the chosen Scenario, the chosen Design tool and the current step, read by every skill before it acts.
_Avoid_: Context, session

**Blocker**:
Data a Screen displays, or Required behaviour, that the existing backend cannot supply; it stops the workflow until a Developer decides.
_Avoid_: Error, issue

**Required behaviour**:
What a screen does today, plus the must-haves the Stakeholder named in the interview; it can never be dropped to fit the design.
_Avoid_: Committed feature, core feature

**Port**:
Rebuilding the look of one Screen of a Scenario C Design export in the project's existing templates, styles and data code.
_Avoid_: Translate, convert

**Work branch**:
The git branch that holds every change of one workflow run; the bundle commits to it but never merges or pushes it.
_Avoid_: Feature branch

**Preview**:
A temporary running copy of the changed project, reachable from the Stakeholder's own phone and laptop, used to click-test before approval.
_Avoid_: Staging (that is the project's own environment), demo

## Release maturity

**Production**:
A Scenario that has at least one behavioural eval per skill it uses and has passed one real end-to-end pilot.
_Avoid_: Stable, GA

**Beta**:
A Scenario whose known Blockers in the skills are fixed but which has not passed a real end-to-end pilot.
_Avoid_: Experimental, preview (Preview means the deploy step)
