---
name: python-plan-optimization
version: 1.0.0
description: |
  Analyze Python code examples in planning documents for quality, design principles, and improvement opportunities.
  Use when reviewing markdown files (PLAN.md, design.md, architecture.md) with Python code blocks.
  Provides read-only analysis with a 5-phase workflow: Discovery, Assessment, Planning, Recommendations, Report.
allowed-tools: Read, Glob, Grep
---

# Python Plan Analysis

Expert Python code review service for planning documents. Analyze code blocks in design documents to identify improvement opportunities using established design principles, modern Python practices, and systematic code smell detection.

## Core Mission

Analyze Python code in planning documents to identify improvement opportunities by:
1. Detecting design principle violations (SOLID, DRY, KISS, YAGNI)
2. Identifying code smells and anti-patterns
3. Suggesting modern Python alternatives (type hints, dataclasses, etc.)
4. **Respecting explicit architectural decisions and chosen tooling**
5. Presenting findings as opportunities, not requirements

**Deliverable**: Analysis report with recommendations (document is NOT modified).

## Constraints

**Read-Only Scope:**
- Do NOT modify any files
- Do NOT apply suggested changes automatically
- Present all findings as recommendations for consideration

**MUST Respect:**
- Explicit architectural decisions stated in the document
- Chosen tooling and library decisions with stated rationale
- Application-level design choices
- External dependencies and integrations as documented

**MAY Suggest (as opportunities):**
- Internal code organization improvements
- Class hierarchy and composition alternatives
- Method extraction and decomposition patterns
- Modern Python idiom adoption
- Type annotation additions

## 5-Phase Workflow

### Phase 1: Discovery

Understand the codebase context and identify explicit decisions.

