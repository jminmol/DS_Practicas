# filtro que valida que el correo tenga texto antes del carácter '@'
# implementa la interfaz Filter
class EmailTextFilter
  include Filter

  def execute(request)
    email = request[:email]

    # separa la parte local del correo (antes del '@')
    local_part = email.split("@")[0]

    # comprueba que exista texto antes del '@'
    if local_part.nil? || local_part.empty?
      raise ValidationError, "El correo debe tener texto antes del @"
    end
  end
end