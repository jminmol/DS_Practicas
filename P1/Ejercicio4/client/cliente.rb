class Cliente
  def initialize(filter_manager)
    @filter_manager = filter_manager
  end

  # envia la solicitud a FilterManager que se encarga de su procesamiento
  def send_request(request)
    @filter_manager.filter_request(request)
  end
end