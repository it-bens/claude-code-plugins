# Code Smells Reference

Comprehensive catalog of code smells with detection patterns and refactoring strategies for Python code.

## Bloaters

Code that has grown excessively large and difficult to work with.

### Long Method

**Detection:**
- Function exceeds ~20 lines of code
- Multiple levels of indentation (3+)
- Comments separating logical sections
- Difficulty naming the function succinctly

**Refactoring: Extract Method**

```python
# Before
def process_order(order):
    # Validate order
    if not order.items:
        raise ValueError("Order must have items")
    if not order.customer:
        raise ValueError("Order must have customer")

    # Calculate totals
    subtotal = sum(item.price * item.quantity for item in order.items)
    tax = subtotal * 0.1
    shipping = 5.0 if subtotal < 50 else 0
    total = subtotal + tax + shipping

    # Create invoice
    invoice = {
        "order_id": order.id,
        "customer": order.customer.name,
        "subtotal": subtotal,
        "tax": tax,
        "shipping": shipping,
        "total": total,
    }

    # Send notification
    email_service.send(order.customer.email, "Order Confirmed", str(invoice))

    return invoice

# After
def process_order(order: Order) -> dict:
    validate_order(order)
    totals = calculate_totals(order)
    invoice = create_invoice(order, totals)
    send_order_confirmation(order.customer, invoice)
    return invoice

def validate_order(order: Order) -> None:
    if not order.items:
        raise ValueError("Order must have items")
    if not order.customer:
        raise ValueError("Order must have customer")

def calculate_totals(order: Order) -> OrderTotals:
    subtotal = sum(item.price * item.quantity for item in order.items)
    tax = subtotal * 0.1
    shipping = 5.0 if subtotal < 50 else 0
    return OrderTotals(subtotal, tax, shipping)
```

### Large Class

**Detection:**
- Class has many methods (10+)
- Class has many instance variables (7+)
- Methods can be grouped into distinct categories
- Changes to one part don't affect other parts

**Refactoring: Extract Class**

```python
# Before
class User:
    def __init__(self, name, email, street, city, zip_code, phone):
        self.name = name
        self.email = email
        self.street = street
        self.city = city
        self.zip_code = zip_code
        self.phone = phone

    def get_full_address(self):
        return f"{self.street}, {self.city} {self.zip_code}"

    def validate_email(self):
        return "@" in self.email

    # ... many more address and contact methods

# After
@dataclass
class Address:
    street: str
    city: str
    zip_code: str

    def get_full_address(self) -> str:
        return f"{self.street}, {self.city} {self.zip_code}"

@dataclass
class ContactInfo:
    email: str
    phone: str

    def validate_email(self) -> bool:
        return "@" in self.email

@dataclass
class User:
    name: str
    address: Address
    contact: ContactInfo
```

### Long Parameter List

**Detection:**
- Function has more than 3-4 parameters
- Many parameters are related (e.g., all describe the same entity)
- Boolean flags controlling behavior

**Refactoring: Introduce Parameter Object**

```python
# Before
def create_report(
    title, author, start_date, end_date,
    include_charts, include_summary, format,
    page_size, orientation, margins
):
    pass

# After
@dataclass
class ReportConfig:
    title: str
    author: str
    start_date: date
    end_date: date

@dataclass
class ReportOptions:
    include_charts: bool = True
    include_summary: bool = True
    format: str = "pdf"

@dataclass
class PageSettings:
    size: str = "A4"
    orientation: str = "portrait"
    margins: tuple[float, ...] = (1.0, 1.0, 1.0, 1.0)

def create_report(
    config: ReportConfig,
    options: ReportOptions | None = None,
    page_settings: PageSettings | None = None
) -> Report:
    options = options or ReportOptions()
    page_settings = page_settings or PageSettings()
    # ...
```

### Primitive Obsession

**Detection:**
- Strings used for structured data (emails, phone numbers, IDs)
- Numbers with special meaning (status codes, amounts)
- Arrays used as records

**Refactoring: Replace Primitive with Object**

