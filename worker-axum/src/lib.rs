//! Axum Worker
//!

use axum::{Router, serve::Serve};
use tokio::net::TcpListener;

use router::app_routes;
pub use state::AppState;

/// Axum worker server
pub struct AxumWorker {
    /// The axum server instance.
    server: Serve<TcpListener, Router, Router>,
    /// The listening address of the server
    pub address: String,
}

impl AxumWorker {
    /// Build a new Axum worker with the given state and address
    pub async fn build(state: AppState, address: &str) -> Result<Self, Box<dyn std::error::Error>> {
        let router = app_routes(state);

        let listener = TcpListener::bind(address).await?;

        let address = listener.local_addr()?.to_string();

        let server: Serve<TcpListener, Router, Router> = axum::serve(listener, router);
        //
        Ok(Self { server, address })
    }

    /// Run the Axum server
    pub async fn run(self) -> Result<(), std::io::Error> {
        tracing::info!("Axum server listening on {}", &self.address);
        self.server.await
    }
}

mod state {
    //! Application state module
    use worker_shared::worker::WorkerService;

    /// Application state containing the worker service
    #[derive(Debug)]
    pub struct AppState {
        /// Worker service instance
        pub worker: WorkerService,
    }

    impl Default for AppState {
        fn default() -> Self {
            let worker = WorkerService;
            Self { worker }
        }
    }
}

mod router {
    //! Router module for defining application routes
    use axum::{Router, routing::get};
    use std::sync::Arc;

    use crate::{handlers::*, state::AppState};

    /// Create the application router with all routes
    pub fn app_routes(state: AppState) -> Router {
        Router::new()
            .route("/v1/health", get(handle_health))
            .route("/v1/work", get(handle_work))
            .with_state(Arc::new(state))
    }
}

mod handlers {
    //! Request handlers module
    use crate::state::AppState;
    use axum::{extract::State, response::IntoResponse};
    use std::sync::Arc;

    /// Health check endpoint handler
    #[tracing::instrument(skip_all)]
    pub async fn handle_health() -> Result<impl IntoResponse, ()> {
        Ok(())
    }

    /// Work endpoint handler
    #[tracing::instrument(skip_all)]
    pub async fn handle_work(State(state): State<Arc<AppState>>) -> Result<impl IntoResponse, ()> {
        state.worker.handle_work(None);
        Ok(())
    }

    #[cfg(test)]
    mod tests {
        use super::*;

        #[tokio::test]
        async fn test_handle_health_should_be_ok() {
            let res = handle_health().await;
            assert!(res.is_ok())
        }

        #[tokio::test]
        async fn test_handle_work_should_be_ok() {
            let state = Arc::new(AppState::default());
            let res = handle_work(State(state)).await;
            assert!(res.is_ok())
        }
    }
}
