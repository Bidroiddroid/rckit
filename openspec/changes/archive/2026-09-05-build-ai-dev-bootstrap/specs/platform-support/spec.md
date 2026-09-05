## ADDED Requirements

### Requirement: Platform detection
The system SHALL detect operating system, distribution, version, architecture, shell, user, privilege state, and package manager before planning component actions.

#### Scenario: Detect Ubuntu WSL2
- **WHEN** the CLI runs on Ubuntu inside WSL2
- **THEN** the platform detector identifies Linux, Ubuntu, WSL2, architecture, shell, user, privilege status, and available package manager

### Requirement: First-version platform support
The first version SHALL support Ubuntu, Debian, and WSL2 Ubuntu for installation workflows.

#### Scenario: Supported Linux distribution
- **WHEN** the user runs `ai-dev install` on supported Ubuntu or Debian
- **THEN** the system continues to component planning

### Requirement: Unsupported platform behavior
The system SHALL fail safely on unsupported platforms unless the command is documentation-only or explicitly marked experimental.

#### Scenario: Unsupported OS
- **WHEN** the user runs an install workflow on an unsupported OS
- **THEN** the system prints a clear support message and exits without changing the host
