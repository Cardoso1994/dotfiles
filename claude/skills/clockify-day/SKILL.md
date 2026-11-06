---
name: clockify-day
description: Log a whole day of work in Clockify from Claude Code and Cowork session activity, Outlook/Teams meetings, and (as evidence only) Slack. Takes an optional date, defaults to today. Proposes entries, asks the user for exact times wherever work and meetings overlap, and writes nothing until the user confirms. Only run when the user invokes /clockify-day.
disable-model-invocation: true
argument-hint: "[YYYY-MM-DD] [notes]"
allowed-tools: Bash(python3 ${CLAUDE_SKILL_DIR}/scripts/sessions.py *)
---

# Log a day to Clockify

Run only when the user types `/clockify-day`. Nothing is written to Clockify
until the user gives an explicit yes to the final table.

## Rules that hold throughout

- **Date:** use the date in the arguments (`YYYY-MM-DD`), else **today**. Any
  other text in the arguments is context for descriptions.
- **Session hours are estimates.** They come from message timestamps with idle
  gaps removed. Always present them as proposals the user can edit.
- **Overlaps are the user's call.** Never subtract, trim or pick between
  overlapping work and meetings yourself. Show the overlap and ask the user
  for the actual start and end times.
- **Slack is evidence, never hours.** It can inform a description or hint at
  work that left no session trace, but it never creates or sizes an entry.
- Skip any source whose tools are unavailable or unauthorized, say so in the
  summary, and continue.

## Steps

1. **Collect session activity.** Run
   `python3 ${CLAUDE_SKILL_DIR}/scripts/sessions.py --date <date>`.
   It prints JSON: `projects` (work blocks per project folder), `sessions`
   (the same blocks split per individual session, which is how you tell apart
   unrelated work that shares one folder), `union`
   (blocks with parallel sessions counted once, so the sum is the real
   total), `cowork` (interactive Claude Desktop Cowork sessions, only a coarse
   created-to-last-activity span, so treat as a hint) and the time zone it
   used. It reads the work account only; add `--config-dir ~/.claude-personal`
   only if the user says personal sessions count. Blocks of a few minutes or
   with very few events are usually noise; mention them rather than log them.

2. **Collect meetings.** Call `outlook_calendar_search` (Microsoft 365) with
   `query: "*"`, `afterDateTime`/`beforeDateTime` bracketing the date,
   `order: "oldest"` and `limit: 25`; follow `nextOffset` until done. Event
   times come back as wall-clock `dateTime` plus `timeZone`: keep them
   together and never read `dateTime` as UTC. Drop all-day events and
   cancelled or declined ones; if the response does not show the user's
   response status, keep the event and ask in step 5.

3. **Collect Slack evidence (optional).** Call `slack_search_public_and_private`
   with `filters: "from:<@USER_ID> on:<date>"`, where `USER_ID` is the logged-in
   user id stated in that tool's description, `response_format: "concise"`.
   Use only to help word descriptions or to ask "I see Slack activity in
   <channel> around <time> with no session; was that work to log?".

4. **Match Jira tickets.** Skip quietly if Atlassian tools are unavailable.
   Delegate with the Agent tool (`subagent_type: "general-purpose"`,
   `model: "haiku"`) so Jira payloads stay out of this context. Give it the
   ticket keys found in the session prompts and project names, and have it
   find the cloud id, fetch known keys, and run JQL
   `assignee = currentUser() AND updated >= -14d ORDER BY updated DESC`
   (`maxResults` 50), using whatever Atlassian read tools are present. It must
   stay read-only and return at most 10 candidates (key, summary, status,
   project key, one line on why). You make the final match; never invent a
   ticket and state your confidence.

5. **Ask for times.** In one message show, in the user's time zone:
   - the session blocks (project, start-end, minutes, first prompts), with SoW
     work grouped by SoW: one group per SoW, rounds of the same SoW together,
   - the meetings (subject, start-end),
   - every overlap between a block and a meeting, and any meeting whose
     response status is unclear,
   - Cowork sessions and Slack-only hints as optional extras.

   Then ask the user for the actual start and end times to use for each
   overlapping stretch, and which blocks to keep, merge or drop. If there are
   no overlaps, still ask them to confirm or edit the proposed times.

6. **Resolve Clockify details.**
   - `getMyContext` for the user id, default workspace and time zone.
   - Build every `start` and `end` as ISO 8601 with the UTC offset that applies
     **on that date** in that zone (offsets change with daylight saving).
   - `listTimeEntries` with explicit `start` and `end` covering the whole day
     (its defaults are today only, so a past date needs both). Report entries
     that already cover a proposed window and drop or adjust proposals the user
     says are duplicates.
   - Decide client versus Internal for each row with
     [project-rules.md](project-rules.md) (read it now): the test is whether
     the time was spent doing work for the client. Note that SOW review, or
     rework before delivery is aligned, is Internal in the FAQ, but the user's
     own rule overrides it: SoW review, SoW writing and the artifacts that go
     with them are logged to the **Presales** project (see the Presales
     section of that file). Pure shadowing, KT and coaching are Internal.
     Log **one entry per SoW**, merging rounds of the same SoW and keeping
     different SoWs apart, even inside one project folder. Say
     which rule you applied for each row, and ask when it is unclear.
   - Pick the project with `findProject`: for client work try the Jira project
     name or key, the Clockify project the user named, or the session's folder
     name; for SoW work and internal meetings use the known internal projects
     in `project-rules.md` (Pre-Sales; Internal Meetings is the default for
     any internal item the user has not assigned elsewhere). Never use an
     archived project. Ask if there is no clear match.

7. **Confirm.** Show one table: date, start-end, duration, Clockify project,
   ticket, description. Descriptions are one to three sentences, past tense,
   starting with a verb, prefixed with the ticket key when matched (SoW
   entries name the SoW or customer, e.g. `Vulcan Materials SoW review (two
   rounds)`), e.g.
   `ABC-123: Implemented retry logic for the ingest Lambda`; meetings use the
   meeting subject. Long meetings are logged at their actual length. End with
   the total hours. Ask for edits or a yes. Do not
   create anything before an explicit yes.

8. **Log it.** After the yes, call `createTimeEntry` once per row with `start`,
   `end`, `description`, `projectId` (and `workspaceId` if needed). Never pass
   `billable: false` for MSP projects (it hides hours from utilization); leave
   `billable` out unless the user asks. Run them one at a time. If a call fails, show the error, stop, and say which rows
   were and were not created; never retry blindly. Finish by listing what was
   created.
