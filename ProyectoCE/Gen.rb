require 'securerandom'

class Gen
  #attr_access :genotipo
  
  def initialize(genotipo)
    @genotipo = genotipo
    inicializarGen()
  end

  def inicializarGen()
    @genotipo = SecureRandom.random_number(21)
  end

end