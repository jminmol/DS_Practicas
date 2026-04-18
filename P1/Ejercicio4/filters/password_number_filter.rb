# filtro que valida que la contraseña contenga al menos un número
# implementa la interfaz Filter
class PasswordNumberFilter
  include Filter

  def execute(request)
    # comprueba si la contraseña contiene algún dígito (0-9)
    # mediante una expresión regular
    unless request[:password].match(/\d/)
      raise ValidationError, "Debe contener un número"
    end
  end
end