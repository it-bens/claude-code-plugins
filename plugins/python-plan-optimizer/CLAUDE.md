@README.md

# Development Guide

## File Navigation

| When you need to... | Consult |
|---------------------|---------|
| Understand plugin purpose and usage | `README.md` |
| Modify agent triggering behavior | `agents/python-plan-optimizer.md` |
| Update analysis workflow | `skills/python-plan-optimization/SKILL.md` |
| Add or modify design principles | `skills/.../references/design-principles.md` |
| Update modern Python guidance | `skills/.../references/modern-python.md` |
| Modify code smell detection | `skills/.../references/code-smells.md` |
| Update compatibility checks | `skills/.../references/behavioral-compatibility.md` |

## Directory Relationships

### `agents/` vs `skills/`

This plugin uses the **thin agent wrapper pattern**:

- **`agents/python-plan-optimizer.md`** - Thin wrapper that validates input and delegates to the skill. Contains triggering examples, input validation flowchart, and output contract. Does NOT contain analysis logic.

- **`skills/python-plan-optimization/SKILL.md`** - Core analysis logic with the 5-phase workflow. Contains all domain knowledge about design principles, code smells, and Python modernization.

**Rule:** If modifying analysis behavior, edit the skill. If modifying when/how the agent is triggered, edit the agent.

### `skills/.../references/`

Reference files provide progressive disclosure:

- **Main SKILL.md** - Always loaded, contains workflow overview and quick reference tables
- **Reference files** - Loaded on demand when deeper guidance is needed

| File | Purpose | When Loaded |
|------|---------|-------------|
| `design-principles.md` | Detailed SOLID/DRY/KISS/YAGNI examples | During Phase 2 assessment |
| `modern-python.md` | Type hints, dataclasses, idioms | During Phase 4 recommendations |
| `code-smells.md` | Detection patterns and suggestions | During Phase 2 assessment |
| `behavioral-compatibility.md` | Impact consideration checklist | During Phase 5 report |

## Agent-Skill Pattern

The thin agent wrapper pattern separates concerns.

**Design principle:** All inputs resolve to a document list (even if it's a list of one). No mode detection needed - the same workflow handles 1 or N documents.

```
User Request (file, directory, or list)
    ↓
AGENT: python-plan-optimizer
    ├─ Resolve input to document list:
    │   ├─ Single file → [file]
    │   ├─ Directory → Glob **/*.md → filter has Python
    │   └─ File list → parse paths
    ├─ Validate each file
    ├─ If no valid documents → Return SKIPPED/FAILED
    └─ Invoke Skill
                    ↓
SKILL: python-plan-optimization (READ-ONLY)
    ├─ Phase 1: Discovery (for each document)
    ├─ Phase 2: Assessment (uses design-principles.md, code-smells.md)
    ├─ Phase 3: Planning (filter conflicting suggestions)
    ├─ Phase 4: Recommendations (uses modern-python.md)
    └─ Phase 5: Report (summary + per-document findings)
                    ↓
Output: Analysis Report (NO FILES MODIFIED)
```

**Agent responsibilities:**
- Resolve input to document list
- File discovery (for directories)
- Validate each document
- Structured output contract

**Skill responsibilities:**
- All domain knowledge
- 5-phase workflow (iterates over documents)
- Report generation

## Extending the Plugin

### Adding New Design Principles

1. Add detailed guidance to `references/design-principles.md`
2. Add quick reference entry to the table in `SKILL.md` Phase 2
3. Consider if new detection patterns needed in `code-smells.md`

### Adding New Code Smells

1. Add detection pattern and refactoring to `references/code-smells.md`
2. Add to the Code Smell Categories table in `SKILL.md` Phase 2
3. Categorize under appropriate group (Bloaters, OO Abusers, etc.)

### Adding Modern Python Features

1. Add feature guidance to `references/modern-python.md`
2. Add to Modern Python Features table in `SKILL.md` Phase 4
3. Include before/after code examples

### Modifying Agent Triggers

1. Add new `<example>` blocks to agent description
2. Follow the pattern: Context, user message, assistant response, commentary
3. Keep examples focused on trigger scenarios, not workflow details

## Critical Behavior Notes

### Read-Only Scope is Non-Negotiable

This plugin operates in **read-only mode**:
- No files are modified
- All suggestions are presented in the report
- Users decide what to implement

### Respecting Architectural Decisions

When the document contains explicit architectural decisions:
- **Recognize** patterns like "We chose X because Y"
- **Do NOT suggest** replacing explicitly chosen approaches
- **MAY suggest** improvements within the chosen framework
- **Always clarify** suggestions are opportunities, not requirements

### Suggestions as Opportunities

All recommendations must be framed appropriately:
- Use language like "Consider...", "An alternative could be..."
- Never present findings as requirements or mandates
- Acknowledge tradeoffs when suggesting changes
- Respect that the document author may have context we don't

### No Questions Policy

The agent uses SKIPPED/FAILED status with reasons instead of asking questions. This enables:
- Batch processing of multiple files
- Predictable automation
- Clear success/failure outcomes
