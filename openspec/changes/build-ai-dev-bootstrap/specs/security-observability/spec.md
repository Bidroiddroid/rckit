## ADDED Requirements

### Requirement: Secret protection
The system SHALL avoid hardcoded secrets, keep secrets out of Git-tracked files, and generate only example placeholders for credentials.

#### Scenario: Generate environment example
- **WHEN** templates include credential fields
- **THEN** generated Git-tracked files contain placeholder values only

### Requirement: Logs
The system SHALL write audit-friendly logs for install, update, verify, doctor, remove, and error workflows.

#### Scenario: Install log
- **WHEN** an install workflow runs
- **THEN** the system records selected components, actions, skipped checks, errors, and final status in logs

### Requirement: Verification report
The system SHALL provide `ai-dev verify` output that groups component health by category and reports a final environment status.

#### Scenario: Verify installed environment
- **WHEN** the user runs `ai-dev verify`
- **THEN** the system checks installed or selected components and prints pass/fail status by category with a final ready/unhealthy result

### Requirement: Doctor diagnostics
The system SHALL provide `ai-dev doctor` diagnostics with actionable findings for common environment problems.

#### Scenario: Docker unavailable
- **WHEN** Docker is selected or installed but the daemon is not running
- **THEN** `ai-dev doctor` reports the issue and suggests a next action
