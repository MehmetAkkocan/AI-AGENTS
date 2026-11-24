# Profile: web
Readers: planner, coder, tester, playtester. Environment: the host has only git, podman, PowerShell 5.1; everything is built/run in containers.

## Scope
Education, learning and game products that run in the browser. No deployment: release = local package + tag + release notes. Mobile view (375×812) is tested in this profile; native app: `mobile.md`.

## Container and technology defaults
All families in ONE container (single `Containerfile` + `compose.yaml`); the choice is written to the ADR in A1/A3 (U/light: in the ARCHITECTURE §1 rationale).
| Family | When | Note |
|---|---|---|
| Server-side + HTMX (FastAPI/Jinja2, Rust/axum + template etc.) | Account/progress saving, server-side evaluation needed | Progress: SQLite/file, `./data` volume. Example stack: FastAPI + HTMX + Jinja2 + SQLite |
| Pure static HTML/JS | No server data, fixed content; small prototype | Unprivileged static server (unprivileged nginx variant or a single binary) + tmpfs for needed paths; the official nginx image is expected to crash at startup with `cap_drop: ALL` + `read_only` (unverified) |
| Canvas game | Real-time game | Static serving + `desktop-engine.md` test hooks MANDATORY |
Compose: write `build.dockerfile: Containerfile` explicitly; port only `127.0.0.1:<port>:<port>` (the single exception: `mobile.md` "Testing on a device" (b), temporary `run.ps1 -Lan` by user EXCEPTION, default off); `read_only: true`, `cap_drop: [ALL]`, `no-new-privileges`, `tmpfs: /tmp`, `mem_limit`/`pids_limit`; persistent data `./data:/app/data:Z`. A product that runs user code (C-SEC): a resource limit is not enough; the five properties of `security-hardening.md` GS-05 are met and its hostile attempts run in `run.ps1 -Test`; in this project the writable `./data` directory must be isolated from user code (cannot read, cannot write; GS-05; mechanism in the ADR in A3) (a design that compiles the code in the same container as the app and does not cut the network may fail GS-05; unverified).
Visuals/audio BY CODE: SVG, CSS, canvas, WebAudio synthesis; no raster images and no recorded audio. Design tokens in a single CSS variable file.

## run.ps1 mapping
Standard switches; success exit 0; `$LASTEXITCODE` is checked after every `podman` call. No switch = `-Build -Up`. The tester runs the commands; the playtester only `-Up`/`-Down`/`-Logs`.
| Switch | Command (pattern) |
|---|---|
| `-Build` | `podman build -f Containerfile -t <name>:latest .` |
| `-Up` | build if there is no image; `podman compose up -d`; print the address (`podman-compose` fallback) |
| `-Down` | `podman compose down` |
| `-Test` | NOT in the runtime image: a separate `test` stage in the `Containerfile` (`podman build --target test` + `podman run --rm`) or a separate test service/image; reason: the runtime image carries only binary/content, root is `read_only`. Unverified; write it to the ADR (U/light: ARCHITECTURE §1) |
| `-Check` | `podman compose run --rm <service> <content validation command>` |
| `-E2E` | calls `-Up` itself, runs the HTTP scenario; if the health endpoint does not return 200 after `-Up`, exit 1 + message; the tester stops what it started |
| `-Logs` | `podman compose logs -f <service>` |
`-Test` and `-E2E` are written in A3 of every new project; the service name, port, test/check command are defined in ARCHITECTURE.

## Test hooks
- A health endpoint (200 + short body) and `-Check` are mandatory in the skeleton.
- E2E without Playwright: the Windows built-in `curl.exe` (not the `curl` alias in PS 5.1) scenario: home page 200 → session with a cookie jar (`-c/-b`) → task/progress POST → expected text. At each step status code + key text in the body. If `Invoke-WebRequest` is used, `-UseBasicParsing`.
- Add `HX-Request: true` to an HTMX POST (CSRF protection requires this header; `Origin`, if present, must equal `Host`).
- Canvas game: `?debug=1&seed=N`, `window.__game.getState()` (`desktop-engine.md`).

## Playtest method
Order: BROWSER → HTTP → MANUAL (user observation); `METHOD:` is written in the report.
1. BROWSER: browser pane tools WORK in a sub-agent (smoke verified: navigate, read_page, get_page_text, read_console_messages, read_network_requests, resize_window, javascript_tool). First check whether it is running, if not `run.ps1 -Up` → local address; if `Session: leave-open` leave the product open, if `close` `-Down` ONLY what it started (do not touch what someone else opened); each screen desktop + 375×812 (`resize_window`); console errors, 4xx/5xx, accessibility tree (label, heading order, focus); horizontal overflow is measured with `javascript_tool` (read-only).
2. A screenshot CANNOT be saved to a FILE; while the pane is hidden a 5 s timeout occurs → the lead asks the user to keep the Browser pane visible. `VISUAL: CHECKED` only if the agent ACTUALLY saw the image of that screen × view; evidence = text description of the image + tree excerpt + JS measurement if needed (size, overflow, color). If it cannot be obtained after 2 retries the cell is `UNVERIFIED`. `reports/shots/` is optional, no gate depends on it.
3. HTTP: `curl.exe` with cookies, `HX-Request: true` for HTMX; `VISUAL: UNVERIFIED` (information); at K3/K4 the user's visual approval is always taken; if the stage does not end with K3/K4 (P-A5 in full mode; K3-less U/A4) user visual approval + EXCEPTION on the gate record.
4. MANUAL: user observation; two-call flow (`agents/playtester.md`, `a6-verification.md` step 4; P: `a6-verification-p.md` step 2: form → user answer `state/MANUAL-<p>.md` → evaluation); `VISUAL: UNVERIFIED`; the form does not replace K3/K4 visual approval; if the stage does not end with K3/K4 the user's form counts as visual approval (EXCEPTION).
Sound, animation feel, reflex cannot be measured (write "unverified").

## Limits
Known pitfalls:
- `dockerfile: Containerfile` is written explicitly; writing it explicitly is safe in every case (that the default lookup varies by provider is unverified).
- The port is bound only to `127.0.0.1` (`compose.yaml`); do not make it `0.0.0.0` (the single exception: `mobile.md` "Testing on a device" (b), temporary `run.ps1 -Lan` by user EXCEPTION, default off).
- CSRF: if a POST lacks `HX-Request` the request is rejected; the test client must send it too.
- PS 5.1 reads a BOM-less UTF-8 script as ANSI (`run.ps1` BOM-less, ASCII): `run.ps1` and messages are ASCII; non-ASCII characters only in `.md`/content.
- `restart: unless-stopped` + an app that crashes at startup = a silent restart loop; after `-Up` check `podman ps` + `-Logs` (general behavior; unverified).
- `-Up` builds only if there is no image; after a code change `-Build` is required (clean clone test `-Build -Up`).

## Release package
`README.md` (single command `run.ps1 -Build -Up`, address, `-Down`) + `CHANGELOG.md` + git tag `vX.Y.Z`. Verification: clean clone → `run.ps1 -Build -Up` → `-E2E` PASS (T-A7). Upload is the user's job.
