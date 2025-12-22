# Design Principles Reference

Detailed guidance for applying design principles to Python code in planning documents.

## SOLID Principles

### Single Responsibility Principle (SRP)

**Definition:** Each class/function should have one reason to change.

**Detection Patterns:**
- Class has methods that don't use the same instance variables
- Function does multiple unrelated operations
- Class name includes "And" or "Manager" with broad scope
- Changelog shows unrelated features modified in same class

**Python Example - Before:**

```python
class UserService:
    def create_user(self, name, email):
        # Validation
        if not email or '@' not in email:
            raise ValueError("Invalid email")
        # Database
        user = {"name": name, "email": email}
        self.db.insert("users", user)
        # Email notification
        self.smtp.send(email, "Welcome!", "Thanks for joining")
        # Logging
        self.logger.info(f"Created user {name}")
        return user
```

**Python Example - After:**

```python
@dataclass
class User:
    name: str
    email: str

class UserValidator:
    def validate(self, user: User) -> None:
        if not user.email or '@' not in user.email:
            raise ValueError("Invalid email")

class UserRepository:
    def __init__(self, db: Database) -> None:
        self._db = db

    def save(self, user: User) -> None:
        self._db.insert("users", asdict(user))

class UserNotifier:
    def __init__(self, smtp: SmtpClient) -> None:
        self._smtp = smtp

    def send_welcome(self, user: User) -> None:
        self._smtp.send(user.email, "Welcome!", "Thanks for joining")
```

### Open/Closed Principle (OCP)

**Definition:** Open for extension, closed for modification.

**Detection Patterns:**
- Adding features requires modifying existing code
- Switch/match statements on type to determine behavior
- Hardcoded conditional branches for variants

**Python Example - Before:**

```python
def calculate_discount(customer_type: str, amount: float) -> float:
    if customer_type == "regular":
        return amount * 0.1
    elif customer_type == "premium":
        return amount * 0.2
    elif customer_type == "vip":
        return amount * 0.3
    else:
        return 0
```

**Python Example - After:**

```python
from abc import ABC, abstractmethod

class DiscountStrategy(ABC):
    @abstractmethod
    def calculate(self, amount: float) -> float:
        pass

class RegularDiscount(DiscountStrategy):
    def calculate(self, amount: float) -> float:
        return amount * 0.1

class PremiumDiscount(DiscountStrategy):
    def calculate(self, amount: float) -> float:
        return amount * 0.2

class VipDiscount(DiscountStrategy):
    def calculate(self, amount: float) -> float:
        return amount * 0.3

def calculate_discount(strategy: DiscountStrategy, amount: float) -> float:
    return strategy.calculate(amount)
```

### Liskov Substitution Principle (LSP)

**Definition:** Subclasses must be substitutable for their base classes.

**Detection Patterns:**
- Subclass raises exceptions not raised by parent
- Subclass returns different types than parent
- Subclass has weaker preconditions or stronger postconditions
- `isinstance()` checks to determine subclass behavior

**Python Example - Before (Violation):**

```python
class Bird:
    def fly(self) -> None:
        print("Flying")

class Penguin(Bird):
    def fly(self) -> None:
        raise NotImplementedError("Penguins can't fly")  # LSP violation
```

**Python Example - After:**

```python
from abc import ABC, abstractmethod

class Bird(ABC):
    @abstractmethod
    def move(self) -> None:
        pass

class FlyingBird(Bird):
    def move(self) -> None:
        self.fly()

    def fly(self) -> None:
        print("Flying")

class Penguin(Bird):
    def move(self) -> None:
        self.swim()

    def swim(self) -> None:
        print("Swimming")
```

### Interface Segregation Principle (ISP)

**Definition:** Many specific interfaces over one general interface.

**Detection Patterns:**
- Classes implement methods that raise `NotImplementedError`
- Classes have methods that do nothing (empty implementations)
- Clients depend on methods they don't use

**Python Example - Before:**

```python
from abc import ABC, abstractmethod

class Worker(ABC):
    @abstractmethod
    def work(self) -> None:
        pass

    @abstractmethod
    def eat(self) -> None:
        pass

    @abstractmethod
    def sleep(self) -> None:
        pass

class Robot(Worker):
    def work(self) -> None:
        print("Working")

    def eat(self) -> None:
        pass  # Robots don't eat - ISP violation

    def sleep(self) -> None:
        pass  # Robots don't sleep - ISP violation
```

**Python Example - After:**

```python
from typing import Protocol

class Workable(Protocol):
    def work(self) -> None: ...

class Eatable(Protocol):
    def eat(self) -> None: ...

class Sleepable(Protocol):
    def sleep(self) -> None: ...

class Human:
    def work(self) -> None:
        print("Working")

    def eat(self) -> None:
        print("Eating")

    def sleep(self) -> None:
        print("Sleeping")

class Robot:
    def work(self) -> None:
        print("Working")
```

### Dependency Inversion Principle (DIP)

**Definition:** Depend on abstractions, not concrete implementations.

**Detection Patterns:**
- High-level modules import low-level modules directly
- Classes instantiate their dependencies internally
- Concrete class names in type hints of constructors

**Python Example - Before:**

