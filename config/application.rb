require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vestiventa
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Desactivar completamente el manejo de credenciales
    config.require_master_key = false

    # Usar la clave secreta de la variable de entorno o generar una
    config.secret_key_base = ENV["SECRET_KEY_BASE"] || SecureRandom.hex(64)
    config.active_record.automatic_role_switching = false
  end
end
