## ADDED Requirements

### Requirement: Declarative component manifest
The system SHALL define available components in a central manifest with category, dependencies, supported platforms, lifecycle module, credential needs, and default selection metadata.

#### Scenario: Load manifest
- **WHEN** the CLI starts a command requiring component metadata
- **THEN** it loads and validates the manifest before planning work

### Requirement: Dependency resolution
The system SHALL resolve transitive dependencies for selected components before execution.

#### Scenario: Laravel dependencies
- **WHEN** the user selects `laravel`
- **THEN** the plan includes required PHP and Composer dependencies before Laravel

#### Scenario: MCP dependencies
- **WHEN** the user selects an MCP integration that requires OpenCode
- **THEN** the plan includes OpenCode unless it is already installed and verified

### Requirement: Profiles
The system SHALL support profiles that expand to predefined component selections while still allowing manual component overrides.

#### Scenario: Profile expansion
- **WHEN** the user runs `ai-dev install --profile ai`
- **THEN** the system expands the `ai` profile into its configured components and dependencies

### Requirement: Unsupported component handling
The system SHALL reject unsupported components for the current platform before execution.

#### Scenario: Unsupported platform
- **WHEN** a selected component does not support the detected platform
- **THEN** the system reports the incompatibility and excludes the component unless the user explicitly overrides a documented guard
