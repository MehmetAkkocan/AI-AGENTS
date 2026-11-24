# AI Agent Team User Guide

This guide is for the person using the team (you). The team lead's rules are in `CLAUDE.md`.

## 1. How it works in brief

The main session in Claude Code is the **team lead**. The lead does no work itself; it splits the work, hands it to the right specialist agent, reads short reports, and decides. Agents (researcher, planner, designers, coder, writer) produce the work. Review is done by separate agents: `critic` critiques the output (APPROVE = fine, REVISE = fix it), `tester` runs commands and returns PASS/FAIL, `playtester` actually runs the product and tries it like a user. Each agent writes its full output to a report file and returns at most 10 lines to the lead. You decide only at certain points (the gates).

## 2. Starting a new project

```
/project new <name> "<idea>"
```

`<name>` contains lowercase letters, digits and hyphens (e.g. `learn-rust`). The lead has the project set up and starts a **discovery interview**: at most 7 questions. Mainly it asks: what kind of work this is (game, education, learning, personal development), who the audience is (child under 13, teen, adult), and which platform (web, mobile, desktop/game engine). Your answers set the project's labels; audience and domain trigger extra checks (section 6).

## 3. Two tracks, three modes

Every project first starts on the **prototype track** (fast, light; the goal is to see whether the idea works). The prototype is subject to your decision at the K3 gate (end of A6); if you like it, it is promoted to the **product track**. A project whose concept is already approved can enter the product track directly: say that the concept is approved and give the path of the concept file; the lead has the project set up on the product track and K1 is recorded without asking you for approval again.

| Situation | Track / mode | What it means |
|---|---|---|
| You want to try out an idea | prototype | One-page brief, a small working slice, light verification, decision at K3 |
| Small product, single platform (up to ~12 tasks) | product / light | Short documents, short test, only K1 and K4 |
| Product with a content pipeline (12-40 tasks) | product / medium | Separate design documents, security, 3 personas; K1, K2, K4 (K3 only on direct entry) |
| Large product (40+ tasks, multi-platform, accounts/data) | product / full | Medium + performance, rollback plan, 4+ personas; K1, K2, K4 (K3 only on direct entry) |

## 4. Nine stages

- **A0 Discovery:** the idea is asked about, audience/type/platform are determined.
- **A1 Concept:** what will and will not be built is written down (a brief or a requirements document).
- **A2 Design:** game/learning design, screens, visual and audio direction.
- **A3 Architecture and skeleton:** technical plan, contracts, an empty but working skeleton and the test setup.
- **A4 Vertical slice:** a small but end-to-end working part of the product; on the product track the playtest happens here (on the prototype track the playtest is at A6).
- **A5 Production:** code and content produced slice by slice; review and a checkpoint at every slice.
- **A6 Verification:** tests, playtest, security/accessibility checks; findings are collected.
- **A7 Release:** local package, release tag, release notes, clean-install test.
- **A8 Retro:** what went well/badly is written down; process changes only with your approval.

The prototype track runs A0-A4, then a light A6 verification, and after the K3 decision A8 (a short retro note); there is no A5 or A7.

## 5. What is asked of you: user gates K1-K4

At the exit of each stage the team first finishes its own review (critic, tester, playtester); gate decisions come to you at 4 places; you are also asked to decide on exceptions, visual approval and blockages (sections 6, 7). The lead makes a presentation of at most 15 lines. You write the decision in the chat in your own words; an ambiguous reply does not count as a decision and the options are asked again.

**K1 Concept** (end of A1, all projects): the product in one sentence, type/audience/profile, scope, non-goals, triggered conditional gates, two risks and the document path are presented. In a direct product entry with a pre-approved concept K1 is not presented; it is recorded as `APPROVED-IN-ADVANCE`.
- `APPROVED`: move on to A2. `FIX <what>`: your note is applied and K1 is presented again. `STOP`: the project is shelved (the repository is preserved).

**K2 Design** (end of A2; only product/medium and full): the loop or curriculum summary, screen count, difficulty model, visual/audio direction, conditional check results and open risks are presented.
- `APPROVED`: move on to A3. `FIX <what>`: the relevant designer fixes it and it is presented again. `SCALE-DOWN <what>`: scope is narrowed but the gate does **not** pass; the design shrinks and K2 is presented again.

