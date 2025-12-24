---
allowed-tools: Skill, Write, Bash, Read
argument-hint: [file-path-or-url]
description: Convert recipe to Tandoor-importable ZIP. Rezept in Tandoor-Import-ZIP konvertieren.
---

# Convert Recipe to ZIP Command

Convert a recipe from an image, PDF, URL, or text to a Tandoor-importable ZIP archive.

## Input

The input is: `$ARGUMENTS`

If no argument is provided, ask the user to provide:
- A file path to an image or PDF
- A recipe URL
- Or paste recipe text directly

## Tandoor ZIP Structure

Tandoor expects this nested ZIP structure for import:

```
recipe-name.zip
└── 1.zip
    └── recipe.json
```

Import via: **Import recipe → App → Tandoor**

## Workflow

1. **Invoke the tandoor-recipe-converter:tandoor-recipe-conversion skill** with the provided input
2. **Extract the JSON** from the skill output (look for the ```json code block)
3. **Determine the filename** from the suggested filename in the output (use `.zip` extension)
4. **Create the ZIP archive** with nested structure
5. **Clean up** temporary files

## Execution

First, invoke the recipe conversion skill:

Use Skill(tandoor-recipe-converter:tandoor-recipe-conversion) with the input: $ARGUMENTS

After the skill completes:

1. Extract the JSON content from the skill output
2. Get the suggested filename (kebab-case based on recipe name)
3. Create the nested ZIP structure:

```bash
# Create temp directory
TMPDIR=$(mktemp -d)

# Write recipe.json to temp dir (use Write tool)
# Then create inner 1.zip
cd "$TMPDIR" && zip -j 1.zip recipe.json

# Create outer archive in current directory
zip -j "<recipe-name>.zip" "$TMPDIR/1.zip"

# Cleanup temp directory
rm -rf "$TMPDIR"
```

4. Report success with the file path

## Output

After saving, report:
- The file path where the ZIP was saved
- The quality score from the conversion
- Any warnings that require attention
- Import instructions

Example output:
```
✅ Recipe saved to: schokoladenkuchen.zip
Quality Score: 92/100

📦 ZIP Structure:
└── 1.zip
    └── recipe.json

Import via: Tandoor → Import recipe → App → Tandoor

⚠️ Estimated values to review:
- Cooking time estimated based on dish type
```
