## ADDED Requirements

### Requirement: New project command
The system SHALL provide `ai-dev new <name>` to create a new project directory from stack-aware templates.

#### Scenario: Create Laravel project scaffold
- **WHEN** the user runs `ai-dev new meu-projeto --stack laravel`
- **THEN** the system creates a Laravel-oriented project scaffold with AI DEV BOOTSTRAP templates appropriate for that stack

### Requirement: Baseline project files
Generated projects SHALL include baseline files for agent instructions, README, environment example, ignore rules, optional Docker Compose, OpenSpec, OpenCode, docs, and tests.

#### Scenario: Baseline scaffold
- **WHEN** a new project is generated
- **THEN** it includes AGENTS.md, README.md, `.env.example`, `.gitignore`, OpenSpec/OpenCode structure when selected, docs, and tests

### Requirement: No overwrite by default
Project scaffolding SHALL not overwrite existing directories or files without explicit confirmation.

#### Scenario: Existing project path
- **WHEN** the target project directory already exists
- **THEN** the system stops or asks for explicit confirmation before modifying existing files
