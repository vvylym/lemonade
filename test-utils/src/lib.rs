//! Test Utilities
//!
pub use reqwest::{Client, Response};

/// Test client for making HTTP requests to test endpoints
pub struct TestClient {
    /// Server address
    pub address: String,
    /// HTTP client
    pub client: Client,
}

impl TestClient {
    /// Create a new test client with the given address
    pub fn new(address: impl Into<String>) -> Self {
        Self {
            address: address.into(),
            client: Client::builder().build().unwrap(),
        }
    }

    /// Send a GET request to the /v1/health endpoint
    pub async fn get_health(&self) -> Response {
        self.client
            .get(format!("{}/v1/health", &self.address))
            .send()
            .await
            .expect("Failed to execute request.")
    }

    /// Send a GET request to the /v1/work endpoint
    pub async fn get_work(&self) -> Response {
        self.client
            .get(format!("{}/v1/work", &self.address))
            .send()
            .await
            .expect("Failed to execute request.")
    }
}