**K3 Slice** (on the prototype track the end of A6, the track's decision gate; on the product track the end of A4, only on medium/full direct entry): **you try the product yourself.** You are given the run command, the address and a list of screens to look at (the Visual approval row); the playtest result, the hypothesis result (CONFIRMED / PARTIAL / REFUTED) and known issues are presented. A decision that moves on (PROMOTION, CONTINUE) is not accepted unless you have looked at the product yourself.
- On the prototype track: `PROMOTION <mode>` moves to the product track (a short retro note is written at A8, then back to A1; the documents expand into product documents and K1 is presented again with the product document; the proposal to keep or rewrite the prototype code is finalized at A3). `ITERATE` (at most 2 times) returns to the slice (A4), improves it and presents it again with A6 verification. `SHELVE` shelves the project.
- On the product track: `CONTINUE` moves to A5. `FIX <what>` fixes and presents again. `STOP` shelves it.

**K4 Release** (end of A6; only the product track): the verification matrix, the `BLOCKER: 0` statement, known issues (≤3), the rollback plan and a version proposal are presented. As at K3, here too **you look at the product yourself**: the run command, address and screens to look at are given; a `RELEASE` decision is not accepted without looking.
- `RELEASE`: a local package is prepared at A7. `FIX <what>`: fixed at A6 and presented again. `DEFER`: the project is put on hold (BLOCKED); when you return the gate is presented again.

Meanings: APPROVED/CONTINUE/RELEASE = move forward; FIX = send back with your note; STOP/SHELVE = shelve the project, the repository is not deleted; DEFER = wait for now.

## 6. Conditional gates

Some checks come into play only under certain conditions; reducing the mode does not remove them. The team writes the triggered ones into the project status file.

| Gate | When | What it checks |
|---|---|---|
| C-CHILD | audience child | child safety and privacy |
| C-AGE | audience child or teen | age-appropriate content |
| C-DOMAIN | health, mental health, finance, security techniques | sensitive-domain rules |
| C-SEC | product track (on prototype if there is user code/accounts/network) | security hardening |
| C-ACCESS | product track (on prototype for a child audience) | accessibility |
| C-PERF | full mode or real-time game | performance budget |

Effect on you: if a check has a **BLOCKER** (serious finding), K2/K4 do not open; it is fixed first. If you want to knowingly accept a blocker, you write that explicitly (EXCEPTION); an exception is recorded only by your decision, the team never grants one itself.

**Blockage:** if the critic says REVISE (fix it) twice on a task, a third round is tried with a stronger model (opus); if still negative, or if a gate (stage review) gets 2 rounds of REVISE, the project becomes `BLOCKED`. While the limit is tight (`tight`) there is no promotion, it becomes blocked after 2 rounds. You get a single question: the problem, what was tried and the options `FIX <direction>` / `STOP` / `EXCEPTION`.

## 7. What you need to know and do

- During playtests and screen comparisons, **keep the Claude desktop Browser panel visible**; if it is hidden the measurement may time out.
- **At K3 and K4 visual approval is always taken from you** (you open and look at the product yourself; a "I did not look" reply does not count as a decision, except for options that do not pass the gate). If screens cannot be verified in a playtest that does not end with a user gate (`VISUAL: UNVERIFIED`, i.e. the agent could not see the screen), your visual approval is requested separately for those screens; your approval is recorded.
- The artificial playtester is not a real user. Especially for a child audience it does not replace trying with real children.
- A release is a **local package**: the tag and release notes are prepared; uploading outward (store, server, repository) is done by you.
- The checklists (child safety, sensitive domain, security, etc.) are not legal advice.
- The commands in this guide are run in the team root (`D:\AI Agent Team`).
- If you see a limit warning (Claude or Gemini), record the status yourself (or have the tester do it); the lead does not run this script:

```
powershell -ExecutionPolicy Bypass -File ".claude/skills/model-router/scripts/budget.ps1" -Claude tight
```

`-Gemini <ok|tight|exhausted>` is for Gemini; run without parameters it shows the status; `-Reset` resets it. While `tight`, planning, design and gate critique drop to sonnet (task critique is already sonnet) and no promotion to a higher model is made on a blockage; while `exhausted` the team stops.

## 8. Daily commands

```
/project status
/project advance
/project select <name>
/project list
```
- `status`: a short summary of the active project. `advance` (`resume` is the same): the next step or the waiting gate. `select <name>`: changes the active project. `list`: all projects.
- If the session was interrupted or compacted (compaction): `/project advance`. All project work goes through `/project`; if there is no active project the lead asks for `/project new` or `/project select`.
- To list reports (optional `-Role`, `-Since YYYYMMDD`):

```
powershell -ExecutionPolicy Bypass -File team/scripts/list-reports.ps1 -Project <name>
```

## 9. Where the files are

- `projects/<name>/docs/`: documents (brief, design, architecture, verification, release notes).
- `projects/<name>/state/`: state (PHASE, TASKS, TASKS-ARCHIVE, HANDOFF, INTAKE, LESSONS). Lessons are project-specific; projects are isolated, a new project does not read earlier projects' lessons.
- `projects/<name>/reports/`: agent reports, named `YYYYMMDD-HHmm-<role>-<topic>[-t<N>].md` (`-t<N>` is the repeat-round suffix).
- `projects/PROJECTS.md`: registry + active project. Every piece of information about a project stays inside `projects/`; no project information is written to the hub. A source/concept file you give from outside the project is copied under `projects/<name>/docs/source/` with an ASCII name right after setup (coder; the original name and location are kept in the project's INTAKE record). Every file path in the Report cell of the gate records must stay inside `projects/<name>/` and the file must exist (otherwise the gate check gives FAIL).
- `team/state/`: only `HANDOFF.md` (hub state). `team/reports/`: empty; only hub-maintenance reports (see README).
- Hub process files change only at your explicit request or with a process proposal you accept.

## 10. Known limits

- The mobile and game-engine profiles have not yet been tested with a real project.
- Screenshots cannot be saved to a file; visual evidence is given as a text description and measurements.
- Gemini works only in suggestion/plan mode and writes no files; the team carries on without it.
- The team folder itself is a git repository; only `projects/<name>/` are separate repositories of their own (excluded by `.gitignore`).
- Visuals and audio are produced with code (no ready-made images/recorded audio). There is no automated visual regression (Playwright); sound, animation and game feel cannot be measured, you try those yourself.
- There is a single active project per session (change it with `/project select <name>`).
