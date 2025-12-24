# Unit Conversion Reference

Complete conversion table for imperial to metric and other common unit conversions.

## Volume Conversions

| Original Unit | Aliases | Factor | Target | Notes | Confidence |
|--------------|---------|--------|--------|-------|------------|
| cup | cups, c | 240 | ml | US standard liquid | 95% |
| cup (flour) | - | 120 | g | Density-adjusted for flour | 90% |
| cup (sugar) | - | 200 | g | Granulated sugar | 90% |
| cup (brown sugar) | - | 220 | g | Packed brown sugar | 85% |
| cup (powdered sugar) | - | 125 | g | Confectioner's sugar | 85% |
| cup (butter) | - | 225 | g | 2 sticks | 95% |
| cup (rice) | - | 185 | g | Uncooked long grain | 85% |
| cup (oats) | - | 90 | g | Rolled oats | 85% |
| tablespoon | tbsp, EL, Esslöffel | 15 | ml | - | 98% |
| teaspoon | tsp, TL, Teelöffel | 5 | ml | - | 98% |
| fluid ounce | fl oz | 30 | ml | US fluid ounce | 95% |
| pint | pt | 475 | ml | US pint | 95% |
| quart | qt | 950 | ml | US quart | 95% |
| gallon | gal | 3785 | ml | US gallon | 95% |
| dash | - | 2 | ml | Liquid dash | 85% |

## Weight Conversions

| Original Unit | Aliases | Factor | Target | Notes | Confidence |
|--------------|---------|--------|--------|-------|------------|
| ounce | oz | 30 | g | Weight ounce (28.35 rounded) | 95% |
| pound | lb, lbs | 450 | g | 453.6 rounded | 98% |
| stick butter | stick | 115 | g | US standard butter stick | 95% |

## Special Measurements

| Original Unit | Aliases | Factor | Target | Notes | Confidence |
|--------------|---------|--------|--------|-------|------------|
| pinch | Prise | 1 | Prise | No conversion needed | 100% |
| handful | Handvoll | 30 | g | Rough estimate for herbs/greens | 60% |
| bunch | Bund | 1 | Bund | No conversion needed | 100% |
| clove | Zehe | 1 | Stück | For garlic | 100% |
| slice | Scheibe | 1 | Scheibe | No conversion needed | 100% |
| piece | Stück | 1 | Stück | No conversion needed | 100% |
| packet | Päckchen | 1 | Päckchen | For vanilla sugar, baking powder | 100% |
| can | Dose | 1 | Dose | Note original size in notes field | 90% |

## German Unit Standardization

| Input Variation | Standard German | Category |
|-----------------|-----------------|----------|
| EL, Esslöffel, Essl. | EL | Volume |
| TL, Teelöffel, Teel. | TL | Volume |
| g, Gramm, gr | g | Weight |
| kg, Kilogramm | kg | Weight |
| ml, Milliliter | ml | Volume |
| l, L, Liter | l | Volume |
| Stk, Stck, Stück | Stück | Count |

## Contextual Conversion Rules

### Flour-Type Ingredients
When converting cups of flour-type ingredients:
- All-purpose flour: 120g per cup
- Bread flour: 130g per cup
- Whole wheat flour: 130g per cup
- Cake flour: 115g per cup
- Almond flour: 95g per cup
- Cocoa powder: 85g per cup

### Sugar-Type Ingredients
When converting cups of sugar-type ingredients:
- Granulated sugar: 200g per cup
- Brown sugar (packed): 220g per cup
- Powdered sugar: 125g per cup
- Honey/Maple syrup: 340g per cup

### Butter and Fats
- 1 stick butter = 115g = 8 tbsp
- 1 cup butter = 225g = 2 sticks
- 1 tbsp butter = 14g
- 1 cup oil = 225ml

## Unknown Unit Handling

When encountering an unknown unit:

1. **Check context for clues:**
   - Baking + "cup-like" → use ml
   - Spice + small amount → use TL/Prise
   - Solid food + "oz" → use g

2. **If still unclear:**
   - Keep original unit in `unit.name`
   - Add warning in `note`: `"Einheit nicht konvertierbar - bitte manuell anpassen"`
   - Mark as `[GESCHÄTZT - BITTE PRÜFEN]`

## Compound Measurements

For compound measurements like "1 cup plus 2 tablespoons":

1. Convert each part separately:
   - 1 cup = 240ml
   - 2 tbsp = 30ml
2. Sum the results: 270ml
3. Output single combined value

Example:
- Input: `"1 stick plus 2 tbsp butter, softened"`
- Calculation: 115g + 30g = 145g
- Output: `{"name": "Butter", "amount": 145.0, "unit": "g", "note": "weich"}`
