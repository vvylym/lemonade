# lemonade

Yet another **Load Balancing** experiment in ***Rust Programming Language***!

## Introduction

This project is a deeper dive into **Rust**, named after the analogy of the **manager** of the ***coolest ever lemonade stand***.

> The lemonade stand is so popular that its has a huge line of thirsty customers every single day. From only a single window opened at first, it worked so well that the business is expanding, deciding to open many more identical windows and even extending its offers to other products like cookies, smoothies...
> 
> So comes in the super-organized manager, who stands in front of the group of windows and direct incoming customers to their respective window, making everything faster and more reliable for everyone using the appropriate playbook.

The goal is to experiment with different stacks to build a **proxy-based load balancer**. Each implementation will intelligently distribute incoming network traffic across multiple backend worker servers, based on various real-time performance data. This project will involve implementing load balancing algorithms, health monitoring, and performance optimization.

## Technology Stack

### **Web Frameworks / Runtime**

- [**Tokio**](https://crates.io/crates/tokio): *A runtime for writing reliable, asynchronous, and slim applications*.

- [**Actix Web**](https://crates.io/crates/actix-web): *A powerful, pragmatic, and extremely fast web framework*.

- [**Axum**](https://crates.io/crates/axum): *A web application framework that focuses on ergonomics and modularity*.

- [**Hyper**](http://crates.io/crates/hyper): *A protective and efficient HTTP library for all*.

- [**Rocket**](https://crates.io/crates/rocket): *An async web frameworkwith a focus on usability, security, extensibility, and speed*.


### Serialization/Deserialization

- [**Serde**]()

- [**Serde Json**]()

### Observability

- [**Tracing**]()

- [**Tracing Subscriber**]()

- [**Metrics**]()

- [**Metrics Prometheus Exporter**]()


## Features

The workspace will focus on a minimal HTTP Rest server providing the following endpoints:

- /v1/health: Simple and minimal endpoint returning `200 OK`, indicating a healthy server.

- /v1/work: Configurable endpoint returning `200 OK` after a defined delay (**10ms** by default bu extensible) that simulates work being done

### Load Balancers

- [**Tokio Load Balancer**]()

- [**Actix Web Load Balancer**]()

- [**Axum Load Balancer**]()

- [**Hyper Load Balancer**]()

- [**Rocket Load Balancer**]()

- [**Tokio-based implementation**]()

### Workers

- [**Tokio Worker**]()

- [**Actix Web Worker**]()

- [**Axum Worker**]()

- [**Hyper Worker**]()

- [**Rocket Worker**]()

## Prerequisites

TODO: Describe prerequisites

## Getting Started

TODO: Describe How to get started

## Testing

TODO: Describe how to test

## License

Lemonade is released under the [MIT license](https://opensource.org/licenses/MIT).
