<!-- A2 Design | owner: game-designer fills | target: docs/GDD.md | gate: E-A2 (+ K2 medium/full). Light mode: no separate GDD in U/light, content goes into docs/DESIGN.md; in P only §1-2 are written into BRIEF. -->
# GDD: <name>
Labels: type=<game|education|learning|self-development>[+game] | audience=<child|teen|adult> | profile=<web|mobile|desktop-engine>

## 1. Vision
<!-- One sentence: who the player is, what they do, what they feel. Must not contradict the product definition in SPEC. -->
<One-sentence vision>
## 2. Core loop
<!-- Write at three scales; each scale: action -> result -> reward/feedback -> next action. -->
- 30 s: <action loop> · 5 min: <level/round goal> · Session: <start-end, continuation point>

## 3. Mechanics
<!-- Each mechanic one row; link to the SPEC feature ID (F-01 format). Rule, input, boundary must be clear. -->
| Mechanic | Rule | Input | Success/Failure | SPEC (F-xx) |
|---|---|---|---|---|
| <name> | <rule> | <key/touch> | <result> | F-01 |

## 4. Progression and reward economy
<!-- Sources of gain/spend, numeric ranges. No manipulative patterns (mandatory if audience is child): false urgency, fear of loss, purchases. -->
<Points/stars/unlock rules and numbers>

## 5. Difficulty curve
<!-- Difficulty parameters per level/wave (speed, time, margin of error) and the increase rule; should be reproducible with a seed. -->
| Level | Parameter | Value | Expected success rate |
|---|---|---|---|

## 6. Feedback
<!-- For each event a visual / sound / text triple; sound and visuals are produced in code (see ART_AUDIO.md). -->
| Event | Visual | Sound | Text |
|---|---|---|---|

## 7. Content inventory
<!-- Exact numbers: levels, units, enemies, items. The A5 work plan derives from these numbers. -->
<Levels: N · units: N · items: N>
## 8. Visual and audio needs produced in code
<!-- List and purpose only; details in ART_AUDIO.md (written by ux-designer). No raster images or recorded sound. -->
- Visual: <SVG/CSS/canvas elements> · Sound: <synthesized sound events>

## 9. SPEC mapping (traceability)
<!-- Each SPEC feature (F-xx) maps to at least one mechanic/flow; leave no unmatched F-xx or feature without SPEC. Acceptance criterion sub-item in the format F-01.a. -->
| SPEC ID (F-xx) | GDD section | Note |
|---|---|---|
| F-01 | <§3 mechanic name> | <note> |

## 10. Out of scope
<!-- Same as the SPEC "non-goals"; any extra exclusions with rationale. -->
- <item>
## 11. Test hook requirement
<!-- Mandatory in a browser game: playtester and tester drive the game with this. Reflex/FPS/feel cannot be measured; at K3 the user plays. -->
- Seedable randomness via `?debug=1&seed=<N>`; state reading via `window.__game.getState()` (<which fields>)
## 12. Open risks
<!-- Goes into the K2 presentation: at most 2 risks, "risk -> mitigation". -->
- <risk -> mitigation>
