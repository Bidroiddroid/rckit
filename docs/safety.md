# Safety Model

AI DEV BOOTSTRAP is selective by default.

- No component is installed unless selected directly or through a selected profile.
- Plans are shown before host changes.
- Destructive actions require confirmation.
- Secrets are never written to Git-tracked files.
- Docker volumes and existing configuration are preserved by default.
- State files are audit records and are checked against the real host.
