# Rails 8: evitar error "No database connection defined for 'reading' role"
ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.connected_to(role: :reading) do
    # Redirige las consultas de lectura a la conexión de escritura
    ActiveRecord::Base.establish_connection(:primary)
  end
end