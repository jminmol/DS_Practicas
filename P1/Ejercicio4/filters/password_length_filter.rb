# filtro que valida que la contraseña tenga una longitud mínima
# implementa la interfaz Filter
class PasswordLengthFilter
  include Filter

  def execute(request)
    # comprueba que la contraseña tenga al menos 8 caracteres
    raise ValidationError, "Contraseña demasiado corta" if request[:password].length < 8
  end
end