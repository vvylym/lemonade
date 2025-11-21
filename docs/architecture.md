# Architecture Overview

This document provides a detailed overview of the Lemonade project architecture.

## Project Structure

Lemonade is organized as a Rust workspace with multiple crates:

```
lemonade/
├── lemonade-actix/      # Actix Web load balancer
├── lemonade-axum/       # Axum load balancer
├── lemonade-hyper/      # Hyper load balancer
├── lemonade-rocket/     # Rocket load balancer
├── lemonade-tokio/      # Tokio load balancer
├── lemonade-shared/     # Shared code for load balancers
├── lemonade-tracing/    # Shared tracing utilities
├── worker-actix/        # Actix Web worker
├── worker-axum/         # Axum worker
├── worker-hyper/        # Hyper worker
├── worker-rocket/       # Rocket worker
├── worker-shared/       # Shared code for workers
└── test-utils/          # Testing utilities
```

## Components

### Load Balancers

Load balancers (`lemonade-*`) are proxy servers that:
- Accept incoming HTTP requests
- Distribute requests across multiple worker instances
- Implement various load balancing algorithms
- Monitor worker health and availability
- Collect metrics for adaptive routing

**Status**: In development

### Workers

Workers (`worker-*`) are backend servers that:
- Handle HTTP requests from load balancers
- Expose `/v1/health` for health checks
- Expose `/v1/work` for simulating work with configurable delays
- Can run independently or as part of a worker pool

**Status**: Implemented and functional

### Shared Libraries

- **lemonade-shared**: Common load balancer logic (routing, algorithms, health checks)
- **worker-shared**: Common worker logic (request handling, work simulation)
- **lemonade-tracing**: Shared observability setup (tracing, logging, metrics)
- **test-utils**: Utilities for integration testing

## Communication Flow

```
Client Request
    ↓
Load Balancer (lemonade-*)
    ├─→ Health Check
    ├─→ Algorithm Selection
    ├─→ Worker Selection
    └─→ Request Forwarding
         ↓
    Worker Pool (worker-*)
    ├─→ worker-1 (127.0.0.1:9001)
    ├─→ worker-2 (127.0.0.1:9002)
    └─→ worker-3 (127.0.0.1:9003)
         ↓
    Response
         ↓
    Load Balancer
         ↓
    Client
```

## Load Balancing Algorithms

### Round Robin
Requests are distributed sequentially across workers in a circular fashion.

### Least Connections
Requests are routed to the worker with the fewest active connections.

### Weighted Round Robin
Round robin with capacity-based weights for each worker.

### Weighted Least Connections
Least connections with capacity-based weights.

### IP Hash
Requests are routed based on client IP for session affinity.

## Health Checks

Workers expose a `/v1/health` endpoint that returns `200 OK` when healthy. Load balancers periodically check worker health and:
- Remove unhealthy workers from the pool
- Re-add workers when they become healthy again
- Route traffic only to healthy workers

## Configuration

### Environment Variables

**Workers:**
- `ACTIX_WORKER_ADDRESS`: Actix worker bind address (default: `127.0.0.1:9021`)
- `AXUM_WORKER_ADDRESS`: Axum worker bind address (default: `127.0.0.1:9022`)
- `HYPER_WORKER_ADDRESS`: Hyper worker bind address (default: `127.0.0.1:9023`)
- `ROCKET_WORKER_ADDRESS`: Rocket worker bind address (default: `127.0.0.1:9024`)

**Load Balancers:**
- Configuration via environment variables (to be implemented)

## Testing Strategy

### Unit Tests
Each crate has unit tests for its core functionality.

### Integration Tests
Integration tests use `test-utils` to:
- Start workers
- Send requests to load balancers
- Verify request distribution
- Test health check behavior

### End-to-End Tests
Full system tests that:
- Start multiple workers
- Start a load balancer
- Send requests and verify distribution
- Test failover scenarios

## Observability

### Tracing
All components use structured tracing for:
- Request/response logging
- Performance metrics
- Error tracking

### Metrics (Planned)
- Request rate per worker
- Response times
- Error rates
- Active connections
- Health check status

## Future Enhancements

- [ ] Session affinity (sticky sessions)
- [ ] Adaptive load balancing based on metrics
- [ ] Circuit breakers for unhealthy workers
- [ ] Rate limiting
- [ ] Request/response transformation
- [ ] SSL/TLS termination
- [ ] WebSocket support
- [ ] gRPC support

