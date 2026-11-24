# Profile: mobile
WARNING: This profile has NOT yet been tested with a real project. The methods are suggestions; items marked "unverified" are tested on first use and written back.
Readers: planner, coder, tester, playtester. Environment: the host has only git, podman, PowerShell 5.1; NO Flutter/Android/iOS SDK and no emulator.

## Scope
Products targeting phones/tablets. Priority: (1) responsive web, (2) PWA, (3) Flutter web build, (4) native app (only if justified in the SPEC, MANUAL path). First ask whether 1-2 suffice; option 4 is not chosen until the native justification (camera, notifications etc.) is written into the SPEC in A1. Store release is out of scope.

## Container and technology defaults
- Responsive web / PWA: `web.md` container rules. Extra: `manifest.webmanifest`, service worker, `meta viewport`, touch target (same as `accessibility.md` ER-08: ≥44×44 CSS px; audience=child ≥48 CSS px), `env(safe-area-inset-*)`, one-handed use.
- PWA installability needs HTTPS, `http://localhost` is the exception (browser behavior; unverified in this environment).
- Flutter web: in a container with a community image that has the Flutter SDK (e.g. cirruslabs; there is no official Google image; unverified) `flutter build web`; the output is a static folder, copied into a static server image with a multi-stage `Containerfile`. Unverified: image version/size/download time, `flutter test` running in a container, pub cache. The version is pinned and written to the ADR (U/light: in the ARCHITECTURE §1 rationale).
- Android APK container build is theoretical (unverified); iOS is impossible (needs macOS); no emulator.
- Visuals/audio by code (SVG, CSS, canvas, WebAudio); no raster and no recorded audio. On mobile browsers audio starts after a user tap.

## run.ps1 mapping
Switches are the same as `web.md` (`-Build -Up -Down -Test -Check -E2E -Logs`; success exit 0; `-Test` is a separate test stage/image, not in the runtime image). Differences:
| Switch | Mobile difference |
|---|---|
| `-Build` | web/PWA: as `web.md`; Flutter web: multi-stage build (unverified) |
| `-Test` | in-container unit test; Flutter: `flutter test` (unverified) |
| `-Check` | is `manifest` valid, do the service worker file and icon SVGs exist, content validation |
| `-E2E` | `curl.exe` HTTP scenario + `manifest`/`sw.js` 200 check |
| `-Lan` (optional) | only with `-Up` and only in "Testing on a device" option (b): binds `0.0.0.0:<port>`, prints the LAN address; default OFF |
Native app (MANUAL path): `run.ps1` covers only the web version; the device build is the user's job.

## Test hooks
- The `web.md` hooks (health endpoint, `-Check`, HTMX header) apply.
- Touch target: at 375×812 clickable element sizes are checked with `javascript_tool` (read-only measurement) and the tree.
- Offline: the existence of the service worker file via HTTP; real offline behavior needs BROWSER (unverified).

## Playtest method
Order: BROWSER → HTTP → MANUAL; `METHOD:` is written in the report. The visual evidence rule is the same as `web.md` Playtest method: pane tools work, screenshots are not saved to files, the pane is kept visible, `VISUAL: CHECKED` only if the image was actually seen (text description + tree + JS measurement), otherwise `UNVERIFIED`.
1. BROWSER: `run.ps1 -Up` → in the pane 375×812 (and 768×1024); text overflow/clipping, touch target size, console errors, 4xx/5xx, accessibility tree. Real touch, swipe gestures, sensors cannot be measured.
2. HTTP: `curl.exe` with cookies; `VISUAL: UNVERIFIED`.
3. MANUAL (native app or device feature): two-call flow (`agents/playtester.md`, `a6-verification.md` step 4; P: `a6-verification-p.md` step 2): (1) the playtester prepares a manual test scenario + observation form (task steps, expected result, SUCCEEDED/STRUGGLED/FAILED boxes, device model/screen, free note), gives no RESULT; the lead presents the form to the user and writes the answer to `state/MANUAL-<p>.md`; (2) the playtester evaluates the answer and returns RESULT; `METHOD: MANUAL`, `VISUAL: UNVERIFIED`; the form does not replace K3/K4 visual approval; if the stage does not end with K3/K4 the user's form counts as visual approval (if PASS the record is `EXCEPTION`, `user: visual approval (MANUAL form); <report paths>`). Device access follows the "Testing on a device" rule below.

**Testing on a device** (profile mobile only): default NONE (port only 127.0.0.1). On the P track only (a) exists; on the U track the lead offers the user two options. (a) settle for 375×812 emulation in the browser; device/PWA-specific items go to BACKLOG as "user observation — not possible"; (b) U track only: by user decision (EXCEPTION) temporary local network access only for the test duration: tester `run.ps1 -Up -Lan` (optional switch, default off), record `C-SEC | product | A6 | user | EXCEPTION | user: temporary -Lan device test (GS-06) | <day>` and immediately after it a `PENDING` with the same key (the C-SEC review still runs), when the test ends tester `-Down`. PWA features that need HTTPS (install, service worker, notification) cannot be tested on the local network → BACKLOG.

## Limits
- Real device, finger ergonomics, battery/performance, iOS Safari differences cannot be measured.
- No native SDK and no emulator; a native app is built and tried in the user's hands.
- Store release, signing, notification services are out of scope.
- Flutter container build is unverified; the profile was written without being tested on a real project.

## Release package
Web/PWA: the `web.md` package + "add to home screen" steps in the README. Flutter web: static folder embedded in the image, `run.ps1 -Build -Up`. Native app: source + build instructions + release notes; no binary is produced. Tag `vX.Y.Z`; the clean clone test is only for the web version (T-A7).
