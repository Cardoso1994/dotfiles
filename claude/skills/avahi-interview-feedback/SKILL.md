---
name: avahi-interview-feedback
description: Write Avahi interview feedback (BambooHR-ready) from a transcript and the interviewer's rough notes, for either a technical interview or an ORBIT loop interview. Use whenever the user mentions interview feedback, a candidate write-up, a debrief, a transcript to summarize, "technical" or "loop" interviews, ORBIT values, the ORBIT question bank, ratings like At Bar / Below Bar, or a hiring recommendation, even if they do not name the skill. Pulls the transcript from Otter and posts the approved feedback to BambooHR when those MCP servers are available, in checkpointed steps. Also use to prepare for an interview (pick ORBIT questions, build a STAR note sheet).
---

# Avahi Interview Feedback

Turns a transcript plus my (the interviewer's) rough observations into a feedback file the hiring team can act on. The reader will make a hiring decision from it without re-watching the interview, so every claim has to be traceable to something the candidate said or did.

## Workflow overview

Work in checkpointed steps and stop at each checkpoint until I say to continue. Never skip ahead, and never post anything to BambooHR before I approve the final text.

1. Identify the interview type and check which MCP servers are available.
2. Reconcile the Otter recording (checkpoint A: I confirm the right meeting and the reconciliation).
3. Gather my notes and write the feedback (checkpoint B: I review and iterate until I approve).
4. Post to BambooHR (checkpoint C: I give an explicit go on the exact text and target application).

## Step 1: Identify the interview type and tools

Ask if it is not obvious. Two types:

| Type | What it is | Template |
|---|---|---|
| **Technical** | Breadth questions, a depth chain, a hands-on exercise. ORBIT values only if some were asked. | `references/technical-template.md` |
| **Loop** | Behavioral interview on ORBIT values (STAR answers). One loop session usually covers 1-3 values. | `references/loop-template.md` |

Read the matching template before writing. For exact question wording, or to prepare questions, read `references/orbit-question-bank.md` (the official Avahi ORBIT Question Bank).

Tools to use when available (load their schemas with ToolSearch first):

- **Otter** (`otter_get_user_info`, `otter_search`, `otter_fetch`) for the recording and transcript.
- **BambooHR** (`get_applications`, `get_application_details`, `create_application_comment`) to find the candidate's application and post the feedback.

If a server only exposes `authenticate` and `complete_authentication`, it is not connected in this session. Say so in one line, tell me to run `/mcp` (or offer to start the auth flow), and fall back to what I paste or point to. Do not stop the whole workflow for a missing server: skip that step and keep the others.

## Step 2: Reconcile the Otter recording (checkpoint A)

Skip this step only if Otter is unavailable or I already pasted the transcript.

1. Call `otter_get_user_info` once, to anchor "today" and "yesterday" to my date and time.
2. Search Otter for the candidate by name, and by date if I gave one. If more than one meeting matches, list them (title, date, duration, attendees) and ask which one. Do not guess.
3. Fetch the chosen meeting's transcript, and its summary and action items if Otter has them.
4. Reconcile before writing anything:
   - Confirm the meeting is the interview: candidate name, date, duration, attendees, and that it is the same session type I named (technical or loop).
   - Note gaps: recording starts late or ends early, long silences, sections with no transcript, speakers mislabeled.
   - Flag likely transcription errors in names, tools, services and numbers that the feedback would repeat (for example an AWS service or a project name).
   - If I already gave notes, compare them with the transcript: what my notes say that the transcript does not show, what the transcript shows that my notes miss, and any conflict.
5. Present a short reconciliation: the meeting identified, the gaps and likely errors, and the differences with my notes. Then **stop and wait** for me to confirm or correct. Do not draft feedback yet.

## Step 3: Gather my notes and write the feedback (checkpoint B)

Needed: the confirmed transcript (or detailed notes), my rough observations, the role and level (junior, mid, senior, manager). Strongly wanted: my rating per section and my recommendation. If ratings or the recommendation are missing, infer ratings from my comments and say so at the end. Never infer the recommendation silently: ask.

Special instructions to honor: output language, integrity concerns, process recommendation.

Write one file (plain text layout as in the loop template, saved with a .md extension) named `<Candidate_Name>_Interview_Feedback.md`. Present it, then add a short note listing which ratings were inferred rather than given and anything you could not verify in the transcript.

Then **stop and wait**. I will ask for changes, answer the open questions and iterate. Apply each change to the file and show what changed. Move on only when I say the feedback is approved. "Looks good" about one section is not approval of the whole file: ask once if unclear.

## Step 4: Post to BambooHR (checkpoint C)

Skip this step if BambooHR is unavailable: tell me the file is ready to paste.

1. Find the application with `get_applications` and confirm the candidate and role with `get_application_details`. If several applications match (different roles, duplicate candidates), list them and ask which one. Do not guess.
2. Show me the exact text you will post and the target (candidate, role, application ID). The comment is the approved feedback only: no transcript excerpts beyond what the feedback already quotes, and no notes to me. BambooHR has no structured fields in this connector, so the section ratings and the recommendation stay inside the text.
3. **Stop and wait** for an explicit go on that text and target. Approval of the file in Step 3 is not approval to post.
4. Post with `create_application_comment`, using exactly the approved text. If I want any edit after approving, update the file and ask for approval again before posting.
5. Report the result plainly. On an error, say what failed and do not retry on your own: a retry can create a duplicate comment, and there is no tool to delete one.
6. Never add Claude attribution or credit lines to the comment.

## Rules (they apply to both types)

**Voice (hard rule).** The user is the interviewer, and the file is their own write-up. Write everything in first person ("I asked", "I had to prompt", "I am inclined to proceed", "I could not validate") in the user's own writing style: plain, direct, short sentences. Never refer to the interviewer in third person ("the interviewer said", "the interviewer could not validate", "per the interviewer's notes", "the interviewer's judgment"), and never narrate the notes as someone else's. The candidate is the only third party in the text. Observations I made are stated as mine ("I noticed", "I did not see"). If the user's past write-ups or notes are available, mirror their phrasing and rhythm. Before presenting, scan the draft for "interviewer" and rewrite any hit.

**Ratings.** Only At Bar, Above Bar, Below Bar, Inconclusive. Use Inconclusive when the evaluation could not be completed fairly (language barrier, nerves, technical problems, time) and say why in the section text. Use Invalidated only for documented integrity cases. My ratings from the notes are ground truth: never overrule them. The rating goes in the section header. Per-question ratings only when I gave them or answers within a section differed a lot.

**Recommendation.** It comes from me, the user. Use my own wording (for example Hire, Proceed, Do not proceed). If I give none, ask, and offer: Proceed, Proceed with secondary technical interview, Proceed with reservations, Do not proceed. Do not soften or harden it. For serious integrity cases add "Flagged for blacklist, no future re-interview." directly under it.

**Evidence.** Every positive or negative statement carries an example: a named project, tool, bug, metric or phrase. Report what was said in order, including when a follow-up or redirect was needed, and when I had to supply the answer. Compare against the CV claim, the expected answer (question bank for ORBIT, my reference for tech) and the level expectation. Reuse my own phrasing from the notes when it is already good. This matters because vague praise is useless in a debrief and an unsupported negative is unfair to the candidate.

**Coverage.** Never invent coverage. Only write up values, questions and tests that were actually asked. Omit uncovered sections and mention why in the summary only if it affects the decision.

**Tone.** Plain, factual, short sentences. No em dashes in body text: use commas, periods or parentheses (em dashes are allowed only in section headers like `SECTION 1: ORBIT VALUES — AT BAR`). English unless told otherwise, even if the interview was in Spanish. Use "Candidate" or the first name, consistently. State process problems neutrally and do not speculate about motives unless my notes explicitly raise an integrity concern.

**Integrity cases (rare).** Only when my notes document it. Add a note under the affected section headers saying responses are invalidated. Facts first (timeline, what was on screen, what was said, what records show), then my inference. Factual, not emotional.

## ORBIT values (current names)

Ownership, Results (Deliver Results), Band Member, Innovation, Trust (Earn Trust). The B is **Band Member**, not "Bias for Action". Older notes and templates may say Bias for Action; use Band Member in new feedback. If the transcript question matches a bank question, tag it with the correct value from the bank.

## Level calibration

The bank separates "as an individual contributor" and "as a people manager" behaviors per value, and marks manager-only questions with (Manager). Judge IC candidates on IC behaviors and manager candidates on both. A manager candidate answering only with individual examples is a finding worth stating.
