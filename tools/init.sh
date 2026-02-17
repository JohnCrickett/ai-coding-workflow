#!/bin/bash
echo "Project Setup"

# Create directories
mkdir -p design
mkdir -p memory
mkdir -p plan
mkdir -p spec

write_project_spec () {
cat > spec/project.md << 'EOL'
# Project Spec: {PROJECT TITLE}

## Objective
- {OBJECTIVE}

## Tech Stack
- {TECH STACK}
EOL
}

write_agentmd () {
cat > AGENTS.md << 'EOL'
## Commands
- Build: `{BUILD COMMAND}` ({BUILD COMMAND DETAILS})
- Test: `{TEST COMMAND}` (runs the tests. Tests must pass before a task is consider complete)
- Lint: `{LINT COMMAND}` (check for possible issues)
- {OTHER COMMANDS AS REQUIRED}

## Project Structure
- `{FOLDER}` –{DETAILS}
- `{FOLDER}` –{DETAILS}
- `{FOLDER}` –{DETAILS}

## Process
 - Always write tests before implemeting functionality.
 - Always ask before adding dependencies.
 - Always ask before modifying existing tests.
 - Never change a test to make it pass.
EOL
}

# Create template project spec
write_project_spec

# Create template Agent.md
write_agentmd
