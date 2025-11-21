# Justfile for lemonade workspace
# Install just: cargo install just
# Run commands: just <command>

# Show available commands
default:
    just --list

# ============================================================================
# Workspace-wide commands
# ============================================================================

# Format all code
format:
    cargo fmt --all

# Check formatting without modifying files
format-check:
    cargo fmt --all -- --check

# Run clippy linter on all crates
lint:
    cargo clippy --all-targets --all-features --workspace -- -D warnings

# Run tests for the entire workspace
test:
    cargo test --workspace --all-features

# Run tests with output
test-verbose:
    cargo test --workspace --all-features -- --nocapture

# Run all checks: format, lint, and test
check: format-check lint test

# Build all crates
build:
    cargo build --workspace --all-features

# Clean build artifacts
clean:
    cargo clean

# Clean and rebuild
rebuild: clean
    cargo build --workspace --all-features

# Full CI pipeline: format, lint, test, coverage, audit, and deny
ci: format lint test coverage audit deny

# ============================================================================
# Coverage commands
# ============================================================================

# Install cargo-llvm-cov if not already installed
install-coverage:
    cargo install cargo-llvm-cov --locked

# Install cargo-audit for security checks
install-audit:
    cargo install cargo-audit --locked

# Install cargo-deny for license and dependency checks
install-deny:
    cargo install cargo-deny --locked

# Generate coverage report for entire workspace
coverage:
    cargo llvm-cov --workspace --all-features --lcov --output-path lcov.info
    cargo llvm-cov --workspace --all-features --summary-only

# Generate HTML coverage report for entire workspace
coverage-html:
    cargo llvm-cov --workspace --all-features --html --output-dir coverage-html
    @echo "Coverage report generated in coverage-html/index.html"

# Update coverage in README
# Usage: just update-coverage <coverage-percentage>
# Example: just update-coverage 85.5
update-coverage coverage:
    ./scripts/update-coverage.sh {{coverage}}

# Incremental coverage - only coverage for changed crates (requires git)
coverage-incremental:
    echo "Detecting changed crates..."
    cargo llvm-cov --workspace --all-features --summary-only

# Run security audit
audit:
    cargo audit --deny warnings

# Run cargo-deny checks (license, duplicate, banned dependencies)
deny:
    cargo deny check all

# ============================================================================
# Load Balancer commands (lb-<framework>)
# ============================================================================

# Load Balancer - Actix
# Build Actix load balancer
lb-actix-build:
    cargo build -p lemonade-actix --all-features

# Test Actix load balancer
lb-actix-test:
    cargo test -p lemonade-actix --all-features

# Run Actix load balancer
lb-actix-run:
    cargo run -p lemonade-actix --all-features

# Check Actix load balancer (format, lint, test)
lb-actix-check:
    cargo fmt -p lemonade-actix -- --check
    cargo clippy -p lemonade-actix --all-targets --all-features -- -D warnings
    cargo test -p lemonade-actix --all-features

# Generate coverage for Actix load balancer
lb-actix-coverage:
    cargo llvm-cov -p lemonade-actix --all-features --summary-only

# Load Balancer - Axum
# Build Axum load balancer
lb-axum-build:
    cargo build -p lemonade-axum --all-features

# Test Axum load balancer
lb-axum-test:
    cargo test -p lemonade-axum --all-features

# Run Axum load balancer
lb-axum-run:
    cargo run -p lemonade-axum --all-features

# Check Axum load balancer (format, lint, test)
lb-axum-check:
    cargo fmt -p lemonade-axum -- --check
    cargo clippy -p lemonade-axum --all-targets --all-features -- -D warnings
    cargo test -p lemonade-axum --all-features

# Generate coverage for Axum load balancer
lb-axum-coverage:
    cargo llvm-cov -p lemonade-axum --all-features --summary-only

# Load Balancer - Hyper
# Build Hyper load balancer
lb-hyper-build:
    cargo build -p lemonade-hyper --all-features

# Test Hyper load balancer
lb-hyper-test:
    cargo test -p lemonade-hyper --all-features

# Run Hyper load balancer
lb-hyper-run:
    cargo run -p lemonade-hyper --all-features

# Check Hyper load balancer (format, lint, test)
lb-hyper-check:
    cargo fmt -p lemonade-hyper -- --check
    cargo clippy -p lemonade-hyper --all-targets --all-features -- -D warnings
    cargo test -p lemonade-hyper --all-features

# Generate coverage for Hyper load balancer
lb-hyper-coverage:
    cargo llvm-cov -p lemonade-hyper --all-features --summary-only

# Load Balancer - Rocket
# Build Rocket load balancer
lb-rocket-build:
    cargo build -p lemonade-rocket --all-features

# Test Rocket load balancer
lb-rocket-test:
    cargo test -p lemonade-rocket --all-features

# Run Rocket load balancer
lb-rocket-run:
    cargo run -p lemonade-rocket --all-features

# Check Rocket load balancer (format, lint, test)
lb-rocket-check:
    cargo fmt -p lemonade-rocket -- --check
    cargo clippy -p lemonade-rocket --all-targets --all-features -- -D warnings
    cargo test -p lemonade-rocket --all-features

# Generate coverage for Rocket load balancer
lb-rocket-coverage:
    cargo llvm-cov -p lemonade-rocket --all-features --summary-only

# Load Balancer - Tokio
# Build Tokio load balancer
lb-tokio-build:
    cargo build -p lemonade-tokio --all-features

