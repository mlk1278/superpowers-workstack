---
name: workstack-agent-routing
description: Resolve logical WorkStack agent roles to normalized dispatch routes. Use internally from WorkStack entry-point skills before delegating exploration, planning, implementation, operation, monitoring, or review work.
---

# WorkStack Agent Routing

Treat this as an internal helper owned by the future public WorkStack entry-point skills. Callers request logical roles; they do not select concrete agents themselves.

## Resolve a route

Run `scripts/resolve-agent --project-root <root> --role <role>` before dispatch. Add `--harness`, `--workflow`, `--reviewer-specialty`, or explicit `--override-*` arguments only when the caller has that context. Always pass `--author-model` for a reviewer.

Record the normalized JSON result in the work log before dispatch. Dispatch the returned primary route and retain `fallbacks` in their returned order. Do not reconstruct or guess a route when resolution fails. In particular, fail closed on reviewer-independence errors.

Resolution precedence is explicit run override, reviewer specialty, workflow, harness, project role, then bundled role.

## Project configuration

Read optional overrides from `<project-root>/.workstack/agents.json`. It accepts these top-level keys:

- `version`: integer `1`.
- `roles`: default role-to-route overrides.
- `harnesses`: harness names containing role-to-route overrides.
- `workflows`: workflow names containing role-to-route overrides.
- `reviewer_specialties`: specialty-to-route overrides.

Each route requires string `harness`, `model`, and `effort` values. It may contain `fallbacks`, an ordered array of routes. Treat invalid JSON or an incomplete selected route as a configuration error; never guess its meaning.
