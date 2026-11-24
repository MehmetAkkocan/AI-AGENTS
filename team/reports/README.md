# Reports (hub)

This folder starts empty. Hub reports (`<YYYYMMDD-HHmm>-<role>-<topic>.md`) are created only during hub maintenance work (changes to process files, agents, scripts).
Project reports live under `projects/<name>/reports/`; no project name or content is written to this folder (`stamp.ps1 -Hub`).
The lead does not read these files in full; it only takes the 10-line summary the agent returns.