# Test Tokio load balancer
lb-tokio-test:
    cargo test -p lemonade-tokio --all-features

# Run Tokio load balancer
lb-tokio-run:
    cargo run -p lemonade-tokio --all-features

# Check Tokio load balancer (format, lint, test)
lb-tokio-check:
    cargo fmt -p lemonade-tokio -- --check
    cargo clippy -p lemonade-tokio --all-targets --all-features -- -D warnings
    cargo test -p lemonade-tokio --all-features

# Generate coverage for Tokio load balancer
lb-tokio-coverage:
    cargo llvm-cov -p lemonade-tokio --all-features --summary-only

# ============================================================================
# Worker commands (worker-<framework>)
# ============================================================================

# Worker - Actix
# Build Actix worker
worker-actix-build:
    cargo build -p worker-actix --all-features

# Test Actix worker
worker-actix-test:
    cargo test -p worker-actix --all-features

# Run Actix worker
worker-actix-run:
    cargo run -p worker-actix --all-features

# Check Actix worker (format, lint, test)
worker-actix-check:
    cargo fmt -p worker-actix -- --check
    cargo clippy -p worker-actix --all-targets --all-features -- -D warnings
    cargo test -p worker-actix --all-features

# Generate coverage for Actix worker
worker-actix-coverage:
    cargo llvm-cov -p worker-actix --all-features --summary-only

# Worker - Axum
# Build Axum worker
worker-axum-build:
    cargo build -p worker-axum --all-features

# Test Axum worker
worker-axum-test:
    cargo test -p worker-axum --all-features

# Run Axum worker
worker-axum-run:
    cargo run -p worker-axum --all-features

# Check Axum worker (format, lint, test)
worker-axum-check:
    cargo fmt -p worker-axum -- --check
    cargo clippy -p worker-axum --all-targets --all-features -- -D warnings
    cargo test -p worker-axum --all-features

# Generate coverage for Axum worker
worker-axum-coverage:
    cargo llvm-cov -p worker-axum --all-features --summary-only

# Worker - Hyper
# Build Hyper worker
worker-hyper-build:
    cargo build -p worker-hyper --all-features

# Test Hyper worker
worker-hyper-test:
    cargo test -p worker-hyper --all-features

# Run Hyper worker
worker-hyper-run:
    cargo run -p worker-hyper --all-features

# Check Hyper worker (format, lint, test)
worker-hyper-check:
    cargo fmt -p worker-hyper -- --check
    cargo clippy -p worker-hyper --all-targets --all-features -- -D warnings
    cargo test -p worker-hyper --all-features

# Generate coverage for Hyper worker
worker-hyper-coverage:
    cargo llvm-cov -p worker-hyper --all-features --summary-only

# Worker - Rocket
# Build Rocket worker
worker-rocket-build:
    cargo build -p worker-rocket --all-features

# Test Rocket worker
worker-rocket-test:
    cargo test -p worker-rocket --all-features

# Run Rocket worker
worker-rocket-run:
    cargo run -p worker-rocket --all-features

# Check Rocket worker (format, lint, test)
worker-rocket-check:
    cargo fmt -p worker-rocket -- --check
    cargo clippy -p worker-rocket --all-targets --all-features -- -D warnings
    cargo test -p worker-rocket --all-features

# Generate coverage for Rocket worker
worker-rocket-coverage:
    cargo llvm-cov -p worker-rocket --all-features --summary-only

# ============================================================================
# Utility commands
# ============================================================================

# Complete setup for new users - builds project and sets up git hooks
setup:
    @echo "🚀 Setting up Lemonade project..."
    @echo ""
    @echo "📦 Building workspace..."
    cargo build --workspace --all-features
    @echo ""
    @echo "🔧 Setting up git hooks..."
    ./scripts/setup-git-hooks.sh
    @echo ""
    @echo "✅ Setup complete!"
    @echo ""
    @echo "Next steps:"
    @echo "  - Run tests: just test"
    @echo "  - Check code: just check"
    @echo "  - See all commands: just --list"

# Set up development tools (coverage, audit, deny)
setup-dev:
    @echo "🛠️  Setting up development tools..."
    @echo ""
    @echo "📊 Installing cargo-llvm-cov (coverage)..."
    cargo install cargo-llvm-cov --locked || echo "  ⚠️  cargo-llvm-cov may already be installed"
    @echo ""
    @echo "🔒 Installing cargo-audit (security)..."
    cargo install cargo-audit --locked || echo "  ⚠️  cargo-audit may already be installed"
    @echo ""
    @echo "🚫 Installing cargo-deny (license checks)..."
    cargo install cargo-deny --locked || echo "  ⚠️  cargo-deny may already be installed"
    @echo ""
    @echo "✅ Development tools setup complete!"
    @echo ""
    @echo "Available commands:"
    @echo "  - just coverage    # Generate coverage report"
    @echo "  - just audit       # Run security audit"
    @echo "  - just deny        # Run cargo-deny checks"

# Set up git hooks (no Python required)
setup-hooks:
    ./scripts/setup-git-hooks.sh

# List all workspace members
list-crates:
    cargo metadata --format-version 1 | jq -r '.workspace_members[]' | sed 's/ .*//'

# Incremental test - only test changed crates (requires git)
test-incremental:
    echo "Detecting changed crates..."
    cargo test --workspace --all-features
