# Checklist: Security hardening (GS)

> This list is not legal advice; for general distribution, compliance responsibility rests with the user.
> The `\|` in tables is only Markdown escaping; in a Grep/ripgrep pattern write a plain `|`. Patterns are separated by commas: each is searched separately, case-insensitive (`-i`). "Result 0" = 0 hits that are not accepted without justification; every hit is judged in context.
> The critic has no browser tool: evidence for an item that needs a browser comes from the playtester report. Command attempts (`curl.exe`, `podman inspect`, scans, sandbox attempts) are proven by the tester's output; the critic reads code/configuration.

- **Gate:** C-SEC · **Trigger:** track = product; in P, core if there is user-input execution / an account / network · **Reviewer:** critic + global skill `security-and-hardening`
- **[core]** (mandatory subset for the P track): GS-01, 02, 05, 06, 08. In the U track, all.
- **Checked in A3 (contract and design: ARCHITECTURE, API.md, Containerfile/compose):** GS-01, 03, 04, 05, 06, 07, 09, 16. **Checked in A6:** all (tester attempts, on the `run.ps1 -Up` build).
- An item for a feature that does not exist (no account, no user code) = N/A + a one-line justification.
- Severity: BLOCKER (closes the gate) · MAJOR (fix before the gate or justified BACKLOG) · MINOR (BACKLOG). An item without evidence = NO.

