# Workflow For Greenfield Development

My workflow relies on leveraging the coding agent for multiple steps in the software development lifecycle. I expect that a software engineer will guide the coding agent through the process of building software. 

That means everything from creating a high level project specification through the development and review of more detailed requirements, the creation of a design and a breakdown of the tasks required to implement the design and deliver software to meet the requirements.

### Setting Up The Project

My workflow assumes some structure exists in the project:

```text
project/
├── AGENTS.md
├── design/
├── memory/
├── plan/
└── spec/
    └── project.md
```

These are used as follows:

- `AGENTS.md` - This is the agents file, built on the [AGENTS.md](https://agents.md/) specification, it should contain the least amount of detail to required to guide the agent through the project. Covering: Commands, Project Structure, and Process.
- `design` - Any design documents created will be stored here.
- `memory` - A record of what has been learned during the development of the project. It provides a basic "memory" for the LLM between context windows.
- `plan` - Any plans created will be stored here.
- `spec` - Any specifications and requirements created will be stored here. The starting point for a project is a `project.md` that should provide the high level overview of the project and requirements.

All of these can be generated using `tools/init.sh`, which will create this structure in the current working directory. 

### Specifications

#### Creating The High Level Specification
After creating the `AGENTS.md` and `spec/project.md` with the tools, they should be edited. All sections in curly braces (i.e.: {PROJECT TITLE}) should be replaced with the relevant details.

For example, for a Rust project the `AGENTS.md` would go from the template to:

```text
## Commands
- Build: `cargo build` (compiles Rust, outputs to target/)
- Test: `cargo test` (runs the tests, must pass before a task is consider complete)
- Lint: `cargo clippy` (check for possible issues)

## Project Structure
- `src/` – Application source code

## Process
 - Always write tests before implemeting functionality.
 - Always ask before adding dependencies.
 - Always ask before modifying existing tests.
 - Never change a test to make it pass.
```

Update the process to reflect your own development processes.

The `spec/project.md` should be similarly updated. Again all sections in curly braces (i.e.: {PROJECT TITLE}) should be replaced with the relevant details.

For example for a simple Redis Like Server it might become:

```text
# Project Spec: Redis Like Server

## Objective
- Build a Redis like server in Rust. It should support multiple concurrent clients, connected via TCP using the RESP2 protocol. The server should support the commands: SET, GET, EXISTS, DEL.

## Tech Stack
- Rust 2024 edition
```

#### Creating Detailed Requirements

Having created the high level detail, use the agent to create a requirements document. I do this using the prompt: 
```text
Read specs/project.md and ask me questions to help refine a set of requirements for this project.

Use the The Easy Approach to Requirements Syntax for the requirements, write them to ./specs/requirements.md

The Easy Approach to Requirements Syntax (EARS) is a mechanism to gently constrain textual requirements. The EARS patterns provide structured guidance that enable authors to write high quality textual requirements.

Generic EARS syntax: 

The clauses of a requirement written in EARS always appear in the same order. The basic structure of an EARS requirement is:

While <optional pre-condition>, when <optional trigger>, the <system name> shall <system response>

The EARS ruleset states that a requirement must have: Zero or many preconditions; Zero or one trigger; One system name; One or many system responses.
```

I then answer the questions the agent asks, and when it produces it, review the resulting `spec/requirements.md`.

If it's relatively close I might edit it myself, if it's far off then I clear the agent's context window, refine the `psec/project.md` and repeat the process to get another `spec/requirements.md`, until I am satisfied that it reflects my current understanding of the project.

### Planning

Ask the agent to review the requirements and create a plan alongside a set of requirements for each step.

```text
Review the updated set of requirements and create a plan that details the tasks needed to implement the requirements.

Output the plan to plans/plan.md add one line per task. Create one specification file per task in the specs folder.

Example plan file:

# Implementation Plan

| Task | Description | Spec | Requirements |
|------|-------------|------|--------------|
| [ ] 01 | Setup project | [task-01-project-setup.md](../specs/task-01-project-setup.md) | REQ-03 |
| [ ] 02 | Create Table | [task-02-create-tables.md](../specs/task-02-create-tables.md) | REQ-02, REQ-11 |
```

We're done with planning, so clear the context and switch to building.

### Building

Prompt the agent to build the first (or next) item:

```text
Read specs/prd.md for an overview of the project.
Read plans/plan.md, pick the next most important task and read the relevant specification from the specs directory.
If it exists, read memory/learnings.md.

After reading the specification create a set of tests to verify the implementation behaves correctly. Then create the code required to meet the specification. Very the functionality is correct using the tests.

Before marking the task as done in plans/plan.md ensure the code lints without issue.

If you learn anything that will be needed for future tasks, record it in memory/learnings.md.

Stop after completing one task.
```

Once the agent claims the task is complete, test it.

If it does not work provide errors and detailed feedback to the agent. Until it does

When it works, commit the changes. Clear the context and then repeat the build step, until the full plan is implemented.


### Code Review and Fix

Ask the agent to code review the project.

```text
Review the code in this project. Look for possible logic errors and failures to write idiomatic code.

## Instructions
1. Read all the code in the repository.
2. Run the tests against the code and ensure they pass.
3. Run the appropriate linter and formatter for the programming language.
4. Check the code against best practices for the programming language of the file.
5. Check the code is clear, easy to read and simple.
6. Check the code is consistent with the majority of the code in the project.
7. Suggest any refactoring opportunities.

Report any issues in a file codereview.md
```

Ask the agent to create a plan to address the issues:
```text
Create a plan to fix these issues, save it to plans/fix-codereview.md detail the fixes required in specs/coderevew-{ITEM}.md replaceing {ITEM} with a name for the item that relates to the step in the plan
```

Once a plan has been created, prompt the agent to fix the next item:
```text
Read specs/prd.md for an overview of the project.
Read plans/fix-codereview.md, pick the next most important task and read the relevant specification from the specs directory.
If it exists, read memory/learnings.md.

After reading the specification create any new tests required to verify the implementation behaves correctly. Then create the code required to meet the specification. Very the functionality is correct using the tests.

Before marking the task as done in plans/fix-codereview.md ensure the code lints without issue.

If you learn anything that will be needed for future tasks, record it in memory/learnings.md.
```

## Notes

If during the workflow you notice requirements are missing, have the agent update the requirements and plan. Then review it. Clear the context before returning to building.
