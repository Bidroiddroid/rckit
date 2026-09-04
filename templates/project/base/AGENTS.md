# Agent Instructions

## Principles

- Prefer OpenSpec for changes that affect behavior, architecture, APIs, security, data, or deployment.
- Keep implementation scoped to the current change.
- Preserve user data, secrets, generated assets, and existing configuration unless explicitly instructed.
- Run relevant tests before finalizing work.

## Workflow

1. Understand the repository and active OpenSpec change.
2. Check official documentation before changing external integrations.
3. Implement the smallest coherent task.
4. Test, verify, review security, and summarize the result.

## Security

- Never commit secrets.
- Use `.env.example` for placeholders only.
- Ask before destructive actions.
- Keep credentials local and scoped.
