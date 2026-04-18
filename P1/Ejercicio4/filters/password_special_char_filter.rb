# filtro que valida que la contraseña contenga al menos un carácter especial
# implementa la interfaz Filter
class PasswordSpecialCharFilter
  include Filter

  def execute(request)
    # comprueba si la contraseña contiene algún carácter especial
    unless request[:password].match(/[!@#$%^&*\-_]/)
      raise ValidationError, "Debe contener un carácter especial"
    end
  end
end