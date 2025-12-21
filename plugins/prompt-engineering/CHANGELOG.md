# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.2.0] - 2025-12-21

Testing in Claude Web revealed the skill wasn't auto-activating. Root causes: skill description used meta-language instead of action-first pattern, and project system prompt's comprehensive inline content made Claude treat it as self-sufficient guidance, bypassing skill file reading entirely.

### Changed

- Rewrote skill description following Anthropic's official pattern to fix auto-activation
- Reduced project system prompt from 248 to 18 lines, delegating all content to SKILL.md

## [1.1.0] - 2025-12-21

### Changed

- Renamed "Phase 1: Requirements Analysis" to "Phase 1: Prompt Scoping" to avoid software engineering terminology confusion
- Reframed all clarification questions to explicitly anchor to "the prompt" being created
- Added boundary guidance: "stay at the prompt level, don't dive into subject matter"

### Added

- Explicit meta-level statement in Core Mission: deliverable is always a prompt artifact, never task execution

### Fixed

- Resolved issue where skill would gather requirements for subject matter instead of for the prompt itself

## [1.0.0] - 2024-12-21

### Added

- Core `prompt-engineering` skill with 3-phase workflow (Requirements, Design, Delivery)
- Reference docs: prompting techniques, Claude 4 guide, prompt patterns
- Example templates: system prompts, prompt chains, optimization reports
- Claude Web project files for cross-platform compatibility
- Refinement mode for iterative prompt modifications
