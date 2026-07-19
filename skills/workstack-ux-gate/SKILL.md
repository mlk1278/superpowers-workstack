---
name: workstack-ux-gate
description: Scripted-capture UX verification of changed user-visible surfaces against approved visual and interaction acceptance criteria. Internal WorkStack gate run before the final gate verdict; returns Pass or Changes Required.
---

# WorkStack UX Gate

**Announce:** "I'm running the UX gate for <surface>."

**Entry:** a context bundle — changed surface routes, the base..head range, the approved acceptance criteria (visual, interaction, responsive, accessibility, copy), and how to reach a running isolated environment.
**Exit:** `Pass` bound to the reviewed head SHA, or `Changes Required` with component-level findings. The gate does not fix anything.

Never review by navigating the browser interactively — manual navigation burns tokens and leaves no rerunnable evidence. Capture is scripted; judgment happens over the resulting images.

## 0. Runtime preflight

The environment must actually serve the changed routes with queryable data before capture starts. No preflight evidence means the gate cannot run, and nothing downstream may claim UX was verified.

## 1. Pathways from the actual diff

Derive 5-10 navigation pathways covering what this diff changed — the flows, entry points, and states the criteria name, not a generic tour of the application.

## 2. Scripted capture

Write a throwaway Playwright script under ignored `.superpowers/ux/` that walks every pathway and screenshots each step and state at small (~375px), medium (~768px), and large (~1440px) widths, naming files `<pathway>-<step>-<width>.png`. Exercise the states the criteria name (empty, loading, error, dense data, overlays, overflow) using isolated fixtures or seeded test data. Run the script once per review round. A step the script cannot complete (auth, data, a dead route) is a finding, not a skip. The script is scratch: rerunnable after every fix, deleted at gate close, never committed.

## 3. Review the captures

Resolve one `reviewer` with specialty `ux` via workstack-agent-routing; the route must resolve to a vision-capable model. The reviewer reads `docs/REVIEW-GUIDANCE.md` when the project provides it, then judges the screenshot set against the approved criteria — never personal taste — without driving the browser. Each finding names component file + visual state + viewport + specific deviation + screenshot reference; findings missing a screenshot or component file are unroutable and do not count.

## 4. Fix loop

Route the finding set to the owning implementer thread, rerun the capture script on the new head, and send the fresh set to the same reviewer thread. Every round and the final `Pass` bind to the head SHA that was reviewed; a new push invalidates prior evidence. Run this gate before the final gate verdict so its fixes land in the gated head.

## Rules

- One primary UX reviewer by default; an additional reviewer needs an explicit written reason such as a broad redesign or an accessibility specialty.
- Do not manufacture states by editing app source. Isolated fixtures and seeded test data are fine; production or shared-user data is not.
