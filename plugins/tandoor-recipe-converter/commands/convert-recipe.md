---
allowed-tools: Skill, Write, Read
argument-hint: [file-path-or-url]
description: Convert recipe to Tandoor JSON and save to file. Rezept in Tandoor-JSON konvertieren und als Datei speichern.
---

# Convert Recipe Command

Convert a recipe from an image, PDF, URL, or text to Tandoor-compatible JSON and save it to a file.

## Input

The input is: `$ARGUMENTS`

If no argument is provided, ask the user to provide:
- A file path to an image or PDF
- A recipe URL
- Or paste recipe text directly

## Workflow

1. **Invoke the tandoor-recipe-converter:tandoor-recipe-conversion skill** with the provided input
2. **Extract the JSON** from the skill output (look for the ```json code block)
3. **Determine the filename** from the suggested filename in the output
4. **Write the JSON file** to the current directory

## Execution

First, invoke the recipe conversion skill:

Use Skill(tandoor-recipe-converter:tandoor-recipe-conversion) with the input: $ARGUMENTS

After the skill completes:

1. Extract the JSON content from the skill output
2. Get the suggested filename (kebab-case based on recipe name)
3. Use the Write tool to save the JSON to `<filename>.json`
4. Report success with the file path

## Output

After saving, report:
- The file path where the JSON was saved
- The quality score from the conversion
- Any warnings that require attention

Example output:
```
✅ Recipe saved to: schokoladenkuchen.json
Quality Score: 92/100

⚠️ Estimated values to review:
- Cooking time estimated based on dish type
```
