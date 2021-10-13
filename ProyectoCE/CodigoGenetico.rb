require_relative 'Cromosoma.rb'

class CodigoGenetico
  
  def initialize(tamaño)
    @cromosomas = []
    ini_Cromosoma(tamaño)
  end

  def ini_Cromosoma(tamaño)
    (0...10).each do |i|
      @cromosomas [i] = Cromosoma.new(tamaño)
    end
  end

end