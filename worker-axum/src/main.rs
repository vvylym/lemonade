//! Lemonade Axum Worker
//!
use worker_axum::{AppState, AxumWorker};

/// Main entrypoint
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    lemonade_tracing::init_tracing();

    let span = tracing::span!(tracing::Level::INFO, "worker_axum");
    let _enter = span.enter();

    // Get port from environment variable or default to 9003
    let address =
        std::env::var("AXUM_WORKER_ADDRESS").unwrap_or_else(|_| "127.0.0.1:9022".to_string());

    let state = AppState::default();

    let app = AxumWorker::build(state, &address)
        .await
        .expect("Failed to build app");

    app.run().await.expect("Failed to run app");

    Ok(())
}
