# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.1] - 2025-12-22

### Fixed

- Agent description now includes "optimize" trigger verb for better invocation matching
- Skill description no longer contains triggering language that competed with agent

**Root cause:** The skill's description contained "Use when..." triggering language that should only exist in the agent. This caused the skill to be invoked directly instead of the agent when users requested optimization.

**Before (skill invoked instead of agent):**
> "Invoke the python-plan-optimizer:python-plan-optimizer agent to optimize the plans python code..."

**After (agent correctly invoked):**
> "Invoke the python-plan-optimizer:python-plan-optimizer subagent to optimize the plans python code..."

## [1.0.0] - 2025-12-22

### Added

- Core `python-plan-optimization` skill with 5-phase read-only workflow
- Thin agent wrapper following testing plugin pattern
- Analysis of SOLID, DRY, KISS, YAGNI principles, code smells, and modern Python idioms
- Reference documentation with progressive disclosure
- Architectural decision recognition and behavioral compatibility checklist
- README.md and CLAUDE.md documentation