```python
# Before
def process_payment(amount: float, currency: str, card_number: str):
    if len(card_number) != 16:
        raise ValueError("Invalid card number")
    # ...

# After
@dataclass(frozen=True)
class Money:
    amount: Decimal
    currency: str

    def __post_init__(self):
        if self.amount < 0:
            raise ValueError("Amount cannot be negative")

@dataclass(frozen=True)
class CardNumber:
    value: str

    def __post_init__(self):
        if len(self.value) != 16 or not self.value.isdigit():
            raise ValueError("Invalid card number")

    @property
    def masked(self) -> str:
        return f"****-****-****-{self.value[-4:]}"

def process_payment(amount: Money, card: CardNumber) -> None:
    # Type safety ensures valid inputs
    pass
```

### Data Clumps

**Detection:**
- Same group of variables appears together in multiple places
- Same parameters passed to multiple functions
- Parallel arrays/lists that are always used together

**Refactoring: Extract Class or Dataclass**

```python
# Before - same data appears in multiple signatures
def calculate_distance(x1, y1, x2, y2):
    return ((x2 - x1)**2 + (y2 - y1)**2)**0.5

def move_point(x, y, dx, dy):
    return x + dx, y + dy

def scale_point(x, y, factor):
    return x * factor, y * factor

# After
@dataclass
class Point:
    x: float
    y: float

    def distance_to(self, other: "Point") -> float:
        return ((other.x - self.x)**2 + (other.y - self.y)**2)**0.5

    def move(self, dx: float, dy: float) -> "Point":
        return Point(self.x + dx, self.y + dy)

    def scale(self, factor: float) -> "Point":
        return Point(self.x * factor, self.y * factor)
```

### Mutable Default Arguments

**Detection:**
- Function parameters with default values of `[]`, `{}`, or other mutable types
- Unexpected behavior when function called multiple times
- State persisting between function calls

**Refactoring: Use None with Factory**

```python
# Before - DANGEROUS
def add_item(item, items=[]):
    items.append(item)
    return items

# Calling add_item("a") then add_item("b") returns ["a", "b"]!

# After - SAFE
def add_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items
```

**Why This Happens:**
Default argument values are evaluated once at function definition time, not each call.
Mutable objects (lists, dicts, sets) persist between calls, causing unexpected behavior.

## Object-Orientation Abusers

Incorrect or incomplete application of OO principles.

### Switch Statements

**Detection:**
- `if/elif/elif...` chains checking same variable
- `match/case` on type to determine behavior
- Same switch structure appears in multiple places

**Refactoring: Replace with Polymorphism or Strategy**

```python
# Before
def calculate_area(shape):
    match shape["type"]:
        case "circle":
            return 3.14159 * shape["radius"]**2
        case "rectangle":
            return shape["width"] * shape["height"]
        case "triangle":
            return 0.5 * shape["base"] * shape["height"]

# After
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        pass

@dataclass
class Circle(Shape):
    radius: float

    def area(self) -> float:
        return 3.14159 * self.radius**2

@dataclass
class Rectangle(Shape):
    width: float
    height: float

    def area(self) -> float:
        return self.width * self.height

@dataclass
class Triangle(Shape):
    base: float
    height: float

    def area(self) -> float:
        return 0.5 * self.base * self.height
```

### Refused Bequest

**Detection:**
- Subclass doesn't use inherited methods/attributes
- Subclass overrides methods to do nothing or raise errors
- "Is-a" relationship doesn't make sense semantically

**Refactoring: Replace Inheritance with Delegation**

```python
# Before - Stack inheriting from List is problematic
class Stack(list):
    def push(self, item):
        self.append(item)

    def pop(self):  # Shadows list.pop with different semantics
        return super().pop()

    # Inherits insert(), remove(), etc. that shouldn't be used

# After
class Stack:
    def __init__(self):
        self._items: list = []

    def push(self, item) -> None:
        self._items.append(item)

    def pop(self):
        if not self._items:
            raise IndexError("Pop from empty stack")
        return self._items.pop()

    def peek(self):
        if not self._items:
            raise IndexError("Peek at empty stack")
        return self._items[-1]

    def __len__(self) -> int:
        return len(self._items)
```

### Parallel Inheritance Hierarchies

