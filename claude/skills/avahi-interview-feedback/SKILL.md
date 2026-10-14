---
name: avahi-interview-feedback
description: Write Avahi interview feedback (BambooHR-ready) from a transcript and the interviewer's rough notes, for either a technical interview or an ORBIT loop interview. Use whenever the user mentions interview feedback, a candidate write-up, a debrief, a transcript to summarize, "technical" or "loop" interviews, ORBIT values, the ORBIT question bank, ratings like At Bar / Below Bar, or a hiring recommendation, even if they do not name the skill. Also use to prepare for an interview (pick ORBIT questions, build a STAR note sheet).
---

# Avahi Interview Feedback

Turns a transcript plus my (the interviewer's) rough observations into a feedback file the hiring team can act on. The reader will make a hiring decision from it without re-watching the interview, so every claim has to be traceable to something the candidate said or did.

## Step 1: Identify the interview type

Ask if it is not obvious. Two types:

| Type | What it is | Template |
|---|---|---|
| **Technical** | Breadth questions, a depth chain, a hands-on exercise. ORBIT values only if some were asked. | `references/technical-template.md` |
| **Loop** | Behavioral interview on ORBIT values (STAR answers). One loop session usually covers 1-3 values. | `references/loop-template.md` |

Read the matching template before writing. For exact question wording, or to prepare questions, read `references/orbit-question-bank.md` (the official Avahi ORBIT Question Bank).

## Step 2: Gather inputs

Needed: transcript (or detailed notes), my rough observations, the role and level (junior, mid, senior, manager). Strongly wanted: my rating per section and my recommendation. If ratings or the recommendation are missing, infer ratings from my comments and say so at the end. Never infer the recommendation silently: ask.

Special instructions to honor: output language, integrity concerns, process recommendation.

## Step 3: Write the file

One Markdown file named `<Candidate_Name>_Interview_Feedback.md`. Present it, then add a short note listing which ratings were inferred rather than given and anything you could not verify in the transcript.

## Rules (they apply to both types)

**Voice (hard rule).** The user is the interviewer, and the file is their own write-up. Write everything in first person ("I asked", "I had to prompt", "I am inclined to proceed", "I could not validate") in the user's own writing style: plain, direct, short sentences. Never refer to the interviewer in third person ("the interviewer said", "the interviewer could not validate", "per the interviewer's notes", "the interviewer's judgment"), and never narrate the notes as someone else's. The candidate is the only third party in the text. Observations I made are stated as mine ("I noticed", "I did not see"). If the user's past write-ups or notes are available, mirror their phrasing and rhythm. Before presenting, scan the draft for "interviewer" and rewrite any hit.

**Ratings.** Only At Bar, Above Bar, Below Bar, Inconclusive. Use Inconclusive when the evaluation could not be completed fairly (language barrier, nerves, technical problems, time) and say why in the section text. Use Invalidated only for documented integrity cases. My ratings from the notes are ground truth: never overrule them. The rating goes in the section header. Per-question ratings only when I gave them or answers within a section differed a lot.

**Recommendation.** One of: Proceed, Proceed with secondary technical interview, Proceed with reservations, Do not proceed. It comes from me, the user. Do not soften or harden it. For serious integrity cases add "Flagged for blacklist, no future re-interview." directly under it.

**Evidence.** Every positive or negative statement carries an example: a named project, tool, bug, metric or phrase. Report what was said in order, including when a follow-up or redirect was needed, and when I had to supply the answer. Compare against the CV claim, the expected answer (question bank for ORBIT, my reference for tech) and the level expectation. Reuse my own phrasing from the notes when it is already good. This matters because vague praise is useless in a debrief and an unsupported negative is unfair to the candidate.

**Coverage.** Never invent coverage. Only write up values, questions and tests that were actually asked. Omit uncovered sections and mention why in the summary only if it affects the decision.

**Tone.** Plain, factual, short sentences. No em dashes in body text: use commas, periods or parentheses (em dashes are allowed only in section headers like `SECTION 1: ORBIT VALUES — AT BAR`). English unless told otherwise, even if the interview was in Spanish. Use "Candidate" or the first name, consistently. State process problems neutrally and do not speculate about motives unless my notes explicitly raise an integrity concern.

**Integrity cases (rare).** Only when my notes document it. Add a note under the affected section headers saying responses are invalidated. Facts first (timeline, what was on screen, what was said, what records show), then my inference. Factual, not emotional.

## ORBIT values (current names)

Ownership, Results (Deliver Results), Band Member, Innovation, Trust (Earn Trust). The B is **Band Member**, not "Bias for Action". Older notes and templates may say Bias for Action; use Band Member in new feedback. If the transcript question matches a bank question, tag it with the correct value from the bank.

## Level calibration

The bank separates "as an individual contributor" and "as a people manager" behaviors per value, and marks manager-only questions with (Manager). Judge IC candidates on IC behaviors and manager candidates on both. A manager candidate answering only with individual examples is a finding worth stating.
