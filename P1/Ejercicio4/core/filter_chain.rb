class FilterChain

  # @filters almacena todos los filtros a ejecutar
  # @target es el servicio final
  def initialize
    @filters = []
    @target = nil
  end

  # añade un nuevo filtro a la cadena
  # los filtros se ejecutarán en el orden en que se añaden
  def add_filter(filter)
    @filters << filter
  end

  # establece el servicio final
  def set_target(target)
    @target = target
  end

  # ejecuta la cadena de filtros
  # cada filtro valida la petición; si alguno falla, lanza excepción
  # y se detiene la ejecución
  # si todos los filtros pasan, se ejecuta el target
  def execute(request)
    @filters.each do |filter|
      filter.execute(request)
    end

    # se ejecuta el servicio final solo si todos los filtros han pasado
    @target.execute(request)
  end

end