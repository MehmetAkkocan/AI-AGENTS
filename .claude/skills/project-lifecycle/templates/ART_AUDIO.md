<!-- A2 Design | owner: ux-designer fills (for games, with the game-designer's GDD §8 needs list) | implemented by: coder | target: docs/ART_AUDIO.md | gate: E-A2 (+ K2 medium/full). Light mode: no separate document in U/light, a short asset list goes into docs/DESIGN.md; detailed in full mode. Not present in P. -->
# ART_AUDIO: <name>

## 1. Scope and license
<!-- Every asset is produced in code inside the project; no external asset is downloaded. Raster images and recorded audio are OUT OF SCOPE. -->
All visuals and sounds are produced with SVG / CSS / procedural drawing / synthesized sound; there is no third-party license.

## 2. Asset list
<!-- Each row is one asset; derive from GDD §8 and UX needs. Size: px or viewBox; duration for sound. -->
| Name | Type (SVG / CSS / procedural / synthesized sound) | Where used | Production technique | Size |
|---|---|---|---|---|
| <name> | <type> | <screen/event> | <technique> | <size> |

## 3. Style rules
<!-- Consistent with the UX.md tokens (--color-*, --radius-md); do not write fixed color codes, give the variable name. -->
- Palette: <token names> · Stroke/fill: <rule> · Animation: <duration, easing; respect prefers-reduced-motion>

## 4. Sound list
<!-- Synthesized sound (web: WebAudio; desktop-engine/mobile: the equivalent in the profile file). Parameters: waveform, frequency, duration, envelope. Sound starts with a user action; a mute mode and volume reduction are mandatory. Hearing the sound cannot be verified by the team: user observation. -->
| Sound | Event | Waveform | Frequency (Hz) | Duration (ms) | Envelope (A/D/S/R) |
|---|---|---|---|---|---|
| <name> | <event> | <sine/square/...> | <...> | <...> | <...> |

## 5. Gemini plan-mode suggestion (optional)
<!-- Second opinion only. Gemini does not write files; the coder applies the suggestion to the file. -->
Prompt draft: `<Project: <name>, audience: <audience>, tokens: <list>. Give a style and parameter suggestion for <asset> that can be implemented only with SVG/CSS/synthesized sound; do not write files.>`
Note: The suggestion is saved under `reports/`; the coder applies accepted items to the code, the ux-designer records them in this document.

## 6. Out of scope
<!-- Keep only these items; add any project-specific exclusions. -->
- Raster images (PNG/JPG), recorded sound/music files, ready-made asset packs, external CDN fonts/icons.
