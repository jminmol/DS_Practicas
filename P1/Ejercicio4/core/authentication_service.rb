# Solo se ejecuta si todos los filtros pasan
class AuthenticationService
  def execute(request)
    puts "Autenticación correcta para #{request[:email]}"
  end
end