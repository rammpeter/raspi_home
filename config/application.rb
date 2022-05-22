require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RaspiHome
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    config.load_defaults 7.0


    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Berlin'
    config.active_record.default_timezone = :local

    #config.active_record.sqlite3.represent_boolean_as_integer = true
    config.active_record.legacy_connection_handling = false
  end
end
