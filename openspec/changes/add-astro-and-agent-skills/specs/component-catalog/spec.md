## MODIFIED Requirements

### Requirement: Declarative component manifest
The system SHALL define available components, including `agent-skills`, in a central manifest with category, dependencies, supported platforms, lifecycle module, credential needs, and default selection metadata.

#### Scenario: Load manifest
- **WHEN** the CLI starts a command requiring component metadata
- **THEN** it loads and validates the manifest before planning work

#### Scenario: Load agent skills metadata
- **WHEN** the CLI plans `agent-skills`
- **THEN** it reports Node.js and Git dependencies, no mandatory credentials, supported platforms, lifecycle module, opt-in status, and context cost

### Requirement: Dependency resolution
The system SHALL resolve transitive dependencies for selected components before execution, including the runtime and source-control dependencies required by agent skill installation.

#### Scenario: Laravel dependencies
- **WHEN** the user selects `laravel`
- **THEN** the plan includes required PHP and Composer dependencies before Laravel

#### Scenario: MCP dependencies
- **WHEN** the user selects an MCP integration that requires OpenCode
- **THEN** the plan includes OpenCode unless it is already installed and verified

#### Scenario: Agent skills dependencies
- **WHEN** the user selects `agent-skills`
- **THEN** the plan includes compatible Node.js and Git before installing the collection
