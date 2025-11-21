# Getting Started Guide

This guide will help you get up and running with Lemonade quickly.

## Prerequisites

Before you begin, ensure you have:

1. **Rust** installed (latest stable version)
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. **Just** command runner installed
   ```bash
   cargo install just
   ```

## Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/vvylym/lemonade.git
cd lemonade

# Run initial setup
just setup
```

This will:
- Build all workspace crates
- Set up git hooks for code quality checks
- Verify everything is working

### 2. Run Your First Worker

Start an Axum worker:

```bash
just worker-axum-run
```

The worker will start on `http://127.0.0.1:9022` by default.

### 3. Test the Worker

In another terminal, test the worker:

```bash
# Health check
curl http://127.0.0.1:9022/v1/health

# Work endpoint (simulates processing)
curl http://127.0.0.1:9022/v1/work
```

You should see `200 OK` responses.

## Running Multiple Workers

To test load balancing, you'll need multiple workers running:

### Terminal 1: Worker on port 9001
```bash
AXUM_WORKER_ADDRESS=127.0.0.1:9001 just worker-axum-run
```

### Terminal 2: Worker on port 9002
```bash
AXUM_WORKER_ADDRESS=127.0.0.1:9002 just worker-axum-run
```

### Terminal 3: Worker on port 9003
```bash
AXUM_WORKER_ADDRESS=127.0.0.1:9003 just worker-axum-run
```

### Terminal 4: Test all workers
```bash
# Test worker 1
curl http://127.0.0.1:9001/v1/health

# Test worker 2
curl http://127.0.0.1:9002/v1/health

# Test worker 3
curl http://127.0.0.1:9003/v1/health
```

## Running Different Framework Workers

You can run workers using different frameworks:

```bash
# Actix Web worker
just worker-actix-run

# Axum worker
just worker-axum-run

# Hyper worker
just worker-hyper-run

# Rocket worker
just worker-rocket-run
```

Each framework has its own default port:
- Actix: `127.0.0.1:9021`
- Axum: `127.0.0.1:9022`
- Hyper: `127.0.0.1:9023`
- Rocket: `127.0.0.1:9024`

## Running Load Balancers

Load balancers are currently in development. Once implemented, you'll be able to run them with:

```bash
# Run Axum load balancer
just lb-axum-run

# Run Actix load balancer
just lb-actix-run

# Run Hyper load balancer
just lb-hyper-run

# Run Rocket load balancer
just lb-rocket-run

# Run Tokio load balancer
just lb-tokio-run
```

## Development Workflow

### Running Tests

```bash
# Run all tests
just test

# Run tests for a specific component
just worker-axum-test
just lb-actix-test
```

### Code Quality Checks

```bash
# Run all checks (format, lint, test)
just check

# Format code
just format

# Lint code
just lint
```

### Full CI Pipeline

```bash
# Run everything (format, lint, test, coverage, audit, deny)
just ci
```

## Next Steps

- Read [docs/research.md](research.md) to understand the concepts behind load balancing
- Read [docs/architecture.md](architecture.md) for detailed architecture information
- Explore the codebase to see how different frameworks are implemented
- Contribute by implementing load balancing algorithms or features

## Troubleshooting

### Port Already in Use

If you get a "port already in use" error:

1. Find the process using the port:
   ```bash
   lsof -i :9022  # Replace with your port
   ```

2. Kill the process or use a different port:
   ```bash
   AXUM_WORKER_ADDRESS=127.0.0.1:9025 just worker-axum-run
   ```

### Build Errors

If you encounter build errors:

1. Update Rust:
   ```bash
   rustup update
   ```

2. Clean and rebuild:
   ```bash
   just clean
   just build
   ```

### Git Hooks Not Working

If git hooks aren't running:

1. Re-run setup:
   ```bash
   just setup
   ```

2. Or manually install hooks:
   ```bash
   ./scripts/setup-git-hooks.sh
   ```

## Getting Help

- Check the [README.md](../README.md) for general information
- Review [docs/research.md](research.md) for conceptual background
- Open an issue on GitHub for bugs or questions

