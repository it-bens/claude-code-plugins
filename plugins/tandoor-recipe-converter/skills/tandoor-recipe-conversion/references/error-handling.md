# Error Handling Reference

Recovery strategies for common conversion errors and edge cases.

## Error Categories

### 1. OCR Quality Failures

**Trigger:** OCR confidence score < 40% for critical sections

#### Primary Strategy: Context-Based Reconstruction
1. Identify readable text fragments
2. Use recipe context for inference:
   - If "Kuchen" in title → baking ingredients expected
   - If quantities visible → match with standard ingredient amounts
   - If cooking method visible → infer ingredient types
3. Mark all estimated content with `[GESCHÄTZT - BITTE PRÜFEN]`

#### Fallback Strategy: Minimal Viable Recipe
1. Extract only 100% confident data
2. Create basic recipe structure:
   - Name: From visible title or "Rezept vom [Date]"
   - Description: "OCR-Qualität niedrig - manuelle Überprüfung erforderlich"
   - Steps: One step with "Anweisungen nicht lesbar - bitte manuell ergänzen"
3. Add placeholders for missing data

#### Last Resort: Structured Error Response
```json
{
  "error": true,
  "error_type": "OCR_QUALITY",
  "confidence_score": 35,
  "partial_data": {
    "detected_title": "...",
    "readable_fragments": ["..."]
  },
  "manual_intervention_required": true,
  "message": "Bildqualität zu niedrig für automatische Konvertierung"
}
```

### 2. Unknown Unit Conversion

**Trigger:** Unit not found in conversion table

#### Primary Strategy: Contextual Estimation
Apply these rules in order:

| Context | Unknown Unit Pattern | Conversion |
|---------|---------------------|------------|
| Baking recipe | Cup-like term | → ml (240) |
| Spice/seasoning | Small amount | → TL or Prise |
| Liquid ingredient | Volume term | → ml |
| Solid ingredient | Weight term | → g |

#### Fallback Strategy: Preserve Original
```json
{
  "unit": {
    "name": "[ORIGINAL: 1 handful]",
    "plural_name": "[ORIGINAL: 1 handful]",
    "description": null
  },
  "note": "Einheit nicht konvertierbar - bitte manuell anpassen [GESCHÄTZT - BITTE PRÜFEN]"
}
```

### 3. Missing Critical Data

#### Missing Ingredients

**Primary Strategy: Pattern Search**
Look for patterns indicating ingredients:
- Numbered or bulleted lists
- Quantity patterns (numbers + words)
- "Zutaten:" or "Ingredients:" headers
- Lines starting with numbers

**Fallback Strategy:**
Return partial recipe with:
```json
{
  "steps": [{
    "name": "",
    "instruction": "Zutaten nicht erkannt - bitte manuell ergänzen",
    "ingredients": [],
    "time": 0,
    "order": 0
  }]
}
```

#### Missing Instructions

**Primary Strategy: Pattern Search**
Look for patterns indicating steps:
- Numbered lists with imperative verbs
- "Zubereitung:" or "Directions:" headers
- Paragraphs starting with cooking verbs

**Fallback Strategy: Generate from Ingredients**
Create basic steps based on ingredient types:
1. "Alle Zutaten vorbereiten und abmessen."
2. [Generated steps based on ingredient categories]
3. "Nach Geschmack abschmecken und servieren."

Mark with: `"Anweisungen automatisch generiert [GESCHÄTZT - BITTE PRÜFEN]"`

### 4. Ambiguous Ingredient Amounts

**Trigger:** Vague amounts like "some", "to taste", "as needed"

#### Conversion Table

| Vague Term | Standard Amount | Unit | Confidence |
|------------|-----------------|------|------------|
| nach Geschmack / to taste | 1.0 | Prise | 70% |
| etwas / some | 2.0 | EL | 60% |
| eine Handvoll / a handful | 30.0 | g | 60% |
| nach Bedarf / as needed | 1.0 | Portion | 50% |
| ein Schuss / a splash | 15.0 | ml | 70% |

Always add: `"note": "[GESCHÄTZT - BITTE PRÜFEN]"`

### 5. Language Detection Failure

**Trigger:** Cannot determine source language

#### Strategy
1. Attempt German first (target language)
2. Try English (most common source)
3. Look for language clues:
   - Measurement units (cups = English, EL/TL = German)
   - Ingredient names
   - Instruction verbs
4. If still unclear, process as English with translation

### 6. URL Fetch Failures

**Trigger:** WebFetch fails or returns unexpected content

#### Retry Strategy
1. Retry once after 2 seconds
2. If still failing, check for common issues:
   - URL requires authentication
   - Content is behind paywall
   - Page is JavaScript-rendered (content not in initial HTML)

#### Fallback Response
```json
{
  "error": true,
  "error_type": "URL_FETCH_FAILED",
  "url": "...",
  "reason": "...",
  "suggestion": "Bitte kopieren Sie den Rezepttext manuell und fügen Sie ihn ein."
}
```

### 7. Malformed Source Data

**Trigger:** Data structure is unusual or broken

#### Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Ingredients mixed with instructions | Parse carefully, separate by patterns |
| Times embedded in text | Extract using regex patterns |
| Servings in various formats | Normalize to integer |
| Multiple recipes in one source | Extract first complete recipe |

### 8. Implausible Values

**Trigger:** Values outside reasonable ranges

#### Plausibility Checks

| Field | Valid Range | If Out of Range |
|-------|-------------|-----------------|
| amount | 0.001 - 5000 | Flag, use closest valid value |
| working_time | 5 - 300 | Cap at limits |
| waiting_time | 0 - 1440 | Cap at limits |
| servings | 1 - 20 | Default to 4 |

Add note: `"Wert angepasst - Original: [original value] [GESCHÄTZT - BITTE PRÜFEN]"`

## Error Response Format

When returning errors, use this structure:

```json
{
  "error": true,
  "error_type": "ERROR_CODE",
  "message": "Human-readable error message in German",
  "details": {
    "field": "affected field",
    "original_value": "...",
    "attempted_action": "..."
  },
  "partial_data": {
    // Any successfully extracted data
  },
  "suggestions": [
    "Mögliche Lösung 1",
    "Mögliche Lösung 2"
  ],
  "manual_intervention_required": true
}
```

## Error Codes

| Code | Description |
|------|-------------|
| `OCR_QUALITY` | Image/PDF quality too low |
| `UNKNOWN_UNIT` | Unit cannot be converted |
| `MISSING_INGREDIENTS` | No ingredients found |
| `MISSING_INSTRUCTIONS` | No instructions found |
| `URL_FETCH_FAILED` | Could not retrieve URL |
| `LANGUAGE_UNKNOWN` | Cannot determine language |
| `MALFORMED_DATA` | Data structure is broken |
| `IMPLAUSIBLE_VALUE` | Value outside valid range |
| `JSON_SYNTAX` | Generated JSON is invalid |

## Recovery Priority

When multiple errors occur, prioritize in this order:

1. **Critical:** JSON syntax, missing ingredients AND instructions
2. **High:** Missing ingredients OR instructions, OCR quality < 40%
3. **Medium:** Unknown units, implausible values, language issues
4. **Low:** Minor estimation required, optional fields missing

Always attempt to produce some output unless critical errors occur.
