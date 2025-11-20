//! Lemonade Workers Shared Library
//!
pub mod worker {
    //! Worker module
    //!
    use std::{thread::sleep, time::Duration};

    /// Default delay
    const DEFAULT_DELAY: u64 = 20;

    ///
    #[derive(Debug, Clone, Default)]
    pub struct WorkerService;

    impl WorkerService {
        ///
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

        ///
        #[test]
        fn test_no_delay_provided_should_elapse_default() {
            let default_delay = Duration::from_millis(DEFAULT_DELAY);
            let worker = WorkerService::default();
            let time_now = Instant::now();
            worker.handle_work(None);
            assert!(time_now.elapsed() >= default_delay);
        }

        ///
        #[test]
        fn test_any_delay_provided_should_elapse_itself() {
            let default_delay = Duration::from_millis(5);
            let worker = WorkerService::default();
            let time_now = Instant::now();
            worker.handle_work(Some(5));
            assert!(time_now.elapsed() >= default_delay);
        }

        ///
        #[test]
        fn test_lesser_delay_provided_should_not_elapse_default() {
            let default_default = Duration::from_millis(DEFAULT_DELAY);
            let worker = WorkerService::default();
            let time_now = Instant::now();
            worker.handle_work(Some(DEFAULT_DELAY - 1));
            assert!(time_now.elapsed() < default_default);
        }

        ///
        #[test]
        fn test_greater_delay_provided_should_elapse_default() {
            let default_default = Duration::from_millis(DEFAULT_DELAY);
            let worker = WorkerService::default();
            let time_now = Instant::now();
            worker.handle_work(Some(DEFAULT_DELAY + 1));
            assert!(time_now.elapsed() > default_default);
        }
    }
}
