## ADDED Requirements

### Requirement: Repository bootstrap entrypoint
The system SHALL provide a repository entrypoint that can be run from a fresh clone to launch AI DEV BOOTSTRAP without requiring the user to know internal script paths.

#### Scenario: Launch from cloned repository
- **WHEN** the user runs the documented bootstrap command from the repository root
- **THEN** the system starts the `ai-dev` install workflow or prints a clear actionable error for a missing prerequisite

### Requirement: Selective installation interface
The system SHALL allow users to install only selected components through an interactive menu, explicit component names, or profiles.

#### Scenario: Install explicit component
- **WHEN** the user runs `ai-dev install python`
- **THEN** the system plans installation for Python and required dependencies only

#### Scenario: Install from interactive menu
- **WHEN** the user runs `ai-dev install` without component arguments
- **THEN** the system presents selectable components grouped by category and waits for confirmation before installing

### Requirement: Core commands
The system SHALL expose commands for `install`, `update`, `verify`, `doctor`, `list`, `status`, `enable`, `disable`, `remove`, `new`, and `reset`.

#### Scenario: Command dispatch
- **WHEN** the user runs a supported `ai-dev` command
- **THEN** the CLI dispatches to the matching workflow and returns a meaningful exit code

#### Scenario: Unknown command
- **WHEN** the user runs an unknown `ai-dev` command
- **THEN** the CLI prints usage information and exits without changing the system

### Requirement: Plan confirmation
The system SHALL show an installation, update, removal, or reset plan before performing host changes.

#### Scenario: User cancels plan
- **WHEN** the user rejects a generated plan
- **THEN** the system exits without installing, updating, removing, or overwriting components
