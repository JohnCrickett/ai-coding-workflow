# Ralph Loop Quick Reference

## Basic Usage

```bash
./ralph-loop.sh [--agent AGENT] --prompt /path/to/prompt.md [--max-iterations N]
```

## Arguments

| Argument | Required | Default | Example |
|----------|----------|---------|---------|
| `--agent AGENT` | No | `amp` | `--agent claude` |
| `--prompt PATH` | Yes | — | `--prompt ./spec.md` |
| `--max-iterations N` | No | 10 | `--max-iterations 20` |
| `-h, --help` | No | — | Show help |

## Agents

| Agent | CLI used | Agentic? |
|-------|----------|----------|
| `amp` | `amp --dangerously-allow-all` | Full |
| `claude` | `claude --dangerously-allow-all -p` | Full |
| `copilot` | `gh copilot suggest` | Limited |

## Examples

```bash
# Default agent (amp), 10 iterations
./ralph-loop.sh --prompt ./requirements.md

# Claude Code
./ralph-loop.sh --agent claude --prompt ./spec.md --max-iterations 5

# Amp with custom iterations
./ralph-loop.sh --agent amp --prompt ./spec.md --max-iterations 20

# GitHub Copilot (limited — suggests commands, not a coding agent)
./ralph-loop.sh --agent copilot --prompt ./prompt.md

# Show help
./ralph-loop.sh --help
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | ✅ Completed (found `<promise>COMPLETE</promise>`) |
| 1 | ❌ Max iterations reached or validation error |

## Output Files

- **`.ralph/logs/ralph-{timestamp}.log`** — Full iteration output
- **`.ralph/progress.md`** — Progress summary file

## Completion Signal

Your prompt must tell the agent to output this when done:

```
<promise>COMPLETE</promise>
```

## Monitoring

```bash
# Watch logs in real-time
tail -f .ralph/logs/ralph-*.log

# Check progress
cat .ralph/progress.md

# Check git history
git log --oneline -20
```

## Prompt Tips

1. **Keep it focused** — One task per loop iteration
2. **Include verification** — Tell the agent how to test
3. **Define completion** — What signals success?
4. **Use acceptance criteria** — Clear requirements

```markdown
## Task: Implement Feature X

### Acceptance Criteria
- [ ] Feature works
- [ ] Tests pass: `npm test`
- [ ] No lint errors: `npm run lint`

When complete, output: <promise>COMPLETE</promise>
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Loop never completes | Make task smaller, clearer completion criteria |
| Copilot loop never completes | Switch to `--agent claude` or `--agent amp` |
| Max iterations reached | Increase `--max-iterations` or simplify task |
| Prompt file not found | Check path is correct and file exists |
| Invalid iteration count | Must be a positive integer |

## Files

- **`ralph-loop.sh`** — Main executable
- **`RALPH-LOOP.md`** — Full documentation
- **`QUICKSTART.md`** — This file
- **`example-prompt.md`** — Example prompt template

---

For detailed info: See [RALPH-LOOP.md](./RALPH-LOOP.md)