| # | Item | How to verify | Severity |
|---|---|---|---|
| GS-01 | Input validation on the server: type, length, range, allowed values are in the contract and the code; invalid input gives 4xx. | A3: API.md field rules. A6: tester sends malformed type and excessively long input with `curl.exe` → 4xx (5xx = NO). | BLOCKER |
| GS-02 | Output escaping: template auto-escaping is on; no raw HTML rendering (Jinja `safe` filter, `innerHTML`), or it is justified. | Grep: `innerHTML`, `v-html`, `autoescape`, `Markup(`, `safe` (filter); hits are justified. A6: tester types script text into input, shown as plain text on screen (playtester report). | BLOCKER |
| GS-03 | CSRF: state-changing requests are protected by a token or by SameSite cookie + Origin check; GET does not change state. | A6: tester sends `curl.exe -X POST` without a token / with a foreign Origin → 403/4xx. Grep: no write operations on GET routes. | BLOCKER |
| GS-04 | If accounts exist: passwords are stored with an adaptive hash (argon2, bcrypt, scrypt); session cookie is HttpOnly + SameSite. | Code Grep: `argon2`, `bcrypt`, `scrypt`; no plain `password` storage. Tester `curl.exe -i` cookie flags. If there are no accounts, N/A. | BLOCKER |
| GS-15 | If accounts exist: the session becomes invalid on logout; login attempts are limited. | Tester: after logout a request with the old cookie is rejected; consecutive failed logins are blocked (output). | MAJOR |
| GS-05 | If user code/input is executed, the isolation PROPERTIES are provided (mechanism is free; no `eval/exec` in the main server process). User code: (1) cannot read or write the server's data directory (e.g. `./data`, progress records); (2) cannot see server secrets and the environment variables of the server process; (3) cannot write to the root file system (writes only to a temporary area set aside for it); (4) cannot reach the network; (5) has limits on time and memory/process count (an infinite loop or fork bomb does not take the server down). The mechanism is chosen in an ADR in A3 (e.g. a separate user, a separate isolated process/container, seccomp/Landlock, or never running the code on the server at all — none of these has been verified by this team; the choice is in the ADR). A mechanism that requires relaxing one item of GS-09 is written to PHASE as an EXCEPTION only by user decision. | A3: there is an ADR under `docs/adr/` with the threat model, the mechanism, its justification, and how the five properties are met; the critic uses Grep to show the path of the test file and the presence of five adversarial attempts: reading/writing the data directory, reading `env`/secrets, writing to the root file system, connecting to an external address, infinite loop + large memory/fork. A6: these attempts run inside `run.ps1 -Test`, each is rejected; evidence is PASS in the tester report (report path). Reading a world-readable file such as `/etc/passwd` is not a criterion. If the code runs only in the browser, the ADR says so and Grep shows there is no call on the server that runs user code (`eval`, `exec`, `subprocess`, compiler call); no adversarial attempt is needed. If there is no user code, N/A. | BLOCKER |
| GS-16 | There is no external network access from the process that runs user code; if this cannot be provided, a residual risk justified in the ADR. | A3: ADR. A6: tester attempts a connection to an external address from the execution process → fails (output). | MAJOR |
| GS-06 | Binds only to 127.0.0.1: port publishing is `127.0.0.1:<port>:<port>`, no `0.0.0.0`. Note: temporary `-Lan` by EXCEPTION — `0.0.0.0` only on the optional `run.ps1 -Lan` path, off by default, only during testing and only if there is a user EXCEPTION record in PHASE (`mobile.md` "Testing on device"); the default `-Up` is still 127.0.0.1. | Grep compose/`run.ps1`: `0.0.0.0`, `ports`; tester `podman port <container>` output. | BLOCKER |
| GS-07 | Dependencies are pinned (exact version/lock file); base image tag is pinned (no `latest`); a known-vulnerability scan has been run, high findings 0 or justified. The scan command is written in ARCHITECTURE according to the stack; if it cannot be run, MINOR + BACKLOG. | Lock file and `FROM` line; tester scan output (tool name goes in the report; tool and command examples unverified: e.g. `pip-audit`, `cargo audit`, `npm audit`). | MAJOR |
| GS-08 | No secrets in source, image, or logs; `.env` is not tracked. | Grep: `secret`, `password`, `api_key`, `apikey`, `token` (on a hit, check whether it is a value or a name); `.gitignore` line; tester `git log -S` output. | BLOCKER |
| GS-09 | Container is unprivileged (compatible with a single container): non-root `USER`, no `privileged`, `cap_drop: ALL` (each required capability individually justified in the ADR), `no-new-privileges`, host/podman socket not mounted (no sibling-container design), read-only root + tmpfs. | A3: Containerfile/compose Grep: `USER`, `privileged`, `cap_drop`, `no-new-privileges`, `docker.sock`, `podman.sock`. A6: tester `podman inspect` output. | MAJOR |
| GS-10 | Security headers: `Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `Referrer-Policy`, framing protection. | Tester `curl.exe -I http://127.0.0.1:<port>/` output; list of missing headers. | MAJOR |
| GS-11 | Debug is off; an error response gives no stack trace or internal path (YO-09 refers to this). | Tester: `curl.exe` to a nonexistent route and a malformed body, no trace in the response. Grep: `debug=True`, `--reload`, `DEBUG`. | MAJOR |
| GS-12 | SQL is parameterized; no queries built by string concatenation. | Grep: `execute(`, `query(`; confirm by reading that every call uses parameter binding. | MAJOR |
| GS-13 | File paths are not built from input, or are canonicalized within the allowed directory. | Tester sends requests with `../` and absolute paths → 4xx; Grep: `open(`, `File::open`, `readFile`. | MAJOR |
| GS-14 | Request body size is limited; the log contains no personal data. | Configuration line; tester sends an oversized body → 413/4xx; log sample. | MINOR |

## Result rule
If a BLOCKER item is NO, C-SEC is closed (REVISE). If a MAJOR item is NO, it is fixed before the gate or a justified BACKLOG line is given. An exception is written to PHASE as `EXCEPTION` only by user decision. N/A is valid only with a justification.

## Reviewer's report table
| Item | Result (YES / NO / N/A) | Evidence (file:line, tester output path) |
|---|---|---|
Last line: `RESULT: APPROVE | REVISE — BLOCKER: <n> · MAJOR: <n> · MINOR: <n>`.

## Sources
- OWASP ASVS: https://asvs.owasp.org
- OWASP Cheat Sheet — ASVS index: https://cheatsheetseries.owasp.org/IndexASVS.html
- OWASP, CSRF prevention: https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html
- OWASP, Docker security: https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html
