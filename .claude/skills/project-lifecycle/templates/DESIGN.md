<!-- A2 | owner: game-designer or learning-designer (by type) writes, THEN ux-designer adds the Screen list / Flow / Visual and audio sections (in sequence, not at the same time) | target: docs/DESIGN.md (U/light only) | gate: E-A2 + triggered C-* (no K2 in light mode) -->
<!-- In U/light mode, a summary of GDD + LEARNING_DESIGN + UX + ART_AUDIO in a single file, about 1-2 pages. In medium/full mode this template is not used; separate GDD / LEARNING_DESIGN / UX / ART_AUDIO are written. Placeholder name: <name>. -->
# DESIGN <name>

## Design summary
<!-- fill-in instruction: 3 lines: what experience, for whom, the single distinguishing feature. Source: SPEC Goals. -->
<summary>

## Core loop
<!-- fill-in instruction: if there is a game/gamification: action -> feedback -> reward -> progression (<=6 steps) + difficulty model 2 lines. If not a game, "none". -->
<loop>

## Learning objectives
<!-- fill-in instruction: for education/learning/self-development, 3-8 measurable objectives; IDs LO-01, LO-02...; each maps to one activity, one assessment and at least one SPEC ID (F-01); age-appropriate language note. Otherwise "none". -->
| Objective ID | Objective | Activity | Assessment | SPEC ID (F-xx) |
|---|---|---|---|---|
| LO-01 | <... can do> | <activity> | <assessment> | F-01 |

## Behavior and habit design (self-development only; write "not applicable" for others)
<!-- fill-in instruction (same headings as LEARNING_DESIGN §8): Trigger, small step, tracking; recovery plan (restarting without blame after a missed day). Manipulative pattern ban: false urgency, guilt, fear of loss, addiction loops (including streak-loss penalties). -->
- Trigger: <reminder context> · Small step: <action <=2 min> · Tracking: <metric, no penalty>

## Screen list
<!-- fill-in instruction (ux-designer): one row per screen: name, purpose, main action, the F-ID it satisfies. 3-10 screens in light mode; if more, note a suggestion to move to medium mode for the critic. -->
| Screen | Purpose | Main action | SPEC ID (F-xx) |
|---|---|---|---|
| <screen> | <purpose> | <action> | F-01 |

## Flow
<!-- fill-in instruction (ux-designer): main flow step by step (<=10), screen name at each step; at least 1 error/empty-state side flow. -->
1. <screen> -> <screen>

## Visual and audio direction
<!-- fill-in instruction (ux-designer): color, typography, icon language, sound; all producible IN CODE (SVG/CSS/procedural or synthesized sound); no raster/recorded sound. Accessibility target (contrast, keyboard, focus) 2 lines. -->
<direction>

## Conditional gate notes
<!-- fill-in instruction: if C-CHILD, C-DOMAIN, C-ACCESS are triggered, how the design meets the relevant checklist, with item IDs (CG-01...). If none, "none". -->
<note>

## SPEC cross-reference and open risks
<!-- fill-in instruction: on which screen/activity each F-ID is satisfied; unsatisfied ones are stated explicitly (the critic does cross-consistency). Last line: at most 3 open risks for K2 and E-A2. -->
F-01: <screen / LO-01>
Open risks: <risk>
