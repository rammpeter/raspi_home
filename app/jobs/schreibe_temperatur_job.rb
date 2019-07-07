class SchreibeTemperaturJob < ApplicationJob
  include ExceptionHelper

  queue_as :default

  CYCLE_SECONDS = 60

  def perform(*args)
    SchreibeTemperaturJob.set(wait_until: Time.now.round + CYCLE_SECONDS).perform_later  # Schedule next start
    #Thread.new{PanoramaConnection.disconnect_aged_connections(CHECK_CYCLE_SECONDS)}
    Temperatur.schreibe_temperatur
  rescue Exception => e
    Rails.logger.error "Exception in SchreibeTemperaturJob.perform:\n#{e.message}"
    log_exception_backtrace(e, 40)
    raise e
  end
end
