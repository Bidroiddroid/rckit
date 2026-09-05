# ai-tooling-integration Specification

## Purpose
TBD - created by archiving change build-ai-dev-bootstrap. Update Purpose after archive.
## Requirements
### Requirement: OpenCode integration
The system SHALL install and configure OpenCode only when selected directly, selected through a profile, or required by a selected component.

#### Scenario: OpenCode selected
- **WHEN** the user selects OpenCode
- **THEN** the system installs or verifies OpenCode and prepares safe default configuration without granting unrestricted permissions

### Requirement: OpenSpec integration
The system SHALL install and configure OpenSpec only when selected directly, selected through a profile, or required by the selected AI development workflow.

#### Scenario: OpenSpec selected
- **WHEN** the user selects OpenSpec
- **THEN** the system installs or verifies OpenSpec and prepares project workflow templates

### Requirement: MCP opt-in configuration
The system SHALL keep MCP integrations individually selectable and disabled by default unless selected by the user or included in a selected profile.

#### Scenario: Select one MCP
- **WHEN** the user selects only the GitHub MCP
- **THEN** the system configures only the GitHub MCP and its required dependencies

### Requirement: Credential-safe AI configuration
The system SHALL never write secrets into Git-tracked files and SHALL request credentials only when required by a selected integration.

#### Scenario: MCP requires token
- **WHEN** a selected MCP requires an API token
- **THEN** the system prompts for secure local configuration and writes only non-secret placeholders to templates
