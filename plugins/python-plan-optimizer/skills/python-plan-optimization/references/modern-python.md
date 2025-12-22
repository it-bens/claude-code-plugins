# Modern Python Practices Reference

Detailed guidance for modernizing Python code to use current idioms and features (Python 3.10+).

## Type Hints and Annotations

### Function Signatures

**Always add type hints to function parameters and return types.**

```python
# Before
def get_user(user_id, include_profile):
    pass

# After
def get_user(user_id: int, include_profile: bool = False) -> User | None:
    pass
```

### Modern Union Syntax (Python 3.10+)

**Use `|` instead of `Union` and `Optional`.**

```python
# Before (Python 3.9 and earlier)
from typing import Union, Optional, List, Dict

def process(value: Union[str, int]) -> Optional[str]:
    pass

def get_items() -> List[Dict[str, Any]]:
    pass

# After (Python 3.10+)
def process(value: str | int) -> str | None:
    pass

def get_items() -> list[dict[str, Any]]:
    pass
```

### Built-in Generic Types (Python 3.9+)

**Use lowercase built-in types instead of `typing` module versions.**

| Old (typing) | New (built-in) |
|--------------|----------------|
| `List[str]` | `list[str]` |
| `Dict[str, int]` | `dict[str, int]` |
| `Set[int]` | `set[int]` |
| `Tuple[int, str]` | `tuple[int, str]` |
| `FrozenSet[str]` | `frozenset[str]` |

### Protocol for Structural Subtyping

**Use `Protocol` instead of ABCs when interface compliance is based on structure.**

```python
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None: ...

class Circle:
    def draw(self) -> None:
        print("Drawing circle")

def render(shape: Drawable) -> None:
    shape.draw()

# Circle is Drawable without explicit inheritance
render(Circle())
```

### TypedDict for Structured Dictionaries

**Use `TypedDict` for dictionaries with known key structure.**

```python
from typing import TypedDict

class UserDict(TypedDict):
    name: str
    email: str
    age: int
    active: bool

def process_user(user: UserDict) -> None:
    print(user["name"])  # Type-checked access
```

## Dataclasses

### Basic Usage

**Convert data-holding classes to `@dataclass`.**

```python
# Before
class User:
    def __init__(self, name, email, age=0):
        self.name = name
        self.email = email
        self.age = age

    def __repr__(self):
        return f"User(name={self.name!r}, email={self.email!r}, age={self.age!r})"

    def __eq__(self, other):
        if not isinstance(other, User):
            return NotImplemented
        return self.name == other.name and self.email == other.email and self.age == other.age

# After
from dataclasses import dataclass

@dataclass
class User:
    name: str
    email: str
    age: int = 0
```

### Immutable Dataclasses

**Use `frozen=True` for immutable data structures.**

```python
@dataclass(frozen=True)
class Point:
    x: float
    y: float

point = Point(1.0, 2.0)
# point.x = 3.0  # Raises FrozenInstanceError
```

### Mutable Default Fields

**Use `field(default_factory=...)` for mutable defaults.**

```python
from dataclasses import dataclass, field

# WRONG - shared mutable default
@dataclass
class Bad:
    items: list = []  # All instances share this list!

# CORRECT
@dataclass
class Good:
    items: list = field(default_factory=list)
```

### Post-Init Processing

**Use `__post_init__` for validation and computed fields.**

```python
from dataclasses import dataclass, field

@dataclass
class Rectangle:
    width: float
    height: float
    area: float = field(init=False)

    def __post_init__(self) -> None:
        if self.width <= 0 or self.height <= 0:
            raise ValueError("Dimensions must be positive")
        self.area = self.width * self.height
```

### Slots for Memory Efficiency

**Use `slots=True` for memory-efficient dataclasses (Python 3.10+).**

```python
@dataclass(slots=True)
class Point:
    x: float
    y: float
```

## Pattern Matching (Python 3.10+)

### Basic Patterns

**Replace complex if/elif chains with `match/case`.**

```python
# Before
def handle_response(response):
    if response["status"] == "success":
        return response["data"]
    elif response["status"] == "error":
        raise APIError(response["message"])
    elif response["status"] == "pending":
        return None
    else:
        raise ValueError(f"Unknown status: {response['status']}")

# After
def handle_response(response: dict) -> Any:
    match response:
        case {"status": "success", "data": data}:
            return data
        case {"status": "error", "message": msg}:
            raise APIError(msg)
        case {"status": "pending"}:
            return None
        case _:
            raise ValueError(f"Unknown response: {response}")
```

### Type Patterns

```python
def process(value: int | str | list) -> str:
    match value:
        case int(n):
            return f"Integer: {n}"
        case str(s):
            return f"String: {s}"
        case [first, *rest]:
            return f"List starting with {first}"
        case _:
            return "Unknown"
```

### Guard Clauses

```python
def categorize(value: int) -> str:
    match value:
        case n if n < 0:
            return "negative"
        case n if n == 0:
            return "zero"
        case n if n > 0:
            return "positive"
```

## Modern Idioms

