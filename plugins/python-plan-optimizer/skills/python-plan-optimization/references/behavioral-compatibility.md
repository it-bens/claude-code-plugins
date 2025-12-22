# Behavioral Compatibility Reference

Detailed guidance for ensuring refactored code maintains identical behavior to the original implementation.

## Core Principle

**Behavioral compatibility means: Same inputs produce same outputs, with identical observable side effects.**

Refactoring changes the internal structure of code without changing its external behavior. Any deviation from original behavior is a bug, not a refactoring.

## The 13-Point Verification Checklist

### 1. Function/Method Signatures

**Requirement:** Signatures must be unchanged or backward compatible.

**Verification:**
- Parameter names: May change (keyword args still work with new names)
- Parameter order: Must not change for positional args
- Required parameters: Must not add new required params
- Default values: Must be semantically equivalent
- Return type: Must be compatible (can be more specific, not less)

**Safe Changes:**
```python
# Original
def process(data, format="json"):
    pass

# Safe - add optional param with default
def process(data, format="json", validate=True):
    pass

# Safe - type hints don't change behavior
def process(data: dict, format: str = "json") -> dict:
    pass
```

**Breaking Changes:**
```python
# BREAKING - changed parameter order
def process(format, data):  # Was (data, format)
    pass

# BREAKING - made optional param required
def process(data, format):  # format was optional
    pass
```

### 2. Return Types and Values

**Requirement:** Return values must be identical for identical inputs.

**Verification:**
- Type: Same type or compatible subtype
- Value: Mathematically/logically equivalent
- None cases: Same conditions trigger None return
- Empty collections: [] vs () vs {} distinctions preserved

**Safe Changes:**
```python
# Original
def get_items(self):
    items = []
    for item in self._data:
        items.append(item)
    return items

# Safe - same result, different implementation
def get_items(self) -> list:
    return list(self._data)
```

**Verification Questions:**
- Does the function return the same type?
- Are edge cases (empty, None, zero) handled identically?
- Is numeric precision preserved?

### 3. Side Effects

**Requirement:** All observable side effects must be preserved.

**Categories of Side Effects:**
- **File I/O:** Files created, modified, deleted
- **Database:** Records inserted, updated, deleted
- **Network:** HTTP requests, socket connections
- **State:** Global variables, class attributes, mutable parameters
- **Output:** Print statements, logging

**Verification:**
```python
# Original - has side effect of modifying input
def normalize(items):
    for i in range(len(items)):
        items[i] = items[i].lower()
    return items

# BREAKING - no longer modifies input
def normalize(items):
    return [item.lower() for item in items]

# Safe - preserves side effect
def normalize(items: list[str]) -> list[str]:
    for i in range(len(items)):
        items[i] = items[i].lower()
    return items
```

### 4. Exception Types and Conditions

**Requirement:** Same exceptions raised under same conditions.

**Verification:**
- Exception type: Exact type preserved (or compatible subclass)
- Exception message: May change (but consider downstream parsing)
- Conditions: Same inputs trigger same exceptions
- Order: If multiple could be raised, order preserved

**Safe Changes:**
```python
# Original
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

# Safe - same exception, different message style
def divide(a: float, b: float) -> float:
    if b == 0:
        raise ValueError(f"Division by zero: {a}/{b}")
    return a / b
```

**Breaking Changes:**
```python
# BREAKING - different exception type
def divide(a, b):
    if b == 0:
        raise ZeroDivisionError("...")  # Was ValueError
    return a / b
```

### 5. Public Class Attributes

**Requirement:** All public attributes accessible in same way.

**Verification:**
- Attribute names: Must remain unchanged
- Attribute types: Must be compatible
- Accessibility: Public must stay public
- Mutability: If was mutable, must stay mutable

**Safe Changes:**
```python
# Original
class User:
    def __init__(self, name):
        self.name = name
        self._internal = []

# Safe - add attributes, use property for computed
@dataclass
class User:
    name: str
    email: str = ""  # New optional attribute

    @property
    def display_name(self) -> str:  # New computed property
        return self.name.title()
```

### 6. Event/Callback Behaviors

**Requirement:** Events fired in same conditions with same data.

**Verification:**
- Event types: Same events triggered
- Event data: Same payload structure
- Order: Events fired in same sequence
- Timing: Synchronous stays synchronous, async stays async

### 7. Thread Safety Characteristics

**Requirement:** Thread safety guarantees must be preserved.

**Verification:**
- Locks: Same locking behavior
- Atomic operations: Atomicity preserved
- Race conditions: No new race conditions introduced
- Deadlock potential: No new deadlock scenarios