```python
class MySqlDatabase:
    def query(self, sql: str) -> list:
        # MySQL-specific implementation
        pass

class UserRepository:
    def __init__(self):
        self.db = MySqlDatabase()  # Concrete dependency

    def get_user(self, user_id: int) -> dict:
        return self.db.query(f"SELECT * FROM users WHERE id = {user_id}")
```

**Python Example - After:**

```python
from typing import Protocol

class Database(Protocol):
    def query(self, sql: str) -> list: ...

class MySqlDatabase:
    def query(self, sql: str) -> list:
        # MySQL-specific implementation
        pass

class UserRepository:
    def __init__(self, db: Database) -> None:
        self._db = db

    def get_user(self, user_id: int) -> dict:
        return self._db.query(f"SELECT * FROM users WHERE id = {user_id}")
```

## DRY (Don't Repeat Yourself)

**Definition:** Every piece of knowledge should have a single, unambiguous representation.

**Detection Patterns:**
- Same code block appears in multiple places
- Similar logic with minor variations
- Copy-pasted code with different variable names
- Multiple sources of truth for same data

**Refactoring Strategies:**

1. **Extract Function** - Common operations become shared functions
2. **Extract Class** - Related operations become a class
3. **Use Inheritance/Composition** - Share behavior through class relationships
4. **Create Utility Modules** - Cross-cutting concerns in dedicated modules
5. **Leverage Decorators** - Cross-cutting concerns like logging, caching

**Python Example - Before:**

```python
def process_user_data(user):
    if not user.get("email"):
        raise ValueError("Email required")
    if "@" not in user.get("email", ""):
        raise ValueError("Invalid email format")
    # ... processing

def process_admin_data(admin):
    if not admin.get("email"):
        raise ValueError("Email required")
    if "@" not in admin.get("email", ""):
        raise ValueError("Invalid email format")
    # ... processing
```

**Python Example - After:**

```python
def validate_email(email: str | None) -> None:
    if not email:
        raise ValueError("Email required")
    if "@" not in email:
        raise ValueError("Invalid email format")

def process_user_data(user: dict) -> None:
    validate_email(user.get("email"))
    # ... processing

def process_admin_data(admin: dict) -> None:
    validate_email(admin.get("email"))
    # ... processing
```

## KISS (Keep It Simple, Stupid)

**Definition:** Prefer straightforward solutions over clever ones.

**Detection Patterns:**
- Complex one-liners that need comments to explain
- Nested comprehensions more than 2 levels deep
- Metaclasses or descriptors for simple problems
- Over-abstracted code with many indirection layers

**Guidelines:**
1. Prefer explicit over implicit
2. Use Python's built-in features before external libraries
3. Write code that reads like natural language
4. Avoid premature optimization
5. Question abstractions that don't simplify

**Python Example - Before:**

```python
# Over-engineered solution
result = list(map(lambda x: x**2, filter(lambda x: x % 2 == 0,
    reduce(lambda acc, x: acc + [x] if x > 0 else acc, numbers, []))))
```

**Python Example - After:**

```python
# Simple and readable
positive_numbers = [n for n in numbers if n > 0]
even_numbers = [n for n in positive_numbers if n % 2 == 0]
result = [n**2 for n in even_numbers]
```

## YAGNI (You Aren't Gonna Need It)

**Definition:** Implement only what is currently required.

**Detection Patterns:**
- Unused parameters "for future use"
- Empty abstract methods waiting to be implemented
- Configuration options that are never used
- Commented-out code "in case we need it"
- Generic solutions for single use cases

**Guidelines:**
1. Remove speculative features
2. Delete commented-out code (use version control instead)
3. Avoid building flexibility for hypothetical futures
4. Question each abstraction layer's necessity

**Python Example - Before:**

```python
class DataProcessor:
    def __init__(self, config=None, logger=None, cache=None,
                 metrics=None, retry_policy=None):  # Many unused params
        self.config = config or {}
        self.logger = logger
        self.cache = cache  # Never used
        self.metrics = metrics  # Never used
        self.retry_policy = retry_policy  # Never used

    def process(self, data, format="json", validate=True,
                async_mode=False, callback=None):  # Many unused params
        # Only uses data and format
        pass
```

**Python Example - After:**

```python
class DataProcessor:
    def __init__(self, config: dict | None = None) -> None:
        self.config = config or {}

    def process(self, data: dict, format: str = "json") -> dict:
        # Implementation uses both parameters
        pass
```

## Additional Principles

### Law of Demeter

**Definition:** Only talk to immediate friends (minimize coupling).

**Detection Patterns:**
- Method chains like `obj.a.b.c.method()`
- Accessing nested attributes of parameters
- "Train wreck" code patterns

### Composition Over Inheritance

**Definition:** Prefer object composition for code reuse.

**When to Use:**
- Inheritance creates tight coupling
- Need to combine behaviors from multiple sources
- "Is-a" relationship isn't clear

### Fail Fast

**Definition:** Validate inputs early, raise exceptions immediately.

**Guidelines:**
- Check preconditions at function start
- Use type hints for static checking
- Raise specific exceptions with clear messages

### Separation of Concerns

**Definition:** Isolate distinct functionality into separate modules.

**Common Separations:**
- Business logic from I/O
- Data access from business rules
- Presentation from domain logic
