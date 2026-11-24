# Profile: desktop-engine
WARNING: This profile has NOT yet been tested with a real project. Items marked "unverified" are tested on first use and written back.
Readers: planner, coder, tester, playtester. Environment: the host has only git, podman, PowerShell 5.1; NO Godot/Unity/Node/Python.

## Scope
Desktop games and products that need an engine. PRIORITY: browser-based game (canvas + JS, `web.md` infrastructure). An engine (Godot/Unity) only if justified in the SPEC and approved by the user at K1.

## Container and technology defaults
- Browser game: `index.html` + modular JS, 2D canvas, static serving (`web.md` canvas row). Fixed timestep: `requestAnimationFrame` only for drawing; the simulation runs a fixed `dt` (e.g. 1/60 s) in an accumulator; `Date.now()`/`Math.random()` are forbidden in game logic.
- Seedable randomness: a single PRNG (e.g. mulberry32), seed via `?seed=N`; same seed + same input sequence = same state.
- Visuals/audio by code: canvas/SVG, particles, WebAudio oscillator/noise synthesis; no raster and no recorded audio.
- JS logic tests do not run in the static server image: a separate test image/stage (e.g. node slim; version pinned in A3; unverified).
- If an engine is needed: Godot headless export in a container is theoretical (image source, templates, web export unverified); Unity is unverified because of license/editor, not recommended. A headless build CANNOT PLAY/SEE the game.

## run.ps1 mapping
Switches are the same as `web.md` (`-Build -Up -Down -Test -Check -E2E -Logs`; success exit 0). The tester runs the commands.
| Switch | In this profile |
|---|---|
| `-Build` | static image (or engine export, unverified) |
| `-Up` / `-Down` / `-Logs` | as `web.md`; address `http://localhost:<port>/?debug=1&seed=1` (development/playtest address only) |
| `-Test` | game logic unit tests in a separate test image (pure functions, no DOM; same seed → same state) |
| `-Check` | content/config validation such as level/balance tables |
| `-E2E` | HTTP smoke (page and scripts 200) + re-runs the browserless logic test |

## Test hooks
MANDATORY (without them A3 cannot exit):
- `?debug=1&seed=N`: debug mode + fixed seed. Cheat modes (invincibility etc.) are off by default.
- `window.__game.getState()`: JSON-serializable state (position, score, health, scene, step counter, seed).
- Recommended: `__game.step(n)` (n fixed steps), `__game.input(sequence)`, `__game.reset(seed)`.
- Hooks exist only with `debug=1`; in a release candidate they are OFF by default (without debug `typeof window.__game` = `undefined`; verified with `javascript_tool`, `pre-release.md` YO-09). A hook grants no privileged effect (writing persistent saves/scores).
- The playtester uses `javascript_tool` only for inspection and THESE hooks (`getState`, `step`, `input`); it changes application state by no other means.

## Playtest method
Order: BROWSER → HTTP → MANUAL; `METHOD:` is written in the report. Visual evidence: `web.md` rules (the pane is kept visible; images are not saved to files; `VISUAL: CHECKED` only if actually seen, text description + tree + JS measurement; otherwise `UNVERIFIED`).
1. BROWSER: open in the pane with `?debug=1&seed=N`; read `getState()`, run the scenario with `step`/`input` (is the task completed, deadlocks, number overflow, invalid state), console errors, 4xx/5xx, desktop + 375×812 layout. If the engine's web export works use this method; if not, MANUAL.
2. HTTP: only proves serving is up; `VISUAL: UNVERIFIED`.
3. MANUAL: engine output or a game without hooks: two-call flow (`agents/playtester.md`, `a6-verification.md` step 4; P: `a6-verification-p.md` step 2): (1) the playtester prepares a manual test scenario + observation form, gives no RESULT; the user plays, the lead writes the answer to `state/MANUAL-<p>.md`; (2) the playtester evaluates and returns RESULT; `METHOD: MANUAL`, `VISUAL: UNVERIFIED`; the form does not replace K3/K4 visual approval; if the stage does not end with K3/K4 the user's form counts as visual approval (if PASS the record is `EXCEPTION`, `user: visual approval (MANUAL form); <report paths>`).
The playtester CANNOT measure: reflex/reaction time, game feel (difficulty perception, fun), FPS/stutter, sound and music. So at K3 the user MUST PLAY (address + `run.ps1 -Up` in the presentation); at K3 and K4 the user's visual approval is always taken (the `VISUAL:` line is information).

## Limits
- There is no measurement tool for real-time performance and sound; C-PERF is limited to the tester's countable criteria (object count, fixed step duration).
- Real gamepad/keyboard hardware behavior cannot be measured.
- Engine path: no engine on the host; headless build unverified; if there is no web export, playtest is MANUAL.
- The profile was written without being tested on a real project.

## Release package
Browser game: the `web.md` package (README single command, `CHANGELOG.md`, `vX.Y.Z`; `run.ps1 -Build -Up` from a clean clone); debug hooks off in the release candidate. If an engine binary is produced, a local package (zip) built in a container + release notes; unverified that it runs. Upload is the user's job.
