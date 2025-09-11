#!/usr/bin/env bash
set -euo pipefail

# Project root (Quarto sets this)
PROJECT_ROOT="${QUARTO_PROJECT_DIR:-$(pwd)}"
DOCS_SLIDES="$PROJECT_ROOT/docs/slides"

# Gather outputs from Quarto if present; else scan docs/slides
declare -a htmls
if [[ -n "${QUARTO_PROJECT_OUTPUT_FILES:-}" ]]; then
  # Read newline-separated list safely
  while IFS= read -r line; do
    htmls+=("$line")
  done <<< "$QUARTO_PROJECT_OUTPUT_FILES"
else
  # Fallback for preview/incremental runs
  if [[ -d "$DOCS_SLIDES" ]]; then
    while IFS= read -r f; do htmls+=("$f"); done < <(find "$DOCS_SLIDES" -type f -name '*.html')
  else
    htmls=()
  fi
fi

# Convert only HTML under docs/slides/** (handle absolute or relative)
for f in "${htmls[@]}"; do
  # Normalize to absolute path
  if [[ "$f" != /* ]]; then
    f="$PROJECT_ROOT/$f"
  fi

  # Must be inside docs/slides and end with .html
  case "$f" in
    "$DOCS_SLIDES"/*.html|"$DOCS_SLIDES"/*/*.html|"$DOCS_SLIDES"/*/*/*.html)
      decktape "$f" "${f%.html}.pdf"
      echo "Decktape: wrote ${f%.html}.pdf"
      ;;
  esac
done

