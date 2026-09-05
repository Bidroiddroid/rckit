# Safety Model

AI DEV BOOTSTRAP is selective by default.

- No component is installed unless selected directly or through a selected profile.
- Plans are shown before host changes.
- Destructive actions require confirmation.
- Secrets are never written to Git-tracked files.
- Docker volumes and existing configuration are preserved by default.
- State files are audit records and are checked against the real host.

## Third-party agent skills

`agent-skills` downloads the public `vercel-labs/agent-skills` collection through the official skills.sh CLI. Installation is opt-in, project-scoped, runs without `sudo`, and disables CLI telemetry. Review every installed `SKILL.md` and helper script before use: skills execute through the selected coding agent and can use that agent's permissions. Availability and future content remain controlled by the external repositories and npm/GitHub services.

Automatic bulk removal is intentionally refused because `skills-lock.json` can track collections and custom skills beyond Vercel's repository. Remove reviewed skill names with the official CLI instead of deleting `.agents/skills` or the shared lock manually.