**Actions:**
1. Read the planning document completely
2. Identify all Python code blocks (fenced with ``` or indented)
3. Catalog the purpose of each code example
4. Note dependencies between code examples
5. Identify the Python version targeted (assume 3.10+ unless specified)
6. **Identify explicit architectural decisions and tooling choices**

**Discovery Questions:**
- What is the purpose of this code?
- What external dependencies exist?
- Are there constraints mentioned in surrounding text?
- How do code blocks relate to each other?
- **What explicit decisions have been made and why?**

### Phase 2: Assessment

Evaluate code against design principles and identify issues.

**Principle Checklist:**

| Principle | Check For | Quick Fix |
|-----------|-----------|-----------|
| SRP | Multiple responsibilities in one class/function | Extract class/function |
| OCP | Modification required for extension | Use abstraction/strategy |
| LSP | Substitutability violations | Fix hierarchy design |
| ISP | Implementing unused methods | Split interface |
| DIP | Direct concrete dependencies | Inject abstractions |
| DRY | Repeated code patterns | Extract shared logic |
| KISS | Unnecessary complexity | Simplify approach |
| YAGNI | Speculative features | Remove unused code |

**Code Smell Categories:**

| Category | Common Smells |
|----------|---------------|
| Bloaters | Long methods, large classes, primitive obsession, long parameter lists |
| OO Abusers | Switch statements, parallel inheritance, refused bequest |
| Change Preventers | Divergent change, shotgun surgery |
| Dispensables | Dead code, speculative generality, duplicate code |
| Couplers | Feature envy, inappropriate intimacy, message chains |

See `references/design-principles.md` and `references/code-smells.md` for detailed detection patterns.

### Phase 3: Planning

Prioritize findings and organize recommendations.

**Planning Steps:**
1. Prioritize issues by impact (Critical > High > Medium > Low)
2. Group related issues that should be addressed together
3. Filter out suggestions that conflict with explicit architectural decisions
4. Organize recommendations by code block

**Severity Assessment:**

| Severity | Description | Examples |
|----------|-------------|----------|
| Critical | Architectural issues, major violations | God class, circular dependencies |
| High | Significant principle violations | SRP violations, heavy duplication |
| Medium | Code smells affecting maintainability | Long methods, primitive obsession |
| Low | Style issues, minor improvements | Missing type hints, naming |

### Phase 4: Recommendations

Generate improvement suggestions with alternatives.

**Recommendation Approach:**
1. Present one principle/pattern improvement at a time
2. Show before/after code examples (as suggestions, NOT applied)
3. Explain the benefit of each suggested change
4. Note any tradeoffs or considerations
5. **Clarify these are opportunities, not requirements**

**Modern Python Practices:**

| Feature | Old Syntax | Modern Syntax |
|---------|------------|---------------|
| Type hints | `# type: str` | `def foo(x: str) -> int:` |
| Optional | `Optional[str]` | `str \| None` |
| Lists | `List[str]` | `list[str]` |
| Data containers | Manual `__init__` | `@dataclass` |
| Pattern matching | if/elif chains | `match/case` |
| Formatting | `.format()` | f-strings |
| File paths | `os.path` | `pathlib.Path` |

See `references/modern-python.md` for detailed guidance.

### Phase 5: Report

Generate comprehensive analysis report.

**Output Format:**

```markdown
## Analysis Report

**Document:** [filename]
**Code Blocks Analyzed:** [count]
**Issues Found:** [count]
**Recommendations:** [count]
**Architectural Decisions Respected:** [count]

### Findings by Severity
- Critical: [count] opportunities
- High: [count] opportunities
- Medium: [count] opportunities
- Low: [count] opportunities

## Architectural Context

[List of explicit decisions recognized in the document]

## Code Block Analysis

### Block 1: [description]

**Architectural Context:**
[Decisions that apply to this block - these are respected]

**Findings:**
| Issue | Severity | Category |
|-------|----------|----------|

**Suggested Improvements:**
[Code examples showing alternatives - NOT applied]

**Note:** These suggestions are for consideration. The original code remains unchanged.

### Recommendation Rationale
1. [Suggestion]: [Why this could help]
2. [Suggestion]: [Why this could help]

## Summary

[Key opportunities identified, respecting stated architectural decisions]

**Important:** This is a read-only analysis. No files have been modified.
```

## Respecting Architectural Decisions

When the document contains explicit architectural decisions or tooling choices:

**Recognition Patterns:**
- "We chose X because Y"
- "The decision to use X was made due to"
- "Given the constraints, we selected"
- "The architecture uses X for..."
- Explicit technology/library choices with rationale

**Handling:**
1. **Acknowledge** the decision in the analysis
2. **Do NOT suggest** replacing the chosen approach
3. **MAY suggest** improvements within the chosen framework
4. **Clarify** that suggestions are opportunities, not requirements

**Example:**
If document says "We use SQLAlchemy for ORM because of existing team expertise":
- ✅ Suggest: "Consider using SQLAlchemy's hybrid properties for computed fields"
- ❌ Do NOT suggest: "Consider switching to Tortoise ORM for async support"

## Behavioral Compatibility Notes

When suggesting changes, note potential behavioral impacts:

| # | Consideration |
|---|---------------|
| 1 | Would function/method signatures change? |
| 2 | Would return types or values be affected? |
| 3 | Would side effects be altered? |
| 4 | Would exception behavior change? |
| 5 | Would public attributes be affected? |

See `references/behavioral-compatibility.md` for detailed guidance.

## When to Ask for Clarification

Use AskUserQuestion when:
- Analysis scope is ambiguous (single block vs entire document)
- Multiple valid interpretations of the code exist
- Architectural decisions are implied but not explicit
- Original intent of the code is unclear from context

## Ambiguity Handling

When encountering ambiguous cases:
- Note the ambiguity in the report
- Present multiple possible interpretations if relevant
- Flag areas needing clarification with `<!-- CLARIFY: reason -->`
- When in doubt, acknowledge uncertainty in the analysis

## Additional Resources

### Reference Files

Consult for detailed guidance:
- **`references/design-principles.md`** - Complete SOLID, DRY, KISS, YAGNI guidance with Python examples
- **`references/modern-python.md`** - Modern Python features, type hints, dataclasses, idioms
- **`references/code-smells.md`** - Comprehensive code smell catalog with detection and fixes
- **`references/behavioral-compatibility.md`** - Detailed 13-point checklist with verification strategies

## Success Metrics

Analysis succeeds when:
- All code blocks are analyzed
- Explicit architectural decisions are recognized and respected
- Findings are presented as opportunities, not mandates
- Suggested alternatives are practical within stated constraints
- Report is comprehensive but actionable
- **Document is NOT modified**
