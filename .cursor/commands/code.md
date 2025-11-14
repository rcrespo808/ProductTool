/code

You are in a small Flutter app repo for a **Product Audit Tool** (barcode → photos → tags → local save, with a tag trie and basic UI).

## Context

- The project root already contains Markdown docs describing:
  - Overview & goals
  - Architecture & folder structure
  - Implementation checklist
  - Test plan
- Treat these docs as the **source of truth**.
- Your job is to **align the codebase to the docs**, not to invent a new design.

---

## Workflow

You MUST work in two phases:

1. **DRY-RUN (this message)**
   - Do NOT modify any files.
   - Read all relevant `.md` docs in the project root.
   - Build an internal understanding of:
     - Target architecture
     - Required features
     - Checklists & tests
   - Audit the current code vs. the docs.
   - Propose a concrete implementation plan:
     - Files to create/modify
     - Main steps you’ll follow
     - Any new dependencies to add
   - Then STOP and wait.

2. **APPLY (next message)**
   - I will reply with **APPLY** when I approve the plan.
   - Then:
     - Implement changes in small, coherent commits.
     - Follow the docs’ checklists as a guide.
     - Keep code consistent with the documented architecture.
     - Add/update tests according to the test plan.
     - Do NOT change the docs unless they are clearly wrong or incomplete (and if so, adjust minimally).

---

## DRY-RUN TASK NOW

- [ ] Scan root `.md` docs and summarize their intent for yourself.
- [ ] Audit the current `lib/` and `test/` trees vs. the documented plan.
- [ ] Output:
  - A short summary of what’s already implemented.
  - A short list of gaps vs. the docs.
  - A step-by-step implementation plan to close the gaps.

Do not write or edit any project files in this phase.
