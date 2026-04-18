require_relative 'filter_chain'

class FilterManager
  def initialize(target)
    @filter_chain = FilterChain.new
    @filter_chain.set_target(target)
  end

  # añade un filtro
  def add_filter(filter)
    @filter_chain.add_filter(filter)
  end

  # ejecuta ese filtro
  def filter_request(request)
    @filter_chain.execute(request)
  end
end