# Tandoor Recipe Converter

Convert recipe images, PDFs, text, or URLs into Tandoor-compatible JSON format with German language output.

## Overview

This plugin transforms recipes from various sources into valid Tandoor JSON with 100% compatibility. All recipe content is output in German, following Tandoor's formatting requirements.

**Key Features:**
- **Multi-Input Support** - Convert from images, PDFs, pasted text, or recipe URLs
- **Automatic Translation** - Translates recipes to German regardless of source language
- **Unit Conversion** - Converts imperial to metric measurements
- **Ingredient Normalization** - Singular forms, proper German terminology
- **Quality Scoring** - Confidence-based validation with clear warnings
- **Dual Platform** - Works in both Claude Web and Claude Code

## Quick Start

### Installation

```bash
/plugin install tandoor-recipe-converter@it-bens
```

### Basic Usage

Convert recipes using natural language:

```
Convert this recipe image to Tandoor JSON
Import the recipe from this PDF
Convert: [paste recipe text here]
Fetch and convert the recipe from https://example.com/recipe
```

### Claude Code: File Output

Use the `/convert-recipe` command to automatically save JSON files:

```
/convert-recipe path/to/recipe.pdf
/convert-recipe https://example.com/chocolate-cake
```

The command saves `<recipe-name>.json` to your current directory.

### Claude Web: Artifact Download

In Claude Web, the skill creates an artifact with a download button. Click "Download" in the artifact's lower-right corner to save the JSON file.

## Input Types

| Type | Example | Notes |
|------|---------|-------|
| Image | Upload recipe photo | OCR extraction |
| PDF | Upload recipe PDF | Native text or OCR |
| Text | Paste recipe content | Direct processing |
| URL | Recipe website link | WebFetch + extraction |

## Output Format

The converter produces:

1. **Conversion Report** - Quality score, warnings, estimations
2. **Recipe JSON** - Valid Tandoor-compatible JSON
3. **Suggested Filename** - Based on recipe name

### Example Output

```json
{
  "name": "Schokoladenkuchen",
  "description": "Ein klassischer Schokoladenkuchen",
  "keywords": [{"name": "kuchen", ...}],
  "steps": [
    {
      "name": "",
      "instruction": "Ofen auf 180°C vorheizen.",
      "ingredients": [...],
      "time": 5,
      "order": 0
    }
  ],
  "working_time": 25,
  "waiting_time": 35,
  "servings": 12
}
```

## Critical Formatting Rules

These rules ensure Tandoor import compatibility:

| Rule | Correct | Incorrect |
|------|---------|-----------|
| Amounts | `1.0`, `2.5` (float) | `1`, `2` (integer) |
| Step names | `""` (empty string) | `"Step 1"` |
| Timestamps | `.000000` (microseconds) | Missing microseconds |
| Ingredients | `"Ei"` (singular) | `"Eier"` (plural) |
| Language | German | Source language |

## Estimation Markers

When values are estimated, they are marked with `[GESCHÄTZT - BITTE PRÜFEN]`:

```json
{
  "note": "nach Geschmack [GESCHÄTZT - BITTE PRÜFEN]"
}
```

Review these values before importing.

## Quality Scoring

| Score | Status | Action |
|-------|--------|--------|
| ≥95 | ✅ Ready | Import directly |
| ≥80 | ⚠️ Warnings | Review warnings first |
| ≥60 | 🔍 Review | Manual verification needed |
| <60 | ❌ Reject | Needs rework |

## Workflow Phases

1. **Input Analysis** - Extract text, assess OCR quality
2. **Data Normalization** - German translation, unit conversion
3. **Data Completion** - Generate missing times, servings
4. **JSON Generation** - Create schema-compliant JSON
5. **Validation** - Quality scoring and report

## Contents

```
tandoor-recipe-converter/
├── .claude-plugin/
│   └── plugin.json
├── CLAUDE.md
├── README.md
├── commands/
│   └── convert-recipe.md       # Claude Code file-save command
├── skills/
│   └── tandoor-recipe-conversion/
│       ├── SKILL.md            # Core conversion workflow
│       └── references/
│           ├── unit-conversions.md
│           ├── ingredient-map.md
│           ├── tandoor-schema.md
│           ├── time-estimates.md
│           └── error-handling.md
└── project/                    # Claude Web compatibility
    ├── system-prompt.md
    ├── title.txt
    └── description.txt
```

## Reference Documentation

Detailed tables available in:
- `skills/tandoor-recipe-conversion/references/unit-conversions.md` - Imperial to metric
- `skills/tandoor-recipe-conversion/references/ingredient-map.md` - German normalization
- `skills/tandoor-recipe-conversion/references/tandoor-schema.md` - JSON structure
- `skills/tandoor-recipe-conversion/references/time-estimates.md` - Cooking times
- `skills/tandoor-recipe-conversion/references/error-handling.md` - Recovery strategies

## Compatibility

- **Tandoor Recipes**: 1.5+
- **Claude Web**: Full support (artifact output)
- **Claude Code**: Full support (file output via command)

## License

MIT