**Detection:**
- Creating a subclass in one hierarchy requires creating one in another
- Prefixes/suffixes match between hierarchies
- Changes ripple across multiple hierarchies

**Refactoring: Move Methods, Collapse Hierarchy, or Use Composition**

```python
# Before - parallel hierarchies
class Employee: pass
class Manager(Employee): pass
class Developer(Employee): pass

class EmployeeSerializer: pass
class ManagerSerializer(EmployeeSerializer): pass
class DeveloperSerializer(EmployeeSerializer): pass

# After - use composition/protocol
from typing import Protocol

class Serializable(Protocol):
    def to_dict(self) -> dict: ...

@dataclass
class Employee:
    name: str
    salary: float

    def to_dict(self) -> dict:
        return {"name": self.name, "salary": self.salary}

@dataclass
class Manager(Employee):
    department: str

    def to_dict(self) -> dict:
        return {**super().to_dict(), "department": self.department}
```

## Change Preventers

Patterns that make changes difficult and risky.

### Divergent Change

**Detection:**
- One class is modified for multiple unrelated reasons
- Different parts of a class change for different features
- Class has low cohesion

**Refactoring: Extract Class (one per reason to change)**

See Large Class example above.

### Shotgun Surgery

**Detection:**
- Making one change requires many small changes across files
- Same type of change is made in multiple places
- Related logic is scattered throughout codebase

**Refactoring: Move Method, Move Field, Inline Class**

```python
# Before - discount logic scattered everywhere
class Order:
    def get_price(self):
        return self.base_price * (1 - self.discount_percent / 100)

class Invoice:
    def calculate_total(self):
        return self.amount * (1 - self.discount_percent / 100)

class Quote:
    def estimated_price(self):
        return self.price * (1 - self.discount_percent / 100)

# After - centralized discount logic
def apply_discount(price: float, discount_percent: float) -> float:
    return price * (1 - discount_percent / 100)

# Or as a value object
@dataclass(frozen=True)
class Money:
    amount: Decimal

    def with_discount(self, percent: Decimal) -> "Money":
        return Money(self.amount * (1 - percent / 100))
```

## Dispensables

Code that serves no purpose and should be removed.

### Dead Code

**Detection:**
- Unreachable code after return/raise
- Unused variables, parameters, functions, classes
- Commented-out code blocks
- Code only reachable under impossible conditions

**Refactoring: Remove Dead Code**

```python
# Before
def calculate(x, y, unused_param):  # unused_param never used
    # result = x + y  # Old implementation
    total = x * y
    return total
    print("Done")  # Unreachable

# After
def calculate(x: int, y: int) -> int:
    return x * y
```

### Speculative Generality

**Detection:**
- Abstract classes with single implementation
- Unused parameters "for future use"
- Methods that only delegate
- Overly generic names

**Refactoring: Collapse Hierarchy, Remove Parameter**

```python
# Before - over-engineered for single use case
class AbstractDataProcessor(ABC):
    @abstractmethod
    def process(self, data): pass

    @abstractmethod
    def validate(self, data): pass

    @abstractmethod
    def transform(self, data): pass

class JsonDataProcessor(AbstractDataProcessor):
    # Only implementation

# After - just the implementation
class JsonProcessor:
    def process(self, data: dict) -> dict:
        self._validate(data)
        return self._transform(data)

    def _validate(self, data: dict) -> None:
        # ...

    def _transform(self, data: dict) -> dict:
        # ...
```

### Duplicate Code

**Detection:**
- Identical or near-identical code blocks
- Same algorithm with different data
- Parallel conditionals

**Refactoring: Extract Method, Pull Up Method, Form Template Method**

```python
# Before
def send_user_notification(user, message):
    if not user.email:
        raise ValueError("No email")
    email_service.send(user.email, "User Notification", message)
    audit_log.record("notification", user.id, message)

def send_admin_notification(admin, message):
    if not admin.email:
        raise ValueError("No email")
    email_service.send(admin.email, "Admin Notification", message)
    audit_log.record("notification", admin.id, message)

# After
def send_notification(recipient: HasEmail, subject: str, message: str) -> None:
    if not recipient.email:
        raise ValueError("No email")
    email_service.send(recipient.email, subject, message)
    audit_log.record("notification", recipient.id, message)
```

