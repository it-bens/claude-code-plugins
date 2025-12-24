# Time Estimates Reference

Cooking time estimates by dish type when times are not provided in the source recipe.

## Time Estimate Table

| Dish Type | Working Time | Waiting Time | Confidence | Examples |
|-----------|--------------|--------------|------------|----------|
| Salat | 15 | 0 | 90% | Grüner Salat, Nudelsalat, Kartoffelsalat |
| Sandwich | 10 | 0 | 95% | Belegtes Brot, Club Sandwich |
| Smoothie | 5 | 0 | 95% | Frucht-Smoothie, Grüner Smoothie |
| Suppe (einfach) | 20 | 30 | 85% | Gemüsesuppe, Tomatensuppe |
| Suppe (komplex) | 30 | 90 | 80% | Gulaschsuppe, Rinderbrühe |
| Pasta (einfach) | 15 | 15 | 90% | Spaghetti Aglio e Olio, Pasta mit Pesto |
| Pasta (komplex) | 30 | 30 | 85% | Lasagne, Cannelloni |
| Risotto | 20 | 25 | 85% | Pilzrisotto, Safranrisotto |
| Pfannengericht | 20 | 10 | 85% | Rührei, Omelett, Pfannkuchen |
| Auflauf | 20 | 45 | 85% | Kartoffelauflauf, Nudelauflauf |
| Eintopf | 30 | 90 | 85% | Linseneintopf, Erbseneintopf |
| Curry | 25 | 30 | 85% | Gemüsecurry, Hähnchencurry |
| Braten | 30 | 120 | 80% | Schweinebraten, Rinderbraten |
| Grillen | 15 | 20 | 85% | Hähnchenbrust, Steak, Würstchen |
| Schmoren | 30 | 150 | 80% | Schmorbraten, Rouladen |
| Kuchen (Rührkuchen) | 20 | 45 | 90% | Marmorkuchen, Zitronenkuchen |
| Kuchen (Hefeteig) | 30 | 120 | 85% | Hefezopf, Rosinenbrot |
| Kuchen (Mürbeteig) | 25 | 60 | 85% | Obstkuchen, Käsekuchen |
| Torte | 45 | 180 | 80% | Schwarzwälder Kirschtorte |
| Brot | 30 | 180 | 85% | Weißbrot, Vollkornbrot |
| Brötchen | 25 | 90 | 85% | Semmeln, Laugenbrötchen |
| Pizza | 20 | 90 | 85% | Pizza Margherita, Pizza Salami |
| Kekse/Plätzchen | 20 | 20 | 90% | Butterkekse, Weihnachtsplätzchen |
| Muffins | 15 | 25 | 90% | Schokomuffins, Blaubeermuffins |
| Dessert (einfach) | 15 | 60 | 85% | Pudding, Mousse, Panna Cotta |
| Dessert (komplex) | 30 | 240 | 80% | Tiramisu, Crème brûlée |
| Eis | 20 | 240 | 80% | Vanilleeis, Fruchtsorbet |
| Marmelade | 30 | 15 | 85% | Erdbeermarmelade, Aprikosenkonfitüre |
| Sauce | 15 | 15 | 85% | Tomatensauce, Béchamel |
| Dressing | 10 | 0 | 95% | Vinaigrette, Caesar Dressing |
| Dip | 10 | 30 | 85% | Guacamole, Hummus |
| Default | 20 | 30 | 60% | Unknown dish type |

## Time Component Definitions

- **Working Time (working_time):** Active preparation time. Includes chopping, mixing, stirring, assembling.
- **Waiting Time (waiting_time):** Passive time. Includes baking, simmering, chilling, rising, marinating.

## Estimation Rules

### 1. Match Dish Type First
Identify the dish type from:
- Recipe name
- Main cooking method
- Primary ingredients
- Recipe category (if stated)

### 2. Use Confidence-Based Markers
When estimating times, add confidence marker to the recipe description:

```
Zeiten geschätzt [GESCHÄTZT - BITTE PRÜFEN]
```

### 3. Adjust for Complexity
Consider adjusting default times based on:

**Increase working time if:**
- Many ingredients (10+): +10 minutes
- Complex preparation (filleting, deboning): +15 minutes
- Multiple components: +5 minutes per component

**Increase waiting time if:**
- Marinating mentioned: +60 minutes
- Chilling required: +30-120 minutes
- Multiple cooking stages: +15 minutes per stage

### 4. Handle Special Cases

**Overnight recipes:**
- If "overnight" or "über Nacht" mentioned
- Set waiting_time to 480 (8 hours)

**Slow cooker recipes:**
- If slow cooker mentioned
- working_time: 15
- waiting_time: 360-480

**Pressure cooker recipes:**
- Reduce waiting_time by 60-70%
- Keep working_time the same

**No-bake recipes:**
- If "no bake" or "ohne Backen"
- waiting_time is typically chilling (60-240 minutes)

## Plausibility Checks

After estimation, verify:

| Check | Valid Range | If Out of Range |
|-------|-------------|-----------------|
| working_time | 5-300 minutes | Flag for review |
| waiting_time | 0-1440 minutes | Flag for review |
| Total time | 5-1500 minutes | Flag for review |

## Default Fallback

If dish type cannot be determined:
- working_time: 20
- waiting_time: 30
- Add note: `"Zeiten geschätzt - Rezepttyp nicht erkannt [GESCHÄTZT - BITTE PRÜFEN]"`

## Examples

### Example 1: Pasta Recipe
Input: "Spaghetti Carbonara"
- Dish type: Pasta (einfach)
- working_time: 15
- waiting_time: 15

### Example 2: Bread Recipe
Input: "Rustikales Bauernbrot"
- Dish type: Brot
- working_time: 30
- waiting_time: 180

### Example 3: Unknown Recipe
Input: "Omas Geheimrezept"
- Dish type: Cannot determine
- working_time: 20
- waiting_time: 30
- Note: "[GESCHÄTZT - BITTE PRÜFEN]"

### Example 4: Complex Recipe with Clues
Input: "Rinderrouladen mit Rotkohl" (mentions braising)
- Dish type: Schmoren
- working_time: 30
- waiting_time: 150
