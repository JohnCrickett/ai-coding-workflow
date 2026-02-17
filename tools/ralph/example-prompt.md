# Ralph Loop Example Prompt

This is an example Ralph Loop prompt that demonstrates the structure and format.

## Task: Simple Feature Implementation

### Goal
Implement a new feature in the codebase that extends functionality and improves the user experience.

### Context
- Project structure: See AGENTS.md
- Technology stack: Varies by project
- Current state: Review recent git history for context
- Constraints: Follow existing code patterns and conventions

### Requirements
You are to implement ONE task from the remaining items in `./plan/plan.md` that has status `pending`.

The task must:
1. Have all acceptance criteria met
2. Pass all tests: See AGENTS.md for test command
3. Have no linting errors: See AGENTS.md for lint command
4. Be committed with a descriptive message
5. Update `./memory/learned.md` with any patterns discovered

### Implementation Steps

1. **Understand the task**
   - Read the task specification from `./plan/plan.md`
   - Identify the specific requirements
   - Understand acceptance criteria

2. **Plan the implementation**
   - Determine which files need changes
   - Identify any new dependencies required
   - Outline the code structure

3. **Implement**
   - Write the code
   - Follow existing patterns in the codebase
   - Write tests alongside implementation

4. **Verify**
   - Run tests
   - Run linter

5. **Commit**
   ```bash
   git add .
   git commit -m "feat: [task name] - [brief description]"
   ```

6. **Update tracking**
   - Mark task as complete in `./plan/plan.md`
   - Document learnings in `./memory/learned.md`

### Acceptance Criteria
- [x] One task from plan is fully implemented
- [x] All tests pass
- [x] No build errors
- [x] No lint errors
- [x] Changes are committed
- [x] Task marked as complete in plan
- [x] Learnings documented

### When Complete

Output this signal when the task is fully complete and verified:

```
<promise>COMPLETE</promise>
```

Do NOT output this signal if:
- Tests are failing
- Lint has errors
- Implementation is incomplete
- Changes are not committed