### Comments (Explaining Bad Code)

**Detection:**
- Comments explain what code does (not why)
- Comments apologize for confusing code
- Large comment blocks before complex sections
- Outdated comments that don't match code

**Refactoring: Extract Method with descriptive name, rename variables**

```python
# Before
# Check if user is eligible for discount
# User must be premium and have been a member for at least 2 years
# and have made at least 5 purchases
if user.type == "premium" and (datetime.now() - user.joined).days > 730 and user.purchase_count >= 5:
    apply_discount()

# After - self-documenting code
def is_eligible_for_loyalty_discount(user: User) -> bool:
    is_premium = user.type == "premium"
    membership_years = (datetime.now() - user.joined).days / 365
    has_long_membership = membership_years >= 2
    has_enough_purchases = user.purchase_count >= 5
    return is_premium and has_long_membership and has_enough_purchases

if is_eligible_for_loyalty_discount(user):
    apply_discount()
```

## Couplers

Excessive coupling between classes.

### Feature Envy

**Detection:**
- Method uses more data from another class than its own
- Method accesses other object's attributes extensively
- Chain of attribute access to get data

**Refactoring: Move Method**

```python
# Before - method envies Invoice's data
class ReportGenerator:
    def format_invoice_summary(self, invoice):
        return (
            f"Invoice #{invoice.number}\n"
            f"Customer: {invoice.customer.name}\n"
            f"Items: {len(invoice.items)}\n"
            f"Total: ${invoice.subtotal + invoice.tax}"
        )

# After - move method to Invoice
class Invoice:
    def format_summary(self) -> str:
        return (
            f"Invoice #{self.number}\n"
            f"Customer: {self.customer.name}\n"
            f"Items: {len(self.items)}\n"
            f"Total: ${self.total}"
        )

    @property
    def total(self) -> float:
        return self.subtotal + self.tax
```

### Inappropriate Intimacy

**Detection:**
- Classes access each other's private attributes
- Bidirectional associations
- Subclass accesses parent's private details

**Refactoring: Move Method, Extract Class, Change Association**

```python
# Before - classes know too much about each other
class Order:
    def __init__(self, customer):
        self.customer = customer
        customer._orders.append(self)  # Accessing private

    def get_discount(self):
        return self.customer._loyalty_points * 0.01  # Accessing private

# After - proper encapsulation
class Customer:
    def __init__(self):
        self._orders: list[Order] = []
        self._loyalty_points: int = 0

    def add_order(self, order: Order) -> None:
        self._orders.append(order)

    def get_discount_rate(self) -> float:
        return self._loyalty_points * 0.01

class Order:
    def __init__(self, customer: Customer):
        self.customer = customer
        customer.add_order(self)

    def get_discount(self) -> float:
        return self.customer.get_discount_rate()
```

### Message Chains

**Detection:**
- Chain of method calls: `a.getB().getC().getD().doSomething()`
- Navigation through object graph to reach distant data
- Violations of Law of Demeter

**Refactoring: Hide Delegate, Extract Method**

```python
# Before
def get_manager_phone(employee):
    return employee.department.manager.contact.phone

# After - hide the navigation
class Employee:
    def get_manager_phone(self) -> str:
        return self.department.get_manager_phone()

class Department:
    def get_manager_phone(self) -> str:
        return self.manager.phone

# Or pass what you need
def send_alert(manager_phone: str) -> None:
    # Called with employee.department.manager.phone from caller
    pass
```

### Middle Man

**Detection:**
- Class mostly delegates to another class
- Methods just forward calls with no added value
- Class exists only to hide another class

**Refactoring: Remove Middle Man, Inline Method**

```python
# Before - Department just delegates everything
class Department:
    def __init__(self, manager):
        self._manager = manager

    def get_manager_name(self):
        return self._manager.name

    def get_manager_email(self):
        return self._manager.email

    def approve_request(self, request):
        return self._manager.approve(request)

# After - expose the manager directly
class Department:
    def __init__(self, manager: Manager):
        self.manager = manager

# Callers access department.manager.name directly
```
