#!/bin/bash
# Ralph Loop - Autonomous AI agent loop
# Supports: claude, amp, copilot
# Usage: ./ralph-loop.sh [--agent AGENT] [--prompt PROMPT_FILE | --prompt-string "TEXT"] [--max-iterations N]

set -eo pipefail

# Defaults
AGENT="amp"
PROMPT_FILE=""
PROMPT_STRING=""
MAX_ITERATIONS=10

# Help function
show_help() {
  cat << EOF
Ralph Loop - Autonomous AI coding agent loop

Usage: ./ralph-loop.sh [options]

Options:
  --agent AGENT             AI agent to use: claude, amp, copilot (default: amp)
  --prompt PROMPT_FILE      Path to prompt file (one of --prompt or --prompt-string required)
  --prompt-string "TEXT"    Prompt as inline string (one of --prompt or --prompt-string required)
  --max-iterations N        Maximum iterations (default: 10)
  -h, --help               Show this help message

Agents:
  amp      AmpCode CLI — amp -x "prompt"
  claude   Claude Code CLI — claude -p "prompt"
  copilot  GitHub Copilot CLI — gh copilot suggest (limited agentic support)

Examples:
  ./ralph-loop.sh --prompt ./prompt.md
  ./ralph-loop.sh --prompt-string "Fix the failing tests in src/"
  ./ralph-loop.sh --agent claude --prompt ./spec.md --max-iterations 5
  ./ralph-loop.sh --agent amp --prompt-string "Refactor the auth module"
  ./ralph-loop.sh --agent copilot --prompt ./prompt.md
EOF
}

# Run the selected agent with a prompt string
run_agent() {
  local prompt="$1"
  case "$AGENT" in
    amp)
      amp -x "$prompt"
      ;;
    claude)
      claude -p "$prompt"
      ;;
    copilot)
      gh copilot suggest "$prompt"
      ;;
  esac
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --agent)
      AGENT="$2"
      shift 2
      ;;
    --prompt)
      PROMPT_FILE="$2"
      shift 2
      ;;
    --prompt-string)
      PROMPT_STRING="$2"
      shift 2
      ;;
    --max-iterations)
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
done

# Validate agent
case "$AGENT" in
  amp|claude|copilot) ;;
  *)
    echo "Error: --agent must be one of: amp, claude, copilot"
    exit 1
    ;;
esac

# Validate prompt input
if [ -n "$PROMPT_FILE" ] && [ -n "$PROMPT_STRING" ]; then
  echo "Error: --prompt and --prompt-string are mutually exclusive"
  exit 1
fi

if [ -z "$PROMPT_FILE" ] && [ -z "$PROMPT_STRING" ]; then
  echo "Error: one of --prompt or --prompt-string is required"
  show_help
  exit 1
fi

if [ -n "$PROMPT_FILE" ] && [ ! -f "$PROMPT_FILE" ]; then
  echo "Error: Prompt file not found: $PROMPT_FILE"
  exit 1
fi

# Resolve prompt content
if [ -n "$PROMPT_FILE" ]; then
  PROMPT_CONTENT="$(cat "$PROMPT_FILE")"
  PROMPT_DISPLAY="$PROMPT_FILE"
else
  PROMPT_CONTENT="$PROMPT_STRING"
  PROMPT_DISPLAY="(inline string)"
fi

if ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]] || [ "$MAX_ITERATIONS" -lt 1 ]; then
  echo "Error: --max-iterations must be a positive integer"
  exit 1
fi

# Warn about limited Copilot support
if [ "$AGENT" = "copilot" ]; then
  echo "⚠️  Note: GitHub Copilot CLI (gh copilot suggest) suggests shell commands"
  echo "          rather than autonomously editing code. The completion signal"
  echo "          <promise>COMPLETE</promise> may not be reliably emitted."
  echo "          Consider using 'claude' or 'amp' for full autonomous coding loops."
  echo ""
fi

# Setup logging
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_DIR=".ralph/logs"
LOG_FILE="$LOG_DIR/ralph-$TIMESTAMP.log"
mkdir -p "$LOG_DIR"

# Setup progress tracking
PROGRESS_FILE=".ralph/progress.md"
if [ ! -f "$PROGRESS_FILE" ]; then
  echo "# Ralph Progress Log" > "$PROGRESS_FILE"
  echo "Started: $(date)" >> "$PROGRESS_FILE"
  echo "Agent: $AGENT" >> "$PROGRESS_FILE"
  echo "---" >> "$PROGRESS_FILE"
fi

echo "🤖 Ralph Loop Starting"
echo "   Agent: $AGENT"
echo "   Prompt: $PROMPT_DISPLAY"
echo "   Max Iterations: $MAX_ITERATIONS"
echo "   Log: $LOG_FILE"
echo ""

for i in $(seq 1 $MAX_ITERATIONS); do
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Iteration $i / $MAX_ITERATIONS  [$AGENT]"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Run agent — stream output to both terminal and log
  ITER_LOG="$LOG_DIR/ralph-$TIMESTAMP-iter$i.log"
  echo "" | tee -a "$LOG_FILE"
  echo "## Iteration $i - $(date)" | tee -a "$LOG_FILE" >> "$PROGRESS_FILE"

  ITER_EXIT=0
  run_agent "$PROMPT_CONTENT" 2>&1 | tee -a "$ITER_LOG" "$LOG_FILE" || ITER_EXIT=${PIPESTATUS[0]}

  # Log iteration result
  {
    echo "Agent: $AGENT"
    echo "Exit code: $ITER_EXIT"
  } | tee -a "$LOG_FILE" >> "$PROGRESS_FILE"

  # Check for completion via exit code (0 = success)
  if [ "$ITER_EXIT" -eq 0 ]; then
    echo ""
    echo "✅ Ralph completed all tasks!"
    echo "   Completed at iteration $i of $MAX_ITERATIONS"
    echo ""
    echo "Completion time: $(date)" >> "$PROGRESS_FILE"
    exit 0
  fi

  echo ""
  echo "⏳ Iteration $i complete. Continuing to next iteration..."
  echo ""

  # Brief pause between iterations
  sleep 2
done

echo ""
echo "⚠️  Ralph reached max iterations ($MAX_ITERATIONS) without completion"
echo "   Check $PROGRESS_FILE for details"
echo "   Increase --max-iterations or review prompt: $PROMPT_DISPLAY"
exit 1
