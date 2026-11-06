"""Pure logic for turning session transcript lines into work blocks.

A transcript line becomes an `Event`. Events from one project are split into
`Block`s wherever the gap between consecutive events exceeds a threshold, and
blocks from different projects can be merged into one union so that parallel
sessions are not double counted. Nothing here touches the filesystem or the
clock; `sessions.py` owns all I/O.
"""

from __future__ import annotations

from collections.abc import Iterable
import dataclasses
import datetime
import functools
import json
from typing import Any

PROMPT_LIMIT = 3
PROMPT_CHARS = 140
EVENT_TYPES = frozenset({"user", "assistant"})


@dataclasses.dataclass(frozen=True)
class Event:
    """One user or assistant turn in a transcript.

    Attributes:
        time: When the line was written, timezone-aware.
        cwd: Working directory the session ran in, or an empty string.
        session: Session id the line belongs to.
        prompt: Shortened text of a typed user prompt, else an empty string.
    """

    time: datetime.datetime
    cwd: str
    session: str
    prompt: str


@dataclasses.dataclass(frozen=True)
class Block:
    """A stretch of continuous work.

    Attributes:
        start: Time of the first event.
        end: Time of the last event.
        events: Number of events folded into the block.
        sessions: Ids of the sessions that contributed events.
        prompts: Up to `PROMPT_LIMIT` typed prompts, in order.
    """

    start: datetime.datetime
    end: datetime.datetime
    events: int
    sessions: frozenset[str]
    prompts: tuple[str, ...]

    @property
    def minutes(self) -> float:
        """Returns the block length in minutes."""
        return (self.end - self.start).total_seconds() / 60


def _prompt_text(record: dict[str, Any]) -> str:
    """Returns the typed prompt of a user record, or an empty string.

    Args:
        record: One decoded transcript line.

    Returns:
        The shortened prompt, or an empty string for assistant lines, tool
        results and harness-generated messages (which start with `<`).
    """
    content = record.get("message", {}).get("content")
    is_typed = (
        record.get("type") == "user"
        and isinstance(content, str)
        and not content.lstrip().startswith("<")
    )
    return " ".join(content.split())[:PROMPT_CHARS] if is_typed else ""


def parse_event(line: str) -> Event | None:
    """Parses one transcript line into an event.

    Args:
        line: One line of a session `.jsonl` file.

    Returns:
        The event, or None when the line is not a user or assistant turn, has
        no usable timestamp, or is not valid JSON.
    """
    try:
        record = json.loads(line)
        stamp = record["timestamp"]
        time = datetime.datetime.fromisoformat(stamp.replace("Z", "+00:00"))
    except (
        json.JSONDecodeError,
        KeyError,
        AttributeError,
        TypeError,
        ValueError,
    ):
        return None
    if not isinstance(record, dict) or record.get("type") not in EVENT_TYPES:
        return None
    return Event(
        time=time,
        cwd=record.get("cwd", ""),
        session=record.get("sessionId", ""),
        prompt=_prompt_text(record),
    )


def block_from_event(event: Event) -> Block:
    """Returns a single-event block.

    Args:
        event: The event to start from.

    Returns:
        A block whose start and end are the event time.
    """
    return Block(
        start=event.time,
        end=event.time,
        events=1,
        sessions=frozenset({event.session}),
        prompts=(event.prompt,) if event.prompt else (),
    )


def join_blocks(first: Block, second: Block) -> Block:
    """Joins two blocks into one that spans both.

    Args:
        first: The block that starts earlier or at the same time.
        second: The block to fold in.

    Returns:
        A block covering both, with prompts capped at `PROMPT_LIMIT`.
    """
    return Block(
        start=min(first.start, second.start),
        end=max(first.end, second.end),
        events=first.events + second.events,
        sessions=first.sessions | second.sessions,
        prompts=(first.prompts + second.prompts)[:PROMPT_LIMIT],
    )


def _fold(
    gap: datetime.timedelta,
    acc: tuple[Block, ...],
    block: Block,
) -> tuple[Block, ...]:
    """Appends a block to the accumulator, joining it if close enough."""
    is_close = bool(acc) and block.start - acc[-1].end <= gap
    return (
        acc[:-1] + (join_blocks(acc[-1], block),)
        if is_close
        else acc + (block,)
    )


def merge_blocks(
    blocks: Iterable[Block],
    gap: datetime.timedelta,
) -> tuple[Block, ...]:
    """Merges blocks that overlap or sit within `gap` of each other.

    Args:
        blocks: Blocks in any order.
        gap: Largest idle time still counted as continuous work.

    Returns:
        Merged blocks ordered by start time.
    """
    ordered = sorted(blocks, key=lambda block: block.start)
    return functools.reduce(functools.partial(_fold, gap), ordered, ())


def split_blocks(
    events: Iterable[Event],
    gap: datetime.timedelta,
) -> tuple[Block, ...]:
    """Splits events into blocks wherever idle time exceeds `gap`.

    Args:
        events: Events in any order.
        gap: Largest idle time still counted as continuous work.

    Returns:
        Blocks ordered by start time.
    """
    return merge_blocks(map(block_from_event, events), gap)


def in_day(
    time: datetime.datetime,
    day: datetime.date,
    tz: datetime.tzinfo,
) -> bool:
    """Tells whether a moment falls on a calendar day in a time zone.

    Args:
        time: A timezone-aware moment.
        day: The calendar day.
        tz: The time zone the day is read in.

    Returns:
        True when `time` converted to `tz` lands on `day`.
    """
    return time.astimezone(tz).date() == day
