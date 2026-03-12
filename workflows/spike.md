# Workflow For A Spike

The strong opinion that drives this: A spike isn't a feature. It's an experiment. The outcome is a decision, not a deliverable.

A spike is a time-boxed research task with the goal of exploring a problem, reducing uncertainty, or answering a specific technical question before committing to a full implementation. With limited time you often only have time to try one approach, maybe two. So you pick your best guess and hope it holds up.

AI agents change this. You can now evaluate multiple approaches in the time it used to take to evaluate one.

## Workflow

1. Write a spike brief before touching code. I do this to get clear in my own head: what's the question I'm trying to answer, and what constraints do I have to work within? One question, clear acceptance criteria, well documented constraints. Keep this to a max of one page to avoid letting the scope become too large.

2. Leverage the best thinking model you have access to generate options to explore, create a brief for each that documents the question and the option to explore.

3. Set up a throwaway directory for each option. No scaffolding, no ceremony. Just the brief for this option.

4. Run an agent in each directory tasked with addressing the brief. This might follow a cutdown version of the [greenfield](greenfield.md) approacj.

5. Review each outcome. Did it answer the question? Note what worked, what didn't, and whether the brief needs refining.

6. Refine and re-run if needed. Tighten the brief and try again until you have a clear result.

7. Write an ADR (Architecture Decision Record) when you're done. Question, findings, decision, rationale. Commit that. Delete the spike directories.
