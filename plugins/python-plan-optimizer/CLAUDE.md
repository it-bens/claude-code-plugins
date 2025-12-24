@README.md

# Development Guide

## File Navigation

| When you need to... | Consult |
|---------------------|---------|
| Understand plugin purpose and usage | `README.md` |
| Modify agent triggering/orchestration | `agents/python-plan-optimizer.md` |
| Update project type detection | `skills/project-type-determination/SKILL.md` |
| Update analysis workflow | `skills/python-plan-optimization/SKILL.md` |
| Modify project type thresholds | `skills/.../references/project-type-profiles.md` |
| Add or modify design principles | `skills/.../references/design-principles.md` |
| Update modern Python guidance | `skills/.../references/modern-python.md` |
| Modify code smell detection | `skills/.../references/code-smells.md` |
| Update compatibility checks | `skills/.../references/behavioral-compatibility.md` |

## Directory Relationships

### `agents/` vs `skills/`

This plugin uses the **two-skill orchestration pattern**:

- **`agents/python-plan-optimizer.md`** - Orchestrates two skills in sequence. Contains triggering examples, input validation, and output contract. Coordinates Phase A (type determination) and Phase B (analysis).

- **`skills/project-type-determination/SKILL.md`** - Determines project type from prompt, document, or user. Outputs `project_type` and `source` for the optimization skill to consume.

- **`skills/python-plan-optimization/SKILL.md`** - Core analysis logic with the 6-phase workflow. Reads project type from context and applies appropriate thresholds.

**Rule:** If modifying analysis behavior, edit the optimization skill. If modifying type detection, edit the determination skill. If modifying orchestration/triggering, edit the agent.

### `skills/.../references/`

Reference files provide progressive disclosure:

- **Main SKILL.md** - Always loaded, contains workflow overview and quick reference tables
- **Reference files** - Loaded on demand when deeper guidance is needed

| File | Purpose | When Loaded |
|------|---------|-------------|
| `project-type-profiles.md` | Thresholds and filters per project type | During Phase 0 context |
| `design-principles.md` | Detailed SOLID/DRY/KISS/YAGNI examples | During Phase 2 assessment |
| `modern-python.md` | Type hints, dataclasses, idioms | During Phase 4 recommendations |
| `code-smells.md` | Detection patterns and suggestions | During Phase 2 assessment |
| `behavioral-compatibility.md` | Impact consideration checklist | During Phase 5 report |

## Agent-Skill Pattern

The two-skill orchestration pattern separates concerns.

**Design principle:** Two-phase workflow ensures project type is determined before analysis. All inputs resolve to a document list (even if it's a list of one).

```
User Request (file, directory, or list)
    ↓
AGENT: python-plan-optimizer
    │
    ├─ PHASE A: Project Type Determination
    │   └─ Invoke Skill: project-type-determination
    │       ├─ Check prompt for explicit type
    │       ├─ Scan documents for type statements
    │       └─ If not found → AskUserQuestion
    │       Output: project_type, source
    │
    └─ PHASE B: Document Analysis
        ├─ Resolve input to document list:
        │   ├─ Single file → [file]
        │   ├─ Directory → Glob **/*.md → filter has Python
        │   └─ File list → parse paths
        ├─ Validate each file
        ├─ If no valid documents → Return SKIPPED/FAILED
        └─ Invoke Skill: python-plan-optimization
                        ↓
SKILL: python-plan-optimization (READ-ONLY)
    ├─ Phase 0: Load project type from context
    ├─ Phase 1: Discovery (for each document)
    ├─ Phase 2: Assessment (apply type filters)
    ├─ Phase 3: Planning (filter to included severities)
    ├─ Phase 4: Recommendations (uses modern-python.md)
    └─ Phase 5: Report (includes project type header)
                        ↓
Output: Analysis Report (NO FILES MODIFIED)
```

**Agent responsibilities:**
- Orchestrate two skills in sequence
- Resolve input to document list
- File discovery (for directories)
- Validate each document
- Structured output contract

**Skill responsibilities (project-type-determination):**
- Detect type from prompt or document
- Ask user when type is ambiguous
- Output project_type and source

**Skill responsibilities (python-plan-optimization):**
- Read project type from context
- Apply type-appropriate thresholds
- 6-phase workflow (iterates over documents)
- Report generation with type header

## Extending the Plugin

### Modifying Project Type Thresholds

1. Edit `references/project-type-profiles.md`
2. Adjust severity filters, smell categories, or special checks
3. Update the threshold table in `python-plan-optimization/SKILL.md` Phase 0 if needed

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

### Question Policy

**Project Type Determination:** May ask user via AskUserQuestion when type cannot be inferred from prompt or document. This is the only interactive component.

**Analysis (all other phases):** Uses SKIPPED/FAILED status with reasons instead of asking questions. This enables:
- Batch processing of multiple files
- Predictable automation
- Clear success/failure outcomes

**Skipping the Question:** To avoid being asked, include project type in your prompt:
- "Analyze my **enterprise** project's PLAN.md"
- "Review this **MVP** plan"
