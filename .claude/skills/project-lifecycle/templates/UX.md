<!-- A2 Design (updated in A4/A6) | owner: ux-designer fills | target: docs/UX.md | gate: E-A2, C-ACCESS (in A2 critic, document level) (+ K2 medium/full). Light mode: no separate UX.md in U/light, the flow + screen table go into the UX section of docs/DESIGN.md (AFTER the designer). -->
# UX: <name>
Labels: profile=<web|mobile|desktop-engine> | audience=<child|teen|adult>

## 1. User flows
<!-- One flow per main task, text with arrows; start and end screen clear. -->
- FL-01 <name>: <Screen A> -> <Screen B> -> <Screen C>

## 2. Screen inventory
<!-- Each screen is linked to a SPEC feature (F-01 format); do not open a screen without an F-xx. -->
| Screen | Purpose | SPEC ID (F-xx) |
|---|---|---|
| <name> | <purpose> | F-01 |

## 3. Components and states
<!-- Component list per screen; write four states for each. A missing state = a missing design. -->
### <Screen name>
- Components: <list>
- Empty: <text/view> · Loading: <...> · Error: <...> · Success: <...>

## 4. Wireframes
<!-- A text-based example for each main screen (ASCII boxes); at least one screen. In full mode produce docs/ux/wireframes/NN-<screen>.html for each screen and leave only a path line here. No HTML in other modes. -->
```
+----------------------+
| <title>       <menu> |
| <main area>          |
| [ <primary action> ] |
+----------------------+
```
Full mode: `docs/ux/wireframes/NN-<screen>.html` (one line per screen, e.g. `01-home-screen.html`)

## 5. Design tokens
<!-- By CSS variable name; ART_AUDIO style rules rely on these. Write value and where used. -->
| Token | Value | Usage |
|---|---|---|
| --color-bg / --color-fg / --color-accent | <#...> | <surface/text/accent> |
| --font-base / --font-size-base | <...> | <body> |
| --space-1..--space-6 | <4px scale> | <spacing> |
| --radius-md | <...> | <corner> |

## 6. Accessibility targets
<!-- By audience: touch target same as accessibility.md ER-08: >=44x44 CSS px; audience=child >=48 CSS px, plain language. -->
- Contrast: <text >=4.5:1, large text >=3:1> · Keyboard: <all actions via Tab/Enter> · Focus: <visible ring> · Touch target: <>=44 CSS px; child >=48>

## 7. Microcopy style
<!-- Button, error, empty-state texts; tone and language suited to the audience; non-blaming error text. -->
<Style + 3 examples>
## 8. Responsive layout
<!-- Two targets: desktop and 375x812 mobile. Layout change per screen. In A4/A6 the ux-designer compares this table with the images they see (if none, with the playtester Visual check table). -->
| Screen | Desktop | 375x812 |
|---|---|---|
## 9. Open risks
<!-- Goes into the K2 presentation: at most 2 risks, "risk -> mitigation". -->
- <risk -> mitigation>
