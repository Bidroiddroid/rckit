## ADDED Requirements

### Requirement: Initial language and framework modules
The system SHALL include modules for Node.js/TypeScript, Python, and PHP/Laravel with framework-specific tooling kept selective.

#### Scenario: Python selected
- **WHEN** the user selects Python
- **THEN** the plan includes Python, pip, venv support, uv, and Ruff without installing unrelated Python frameworks by default

#### Scenario: Node selected
- **WHEN** the user selects Node.js/TypeScript
- **THEN** the plan includes Node.js, npm, pnpm, and TypeScript without globally installing application frameworks by default

### Requirement: Initial development tooling modules
The system SHALL include modules for Git, GitHub CLI, Make, jq, yq, ripgrep, fd, and mise.

#### Scenario: Development tools selected
- **WHEN** the user selects development tools or a profile containing them
- **THEN** the system installs or verifies each selected tool using the component lifecycle contract

### Requirement: Initial infrastructure modules
The system SHALL include modules for Docker, Docker Compose, Portainer, Traefik, PostgreSQL, Redis, and optional MySQL/MariaDB.

#### Scenario: PostgreSQL selected
- **WHEN** the user selects PostgreSQL
- **THEN** the system provisions or verifies PostgreSQL primarily through Docker without deleting existing volumes

### Requirement: Initial security modules
The system SHALL include modules for Gitleaks, Trivy, and Semgrep.

#### Scenario: Security tools selected
- **WHEN** the user selects the security category
- **THEN** the system installs or verifies Gitleaks, Trivy, and Semgrep and makes them available for later development workflows
