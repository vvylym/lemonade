//! Test Utilities
//! 
pub use reqwest::{Client, Response};

/// 
pub struct TestClient {
    /// 
    pub address: String,
    /// 
    pub client: Client,
}

/// 
impl TestClient {
    /// 
    pub fn new(address: impl Into<String>) -> Self {
        Self {
            address: address.into(),
            client: Client::builder()
                .build()
                .unwrap(),
        }
    }
    
    /// 
    pub async fn get_health(&self) -> Response {
        self.client
            .get(&format!("{}/v1/health", &self.address))
            .send()
            .await
            .expect("Failed to execute request.")
    }

    /// 
    pub async fn get_work(&self) -> Response {
        self.client
            .get(&format!("{}/v1/work", &self.address))
            .send()
            .await
            .expect("Failed to execute request.")
    }
}