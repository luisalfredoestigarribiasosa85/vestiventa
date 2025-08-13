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

    # Configuración de credenciales simplificada
    config.require_master_key = false
    config.secret_key_base = ENV["SECRET_KEY_BASE"] || SecureRandom.hex(64)

    # Intentar cargar credenciales solo si la clave maestra está presente
    if ENV["RAILS_MASTER_KEY"].present? && File.exist?(Rails.root.join("config/credentials.yml.enc"))
      begin
        config.require_master_key = true
        # Solo intentar acceder a las credenciales si realmente las necesitamos
        config.secret_key_base = Rails.application.credentials.secret_key_base if Rails.application.credentials.secret_key_base.present?
      rescue ActiveSupport::MessageEncryptor::InvalidMessage
        # Si hay un error con las credenciales, continuar sin ellas
        config.require_master_key = false
      end
    end
  end
end
