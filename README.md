# AI Coding Workflow

An overview of my opinionated AI-assisted coding workflow and the supporting tools.

## Opinionated Views

### On AI and AI-Assisted Coding

1. The agent harness largely shouldn’t matter. The process should work with all of them.
2. Most AI-assisted coding processes are too complex. They clutter the context window with unnecessary MCP tools, skills or content from AGENTS.md.
3. A small tightly defined and focused context window produces the best results.
4. LLMs do not reason, they do not think, they are not intelligent. They are simple text prediction engines. Treat them that way.
5. LLMs are non-deterministic. That does not matter as long as the process provides deterministic feedback: compiler warnings as errors, linting, testing, and verifyable acceptance criteria.
6. Don't get attached to the code. Be prepared to revert changes and retry with refinements to the context.
7. Fast feedback helps. Provide a way for an LLM to get feedback on its work.
8. Coding standards and conventions remain useful. LLMs have been trained on code that follows common ones and to copy examples in their context. When your code align with those patterns, you get better results.


### On Software Development

1. Work on small defined tasks.
2. Work with small batch sizes.
3. Do the simplest possible thing that meets the requirements.
4. Make small atomic commits.
5. Work iteratively.
6. Refactor when needed.
7. Integrate continuously.
8. Trust, but verify.
9. Leverage tools.
10. Don't get attached to the code.

## Repo Contents

- `skills/` - contains the skills I install in an agent.
- `tools/` - command line tools I use to setup a project.

## Philosophy 

1. It's all about the context! To get the best results from the coding agent, manage the context; start every task with a clear context, work on small tightly defined tasks, keeping a small, tight context. Stay out of the "dumb zone", i.e. keep the context window less than 50% full.
2. Provide examples. In use, LLMs cannot learn, they can follow patterns (which is sometimes referred to as in-context learning). Provide examples of the patterns you want them to follow.
3. Provide positive reinforcement, don't tell it off. Don't tell it what not to do. Every instruction or input you provide goes into the context. LLMs predict based on the context, if you provide examples of what not to do, it predicts based off those examples. As an illustration, consider the instruction: "don't think of an elephant", what do you think of? A better approach if we want someone to not think of an elephant is is to instruct them to: "think of a dog". 
4. When writing prompts be specific, clear and precise. Avoid unnecessary words or information that may distract from the specific task.


## Workflows

- [Greenfield Development](workflows/greenfield.md) - building new software, no legacy users to satisfy.
- Prototyping/Spike – Quick throwaway code to test feasibility
- Maintenance – Keeping existing systems running
- Refactoring – Restructuring without changing behaviour
- Performance Optimisation – Improving speed, memory usage, or efficiency
- Rewriting – Replacing old code with new
- Porting – Moving code to new platforms/languages
- Debugging – Tracing issues through existing code
- Bug Fixing – Diagnosing and solving defects 
- Testing – Writing unit tests, integration tests, or fixing test suites
- Code Review – Evaluating others' code for quality, bugs, and standards
- Documentation – Writing/updating technical docs, comments, READMEs
- Infrastructure – Managing deployment and infrastructure as code
- Legacy Code Comprehension – Understanding unfamiliar or old codebases
