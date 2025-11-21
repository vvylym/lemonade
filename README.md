# Lemonade

Yet another **Load Balancing** experiment in ***Rust Programming Language***!

[![Rust](https://img.shields.io/badge/rust-1.91.1-orange.svg)](https://www.rust-lang.org/)
[![Tokio](https://img.shields.io/badge/tokio-1.48.0-blue.svg)](https://tokio.rs/)
[![Actix Web](https://img.shields.io/badge/actix--web-4.12.0-green.svg)](https://actix.rs/)
[![Axum](https://img.shields.io/badge/axum-0.8.7-purple.svg)](https://github.com/tokio-rs/axum)
[![Rocket](https://img.shields.io/badge/rocket-0.5-red.svg)](https://rocket.rs/)
[![Hyper](https://img.shields.io/badge/hyper-1.8.1-yellow.svg)](https://hyper.rs/)
![Coverage](https://img.shields.io/badge/coverage-0.00%25-red)
[![CI](https://github.com/vvylym/lemonade/actions/workflows/ci.yml/badge.svg)](https://github.com/vvylym/lemonade/actions/workflows/ci.yml)

## What is Lemonade?

**Lemonade** is an experimental project exploring **proxy-based load balancing** in Rust. The project implements load balancers and worker servers using different Rust web frameworks (Actix Web, Axum, Hyper, Rocket, and Tokio) to compare their performance, ergonomics, and capabilities.

> The lemonade stand is so popular that it has a huge line of thirsty customers every single day. From only a single window opened at first, it worked so well that the business is expanding, deciding to open many more identical windows and even extending its offers to other products like cookies, smoothies...
> 
> So comes in the super-organized manager, who stands in front of the group of windows and directs incoming customers to their respective window, making everything faster and more reliable for everyone using the appropriate playbook.

This analogy captures the essence of load balancing: a **manager** (load balancer) intelligently distributes incoming requests (customers) across multiple **workers** (windows) to optimize performance, reliability, and resource utilization.

### Project Goals

- **Experiment** with different Rust web frameworks for building load balancers
- **Compare** performance characteristics across frameworks
- **Implement** various load balancing algorithms (Round Robin, Least Connections, etc.)
- **Learn** about distributed systems concepts through hands-on implementation
- **Document** findings and best practices

For a deeper dive into the concepts and motivations behind this project, see [docs/research.md](docs/research.md) - a comprehensive guide that explains distributed systems and load balancing through the lemonade stand analogy.

## Architecture

The project is organized as a Rust workspace with the following components:

### Load Balancers (`lemonade-*`)

Proxy-based load balancers that distribute incoming HTTP requests across multiple worker servers:

- **lemonade-actix**: Load balancer using Actix Web
- **lemonade-axum**: Load balancer using Axum
- **lemonade-hyper**: Load balancer using Hyper
- **lemonade-rocket**: Load balancer using Rocket
- **lemonade-tokio**: Load balancer using Tokio

### Workers (`worker-*`)

Backend servers that handle actual work requests:

- **worker-actix**: Worker server using Actix Web
- **worker-axum**: Worker server using Axum
- **worker-hyper**: Worker server using Hyper
- **worker-rocket**: Worker server using Rocket

### Shared Libraries

- **lemonade-shared**: Shared code for load balancers
- **worker-shared**: Shared code for workers
- **lemonade-tracing**: Shared tracing/observability utilities
- **test-utils**: Testing utilities for integration tests

## Features

### HTTP REST Endpoints

All workers expose the following endpoints:

- **`GET /v1/health`**: Health check endpoint returning `200 OK` when the server is healthy
- **`GET /v1/work`**: Work endpoint that simulates processing by returning `200 OK` after a configurable delay (default: 20ms)

### Load Balancing Algorithms (Planned)

- **Round Robin**: Distribute requests sequentially across workers
- **Least Connections**: Route to the worker with the fewest active connections
- **Weighted Round Robin**: Round robin with capacity-based weights
- **Weighted Least Connections**: Least connections with capacity-based weights
- **IP Hash**: Route based on client IP for session affinity

### Planned Features

- Health checks and automatic failover
- Metrics collection and observability
- Session affinity (sticky sessions)
- Adaptive load balancing based on real-time metrics

## Prerequisites

- **Rust**: Latest stable version (install from [rustup.rs](https://rustup.rs/))
- **Just**: Command runner (install with `cargo install just`)

## Getting Started

### Initial Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/vvylym/lemonade.git
   cd lemonade
   ```

2. **Run the setup command:**
   ```bash
   just setup
   ```
   
   This will:
   - Build all workspace crates
   - Set up git hooks for automatic code quality checks
   - Verify everything is working correctly

3. **(Optional) Install development tools:**
   ```bash
   just setup-dev
   ```
   
   This installs additional tools:
   - `cargo-llvm-cov` for code coverage
   - `cargo-audit` for security vulnerability checks
   - `cargo-deny` for license and dependency checks

### Running Workers

Workers are backend servers that handle HTTP requests. Each worker can run independently.

#### Running a Single Worker

To run a worker using a specific framework:

```bash
# Run Axum worker (default: http://127.0.0.1:9022)
just worker-axum-run

# Run Actix worker
just worker-actix-run

# Run Hyper worker
just worker-hyper-run

# Run Rocket worker
just worker-rocket-run
```

#### Configuring Worker Address

Workers can be configured via environment variables:

```bash
# Axum worker
AXUM_WORKER_ADDRESS=127.0.0.1:9001 just worker-axum-run

# Actix worker
ACTIX_WORKER_ADDRESS=127.0.0.1:9002 just worker-actix-run

# Hyper worker
HYPER_WORKER_ADDRESS=127.0.0.1:9003 just worker-hyper-run

# Rocket worker
ROCKET_WORKER_ADDRESS=127.0.0.1:9004 just worker-rocket-run
```

#### Testing Workers

You can test a worker by making HTTP requests:

```bash
# Health check
curl http://127.0.0.1:9022/v1/health

# Work endpoint (simulates processing)
curl http://127.0.0.1:9022/v1/work
```

### Running Load Balancers

Load balancers distribute requests across multiple worker instances. (Note: Load balancers are currently in development)

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

### Running a Complete Setup

To test the full load balancing setup:

1. **Start multiple workers** in separate terminals:
   ```bash
   # Terminal 1
   AXUM_WORKER_ADDRESS=127.0.0.1:9001 just worker-axum-run
   
   # Terminal 2
   AXUM_WORKER_ADDRESS=127.0.0.1:9002 just worker-axum-run
   
   # Terminal 3
   AXUM_WORKER_ADDRESS=127.0.0.1:9003 just worker-axum-run
   ```

2. **Start the load balancer** (when implemented):
   ```bash
   # Terminal 4
   just lb-axum-run
   ```

3. **Test the load balancer:**
   ```bash
   # Requests will be distributed across workers
   curl http://127.0.0.1:8080/v1/health
   curl http://127.0.0.1:8080/v1/work
   ```

## Development

### Available Commands

This project uses [`just`](https://github.com/casey/just) as a command runner. See the [justfile](justfile) for all available commands.

#### Workspace-wide Commands

- **Format code**: `just format` or `just format-check` (check only)
- **Lint code**: `just lint`
- **Run all tests**: `just test`
- **Run tests with output**: `just test-verbose`
- **Run all checks**: `just check` (format, lint, and test)
- **Build all crates**: `just build`
- **Clean build artifacts**: `just clean`
- **Full CI pipeline**: `just ci` (format, lint, test, coverage, audit, and deny)

#### Load Balancer Commands

Commands follow the pattern `lb-<framework>-<action>` where framework is one of: `actix`, `axum`, `hyper`, `rocket`, `tokio`

- **Build**: `just lb-<framework>-build`
- **Test**: `just lb-<framework>-test`
- **Run**: `just lb-<framework>-run`
- **Check** (format, lint, test): `just lb-<framework>-check`
- **Coverage**: `just lb-<framework>-coverage`

#### Worker Commands

Commands follow the pattern `worker-<framework>-<action>` where framework is one of: `actix`, `axum`, `hyper`, `rocket`

- **Build**: `just worker-<framework>-build`
- **Test**: `just worker-<framework>-test`
- **Run**: `just worker-<framework>-run`
- **Check** (format, lint, test): `just worker-<framework>-check`
- **Coverage**: `just worker-<framework>-coverage`

#### Examples

```bash
# Workspace-wide operations
just test                    # Run all tests
just check                   # Run all checks before committing
just coverage               # Generate coverage report

# Load Balancer operations
just lb-actix-test          # Test Actix load balancer
just lb-axum-run            # Run Axum load balancer
just lb-tokio-check         # Check Tokio load balancer (format, lint, test)

# Worker operations
just worker-axum-test       # Test Axum worker
just worker-hyper-run       # Run Hyper worker
just worker-rocket-check    # Check Rocket worker (format, lint, test)

# Coverage for specific components
just lb-actix-coverage      # Coverage for Actix load balancer
just worker-axum-coverage   # Coverage for Axum worker

# Security and quality checks
just audit                  # Check for security vulnerabilities
just deny                   # Check licenses and dependencies
```

## Documentation

- **[docs/research.md](docs/research.md)**: A comprehensive guide explaining distributed systems and load balancing concepts through the lemonade stand analogy. This document covers:
  - Distributed systems fundamentals
  - Load balancing strategies and algorithms
  - Health checks, session affinity, and other load balancer features
  - The CAP theorem and its implications
  - Real-world patterns and best practices

## Dependency Management

This project uses [Dependabot](https://docs.github.com/en/code-security/dependabot) to automatically check for and update dependencies. Dependabot will:

- Check for updates weekly (every Monday)
- Create pull requests for dependency updates
- Group minor and patch updates together
- Ignore major version updates for critical dependencies (actix-web, axum, rocket, tokio, hyper)

You can view and manage dependency updates in the [Dependabot alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts) section of your repository.

## Security & Quality Checks

- **Security audit**: `just audit` - Check for known security vulnerabilities using cargo-audit
- **Cargo deny**: `just deny` - Check licenses, duplicates, and banned dependencies
- **Install audit tool**: `just install-audit`
- **Install deny tool**: `just install-deny`

These checks also run automatically:
- **Security Audit**: Runs weekly (Tuesday) and on every push/PR in CI/CD
- **Cargo Deny**: Runs automatically in pre-commit hooks for every local commit

## Technology Stack

### Web Frameworks / Runtime

- [**Tokio**](https://crates.io/crates/tokio): A runtime for writing reliable, asynchronous, and slim applications
- [**Actix Web**](https://crates.io/crates/actix-web): A powerful, pragmatic, and extremely fast web framework
- [**Axum**](https://crates.io/crates/axum): A web application framework that focuses on ergonomics and modularity
- [**Hyper**](https://crates.io/crates/hyper): A fast and correct HTTP library
- [**Rocket**](https://crates.io/crates/rocket): An async web framework with a focus on usability, security, extensibility, and speed

### Serialization/Deserialization

- [**Serde**](https://crates.io/crates/serde): A framework for serializing and deserializing Rust data structures
- [**Serde Json**](https://crates.io/crates/serde_json): JSON support for Serde

### Observability

- [**Tracing**](https://crates.io/crates/tracing): Application-level tracing for Rust
- [**Tracing Subscriber**](https://crates.io/crates/tracing-subscriber): Subscriber implementations for the tracing crate

## License

Lemonade is released under the [MIT license](LICENSE).
