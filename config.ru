# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

SchreibeTemperaturJob.set(wait:  5.seconds).perform_later
HousekeepingJob.set(      wait: 20.seconds).perform_later

run Rails.application
