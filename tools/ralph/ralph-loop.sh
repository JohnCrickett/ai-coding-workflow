#!/bin/bash
# Ralph Loop - Autonomous AI agent loop
# Supports: claude, amp, copilot
# Usage: ./ralph-loop.sh [--agent AGENT] [--prompt PROMPT_FILE] [--max-iterations N]

set -e

# Defaults
AGENT="amp"
PROMPT_FILE=""
MAX_ITERATIONS=10

# Help function
show_help() {
  cat << EOF
Ralph Loop - Autonomous AI coding agent loop

Usage: ./ralph-loop.sh [options]

Options:
  --agent AGENT             AI agent to use: claude, amp, copilot (default: amp)
  --prompt PROMPT_FILE      Path to prompt file (required)
  --max-iterations N        Maximum iterations (default: 10)
  -h, --help               Show this help message

Agents:
  amp      AmpCode CLI — cat prompt | amp --dangerously-allow-all
  claude   Claude Code CLI — claude --dangerously-allow-all -p "prompt"
  copilot  GitHub Copilot CLI — gh copilot suggest (limited agentic support)

Examples:
  ./ralph-loop.sh --prompt ./prompt.md
  ./ralph-loop.sh --agent claude --prompt ./spec.md --max-iterations 5
  ./ralph-loop.sh --agent amp --prompt /path/to/spec.md
  ./ralph-loop.sh --agent copilot --prompt ./prompt.md
EOF
}

# Run the selected agent with the prompt file
run_agent() {
  local prompt_file="$1"
  case "$AGENT" in
    amp)
      cat "$prompt_file" | amp --dangerously-allow-all
      ;;
    claude)
      claude --dangerously-allow-all -p "$(cat "$prompt_file")"
      ;;
    copilot)
      gh copilot suggest "$(cat "$prompt_file")"
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

# Validate prompt file
if [ -z "$PROMPT_FILE" ]; then
  echo "Error: --prompt is required"
  show_help
  exit 1
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "Error: Prompt file not found: $PROMPT_FILE"
  exit 1
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
echo "   Prompt: $PROMPT_FILE"
echo "   Max Iterations: $MAX_ITERATIONS"
echo "   Log: $LOG_FILE"
echo ""

for i in $(seq 1 $MAX_ITERATIONS); do
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Iteration $i / $MAX_ITERATIONS  [$AGENT]"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Run agent with the prompt
  OUTPUT=$(run_agent "$PROMPT_FILE" 2>&1 | tee -a "$LOG_FILE") || true

  # Log iteration
  {
    echo ""
    echo "## Iteration $i - $(date)"
    echo "Status: $(if echo "$OUTPUT" | grep -q '<promise>COMPLETE</promise>' 2>/dev/null; then echo "COMPLETE"; else echo "CONTINUE"; fi)"
  } >> "$PROGRESS_FILE"

  # Check for completion signal
  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>" 2>/dev/null; then
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
echo "   Increase --max-iterations or review prompt at: $PROMPT_FILE"
exit 1
