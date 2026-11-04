"""Merge managed Claude Code settings into an account's live settings.json.

Usage: merge_settings.py BASE PROFILE LIVE [--dry-run]

The managed settings (BASE deep-merged with PROFILE) win on conflicts, but keys
that exist only in LIVE are kept, because Claude Code writes to settings.json
itself (autoMode rules, approved permissions). Permission lists are unioned.
With --dry-run, print a diff instead of writing.
"""

import difflib
import json
import os
import shutil
import sys

UNION_LISTS = {"allow", "deny", "ask"}


def load(path):
    if not os.path.exists(path):
        return {}
    with open(path) as f:
        return json.load(f)


def deep_merge(base, override, key=None):
    if isinstance(base, dict) and isinstance(override, dict):
        result = dict(base)
        for k, v in override.items():
            result[k] = deep_merge(base[k], v, k) if k in base else v
        return result
    if key in UNION_LISTS and isinstance(base, list):
        return base + [x for x in override if x not in base]
    return override


def main():
    base_path, profile_path, live_path = sys.argv[1:4]
    managed = deep_merge(load(base_path), load(profile_path))
    live = load(live_path)
    merged = deep_merge(live, managed)
    new = json.dumps(merged, indent=2) + "\n"
    if "--dry-run" in sys.argv:
        old = json.dumps(live, indent=2) + "\n"
        sys.stdout.writelines(
            difflib.unified_diff(
                old.splitlines(True),
                new.splitlines(True),
                live_path,
                live_path + " (merged)",
            )
        )
        return
    if os.path.exists(live_path):
        shutil.copy(live_path, live_path + ".bak")
    with open(live_path, "w") as f:
        f.write(new)


if __name__ == "__main__":
    main()
