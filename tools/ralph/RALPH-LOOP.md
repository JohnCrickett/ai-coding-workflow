# Ralph Loop

An autonomous AI agent loop that repeatedly invokes a coding agent until all tasks are complete. Each iteration runs with fresh context, using a specification document as the source of truth.

Supports **Claude Code**, **Amp**, and **GitHub Copilot** (limited).

## What is Ralph Loop?

Ralph Loop is inspired by [Geoffrey Huntley's Ralph pattern](https://ghuntley.com/ralph/). It's an orchestration mechanism where:

- A **specification/prompt** defines the work to be done
- The loop **spawns fresh agent instances** (clean context each time)
- **Progress persists** via git commits, logs, and status files
- The loop exits when a completion signal (`<promise>COMPLETE</promise>`) is detected
- Or exits after reaching the max iteration count

## Installation

The script is in `tools/ralph/ralph-loop.sh`.

```bash
chmod +x tools/ralph/ralph-loop.sh
```

## Usage

### Basic Usage

```bash
./tools/ralph/ralph-loop.sh --prompt /path/to/prompt.md
```

### Arguments

| Argument | Required | Default | Description |
|----------|----------|---------|-------------|
| `--agent AGENT` | No | `amp` | Agent to use: `claude`, `amp`, `copilot` |
| `--prompt FILE` | Yes | — | Path to the prompt/spec file |
| `--max-iterations N` | No | `10` | Max loop iterations before stopping |
| `-h, --help` | No | — | Show help message |

### Agents

| Agent | CLI invocation | Agentic? |
|-------|----------------|----------|
| `amp` | `amp --dangerously-allow-all` | Full |
| `claude` | `claude --dangerously-allow-all -p "..."` | Full |
| `copilot` | `gh copilot suggest "..."` | Limited — suggests commands only |

### Examples

```bash
# Default: Amp, 10 iterations
./ralph-loop.sh --prompt ./spec.md

# Claude Code, 5 iterations
./ralph-loop.sh --agent claude --prompt ./spec.md --max-iterations 5

# Amp, custom iterations
./ralph-loop.sh --agent amp --prompt ./prompt.md --max-iterations 20

# GitHub Copilot (limited agentic support)
./ralph-loop.sh --agent copilot --prompt ./prompt.md

# Show help
./ralph-loop.sh --help
```

## How It Works

1. **Reads the prompt file** and validates it exists
2. **Iteration loop** — For each iteration:
   - Invokes the selected agent with the prompt
   - Logs output to `.ralph/logs/ralph-{timestamp}.log`
   - Checks for the completion signal `<promise>COMPLETE</promise>`
   - If found: exits successfully (code 0)
   - If not found: continues to next iteration
3. **Progress tracking** — Updates `.ralph/progress.md`
4. **Exit codes:**
   - `0` — All tasks completed
   - `1` — Max iterations reached without completion, or validation error

## Agent Details

### Claude Code (`claude`)

Invoked in non-interactive print mode:

```
claude --dangerously-allow-all -p "$(cat prompt.md)"
```

- Full autonomous coding agent
- Executes file edits, runs tests, commits — all from the prompt
- Requires [Claude Code](https://claude.ai/code) to be installed

### Amp (`amp`)

Invoked via stdin:

```
cat prompt.md | amp --dangerously-allow-all
```

- Full autonomous coding agent
- Requires [AmpCode](https://ampcode.com) to be installed

### GitHub Copilot (`copilot`)

Invoked via `gh copilot suggest`:

```
gh copilot suggest "$(cat prompt.md)"
```

- **Limited**: suggests a single shell command based on the prompt; does not autonomously edit code or follow multi-step instructions
- The completion signal `<promise>COMPLETE</promise>` will not be reliably emitted
- Use `claude` or `amp` for full autonomous coding loops
- Requires the [GitHub CLI](https://cli.github.com) with the `gh copilot` extension

## Output Files

- `.ralph/logs/ralph-{timestamp}.log` — Full iteration logs
- `.ralph/progress.md` — Progress summary

## Completion Signals

Your prompt should instruct the agent to output `<promise>COMPLETE</promise>` when done:

```markdown
When all tasks are complete and verified, output:
<promise>COMPLETE</promise>
```

## Best Practices

### 1. Right-size your spec

Each iteration should fit within a single context window. If a task is too large, split it:

```
❌ Too big: "Build the entire authentication system"
✅ Right-sized: "Add password reset email endpoint with tests"
```

### 2. Include verification steps

Your prompt should tell the agent how to verify work:

```markdown
After each change:
- Run `npm test` to verify tests pass
- Run `npm run lint` to catch style issues
- Commit changes with a descriptive message
```

### 3. Update AGENTS.md between iterations

Between iterations, human review can update AGENTS.md with learnings:

```
Patterns discovered
Gotchas and edge cases
Project conventions discovered
Useful file locations
```

This guides future iterations.

### 4. Structure your prompt

A good Ralph Loop prompt includes:

1. **Goal** — What needs to be done
2. **Context** — Project overview, tech stack
3. **Scope** — What's in/out of scope
4. **Acceptance criteria** — How to verify it's done
5. **Completion signal** — Output `<promise>COMPLETE</promise>` when done

Example structure:

```markdown
# Task: Add User Pagination

## Goal
Add pagination to the user list endpoint

## Context
- API: Node.js/Express
- Database: PostgreSQL
- Frontend: React

## Acceptance Criteria
- [ ] Endpoint accepts `page` and `limit` query params
- [ ] Returns paginated results with total count
- [ ] Tests pass: `npm test`
- [ ] No lint errors: `npm run lint`

## What to do
1. Update the `/users` endpoint to support pagination
2. Write tests
3. Verify all checks pass

When complete, output: <promise>COMPLETE</promise>
```

### 5. Handle context limits

If an agent hits context limits mid-iteration, manually resume:

```bash
# Resume with updated progress in prompt
./ralph-loop.sh --agent claude --prompt ./spec/updated.md --max-iterations 10
```

## Troubleshooting

### Script hangs or takes too long

- **Problem**: Prompt is too large or iteration is too complex
- **Solution**: Break the task into smaller pieces

### Loop never completes

- **Problem**: Prompt doesn't clearly state completion conditions, or agent doesn't emit the signal
- **Solution**: Update prompt with clear acceptance criteria and completion signal

### Copilot loop never completes

- **Problem**: `gh copilot suggest` doesn't follow multi-step instructions or emit the completion signal
- **Solution**: Switch to `--agent claude` or `--agent amp`

### Git conflicts after iterations

- **Problem**: Multiple iterations are modifying the same files
- **Solution**: Structure commits carefully or manually resolve conflicts between iterations

## Advanced: Monitoring Iterations

While the loop runs, monitor progress:

```bash
# In another terminal
tail -f .ralph/logs/ralph-*.log
cat .ralph/progress.md
```

Or check git history:

```bash
git log --oneline | head -20
```

## Integration with CI/CD

```yaml
# GitHub Actions example
- name: Run Ralph Loop
  run: |
    ./tools/ralph/ralph-loop.sh \
      --agent claude \
      --prompt ./spec/feature.md \
      --max-iterations 20
```

## Further Reading

- [Geoffrey Huntley's Ralph Pattern](https://ghuntley.com/ralph/)
- [Ralph - Autonomous AI Agent Loop](https://github.com/snarktank/ralph)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Amp Documentation](https://ampcode.com/manual)
