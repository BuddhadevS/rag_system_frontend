#!/usr/bin/env sh
# Project-local Graphify wrapper.
# Usage: ./cmds/graphify.sh <command> [args...]

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT_DIR"

usage() {
  cat <<'USAGE'
Usage:
  ./cmds/graphify.sh status
  ./cmds/graphify.sh install
  ./cmds/graphify.sh extract [graphify extract args...]
  ./cmds/graphify.sh update [graphify update args...]
  ./cmds/graphify.sh query "question"
  ./cmds/graphify.sh explain "node or concept"
  ./cmds/graphify.sh path "A" "B"
  ./cmds/graphify.sh tree

Notes:
  - The scan is rooted at the repository and governed by .graphifyignore.
  - This wrapper is for headless terminal/CI extraction and may require a configured Graphify backend/API key.
  - In Claude/Codex/OpenCode/Cursor/Gemini assistant sessions, prefer `/graphify .` for assistant-driven extraction.
  - AST-only update is intended after code changes once graphify-out/graph.json exists.
USAGE
}

require_graphify() {
  if ! command -v graphify >/dev/null 2>&1; then
    echo "graphify is not installed. Install it with: pip install graphifyy"
    exit 1
  fi
}

status() {
  require_graphify
  graphify --version

  if [ -f "$ROOT_DIR/.graphifyignore" ]; then
    echo ".graphifyignore: present"
  else
    echo ".graphifyignore: missing"
  fi

  if [ -f "$ROOT_DIR/graphify-out/graph.json" ]; then
    echo "graphify-out/graph.json: present"
  else
    echo "graphify-out/graph.json: missing"
  fi

  if [ -f "$ROOT_DIR/AGENTS.md" ] && grep -q "## graphify" "$ROOT_DIR/AGENTS.md"; then
    echo "Codex/OpenCode AGENTS.md section: present"
  else
    echo "Codex/OpenCode AGENTS.md section: missing"
  fi

  if [ -f "$ROOT_DIR/CLAUDE.md" ] && grep -q "## graphify" "$ROOT_DIR/CLAUDE.md"; then
    echo "Claude CLAUDE.md section: present"
  else
    echo "Claude CLAUDE.md section: missing"
  fi

  if [ -f "$ROOT_DIR/GEMINI.md" ] && grep -q "## graphify" "$ROOT_DIR/GEMINI.md"; then
    echo "Gemini GEMINI.md section: present"
  else
    echo "Gemini GEMINI.md section: missing"
  fi

  if [ -f "$ROOT_DIR/.cursor/rules/graphify.mdc" ]; then
    echo "Cursor rule: present"
  else
    echo "Cursor rule: missing"
  fi

  if [ -f "$ROOT_DIR/.opencode/plugins/graphify.js" ] &&
     grep -q "graphify.js" "$ROOT_DIR/.opencode/opencode.json" 2>/dev/null; then
    echo "OpenCode plugin: present"
  else
    echo "OpenCode plugin: missing"
  fi

  if [ -f "$ROOT_DIR/.agents/skills/graphify/SKILL.md" ] &&
     [ -f "$ROOT_DIR/.claude/skills/graphify/SKILL.md" ] &&
     [ -f "$ROOT_DIR/.opencode/skills/graphify/SKILL.md" ]; then
    echo "Project Graphify skills: present"
  else
    echo "Project Graphify skills: missing"
  fi
}

install_platforms() {
  require_graphify
  graphify codex install
  graphify claude install
  graphify opencode install
  graphify cursor install
}

cmd="${1:-status}"
case "$cmd" in
  -h|--help|help)
    usage
    ;;
  status)
    status
    ;;
  install)
    install_platforms
    ;;
  extract)
    shift
    require_graphify
    graphify extract "$ROOT_DIR" --out "$ROOT_DIR" "$@"
    ;;
  update)
    shift
    require_graphify
    graphify update "$ROOT_DIR" "$@"
    ;;
  query)
    shift
    require_graphify
    graphify query "$@"
    ;;
  explain)
    shift
    require_graphify
    graphify explain "$@"
    ;;
  path)
    shift
    require_graphify
    graphify path "$@"
    ;;
  tree)
    shift
    require_graphify
    graphify tree --root "$ROOT_DIR" --label "JV_social_media_microservices_API" "$@"
    ;;
  *)
    usage
    exit 1
    ;;
esac