**Warning Signs:**
- Removing `threading.Lock` usage
- Changing from atomic to non-atomic operations
- Adding shared mutable state

### 8. Performance Characteristics

**Requirement:** Performance should not significantly degrade.

**Verification:**
- Time complexity: Same big-O or better
- Space complexity: Same big-O or better
- Hot paths: No new bottlenecks in critical paths

**Acceptable Changes:**
- O(n) stays O(n) even if constant factor changes
- Slight memory increase for better readability

**Unacceptable Changes:**
- O(n) becomes O(n²)
- Adding database calls in loops
- Blocking I/O in async contexts

### 9. Test Compatibility

**Requirement:** Existing tests should pass unchanged.

**Verification:**
- Unit tests: All assertions should still pass
- Integration tests: System behavior unchanged
- Mocks: Mock interfaces still valid

**Test as Documentation:**
Tests often encode expected behavior. If tests would fail after refactoring, the refactoring may be changing behavior.

### 10. Default Values

**Requirement:** Default parameter values produce identical behavior.

**Verification:**
```python
# Original
def connect(host, port=8080):
    pass

# Safe - same default
def connect(host: str, port: int = 8080) -> Connection:
    pass

# BREAKING - different default
def connect(host: str, port: int = 80) -> Connection:
    pass
```

### 11. Iteration Order

**Requirement:** If order matters, preserve it.

**Verification:**
- List/tuple order: Preserved
- Dict order: Preserved (Python 3.7+)
- Set order: If code depends on iteration order, flag as issue

**Warning:**
```python
# Original - order dependent
def get_first_match(items, predicate):
    for item in items:
        if predicate(item):
            return item

# Safe - preserves order
def get_first_match(items: list, predicate: Callable) -> Any:
    return next((item for item in items if predicate(item)), None)

# BREAKING - set has no guaranteed order
def get_first_match(items: set, predicate: Callable) -> Any:
    # Order is now undefined!
    pass
```

### 12. Serialization Compatibility

**Requirement:** Serialized representations must be compatible.

**Verification:**
- JSON output: Same structure and values
- Pickle compatibility: Can unpickle old data
- API responses: Same schema

**Warning Signs:**
- Changing attribute names (affects JSON keys)
- Changing class names (affects pickle)
- Reordering fields (may affect some serializers)

### 13. External API Compatibility

**Requirement:** Interactions with external systems unchanged.

**Verification:**
- HTTP requests: Same endpoints, methods, payloads
- Database queries: Same queries, same results
- File formats: Same file structures

## Verification Strategies

### Before/After Comparison

```python
# Create test cases covering edge cases
test_cases = [
    ([], {}),                    # Empty inputs
    ([1, 2, 3], {"key": "val"}), # Normal inputs
    (None, None),                # None handling
    ([0], {"": ""}),             # Edge values
]

# Compare results
for args in test_cases:
    original_result = original_function(*args)
    refactored_result = refactored_function(*args)
    assert original_result == refactored_result, f"Mismatch for {args}"
```

### Property-Based Testing

```python
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_behavior_preserved(data):
    assert original_function(data) == refactored_function(data)
```

### Characterization Tests

When original behavior is unclear, write tests that capture current behavior:

```python
def test_characterization():
    # Captures actual behavior, whatever it is
    result = function_under_test(specific_input)
    assert result == captured_output  # Document current behavior
```

## When Behavioral Changes Are Acceptable

### Bug Fixes

If original code has a bug, fixing it is acceptable:
- Document the bug fix in change log
- Note that this is intentional behavior change
- Flag for review: `<!-- BREAKING: Fixed bug where... -->`

### Performance Critical Changes

If performance is severely impacted:
- Document the tradeoff
- Note the behavioral difference
- Get explicit approval

### Security Fixes

If original code has security vulnerability:
- Changing behavior to fix security is acceptable
- Document the security fix
- May require migration guidance

## Documentation Template

For each refactored code block, document:

```markdown
## Behavioral Compatibility Check

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | Signatures | PASS | Added type hints only |
| 2 | Return values | PASS | Identical |
| 3 | Side effects | PASS | Same file writes |
| 4 | Exceptions | PASS | Same ValueError conditions |
| 5 | Public attributes | PASS | No changes |
| 6 | Events/callbacks | N/A | No events used |
| 7 | Thread safety | PASS | No threading changes |
| 8 | Performance | PASS | Same O(n) complexity |
| 9 | Tests | PASS | All tests pass |
| 10 | Defaults | PASS | Same default values |
| 11 | Iteration order | PASS | List order preserved |
| 12 | Serialization | PASS | JSON output unchanged |
| 13 | External APIs | N/A | No external calls |

**Verdict:** VERIFIED - All applicable checks pass.
```
