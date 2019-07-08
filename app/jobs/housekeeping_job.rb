class HousekeepingJob < ApplicationJob
  include ExceptionHelper

  queue_as :default

  CYCLE_SECONDS = 86400

  def perform(*args)
    HousekeepingJob.set(wait_until: Time.now.round + CYCLE_SECONDS).perform_later  # Schedule next start
    Temperatur.housekeeping
  rescue Exception => e
    Rails.logger.error "Exception in HousekeepingJob.perform:\n#{e.message}"
    log_exception_backtrace(e, 40)
    raise e
  end
end
