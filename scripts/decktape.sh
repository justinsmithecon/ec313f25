#!/usr/bin/env bash
set -euo pipefail

# Project root (Quarto sets this)
PROJECT_ROOT="${QUARTO_PROJECT_DIR:-$(pwd)}"
DOCS_SLIDES="$PROJECT_ROOT/docs/slides"
DOCS_QUESTIONS="$PROJECT_ROOT/docs/questions"

# Gather outputs from Quarto if present; else scan docs/slides and docs/questions
declare -a htmls
if [[ -n "${QUARTO_PROJECT_OUTPUT_FILES:-}" ]]; then
  # Read newline-separated list safely
  while IFS= read -r line; do
    htmls+=("$line")
  done <<< "$QUARTO_PROJECT_OUTPUT_FILES"
else
  # Fallback for preview/incremental runs
  for dir in "$DOCS_SLIDES" "$DOCS_QUESTIONS"; do
    if [[ -d "$dir" ]]; then
      while IFS= read -r f; do htmls+=("$f"); done < <(find "$dir" -type f -name '*.html')
    fi
  done
fi

# Convert only HTML under docs/slides/** or docs/questions/** (handle absolute or relative)
for f in "${htmls[@]}"; do
  # Normalize to absolute path
  if [[ "$f" != /* ]]; then
    f="$PROJECT_ROOT/$f"
  fi

  case "$f" in
    "$DOCS_SLIDES"/*.html|"$DOCS_SLIDES"/*/*.html|"$DOCS_SLIDES"/*/*/*.html|\
    "$DOCS_QUESTIONS"/*.html|"$DOCS_QUESTIONS"/*/*.html|"$DOCS_QUESTIONS"/*/*/*.html)
      decktape "$f" "${f%.html}.pdf"
      echo "Decktape: wrote ${f%.html}.pdf"
      ;;
  esac
done

