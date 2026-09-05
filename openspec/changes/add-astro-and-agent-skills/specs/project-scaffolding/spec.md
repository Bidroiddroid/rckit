## MODIFIED Requirements

### Requirement: New project command
The system SHALL provide `ai-dev new <name>` to create a new project directory from stack-aware templates or an official stack generator, including `node`, `python`, `laravel`, and `astro`.

#### Scenario: Create Laravel project scaffold
- **WHEN** the user runs `ai-dev new meu-projeto --stack laravel`
- **THEN** the system creates a Laravel-oriented project scaffold with AI DEV BOOTSTRAP templates appropriate for that stack

#### Scenario: Create Astro project scaffold
- **WHEN** the user runs `ai-dev new meu-site --stack astro`
- **THEN** the system creates an official Astro project and complements it with AI DEV BOOTSTRAP artifacts appropriate for that stack

### Requirement: Baseline project files
Generated projects SHALL include baseline files for agent instructions, README, environment example, ignore rules, optional Docker Compose, OpenSpec, OpenCode, docs, and tests without replacing framework-owned files.

#### Scenario: Baseline scaffold
- **WHEN** a new project is generated
- **THEN** it includes AGENTS.md, README.md, `.env.example`, `.gitignore`, OpenSpec/OpenCode structure when selected, docs, and tests

#### Scenario: Preserve Astro files
- **WHEN** baseline artifacts are applied after the official Astro generator
- **THEN** the system preserves Astro-owned package, configuration, source, and public files
