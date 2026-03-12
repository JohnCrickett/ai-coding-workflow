## Quick Start

1. Initialize your project:
   ```bash
   cd your-project
   /path/to/tools/init.sh
   ```

2. Edit the generated files:
   - `AGENTS.md` - Project commands and guidelines
   - `spec/project.md` - High-level requirements

3. Create a specification (replace amp with your agent):
   ```bash
   amp < spec/project.md
   # Use Amp to help refine requirements into spec/requirements.md
   ```

4. Create a plan:
   ```bash
   amp < spec/requirements.md
   # Use Amp to create plan/plan.md with tasks
   ```

5. Run Ralph Loop:
   ```bash
   /path/to/tools/ralph-loop.sh --prompt spec/requirements.md
   ```

## Philosophy

These tools implement an opinionated AI-assisted coding workflow:

1. **Small, focused context** - Each tool does one thing well
2. **Deterministic feedback** - Tests, linting, and compile checks guide the AI
3. **Iterative refinement** - Humans guide, AI executes, feedback improves
4. **Fresh context per iteration** - Prevents context rot in long-running tasks
5. **Spec-driven** - The specification is the source of truth, not conversation history

## File Structure Reference

```
project/
├── AGENTS.md                    # Build/test commands, project conventions
├── spec/
│   ├── project.md             # High-level overview and objectives
│   ├── requirements.md        # Detailed requirements (EARS format)
│   └── [task-name].md         # Specs for individual tasks
├── plan/
│   ├── plan.md               # Overall implementation plan
│   └── [task-name]-plan.md   # Detailed task plans
├── design/
│   └── [feature-name].md     # Design documents
└── memory/
    └── learned.md            # Patterns, gotchas, conventions discovered
```
