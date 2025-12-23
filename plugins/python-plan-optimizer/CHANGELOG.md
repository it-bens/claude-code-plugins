# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.4.0] - 2025-12-23

### Changed

- **Verification requires flow tracing** - "Verify problem exists" → "Trace data flow to verify incorrect behavior"
- **WebSearch requires confirmation** - "verify via WebSearch" → "only include if documentation confirms it exists"
- **Line counts must distinguish logic** - Report logic lines separately (e.g., "60 logic, 95 total")
- **SRP detection precise** - "Multiple responsibilities" → "2+ unrelated reasons to change"
- **DRY threshold explicit** - Requires 3+ occurrences; 2 may be acceptable locality
- **Severity context-aware** - Added "Context Requirement" column and pre-assignment questions
- **Long Method defined** - "~20 lines of code" → "~20 lines of logic"

### Added

- **DRY "when NOT to apply" guidance** - Prevents over-application

**Root cause:** Investigation of 10 invalid claims revealed vague/incorrect instructions:
1. WebSearch didn't require positive confirmation (fabricated APIs)
2. Severity was context-free (context-blind severity)
3. "Verify problem exists" accepted pattern matches (over-generalized principles)
4. "Lines of code" undefined (inflated metrics)
5. DRY/SRP lacked thresholds (over-application of principles)

Examples: `RateLimitError` claimed without verification, "Critical" severity for single-worker app, `hash()` instability claimed as bug without flow trace, "95 lines" when 60 were logic, DRY violation for 2 occurrences

## [1.3.0] - 2025-12-23

### Changed

- **NEVER constraint broadened** - "library versions" → "library APIs (imports, exceptions, classes, attributes, behavior)"—package splits are common
- **Caching mechanisms explicit** - Added `@cached_property`, `@computed_field`, memoization to stale value warning
- **Generic over-constraining** - Added warning against constraining generics that break valid use cases
- **Verification scope broadened** - Phase 2 step 5 now covers all third-party library claims, not just versions
- **Placeholders recognized** - MUST Respect list now includes intentional placeholders (`# TODO`, `# ...`, stubs)

### Added

- **Concurrency Verification section** - Distinguishes async-safe, thread-safe, and process-safe with examples
- **Decorator Evaluation Timing table** in modern-python.md - Shows when `@property`, `@cached_property`, `@computed_field` execute

**Root cause:** Investigation of 11 invalid claims revealed 5 constraint gaps:
1. Overly narrow verification scope (only "versions", not all API claims)
2. Implicit knowledge assumed (caching behavior, concurrency models, evaluation timing)
3. Missing concept distinctions (async-safe ≠ thread-safe ≠ process-safe)
4. Planning document conventions not recognized (placeholders are intentional)
5. Only one direction covered (redundant wrappers warned, over-constraining not)

Examples: `asyncpraw.exceptions` vs `asyncprawcore`, `asyncio.Lock()` claimed "thread-safe", `@computed_field` recommended for dynamic data, `# TODO` flagged as defect, `TypeVar("T", bound=BaseModel)` breaking `Result[str]`

## [1.2.1] - 2025-12-23

### Fixed

- Agent description now includes "optimize" example for better invocation matching
- Skill body no longer contains service language that competed with agent

**Root cause:** The skill's body content (title "Python Plan Analysis", phrase "Expert Python code review service") acted as competing trigger language. This caused the skill to be invoked directly instead of the agent.

## [1.2.0] - 2025-12-23

### Added

- **Multi-file support** - Analyze multiple documents via directories or file lists
- **File discovery** - Agent uses Glob to find `.md` files and Grep to filter for Python code blocks
- **Cross-document analysis** - Identifies patterns and inconsistencies across documents
- **Batch trigger examples** in agent frontmatter for directory and file list invocations

### Changed

- **List-first design** - All inputs resolve to a document list (even single files become a list of one)
- Agent resolves input to document list, validates each, invokes skill once
- Skill Phase 1 changed from "Read the planning document" to "For each document"
- Phase 5 uses single report template that works for 1 or N documents
- Output contract uses array structure: `documents: [...]` with per-document status

**Root cause of original issue:** Singular language throughout:
- Agent validated "Document Path" (singular)
- Skill said "Read the planning document" (singular)
- Output assumed one document

**Solution approach:** Change singular to iterative language. No mode detection needed - treat everything as a list. A single file is just a list of one document.

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
