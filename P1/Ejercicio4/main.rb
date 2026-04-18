# filtros
require_relative 'filters/filter'
require_relative 'filters/email_text_filter'
require_relative 'filters/email_domain_filter'
require_relative 'filters/password_length_filter'
require_relative 'filters/password_number_filter'
require_relative 'filters/password_special_char_filter'

# nucleo del sistema
require_relative 'core/filter_chain'
require_relative 'core/filter_manager'
require_relative 'core/authentication_service'

# cliente
require_relative 'client/cliente'

# excepción personalizada
require_relative 'validation_error'

# construye y configura el sistema de filtros
# inicializa el servicio de autenticación y registra todos los filtros
def build_filter_manager
  auth_service = AuthenticationService.new
  filter_manager = FilterManager.new(auth_service)

  # filtros de correo
  filter_manager.add_filter(EmailTextFilter.new)
  filter_manager.add_filter(EmailDomainFilter.new)

  # filtros de contraseña
  filter_manager.add_filter(PasswordLengthFilter.new)
  filter_manager.add_filter(PasswordNumberFilter.new)
  filter_manager.add_filter(PasswordSpecialCharFilter.new)

  # devuelve el sistema listo para ser utilizado
  filter_manager
end

# solicita al usuario el correo electrónico
print "Introduce tu correo: "
email = gets.chomp

# solicita al usuario la contraseña
print "Introduce tu contraseña: "
password = gets.chomp

# construye la petición
request = {
  email: email,
  password: password
}

# construye el sistema de filtros
filter_manager = build_filter_manager

# crea el cliente que utilizará el sistema
cliente = Cliente.new(filter_manager)

# envía la petición al sistema de validación
begin
  cliente.send_request(request)
rescue ValidationError => e
  puts "Error de validación: #{e.message}"
end