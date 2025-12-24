# Project Type Profiles

Analysis thresholds and configuration for each project type. Load this reference during Phase 2 (Assessment) to apply type-appropriate filtering.

## Profile Definitions

### POC (Proof of Concept)

**Purpose:** Validate an idea quickly; code is likely throw-away.

**Rationale:** "Don't polish what you'll throw away"

| Aspect | Setting | Rationale |
|--------|---------|-----------|
| Severity Threshold | Critical only | Only show blockers |
| Code Smells | Skip all | Not worth refactoring |
| Modern Python | Skip suggestions | Speed over style |
| Documentation | Skip | No long-term maintenance |
| Web Verification | Skip | Accept some risk |
| Report Verbosity | Minimal | Brief, actionable |

**Include in Report:**
- Critical issues that would prevent the POC from working
- Security vulnerabilities (even POCs shouldn't be insecure)

**Exclude from Report:**
- All code smell categories
- All design principle violations except Critical
- Type hint suggestions
- Documentation suggestions
- Modern Python idiom suggestions

---

### MVP (Minimum Viable Product)

**Purpose:** Ship quickly but build a foundation for growth.

**Rationale:** "Good enough to ship, aware of tech debt"

| Aspect | Setting | Rationale |
|--------|---------|-----------|
| Severity Threshold | Critical + High | Balance speed and quality |
| Code Smells | Major only | Large Class, Long Method |
| Modern Python | Type hints only | Foundation for IDE support |
| Documentation | Public API only | User-facing interfaces |
| Web Verification | Critical claims only | Verify important assertions |
| Report Verbosity | Standard | Clear, actionable |

**Include in Report:**
- Critical and High severity issues
- Bloater code smells (Large Class, Long Method, Long Parameter List)
- Type hint recommendations for public interfaces
- Public API documentation gaps

**Exclude from Report:**
- Medium and Low severity issues
- OO Abuser, Coupler, Change Preventer smells
- Internal method documentation
- Advanced modern Python (pattern matching, walrus operator)

---

### Private/Personal Project

**Purpose:** Learning, experimentation, personal utility.

**Rationale:** "Learn from all suggestions"

| Aspect | Setting | Rationale |
|--------|---------|-----------|
| Severity Threshold | All severities | Complete picture |
| Code Smells | All categories | Learning opportunity |
| Modern Python | All suggestions | Exposure to idioms |
| Documentation | Suggest where beneficial | Self-documentation |
| Web Verification | Optional | User's discretion |
| Report Verbosity | Educational | Explain the "why" |

**Include in Report:**
- All severity levels
- All code smell categories
- All design principle violations
- All modern Python suggestions
- **Educational context** for each finding

**Report Style:**
- Explain *why* each pattern is problematic
- Provide learning resources where relevant
- Frame suggestions as learning opportunities

---

### Enterprise Project

**Purpose:** Production system with team collaboration and long maintenance horizon.

**Rationale:** "Must be maintainable by the team for years"

| Aspect | Setting | Rationale |
|--------|---------|-----------|
| Severity Threshold | All severities | Miss nothing |
| Code Smells | All + Cross-document consistency | Team maintainability |
| Modern Python | All + enforce type coverage | IDE support critical |
| Documentation | Required for public interfaces | Team onboarding |
| Web Verification | **Required for all claims** | Production reliability |
| Report Verbosity | Comprehensive with rationale | Decision trail |

**Include in Report:**
- All severity levels
- All code smell categories with emphasis on Change Preventers
- Cross-document consistency checks
- Type coverage enforcement recommendations
- Documentation requirements for public APIs
- Verification status for all external library claims

**Additional Checks:**
- Cross-document pattern consistency
- Naming convention adherence
- Error handling completeness
- Logging and observability patterns

**Web Verification Requirement:**
- ALL claims about external libraries MUST be verified via WebSearch
- Include verification status in findings
- Flag unverified claims as "Needs Verification"

---

### Open Source Project

**Purpose:** Public library/tool consumed by unknown developers.

**Rationale:** "Unknown consumers depend on your API; type hints and docs are their primary interface"

| Aspect | Setting | Rationale |
|--------|---------|-----------|
| Severity Threshold | All severities | Quality is public |
| Code Smells | All + API design patterns | Public surface matters |
| Modern Python | All + **type hints required** | Consumers need IDE support |
| Documentation | **Required** for all public API | Primary interface for users |
| Web Verification | Required for claims | Public credibility |
| Report Verbosity | Comprehensive + API stability | Consumer impact |

**Include in Report:**
- All severity levels
- All code smell categories
- API design pattern analysis
- **Mandatory type hint coverage** for public API
- **Mandatory documentation** for public API
- Breaking change detection
- Semver implications

**Open Source-Specific Checks:**

| Check | Severity | Rationale |
|-------|----------|-----------|
| Public function without docstring | High | Consumers can't understand usage |
| Public function without type hints | High | IDE support broken for consumers |
| Public class without `__slots__` consideration | Low | Memory optimization for consumers |
| Missing `__all__` in public modules | Medium | Import ambiguity |
| API change that could break consumers | Warning | Semver guidance needed |
| Missing py.typed marker consideration | Low | Type checker support |

**Breaking Change Detection:**
Look for patterns that could break consumers:
- Renamed public classes/functions
- Changed method signatures
- Removed public attributes
- Changed exception types
- Modified return types

When detected, flag with: "**Breaking Change:** This modification would affect existing consumers. Consider semver implications."

---

## Threshold Loading

During Phase 2 (Assessment), apply the appropriate profile filters:

| Type | Severities | Smell Categories | Web Verification | Special |
|------|------------|------------------|------------------|---------|
| poc | Critical | None | Skip | Minimal report |
| mvp | Critical, High | Bloaters | Critical only | Standard report |
| private | All | All | Optional | Educational mode |
| enterprise | All | All | **Required** | Cross-document checks |
| opensource | All | All + API | Required | Type hints + docs required |

## Report Header

Add project type context to every report:

```markdown
## Analysis Report

**Project Type:** [type] (source: [prompt|document|user])
**Analysis Mode:** [description based on profile]

---
```

**Analysis Mode Descriptions:**

| Type | Mode Description |
|------|------------------|
| poc | Minimal analysis - critical issues only |
| mvp | Balanced analysis - critical and high priority issues |
| private | Full analysis - all findings with educational context |
| enterprise | Strict analysis - all findings, verification required |
| opensource | API-focused analysis - all findings, type hints and docs required |

## Fallback Behavior

If project type is not determined:
- Default to `private` (most permissive)
- Report includes: "Project type not specified - using full analysis mode (private)"
