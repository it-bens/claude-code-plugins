# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.1.0] - 2025-12-22

### Added

- **Mutable Default Arguments** code smell in `references/code-smells.md` - common Python pitfall where `[]` or `{}` defaults persist between calls

### Changed

- **Constraints section** now includes all "NEVER" rules (consolidated from separate sections)
- **Phase 2 Assessment** now requires verification for each finding (quote code, check context)
- Added WebSearch and WebFetch to allowed-tools (skill) and tools (agent)
- Output format requires quoted code with line numbers
- Enhanced design-principles.md with Library/SDK Pattern Respect section

### Fixed

- False positive prevention: Claims now require exact code quotes
- Metric accuracy: Line counts must be precise, not rounded up
- Context confusion: Explicit file/stage labels required
- Version hallucination: Specific versions require web search verification

**Root cause of fixes:** Investigation revealed 5 out of 8 recommendations were invalid due to:
1. Code parsing failures (missed existing patterns like `async with`)
2. Hallucinated version numbers (e.g., "uvicorn>=0.40" when 0.40 doesn't exist)
3. Domain-inappropriate patterns (caching time-dependent data)
4. Redundant abstractions (enums for `Literal[...]` types)
5. Context confusion (mixing up patterns from different files/stages)

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
