# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
begin
  Rails.application.initialize!
rescue => e
  # Si hay un error durante la inicialización, mostrarlo y salir
  STDERR.puts "Error al inicializar la aplicación: #{e.message}"
  STDERR.puts e.backtrace.join("\n") if ENV["RAILS_ENV"] == "development"
  exit 1
end
