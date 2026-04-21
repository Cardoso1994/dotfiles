---
name: python-style-guide
description: Enforces Google Python Style Guide and functional programming principles. Use when the user asks to write, create, edit, modify, review, or refactor any Python code, Python script, Python function, Python class, Python module, or any .py file. Also use when adding features to existing Python code or fixing bugs in Python.
---

Apply these rules to all Python code you write or modify.

## Imports

- No relative imports — always use full package paths
- One import per line; group in order: future → stdlib → third-party → local
- Import modules, not individual classes/functions (except `typing`,
  `collections.abc`)
- Sort alphabetically within each group

## Naming

| Type | Convention |
|------|------------|
| Modules, functions, variables | `lower_with_under` |
| Classes, Exceptions | `CapWords` |
| Constants | `CAPS_WITH_UNDER` |
| Protected | `_leading_under` |

## Docstrings

Every public function, class, and module must have a docstring.

```python
def fetch_data(url: str, timeout: int = 30) -> dict[str, Any]:
    """Fetches data from the given URL.

    Args:
        url: The endpoint to call.
        timeout: Request timeout in seconds.

    Returns:
        Parsed JSON response as a dict.

    Raises:
        IOError: If the request fails.
    """
```

- Generators use `Yields:` instead of `Returns:`
- Classes: describe what the instance *represents*, include `Attributes:`
  section
- Modules: one-line summary + blank line + details

## Type Annotations

Required on all public function signatures and return values. Annotate
variables when type is non-obvious.

```python
def process(items: list[str], limit: int = 10) -> dict[str, int]:
    ...
```

## Formatting

- Max 80 characters per line
- 4 spaces, never tabs
- Two blank lines between top-level definitions
- Use implicit line joining (parentheses), not backslash continuation
- No trailing whitespace
- No spaces around `=` in keyword arguments (unless type-annotated)

## Functional Programming

These rules apply to core logic (non-I/O) modules:

**Dispatch tables over if/elif ladders:**
```python
# Yes
OPERATIONS = {"+": lambda a, b: a + b, "-": lambda a, b: a - b}
result = OPERATIONS[op](left, right)

# No
if op == "+": return left + right
elif op == "-": return left - right
```

**Pure functions** — same input always produces same output, no hidden state, no side effects.

**I/O at edges** — only `main.py` or boundary modules do `input()`, `print()`, logging, network, filesystem. Core logic modules stay pure.

**No explicit loops in core logic** — prefer comprehensions, `map`, `filter`, or recursion. No `for`/`while` in parser/eval/tokenizer modules.

**No mutable global state** — module-level constants (`CAPS_WITH_UNDER`) are fine; mutable dicts/lists are not.

## Exception Handling

- Use specific exceptions (`ValueError`, `TypeError`), never bare `except:`
- Never use `assert` for validation (use `if` + `raise`)
- Minimize `try` block size
- Custom exceptions end in `Error`

## Testing

- Import real functions — never reimplement logic inside tests
- No mocks for pure functions; only mock I/O, filesystem, network, time
- Use `math.isclose()` for float comparisons
- Write composition tests: `calc(expr)` catches breaks in `parse()` + `eval_expr()` separately
- Add determinism tests: call same function twice, assert equal results

## Quick Checklist

Every file:
- [ ] Module docstring
- [ ] Grouped, absolute imports
- [ ] Type annotations on public API
- [ ] 80-char limit
- [ ] No mutable global state

Every function:
- [ ] Docstring with Args/Returns/Raises
- [ ] Type annotations
- [ ] Single responsibility
- [ ] No side effects (if core logic)

Every PR:
- [ ] No relative imports
- [ ] No bare `except:`
- [ ] No `assert` for validation
- [ ] Dispatch tables where applicable
- [ ] I/O isolated to edges
