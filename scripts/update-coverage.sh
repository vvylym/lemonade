#!/bin/bash
# Script to update coverage percentage in README.md
# Usage: ./scripts/update-coverage.sh <coverage-percentage>
# Example: ./scripts/update-coverage.sh 85.5

set -euo pipefail

COVERAGE="${1:-0.00}"
README_PATH="README.md"

# Validate coverage is a number
if ! [[ "$COVERAGE" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    echo "Error: Coverage must be a number (got: $COVERAGE)" >&2
    exit 1
fi

# Format coverage with 2 decimal places
COVERAGE_FORMATTED=$(printf "%.2f" "$COVERAGE")

# Check if README exists
if [ ! -f "$README_PATH" ]; then
    echo "Error: README.md not found at $README_PATH" >&2
    exit 1
fi

# Determine badge color based on coverage
COVERAGE_INT=$(echo "$COVERAGE_FORMATTED" | cut -d. -f1)
if [ "$COVERAGE_INT" -ge 80 ]; then
    BADGE_COLOR="brightgreen"
elif [ "$COVERAGE_INT" -ge 60 ]; then
    BADGE_COLOR="yellow"
elif [ "$COVERAGE_INT" -ge 40 ]; then
    BADGE_COLOR="orange"
else
    BADGE_COLOR="red"
fi

# Create coverage badge URL
BADGE_URL="https://img.shields.io/badge/coverage-${COVERAGE_FORMATTED}%25-${BADGE_COLOR}"

# Create temporary file with updated content
TEMP_FILE=$(mktemp)
trap "rm -f $TEMP_FILE" EXIT

# Update the coverage badge at the top of the README (in the badge line)
# The badge should be on a line that contains "coverage" and "img.shields.io"
awk -v badge="$BADGE_URL" -v coverage="$COVERAGE_FORMATTED" -v badge_color="$BADGE_COLOR" '
    /!\[Coverage\]|coverage.*img\.shields\.io|badge.*coverage/ {
        # Replace the coverage badge URL
        gsub(/coverage-[0-9]+\.[0-9]+%25-[a-z]+/, "coverage-" coverage "%25-" badge_color, $0)
        gsub(/!\[Coverage\]\([^)]+\)/, "![Coverage](" badge ")", $0)
        print
        next
    }
    { print }
' "$README_PATH" > "$TEMP_FILE"

# Replace original file
mv "$TEMP_FILE" "$README_PATH"

echo "Updated README.md with coverage: ${COVERAGE_FORMATTED}%"
