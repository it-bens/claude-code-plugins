@README.md

# Development Guide

## File Navigation

| When you need to... | Consult |
|---------------------|---------|
| Understand plugin purpose and usage | `README.md` |
| Modify conversion workflow | `skills/tandoor-recipe-conversion/SKILL.md` |
| Update unit conversion tables | `skills/.../references/unit-conversions.md` |
| Modify ingredient normalization | `skills/.../references/ingredient-map.md` |
| Update JSON schema rules | `skills/.../references/tandoor-schema.md` |
| Modify cooking time estimates | `skills/.../references/time-estimates.md` |
| Update error recovery strategies | `skills/.../references/error-handling.md` |
| Modify Claude Code file output | `commands/convert-recipe.md` |

## Directory Relationships

### `skills/` vs `commands/`

This plugin uses the **skill + command wrapper pattern**:

- **`skills/tandoor-recipe-conversion/SKILL.md`** - Core conversion logic. Works in both Claude Web and Claude Code. Outputs structured JSON in conversation.

- **`commands/convert-recipe.md`** - Claude Code wrapper. Invokes the skill, extracts JSON, writes to file. Adds file system operations.

**Rule:** If modifying conversion logic, edit the skill. If modifying file output behavior, edit the command.

### `skills/.../references/`

Reference files provide progressive disclosure:

- **Main SKILL.md** - Always loaded, contains workflow overview and quick reference tables
- **Reference files** - Loaded on demand when deeper guidance is needed

| File | Purpose | When Loaded |
|------|---------|-------------|
| `unit-conversions.md` | Imperial→metric conversion table | During Phase 2 normalization |
| `ingredient-map.md` | German ingredient names, plural exceptions | During Phase 2 normalization |
| `tandoor-schema.md` | JSON structure, field requirements | During Phase 4 generation |
| `time-estimates.md` | Cooking times by dish type | During Phase 3 completion |
| `error-handling.md` | Recovery strategies for failures | When errors occur |

### `project/`

Claude Web compatibility files:

- **`system-prompt.md`** - Embedded version of skill for Claude Web projects
- **`title.txt`** - Project title
- **`description.txt`** - Project description

## Workflow Architecture

```
User Input (image, PDF, text, or URL)
    ↓
SKILL: tandoor-recipe-conversion
    ├─ Phase 1: Input Analysis
    │   ├─ Detect input type
    │   ├─ OCR extraction (if image/PDF)
    │   └─ Quality assessment
    ├─ Phase 2: Data Normalization
    │   ├─ Translate to German
    │   ├─ Convert units (uses unit-conversions.md)
    │   └─ Normalize ingredients (uses ingredient-map.md)
    ├─ Phase 3: Data Completion
    │   ├─ Estimate missing times (uses time-estimates.md)
    │   └─ Generate servings, keywords
    ├─ Phase 4: JSON Generation
    │   └─ Create Tandoor JSON (uses tandoor-schema.md)
    └─ Phase 5: Validation & Output
        ├─ Quality scoring
        ├─ Report generation
        └─ JSON output
                ↓
┌─────────────────────────────────────────┐
│            Platform-Specific            │
├─────────────────────────────────────────┤
│ Claude Web: Artifact with download      │
│ Claude Code: /convert-recipe → file     │
└─────────────────────────────────────────┘
```

## Extending the Plugin

### Adding New Unit Conversions

1. Add entry to `references/unit-conversions.md` table
2. Include original unit, factor, target unit, notes, confidence
3. Test with sample recipe containing that unit

### Adding New Ingredient Normalizations

1. Add entry to `references/ingredient-map.md` table
2. Include input terms, standard German name, category, plural exception flag
3. Ensure singular form is used (unless plural exception)

### Modifying Time Estimates

1. Edit `references/time-estimates.md`
2. Update or add dish type with working_time, waiting_time, confidence
3. Add examples for the dish type

### Updating JSON Schema Rules

1. Edit `references/tandoor-schema.md`
2. Update field requirements, validation rules, or structure
3. Update the JSON template example
4. Ensure Phase 4 in SKILL.md reflects changes

## Critical Behavior Notes

### Float Amounts Are Non-Negotiable

Tandoor's database expects DECIMAL fields. All amounts MUST be floats:
- ✅ `"amount": 1.0`
- ❌ `"amount": 1`

### Empty Step Names Required

Tandoor renders step names as headings. Non-empty names break layout:
- ✅ `"name": ""`
- ❌ `"name": "Step 1"`

### German Language Output

All output must be in German for DACH region Tandoor instances:
- Translate all source content
- Use German ingredient names
- German cooking instructions

### Estimation Markers

When values are estimated, always mark with `[GESCHÄTZT - BITTE PRÜFEN]`:
- Enables user verification
- Maintains transparency
- Required for estimated cooking times, missing amounts

### Singular Ingredient Names

Tandoor's shopping list auto-pluralizes. Use singular to avoid double pluralization:
- ✅ `"name": "Ei"`
- ❌ `"name": "Eier"` → would become "Eiern" incorrectly

**Exception:** Some items are always plural (see `ingredient-map.md` for `always_use_plural_food: true` items like "Spaghetti").

## Testing

### Test Cases

1. **Image Input** - Recipe photo with clear text
2. **PDF Input** - Multi-page recipe PDF
3. **Text Input** - Pasted recipe from website
4. **URL Input** - Recipe website URL
5. **Imperial Units** - Recipe with cups, tablespoons
6. **Mixed Language** - English recipe requiring translation
7. **Missing Data** - Recipe without times or servings
8. **Low Quality OCR** - Blurry or handwritten recipe

### Validation Checklist

- [ ] JSON parses without errors
- [ ] All amounts are floats
- [ ] All step names are empty strings
- [ ] Timestamps have microseconds
- [ ] Ingredients are singular (except exceptions)
- [ ] Content is in German
- [ ] Estimated values are marked
