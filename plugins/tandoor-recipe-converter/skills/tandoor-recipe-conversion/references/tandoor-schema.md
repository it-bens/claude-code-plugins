# Tandoor JSON Schema Reference

Complete structure and validation rules for Tandoor-compatible recipe JSON.

## Top-Level Structure

```json
{
  "name": "string (required, non-empty)",
  "description": "string (can be empty)",
  "keywords": [/* array of keyword objects */],
  "steps": [/* array of step objects, at least one required */],
  "working_time": 0,
  "waiting_time": 0,
  "internal": true,
  "nutrition": null,
  "servings": 4,
  "servings_text": "",
  "source_url": ""
}
```

## Field Requirements

| Field | Type | Required | Default | Validation |
|-------|------|----------|---------|------------|
| `name` | string | Yes | - | Non-empty |
| `description` | string | Yes | `""` | Can be empty |
| `keywords` | array | Yes | `[]` | Array of keyword objects |
| `steps` | array | Yes | - | At least one step required |
| `working_time` | integer | Yes | `0` | ≥ 0, reasonable range 5-300 |
| `waiting_time` | integer | Yes | `0` | ≥ 0, reasonable range 0-1440 |
| `internal` | boolean | Yes | `true` | Always `true` for imports |
| `nutrition` | null | Yes | `null` | Always `null` |
| `servings` | integer | Yes | `4` | > 0, reasonable range 1-20 |
| `servings_text` | string | Yes | `""` | Always empty string |
| `source_url` | string | Yes | `""` | URL or empty string |

## Keyword Object Structure

```json
{
  "name": "keyword-name",
  "description": "",
  "created_at": "2025-01-15T14:30:00.000000+01:00",
  "updated_at": "2025-01-15T14:30:00.000000+01:00"
}
```

### Keyword Field Rules

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `name` | string | Yes | Lowercase, hyphenated, no spaces |
| `description` | string | Yes | Always empty string |
| `created_at` | string | Yes | ISO 8601 with microseconds |
| `updated_at` | string | Yes | ISO 8601 with microseconds |

### Keyword Name Examples

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `kuchen` | `Kuchen` |
| `vegetarisch` | `Vegetarisch` |
| `schnell-und-einfach` | `schnell und einfach` |
| `low-carb` | `Low Carb` |

## Step Object Structure

```json
{
  "name": "",
  "instruction": "German instruction text",
  "ingredients": [/* array of ingredient objects */],
  "time": 10,
  "order": 0,
  "show_as_header": false,
  "show_ingredients_table": true
}
```

### Step Field Rules

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `name` | string | Yes | **MUST be empty string `""`** |
| `instruction` | string | Yes | German text, non-empty |
| `ingredients` | array | Yes | Array of ingredient objects |
| `time` | integer | Yes | Minutes, ≥ 0 |
| `order` | integer | Yes | Sequential from 0 |
| `show_as_header` | boolean | Yes | `false` |
| `show_ingredients_table` | boolean | Yes | `true` |

### Critical: Step Name Must Be Empty

The `name` field in steps **MUST** always be an empty string:
- ✅ `"name": ""`
- ❌ `"name": "Step 1"`
- ❌ `"name": "Vorbereitung"`
- ❌ `"name": null`

Non-empty step names break Tandoor's layout rendering.

## Ingredient Object Structure

```json
{
  "food": {
    "name": "Mehl",
    "plural_name": null,
    "ignore_shopping": false,
    "supermarket_category": null
  },
  "unit": {
    "name": "g",
    "plural_name": "g",
    "description": null
  },
  "amount": 200.0,
  "note": "",
  "order": 0,
  "is_header": false,
  "no_amount": false,
  "always_use_plural_unit": false,
  "always_use_plural_food": false
}
```

### Ingredient Field Rules

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| `food` | object | Yes | Food object |
| `unit` | object | Yes | Unit object |
| `amount` | float | Yes | **MUST be float** (e.g., `1.0` not `1`) |
| `note` | string | Yes | Can be empty |
| `order` | integer | Yes | Sequential from 0 |
| `is_header` | boolean | Yes | `false` |
| `no_amount` | boolean | Yes | `false` (unless no amount specified) |
| `always_use_plural_unit` | boolean | Yes | `false` |
| `always_use_plural_food` | boolean | Yes | `false` or `true` for exceptions |

### Critical: Amount Must Be Float

All amounts **MUST** be floats with decimal point:
- ✅ `"amount": 1.0`
- ✅ `"amount": 2.5`
- ✅ `"amount": 100.0`
- ❌ `"amount": 1`
- ❌ `"amount": 100`

Integer amounts cause silent database validation failures.

