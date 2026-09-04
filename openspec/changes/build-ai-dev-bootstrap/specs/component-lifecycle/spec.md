## ADDED Requirements

### Requirement: Standard lifecycle contract
Each component module SHALL implement detection, installation, configuration, verification, update, removal, and diagnostics through a standard lifecycle contract.

#### Scenario: Lifecycle module execution
- **WHEN** the planner schedules a component action
- **THEN** the runtime calls the component lifecycle operation through the standard module contract

### Requirement: Idempotent install
Component installation SHALL be safe to run repeatedly without duplicating installations, corrupting configuration, duplicating PATH entries, recreating unnecessary containers, or deleting data.

#### Scenario: Re-run install
- **WHEN** the user runs the same install command multiple times
- **THEN** already installed and verified components are skipped or reconciled without destructive changes

### Requirement: Real state reconciliation
The system SHALL use stored state as an audit/cache record and validate it against the real host before reporting success.

#### Scenario: Stale state file
- **WHEN** the state file says a component is installed but the real executable or service is missing
- **THEN** `ai-dev verify` reports the component as unhealthy and `ai-dev doctor` suggests a fix

### Requirement: Safe removal
Component removal SHALL require explicit confirmation before deleting user data, configuration files, Docker volumes, or services.

#### Scenario: Preserve Docker volume
- **WHEN** the user removes PostgreSQL support
- **THEN** the system does not delete existing database volumes unless the user explicitly confirms volume deletion
