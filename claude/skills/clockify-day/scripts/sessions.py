"""Prints a day's Claude work blocks as JSON, for the /clockify-day skill.

Reads Claude Code transcripts from the work account's config directory (add
`--config-dir ~/.claude-personal` to include the personal account) and the
metadata of interactive Claude Desktop Cowork sessions, then prints
per-project work blocks plus a union that counts parallel sessions once.
Hours are estimates: a gap longer than `--gap-minutes` ends a block.

Usage:
    python3 sessions.py [--date YYYY-MM-DD] [--gap-minutes 15]
"""

from __future__ import annotations

import argparse
import collections
import dataclasses
from collections.abc import Iterator
from collections.abc import Sequence
import datetime
import json
import pathlib
import sys
from typing import Any
import zoneinfo

import blocks

DEFAULT_CONFIG_DIRS = ("~/.claude",)
COWORK_ROOT = "~/Library/Application Support/Claude/local-agent-mode-sessions"


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    """Parses command-line arguments.

    Args:
        argv: Arguments without the program name.

    Returns:
        The parsed namespace.
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--date", help="Local day, YYYY-MM-DD (default today)")
    parser.add_argument("--gap-minutes", type=int, default=15)
    parser.add_argument("--tz", help="IANA zone (default: system zone)")
    parser.add_argument(
        "--config-dir",
        action="append",
        help="Claude config dir; repeatable (default ~/.claude, work)",
    )
    return parser.parse_args(argv)


def read_events(
    path: pathlib.Path,
    project: str,
) -> Iterator[blocks.Event]:
    """Yields the events found in one transcript file.

    Events are filed under the transcript's project folder and not under the
    `cwd` recorded on each line, because `cwd` drifts into subdirectories
    during a session and would split one project into many.

    Args:
        path: A session `.jsonl` file.
        project: Name of the project folder the transcript lives in.

    Yields:
        One event per user or assistant line.
    """
    with path.open(encoding="utf-8", errors="replace") as handle:
        yield from (
            dataclasses.replace(event, cwd=project)
            for event in filter(None, map(blocks.parse_event, handle))
        )


def transcript_paths(
    config_dirs: Sequence[pathlib.Path],
    since: datetime.datetime,
) -> Iterator[tuple[pathlib.Path, str]]:
    """Yields transcript files that were written since a moment.

    Args:
        config_dirs: Claude config directories.
        since: Files last modified before this are skipped.

    Yields:
        Pairs of `.jsonl` path and project folder name, subagent
        transcripts included.
    """
    candidates = (
        (path, path.relative_to(config / "projects").parts[0])
        for config in config_dirs
        for path in (config / "projects").glob("**/*.jsonl")
    )
    yield from (
        (path, project)
        for path, project in candidates
        if datetime.datetime.fromtimestamp(
            path.stat().st_mtime, datetime.timezone.utc
        )
        >= since
    )


def project_blocks(
    events: Sequence[blocks.Event],
    gap: datetime.timedelta,
    tz: datetime.tzinfo | None,
) -> list[dict[str, Any]]:
    """Groups events by working directory and splits each into blocks.

    Args:
        events: Events of the target day.
        gap: Largest idle time still counted as continuous work.
        tz: Zone the times are shown in; None means the system zone.

    Returns:
        One entry per project, each with its blocks as dictionaries.
    """
    grouped: dict[str, list[blocks.Event]] = collections.defaultdict(list)
    for event in events:
        grouped[event.cwd or "(unknown)"].append(event)
    return [
        {
            "project": cwd,
            "blocks": [
                render(b, tz) for b in blocks.split_blocks(group, gap)
            ],
        }
        for cwd, group in sorted(grouped.items())
    ]


def session_blocks(
    events: Sequence[blocks.Event],
    gap: datetime.timedelta,
    tz: datetime.tzinfo | None,
) -> list[dict[str, Any]]:
    """Splits events into blocks per individual session.

    Unlike `project_blocks`, one project folder can hold several unrelated
    sessions (for example different SoW reviews); keeping them apart lets the
    caller attribute time to the right piece of work.

    Args:
        events: Events of the target day.
        gap: Largest idle time still counted as continuous work.
        tz: Zone the times are shown in; None means the system zone.

    Returns:
        One entry per session, ordered by first activity, each with its
        project folder and blocks as dictionaries.
    """
    grouped: dict[tuple[str, str], list[blocks.Event]] = (
        collections.defaultdict(list)
    )
    for event in events:
        grouped[(event.cwd or "(unknown)", event.session)].append(event)
    entries = [
        {
            "session": session[:8],
            "project": cwd,
            "blocks": [
                render(b, tz) for b in blocks.split_blocks(group, gap)
            ],
        }
        for (cwd, session), group in grouped.items()
    ]
    return sorted(entries, key=lambda entry: entry["blocks"][0]["start"])


def render(block: blocks.Block, tz: datetime.tzinfo | None = None) -> dict:
    """Converts a block to a JSON-ready dictionary.

    Args:
        block: The block to convert.
        tz: Zone the times are shown in; None keeps the system zone.

    Returns:
        A dictionary with local times, minutes, counts and prompts.
    """
    return {
        "start": block.start.astimezone(tz).isoformat(timespec="minutes"),
        "end": block.end.astimezone(tz).isoformat(timespec="minutes"),
        "minutes": round(block.minutes),
        "events": block.events,
        "sessions": len(block.sessions),
        "prompts": list(block.prompts),
    }


def cowork_sessions(
    day: datetime.date,
    tz: datetime.tzinfo | None,
) -> list[dict[str, Any]]:
    """Lists interactive Cowork sessions active on a day.

    Cowork keeps no per-message transcript here, only creation and last
    activity times, so the span is coarse and may include idle time.
    Scheduled (automated) sessions are skipped because they are not work done
    by the user.

    Args:
        day: The local calendar day.
        tz: Zone the day is read in; None means the system zone.

    Returns:
        One entry per session with title and local start and end.
    """
    root = pathlib.Path(COWORK_ROOT).expanduser()
    found: list[dict[str, Any]] = []
    for path in root.glob("*/*/local_*.json"):
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
            start = datetime.datetime.fromtimestamp(
                data["createdAt"] / 1000, datetime.timezone.utc
            )
            end = datetime.datetime.fromtimestamp(
                data["lastActivityAt"] / 1000, datetime.timezone.utc
            )
        except (OSError, KeyError, TypeError, ValueError):
            continue
        if data.get("sessionType") == "scheduled":
            continue
        if not (blocks.in_day(start, day, tz) or blocks.in_day(end, day, tz)):
            continue
        found.append(
            {
                "title": data.get("title", ""),
                "folders": data.get("userSelectedFolders", []),
                "start": start.astimezone(tz).isoformat(timespec="minutes"),
                "end": end.astimezone(tz).isoformat(timespec="minutes"),
                "minutes": round((end - start).total_seconds() / 60),
            }
        )
    return sorted(found, key=lambda item: item["start"])


def main(argv: Sequence[str]) -> int:
    """Runs the report and prints it as JSON.

    Args:
        argv: Command-line arguments without the program name.

    Returns:
        Process exit code.
    """
    args = parse_args(argv)
    tz = zoneinfo.ZoneInfo(args.tz) if args.tz else None
    today = datetime.datetime.now(tz).date()
    day = datetime.date.fromisoformat(args.date) if args.date else today
    gap = datetime.timedelta(minutes=args.gap_minutes)
    midnight = datetime.datetime.combine(day, datetime.time.min)
    start_of_day = midnight.replace(tzinfo=tz).astimezone(tz)
    config_dirs = [
        pathlib.Path(name).expanduser()
        for name in (args.config_dir or DEFAULT_CONFIG_DIRS)
    ]
    events = [
        event
        for path, project in transcript_paths(config_dirs, start_of_day)
        for event in read_events(path, project)
        if blocks.in_day(event.time, day, tz)
    ]
    union = blocks.split_blocks(events, gap)
    report = {
        "date": day.isoformat(),
        "timezone": args.tz or start_of_day.strftime("%Z (UTC%z)"),
        "gap_minutes": args.gap_minutes,
        "note": "Estimates from message timestamps; idle gaps end a block.",
        "projects": project_blocks(events, gap, tz),
        "sessions": session_blocks(events, gap, tz),
        "union": [render(block, tz) for block in union],
        "union_minutes": round(sum(block.minutes for block in union)),
        "cowork": cowork_sessions(day, tz),
    }
    json.dump(report, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
