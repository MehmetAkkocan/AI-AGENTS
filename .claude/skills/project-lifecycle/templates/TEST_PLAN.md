<!-- A3, planner fills, target: docs/TEST_PLAN.md; the tester runs the commands. Only U/medium-full: not present in P and U/light (playtest tasks are derived from BRIEF/SPEC in PLAYTEST_REPORT). The single source of playtest tasks is §3 -->
<!-- Mapping ID: SPEC feature `F-01`, acceptance criterion `F-01.a`; LEARNING_DESIGN objective `LO-01` -->
<!-- §1: add/remove layers (if there is no content, the -Check row is "none"). §4: every F-xx.a and LO-xx is linked to at least one test/activity; VERIFICATION cites this table -->

# Test Plan — <name>

## 1. Test pyramid
| Layer | Scope | Command | Pass criterion |
|---|---|---|---|
| Unit | <module logic> | `run.ps1 -Test` | exit 0, <coverage target> |
| Integration | <between modules, data layer> | `run.ps1 -Test` | exit 0 |
| Content validation | CONTENT_SCHEMA rules | `run.ps1 -Check` | exit 0, 0 errors |
| E2E (smoke) | running product, main flow | `run.ps1 -E2E` | exit 0 |
A successful command gives exit 0; in A3 everything must be green with the empty product (T-A3).

## 2. E2E scenarios
<!-- The first smoke runs in A3 with the empty product; it re-runs at the end of every slice, and scenarios are added. -->
| # | Scenario | Steps | Expected |
|---|---|---|---|
| E1 | Smoke (empty product) | 1. `-Up` 2. request to the main address 3. check status code and title 4. `-Down` | 200, <expected text> |
| E2 | <slice flow> | 1. <step> 2. <step> 3. <step> | <result> |

## 3. Playtest tasks
<!-- Persona = from the BRIEF/SPEC audience; each set has one accessibility persona. Method: BROWSER > HTTP > MANUAL (profile file). -->
| Persona | Task | Success criterion |
|---|---|---|
| <persona-1> | <task, in the user's language> | <time / step count / unassisted completion> |
| <accessibility persona> | <task> | completed with keyboard, labels are read |

## 4. Acceptance criterion - test mapping
| Acceptance criterion (F-01.a) | Criterion | Test (layer + name) | Status |
|---|---|---|---|
| <F-01.a> | <criterion> | <E2E E2 / unit ...> | OPEN |
| <LO-01 (if there is a learning objective)> | <criterion> | <test / activity> | OPEN |

## 5. Conditional gate checks
<!-- Only those in the PHASE conditional: line. Checklist: checklists/. -->
| Gate | Check | Tool / evidence |
|---|---|---|
| <C-SEC> | <input validation, execution boundary> | <test name + critic report> |
| <C-PERF> | ARCHITECTURE performance budget | <measurement command + tester report> |
