//! Axum Worker
//!

use axum::{Router, serve::Serve};
use tokio::net::TcpListener;

use router::app_routes;
pub use state::AppState;

///
pub struct AxumWorker {
    /// The axum server instance.
    server: Serve<TcpListener, Router, Router>,
    /// The listeting address of the server
    pub address: String,
}

impl AxumWorker {
    ///
    pub async fn build(state: AppState, address: &str) -> Result<Self, Box<dyn std::error::Error>> {
        let router = app_routes(state);

        let listener = TcpListener::bind(address).await?;

        let address = listener.local_addr()?.to_string();

        let server: Serve<TcpListener, Router, Router> = axum::serve(listener, router);
        //
        Ok(Self { server, address })
    }

    ///
    pub async fn run(self) -> Result<(), std::io::Error> {
        tracing::info!("Axum server listening on {}", &self.address);
        self.server.await
    }
}

mod state {
    //!
    use worker_shared::worker::WorkerService;

    ///
    #[derive(Debug)]
    pub struct AppState {
        ///
        pub worker: WorkerService,
    }

    impl Default for AppState {
        fn default() -> Self {
            let worker = WorkerService::default();
            Self { worker }
        }
    }
}

mod router {
    //!
    use axum::{Router, routing::get};
    use std::sync::Arc;

    use crate::{handlers::*, state::AppState};

    ///
    pub fn app_routes(state: AppState) -> Router {
        Router::new()
            .route("/v1/health", get(handle_health))
            .route("/v1/work", get(handle_work))
            .with_state(Arc::new(state))
    }
}

mod handlers {
    //!
    use crate::state::AppState;
    use axum::{extract::State, response::IntoResponse};
    use std::sync::Arc;

    ///
    #[tracing::instrument(skip_all)]
    pub async fn handle_health() -> Result<impl IntoResponse, ()> {
        Ok(())
    }

    ///
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
