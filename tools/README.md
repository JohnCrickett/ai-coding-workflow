# AI Assisted Coding Tools

Command-line tools for AI-assisted development workflows.

## Tools

### init.sh

Initialize a new project with the standard structure for AI-assisted development.

```bash
./init.sh
```

Creates:
```
project/
├── AGENTS.md          # Agent guidance
├── spec/
│   └── project.md     # High-level specification
├── plan/
│   └── plan.md        # Implementation plan
├── design/            # Design documents
└── memory/            # Learnings and context
    └── learned.md
```

### ralph/ralph-loop.sh

An autonomous AI agent loop for continuous development. Spawns fresh agent instances to work through a specification until completion.

```bash
./ralph/ralph-loop.sh [--agent AGENT] --prompt /path/to/prompt.md [--max-iterations N]
```

**Arguments:**

| Argument | Required | Default | Description |
|----------|----------|---------|-------------|
| `--agent AGENT` | No | `amp` | Agent to use: `claude`, `amp`, `copilot` |
| `--prompt FILE` | Yes | — | Path to the prompt/spec file |
| `--max-iterations N` | No | `10` | Max iterations before stopping |
| `-h, --help` | No | — | Show help |

**Examples:**

```bash
# Default agent (amp), 10 iterations
./ralph/ralph-loop.sh --prompt ./spec.md

# Claude Code, 5 iterations
./ralph/ralph-loop.sh --agent claude --prompt ./spec.md --max-iterations 5

# Amp with custom iterations
./ralph/ralph-loop.sh --agent amp --prompt ./spec.md --max-iterations 20
```

The loop exits when the agent outputs `<promise>COMPLETE</promise>`, or when max iterations is reached.

**See**: [ralph/RALPH-LOOP.md](./ralph/RALPH-LOOP.md) | [ralph/QUICKSTART.md](./ralph/QUICKSTART.md)
