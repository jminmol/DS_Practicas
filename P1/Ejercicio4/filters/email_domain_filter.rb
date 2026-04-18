# filtro que valida que el dominio del correo sea permitido
# implementa la interfaz Filter
class EmailDomainFilter
  include Filter

  # lista de dominios permitidos
  ALLOWED_DOMAINS = ["gmail.com", "hotmail.com"]

  def execute(request)
    email = request[:email]

    # separa la parte del dominio (después del '@')
    _, domain = email.split("@")

    # comprueba si el dominio está dentro de los permitidos
    unless ALLOWED_DOMAINS.include?(domain)
      raise ValidationError, "Dominio no permitido"
    end
  end
end