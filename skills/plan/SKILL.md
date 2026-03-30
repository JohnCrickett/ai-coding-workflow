---
name: plan
description: Create a plan to implement the provided requirements.
---

# Plan Generation

## Instructions
1. Review the updated set of requirements and create a plan that details the tasks needed to implement the requirements.

Output the plan to plans/plan.md add one line per task. Create one specification file per task in the specs folder.

Example plan file:

```markdown
# Implementation Plan

| Task | Description | Spec | Requirements |
|------|-------------|------|--------------|
| [ ] 01 | Setup project | [task-01-project-setup.md](../specs/task-01-project-setup.md) | REQ-03 |
| [ ] 02 | Create Table | [task-02-create-tables.md](../specs/task-02-create-tables.md) | REQ-02, REQ-11 |


## Dependency Order

01 → 02 → 03 → 04 → 05 → 06 → 07 → 08 → 09 → 10 → 11 → 12 → 13
         └──────────┴────┴────┴────┴────┘
                 (commands can be parallel)

```

## Examples
Generate a plan to build this project.
Read the requirements and plan the tasks for this project.
Plan this project.
