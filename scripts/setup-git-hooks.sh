#!/bin/bash
# Script to set up git hooks without requiring Python/pre-commit
# Usage: ./scripts/setup-git-hooks.sh

set -euo pipefail

# Get the script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Change to project root
cd "$PROJECT_ROOT"

HOOKS_DIR=".git/hooks"
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository" >&2
    exit 1
fi

# Check if cargo is available
if ! command -v cargo &> /dev/null; then
    echo "Error: cargo not found in PATH. Please install Rust first." >&2
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Create pre-commit hook
cat > "$PRE_COMMIT_HOOK" << 'HOOK_EOF'
#!/bin/bash
# Pre-commit hook for Rust workspace
# Runs formatting, linting, tests, audit, and deny checks before commit

set -e

# Get the project root (parent of .git directory)
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
cd "$PROJECT_ROOT"

echo "Running pre-commit checks..."

# Format check
echo "  [1/5] Checking code formatting..."
if ! cargo fmt --all -- --check > /dev/null 2>&1; then
    echo "  ❌ Code is not formatted. Run 'cargo fmt --all' or 'just format' to fix."
    exit 1
fi
echo "  ✓ Formatting OK"

# Clippy lint
echo "  [2/5] Running clippy..."
if ! cargo clippy --all-targets --all-features --workspace -- -D warnings > /dev/null 2>&1; then
    echo "  ❌ Clippy found issues. Run 'cargo clippy' or 'just lint' to see details."
    exit 1
fi
echo "  ✓ Clippy OK"

# Run tests
echo "  [3/5] Running tests..."
if ! cargo test --workspace --all-features --quiet > /dev/null 2>&1; then
    echo "  ❌ Tests failed. Run 'cargo test' or 'just test' to see details."
    exit 1
fi
echo "  ✓ Tests OK"

# Security audit (only if cargo-audit is installed)
echo "  [4/5] Running security audit..."
if command -v cargo-audit &> /dev/null; then
    if ! cargo audit --deny warnings > /dev/null 2>&1; then
        echo "  ❌ Security audit found vulnerabilities. Run 'cargo audit' or 'just audit' to see details."
        exit 1
    fi
    echo "  ✓ Security audit OK"
else
    echo "  ⚠️  cargo-audit not installed. Run 'just setup-dev' to install it."
fi

# Cargo deny (only if cargo-deny is installed)
echo "  [5/5] Running cargo-deny..."
if command -v cargo-deny &> /dev/null; then
    if ! cargo deny check all > /dev/null 2>&1; then
        echo "  ❌ Cargo-deny found issues. Run 'cargo deny check all' or 'just deny' to see details."
        exit 1
    fi
    echo "  ✓ Cargo-deny OK"
else
    echo "  ⚠️  cargo-deny not installed. Run 'just setup-dev' to install it."
fi

echo ""
echo "All pre-commit checks passed! ✓"
HOOK_EOF

# Make the hook executable
chmod +x "$PRE_COMMIT_HOOK"

echo "Git hooks installed successfully!"
echo "The pre-commit hook will now run on every commit."
echo ""
echo "To skip hooks for a commit, use: git commit --no-verify"

