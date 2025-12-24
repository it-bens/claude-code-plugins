# Ingredient Normalization Map

Reference for normalizing ingredient names to German singular form.

## Core Principle

Tandoor's shopping list function automatically pluralizes ingredients. Using plural forms leads to double pluralization:
- ❌ "Eier" → becomes "Eiern" (incorrect)
- ✅ "Ei" → becomes "Eier" (correct)

**Always use singular form unless marked as plural exception.**

## Protein Ingredients

| Input Terms | Standard German | Category | Plural Exception |
|------------|-----------------|----------|------------------|
| eggs, egg, Eier, Hühnerei | Ei | Protein | No |
| chicken, Hähnchen, Huhn | Hähnchenbrust | Protein | No |
| beef, Rindfleisch | Rindfleisch | Protein | No |
| pork, Schweinefleisch | Schweinefleisch | Protein | No |
| ground meat, mince, Hackfleisch, Faschiertes | Hackfleisch | Protein | No |
| salmon, Lachs | Lachs | Protein | No |
| tuna, Thunfisch | Thunfisch | Protein | No |
| shrimp, prawns, Garnelen | Garnele | Protein | No |
| tofu, Tofu | Tofu | Protein | No |

## Vegetable Ingredients

| Input Terms | Standard German | Category | Plural Exception |
|------------|-----------------|----------|------------------|
| onions, onion, Zwiebeln, Speisezwiebel | Zwiebel | Gemüse | No |
| garlic, Knoblauch | Knoblauch | Gemüse | No |
| garlic clove, Knoblauchzehe | Knoblauchzehe | Gemüse | No |
| tomatoes, tomato, Tomaten, Paradeiser | Tomate | Gemüse | No |
| carrots, carrot, Möhren, Karotten, Mohrrüben | Karotte | Gemüse | No |
| potatoes, potato, Kartoffeln, Erdäpfel | Kartoffel | Gemüse | No |
| peppers, pepper, Paprika | Paprika | Gemüse | No |
| zucchini, courgette, Zucchini | Zucchini | Gemüse | No |
| mushrooms, Pilze, Champignons | Champignon | Gemüse | No |
| spinach, Spinat | Spinat | Gemüse | No |
| broccoli, Brokkoli | Brokkoli | Gemüse | No |
| celery, Sellerie | Sellerie | Gemüse | No |
| leek, Lauch, Porree | Lauch | Gemüse | No |
| cucumber, Gurke | Gurke | Gemüse | No |
| lettuce, salad, Salat | Salat | Gemüse | No |
| cabbage, Kohl | Kohl | Gemüse | No |

## Dairy Ingredients

| Input Terms | Standard German | Category | Plural Exception |
|------------|-----------------|----------|------------------|
| milk, Milch | Milch | Milchprodukt | No |
| cream, Sahne, Rahm, Schlagsahne, Obers | Sahne | Milchprodukt | No |
| butter, Butter | Butter | Milchprodukt | No |
| cheese, Käse | Käse | Milchprodukt | No |
| cottage cheese, Quark, Topfen | Quark | Milchprodukt | No |
| yogurt, Joghurt | Joghurt | Milchprodukt | No |
| sour cream, Schmand, Sauerrahm | Schmand | Milchprodukt | No |
| crème fraîche, Crème fraîche | Crème fraîche | Milchprodukt | No |

## Herbs and Spices

| Input Terms | Standard German | Category | Plural Exception |
|------------|-----------------|----------|------------------|
| parsley, Petersilie, Peterle | Petersilie | Kräuter | No |
| basil, Basilikum | Basilikum | Kräuter | No |
| thyme, Thymian | Thymian | Kräuter | No |
| rosemary, Rosmarin | Rosmarin | Kräuter | No |
| oregano, Oregano | Oregano | Kräuter | No |
| dill, Dill | Dill | Kräuter | No |
| chives, Schnittlauch | Schnittlauch | Kräuter | No |
| mint, Minze | Minze | Kräuter | No |
| cinnamon, Zimt | Zimt | Gewürz | No |
| nutmeg, Muskat | Muskatnuss | Gewürz | No |
| paprika powder, Paprikapulver | Paprikapulver | Gewürz | No |
| cumin, Kreuzkümmel | Kreuzkümmel | Gewürz | No |
| salt, Salz | Salz | Gewürz | No |
| pepper, Pfeffer | Pfeffer | Gewürz | No |

## Baking Ingredients

| Input Terms | Standard German | Category | Plural Exception |
|------------|-----------------|----------|------------------|
| flour, Mehl | Mehl | Backen | No |
| sugar, Zucker | Zucker | Backen | No |
| brown sugar, brauner Zucker | brauner Zucker | Backen | No |
| powdered sugar, Puderzucker | Puderzucker | Backen | No |
| vanilla sugar, Vanillezucker | Vanillezucker | Backen | No |
| baking powder, Backpulver | Backpulver | Backen | No |
| baking soda, Natron | Natron | Backen | No |
| yeast, Hefe | Hefe | Backen | No |
| cocoa, Kakao, Kakaopulver | Kakaopulver | Backen | No |
| chocolate, Schokolade | Schokolade | Backen | No |

## Grains and Pasta

| Input Terms | Standard German | Category | Plural Exception |
|------------|-----------------|----------|------------------|
| rice, Reis | Reis | Getreide | No |
| pasta, Nudeln | Nudel | Getreide | No |
| spaghetti | Spaghetti | Nudeln | **Yes** |
| penne | Penne | Nudeln | **Yes** |
| fusilli | Fusilli | Nudeln | **Yes** |
| tagliatelle | Tagliatelle | Nudeln | **Yes** |
| noodles, Nudeln | Nudel | Getreide | No |
| bread, Brot | Brot | Getreide | No |
| breadcrumbs, Semmelbrösel, Paniermehl | Paniermehl | Getreide | No |
| oats, Haferflocken | Haferflocke | Getreide | No |

## Plural Exceptions

These ingredients are **always plural** in German and should use `"always_use_plural_food": true`:

| Ingredient | Reason |
|------------|--------|
| Spaghetti | Italian pasta name, always plural |
| Penne | Italian pasta name, always plural |
| Fusilli | Italian pasta name, always plural |
| Tagliatelle | Italian pasta name, always plural |
| Pommes frites | French origin, always plural |
| Gnocchi | Italian, always plural |
| Ravioli | Italian, always plural |
| Cannelloni | Italian, always plural |

## Descriptor Handling

Move descriptors to the `note` field:

| Input | Output |
|-------|--------|
| `3 large eggs` | `{"name": "Ei", "amount": 3.0, "note": "groß"}` |
| `2 small onions, diced` | `{"name": "Zwiebel", "amount": 2.0, "note": "klein, gewürfelt"}` |
| `1 ripe avocado` | `{"name": "Avocado", "amount": 1.0, "note": "reif"}` |
| `fresh parsley, chopped` | `{"name": "Petersilie", "amount": 1.0, "unit": "Bund", "note": "frisch, gehackt"}` |

## Common Descriptor Translations

| English | German |
|---------|--------|
| large | groß |
| small | klein |
| medium | mittelgroß |
| fresh | frisch |
| dried | getrocknet |
| frozen | tiefgefroren |
| chopped | gehackt |
| diced | gewürfelt |
| sliced | in Scheiben |
| minced | fein gehackt |
| grated | gerieben |
| melted | geschmolzen |
| softened | weich |
| room temperature | zimmerwarm |
