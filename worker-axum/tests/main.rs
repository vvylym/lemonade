//! Tests module
//!
use test_utils::TestClient;
use worker_axum::{AppState, AxumWorker};

/// Test address for binding
const TEST_ADDRESS: &str = "127.0.0.1:0";

/// Test that health endpoint returns 200 OK
#[tokio::test]
async fn test_health_should_return_200_ok() {
    let app = AxumWorker::build(AppState::default(), TEST_ADDRESS)
        .await
        .expect("failed to initialize the app");

    let address = format!("http://{}", app.address.clone());

    tokio::spawn(app.run());

    let client = TestClient::new(address);

    let response = client.get_work().await;

    assert_eq!(response.status().as_u16(), 200);
}

/// Test that work endpoint returns 200 OK
#[tokio::test]
async fn test_work_should_return_200_ok() {
    let app = AxumWorker::build(AppState::default(), TEST_ADDRESS)
        .await
        .expect("failed to initialize the app");
    let address = format!("http://{}", app.address.clone());

    tokio::spawn(app.run());

    let client = TestClient::new(address);

    let response = client.get_work().await;

    assert_eq!(response.status().as_u16(), 200);
}