### Food Object

```json
{
  "name": "Ingredient singular form",
  "plural_name": null,
  "ignore_shopping": false,
  "supermarket_category": null
}
```

### Unit Object

```json
{
  "name": "g",
  "plural_name": "g",
  "description": null
}
```

Common units:
- Weight: `g`, `kg`
- Volume: `ml`, `l`, `EL`, `TL`
- Count: `Stück`, `Prise`, `Bund`, `Päckchen`

## Timestamp Format

All timestamps must include microseconds:

```
YYYY-MM-DDTHH:MM:SS.ffffff+TZ:TZ
```

Examples:
- ✅ `2025-01-15T14:30:00.000000+01:00`
- ✅ `2025-06-20T09:15:30.000000+02:00`
- ❌ `2025-01-15T14:30:00+01:00` (missing microseconds)
- ❌ `2025-01-15` (missing time component)

Use current timestamp for `created_at` and `updated_at` fields.

## Complete Example

```json
{
  "name": "Schokoladenkuchen",
  "description": "Ein klassischer Schokoladenkuchen",
  "keywords": [
    {
      "name": "kuchen",
      "description": "",
      "created_at": "2025-01-15T14:30:00.000000+01:00",
      "updated_at": "2025-01-15T14:30:00.000000+01:00"
    },
    {
      "name": "schokolade",
      "description": "",
      "created_at": "2025-01-15T14:30:00.000000+01:00",
      "updated_at": "2025-01-15T14:30:00.000000+01:00"
    }
  ],
  "steps": [
    {
      "name": "",
      "instruction": "Ofen auf 180°C vorheizen. Backform einfetten und mit Mehl bestäuben.",
      "ingredients": [],
      "time": 5,
      "order": 0,
      "show_as_header": false,
      "show_ingredients_table": true
    },
    {
      "name": "",
      "instruction": "Mehl, Kakao, Backpulver und Salz in einer Schüssel vermischen.",
      "ingredients": [
        {
          "food": {
            "name": "Mehl",
            "plural_name": null,
            "ignore_shopping": false,
            "supermarket_category": null
          },
          "unit": {
            "name": "g",
            "plural_name": "g",
            "description": null
          },
          "amount": 200.0,
          "note": "",
          "order": 0,
          "is_header": false,
          "no_amount": false,
          "always_use_plural_unit": false,
          "always_use_plural_food": false
        },
        {
          "food": {
            "name": "Kakaopulver",
            "plural_name": null,
            "ignore_shopping": false,
            "supermarket_category": null
          },
          "unit": {
            "name": "g",
            "plural_name": "g",
            "description": null
          },
          "amount": 50.0,
          "note": "ungesüßt",
          "order": 1,
          "is_header": false,
          "no_amount": false,
          "always_use_plural_unit": false,
          "always_use_plural_food": false
        },
        {
          "food": {
            "name": "Backpulver",
            "plural_name": null,
            "ignore_shopping": false,
            "supermarket_category": null
          },
          "unit": {
            "name": "TL",
            "plural_name": "TL",
            "description": null
          },
          "amount": 1.0,
          "note": "",
          "order": 2,
          "is_header": false,
          "no_amount": false,
          "always_use_plural_unit": false,
          "always_use_plural_food": false
        },
        {
          "food": {
            "name": "Salz",
            "plural_name": null,
            "ignore_shopping": false,
            "supermarket_category": null
          },
          "unit": {
            "name": "Prise",
            "plural_name": "Prisen",
            "description": null
          },
          "amount": 1.0,
          "note": "",
          "order": 3,
          "is_header": false,
          "no_amount": false,
          "always_use_plural_unit": false,
          "always_use_plural_food": false
        }
      ],
      "time": 5,
      "order": 1,
      "show_as_header": false,
      "show_ingredients_table": true
    }
  ],
  "working_time": 25,
  "waiting_time": 35,
  "internal": true,
  "nutrition": null,
  "servings": 12,
  "servings_text": "",
  "source_url": ""
}
```

## Validation Checklist

Before output, verify:

- [ ] Valid JSON syntax (no parsing errors)
- [ ] All `amount` fields are floats with decimal point
- [ ] All step `name` fields are empty strings `""`
- [ ] All timestamps have microseconds `.000000`
- [ ] No trailing commas in arrays or objects
- [ ] All booleans are unquoted (`true`/`false`, not `"true"`)
- [ ] `internal` is `true`
- [ ] `nutrition` is `null`
- [ ] `servings_text` is `""`
- [ ] At least one step exists
- [ ] Step `order` values are sequential from 0
- [ ] Ingredient `order` values are sequential from 0 within each step
