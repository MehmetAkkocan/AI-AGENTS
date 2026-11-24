<!-- A3, filled by planner (learning-designer provides pedagogical input as a report), target: docs/contracts/CONTENT_SCHEMA.md. P: minimal · light+: full. Writers produce content according to this contract. Objective ID LO-01 (LEARNING_DESIGN) -->
<!-- Layout: write the real folder names. Fields: a separate table for each content type. Example: a complete unit that PASSES -Check. Versioning: write the change policy in one line -->

# Content Schema — <name>

Format: <TOML | YAML | Markdown + front matter>, UTF-8. <multi-line field rule, escaping pitfalls>.

## File / folder layout
```
content/
  <group-1>/          # <example: level / module / chapter>
    <group>.<ext>     # group meta file
    NN-<slug>.<ext>   # units, ordered by file name
  _fixture/           # test content; does not appear in the playable list
```

## ID rules
<!-- ASCII lowercase letters, digits, hyphens only. After release the ID NEVER CHANGES (progress records depend on it). -->
- Unit: `<group>-<NN>` (NN is the same as the NN in the file name) · Question: `<group>-q<K>` · <other>

## Unit fields
| Field | Type | Required | Rule |
|---|---|---|---|
| id | string | yes | ID rule; unique |
| title | string | yes | <length> |
| objective | string | yes | LEARNING_DESIGN objective ID (LO-01 format) |
| body_md | string | yes | <word range>; no `#` (h1); sections: <order> |
| <field> | <type> | <yes/no> | <rule> |

## Validation rules (`run.ps1 -Check`, violation = exit 1)
- Folder number / meta id consistency; duplicate id; id format and prefix
- Missing required field, empty field; <type constraint, option count, range>
- References (objective ID, prerequisite) point to a real record
- <project-specific: example code compiles, solution passes the tests>

## Example unit
```<ext>
id = "<group>-01"
title = "<title>"
objective = "LO-01"
body_md = '''<text>'''
```
Golden example: `<content/.../NN-slug.ext>` (approved in A4; writers use it as the template).

## Versioning
`schema_version = <N>` in the meta file; adding a field is backward compatible, deleting/renaming requires a version bump and a migration note.
