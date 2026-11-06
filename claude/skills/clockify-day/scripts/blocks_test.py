"""Tests for blocks.py."""

import datetime
import json
import unittest

import blocks

UTC = datetime.timezone.utc


def _event(minute: int, session: str = "s1", prompt: str = "") -> blocks.Event:
    """Builds an event `minute` minutes after 09:00 UTC on 2026-10-22."""
    base = datetime.datetime(2026, 10, 22, 9, 0, tzinfo=UTC)
    return blocks.Event(
        base + datetime.timedelta(minutes=minute), "/p", session, prompt
    )


GAP = datetime.timedelta(minutes=15)


class SplitBlocksTest(unittest.TestCase):
    """Covers gap splitting and merging."""

    def test_close_events_form_one_block(self) -> None:
        result = blocks.split_blocks([_event(0), _event(10), _event(20)], GAP)
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0].minutes, 20)
        self.assertEqual(result[0].events, 3)

    def test_gap_over_threshold_splits(self) -> None:
        result = blocks.split_blocks([_event(0), _event(40)], GAP)
        self.assertEqual([b.minutes for b in result], [0, 0])

    def test_gap_equal_to_threshold_stays_joined(self) -> None:
        joined = blocks.split_blocks([_event(0), _event(15)], GAP)
        self.assertEqual(len(joined), 1)

    def test_input_order_does_not_matter(self) -> None:
        events = [_event(30), _event(0), _event(10)]
        self.assertEqual(
            blocks.split_blocks(events, GAP),
            blocks.split_blocks(sorted(events, key=lambda e: e.time), GAP),
        )

    def test_deterministic(self) -> None:
        events = [_event(0), _event(5, "s2"), _event(50)]
        self.assertEqual(
            blocks.split_blocks(events, GAP), blocks.split_blocks(events, GAP)
        )

    def test_prompts_capped(self) -> None:
        events = [_event(i, prompt=f"p{i}") for i in range(6)]
        self.assertEqual(
            blocks.split_blocks(events, GAP)[0].prompts, ("p0", "p1", "p2")
        )

    def test_merge_counts_parallel_sessions_once(self) -> None:
        a = blocks.split_blocks([_event(0), _event(30)], GAP)
        b = blocks.split_blocks([_event(10), _event(20)], GAP)
        merged = blocks.merge_blocks(a + b, GAP)
        self.assertEqual([m.minutes for m in merged], [30])


class ParseEventTest(unittest.TestCase):
    """Covers transcript line parsing."""

    def _line(self, **fields: object) -> str:
        base = {
            "type": "user",
            "timestamp": "2026-10-22T21:35:11.467Z",
            "cwd": "/p",
            "sessionId": "s",
            "message": {"role": "user", "content": "hello  there"},
        }
        return json.dumps({**base, **fields})

    def test_typed_prompt(self) -> None:
        event = blocks.parse_event(self._line())
        self.assertEqual(event.prompt, "hello there")
        self.assertEqual(event.time.tzinfo, UTC)

    def test_harness_message_has_no_prompt(self) -> None:
        line = self._line(message={"content": "<local-command-caveat>x"})
        self.assertEqual(blocks.parse_event(line).prompt, "")

    def test_ignores_other_types_and_bad_lines(self) -> None:
        self.assertIsNone(blocks.parse_event(self._line(type="mode")))
        self.assertIsNone(blocks.parse_event("not json"))
        self.assertIsNone(blocks.parse_event("[1, 2]"))
        self.assertIsNone(blocks.parse_event('{"type": "user"}'))


class InDayTest(unittest.TestCase):
    """Covers local-day membership."""

    def test_utc_late_evening_is_next_day_in_cest(self) -> None:
        cest = datetime.timezone(datetime.timedelta(hours=2))
        moment = datetime.datetime(2026, 10, 22, 23, 0, tzinfo=UTC)
        next_day = datetime.date(2026, 10, 23)
        self.assertTrue(blocks.in_day(moment, next_day, cest))
        self.assertFalse(blocks.in_day(moment, next_day.replace(day=22), cest))


if __name__ == "__main__":
    unittest.main()