### Walrus Operator (Python 3.8+)

**Use `:=` for assignment expressions where it improves readability.**

```python
# Before
match = pattern.search(text)
if match:
    process(match.group())

# After
if match := pattern.search(text):
    process(match.group())

# In comprehensions
valid_items = [processed for item in items if (processed := process(item)) is not None]
```

### F-Strings

**Always use f-strings for string formatting.**

```python
# Before
message = "User {} has {} items".format(user.name, len(items))
message = "User %s has %d items" % (user.name, len(items))

# After
message = f"User {user.name} has {len(items)} items"

# With expressions
message = f"Total: {sum(prices):.2f}"

# Multi-line
query = f"""
    SELECT * FROM users
    WHERE id = {user_id}
    AND status = {status!r}
"""
```

### Pathlib for File Operations

**Use `pathlib.Path` instead of `os.path`.**

```python
# Before
import os

path = os.path.join(base_dir, "data", "file.txt")
if os.path.exists(path):
    with open(path) as f:
        content = f.read()
filename = os.path.basename(path)
extension = os.path.splitext(path)[1]

# After
from pathlib import Path

path = Path(base_dir) / "data" / "file.txt"
if path.exists():
    content = path.read_text()
filename = path.name
extension = path.suffix
```

### Context Managers

**Use `with` statements for resource management.**

```python
# File handling
with open("file.txt") as f:
    content = f.read()

# Multiple resources
with open("input.txt") as inp, open("output.txt", "w") as out:
    out.write(inp.read())

# Custom context managers
from contextlib import contextmanager

@contextmanager
def timed_operation(name: str):
    start = time.time()
    try:
        yield
    finally:
        print(f"{name} took {time.time() - start:.2f}s")
```

### Comprehensions

**Use comprehensions for creating collections from iterations.**

```python
# List comprehension
squares = [x**2 for x in range(10)]

# Dict comprehension
name_to_age = {user.name: user.age for user in users}

# Set comprehension
unique_names = {user.name.lower() for user in users}

# Generator expression (memory efficient)
total = sum(item.price for item in items)

# Conditional comprehension
adults = [user for user in users if user.age >= 18]
```

## Error Handling

### Specific Exception Classes

**Create domain-specific exceptions.**

```python
class ApplicationError(Exception):
    """Base exception for application errors."""
    pass

class UserNotFoundError(ApplicationError):
    """Raised when a user cannot be found."""
    def __init__(self, user_id: int) -> None:
        self.user_id = user_id
        super().__init__(f"User {user_id} not found")

class ValidationError(ApplicationError):
    """Raised when validation fails."""
    def __init__(self, field: str, message: str) -> None:
        self.field = field
        super().__init__(f"Validation error on {field}: {message}")
```

### Exception Chaining

**Use `raise ... from ...` to preserve exception context.**

```python
try:
    result = external_api.fetch(user_id)
except requests.RequestException as e:
    raise UserNotFoundError(user_id) from e
```

### Avoid Bare Except

**Always catch specific exceptions.**

```python
# Bad
try:
    process()
except:
    pass

# Good
try:
    process()
except (ValueError, TypeError) as e:
    logger.error(f"Processing failed: {e}")
    raise
```

## Documentation

### Google-Style Docstrings

```python
def calculate_discount(
    price: float,
    discount_percent: float,
    max_discount: float | None = None
) -> float:
    """Calculate discounted price.

    Applies a percentage discount to the given price, optionally
    capping the discount at a maximum amount.

    Args:
        price: Original price in dollars.
        discount_percent: Discount percentage (0-100).
        max_discount: Optional maximum discount amount.

    Returns:
        The discounted price, never less than zero.

    Raises:
        ValueError: If price is negative or discount_percent
            is not between 0 and 100.

    Example:
        >>> calculate_discount(100.0, 20.0)
        80.0
        >>> calculate_discount(100.0, 50.0, max_discount=30.0)
        70.0
    """
    if price < 0:
        raise ValueError("Price cannot be negative")
    if not 0 <= discount_percent <= 100:
        raise ValueError("Discount must be between 0 and 100")

    discount = price * (discount_percent / 100)
    if max_discount is not None:
        discount = min(discount, max_discount)

    return max(0, price - discount)
```

## Enum for Constants

**Use `Enum` for related constants.**

```python
from enum import Enum, auto

class Status(Enum):
    PENDING = auto()
    ACTIVE = auto()
    COMPLETED = auto()
    CANCELLED = auto()

class Color(Enum):
    RED = "#FF0000"
    GREEN = "#00FF00"
    BLUE = "#0000FF"

# Usage
user.status = Status.ACTIVE
if user.status == Status.COMPLETED:
    notify_completion()
```

## Named Tuples

**Use `NamedTuple` for immutable record types.**

```python
from typing import NamedTuple

class Coordinate(NamedTuple):
    x: float
    y: float
    label: str = ""

point = Coordinate(1.0, 2.0, "origin")
print(point.x, point.y)  # Attribute access
x, y, label = point  # Unpacking works
```
