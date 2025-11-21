//! Lemonade Workers Shared Library
//!
pub mod worker {
    //! Worker module
    //!
    use std::{thread::sleep, time::Duration};

    /// Default delay in milliseconds
    const DEFAULT_DELAY: u64 = 20;

    /// Worker service for handling work requests
    #[derive(Debug, Clone, Default)]
    pub struct WorkerService;

    impl WorkerService {
        /// Handle a work request with an optional delay
        ///
        /// # Arguments
        ///
        /// * `delay_ms` - Optional delay in milliseconds. If None, uses the default delay.
        pub fn handle_work(&self, delay_ms: Option<u64>) {
            //
            let duration = Duration::from_millis(delay_ms.unwrap_or(DEFAULT_DELAY));
            //
            sleep(duration);
        }
    }

    #[cfg(test)]
    mod tests {
        //! Tests module for the Worker
        //!
        use super::*;
        use std::time::Instant;

        /// Test that default delay is used when no delay is provided
        #[test]
        fn test_no_delay_provided_should_elapse_default() {
            let default_delay = Duration::from_millis(DEFAULT_DELAY);
            let worker = WorkerService;
            let time_now = Instant::now();
            worker.handle_work(None);
            assert!(time_now.elapsed() >= default_delay);
        }

        /// Test that provided delay is used when specified
        #[test]
        fn test_any_delay_provided_should_elapse_itself() {
            let default_delay = Duration::from_millis(5);
            let worker = WorkerService;
            let time_now = Instant::now();
            worker.handle_work(Some(5));
            assert!(time_now.elapsed() >= default_delay);
        }

        /// Test that a delay less than default doesn't elapse the default time
        #[test]
        fn test_lesser_delay_provided_should_not_elapse_default() {
            let default_default = Duration::from_millis(DEFAULT_DELAY);
            let worker = WorkerService;
            let time_now = Instant::now();
            worker.handle_work(Some(DEFAULT_DELAY - 1));
            assert!(time_now.elapsed() < default_default);
        }

        /// Test that a delay greater than default elapses more than the default time
        #[test]
        fn test_greater_delay_provided_should_elapse_default() {
            let default_default = Duration::from_millis(DEFAULT_DELAY);
            let worker = WorkerService;
            let time_now = Instant::now();
            worker.handle_work(Some(DEFAULT_DELAY + 1));
            assert!(time_now.elapsed() > default_default);
        }
    }
}
