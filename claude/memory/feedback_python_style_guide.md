---
name: Always invoke python-style-guide skill for Python code
description: User expects the python-style-guide skill to be invoked before writing or modifying any Python file
type: feedback
originSessionId: 20404a3c-f2b6-40fd-bbdc-7497c6afae34
---
Always invoke the `python-style-guide` skill before writing or modifying any Python code. The user will reject the output if the skill was not applied.

**Why:** User called this out explicitly when Python code was written without invoking the skill first.

**How to apply:** Any time the task involves writing, editing, or reviewing a `.py` file, call `Skill(python-style-guide)` first and follow the returned rules before producing code.
