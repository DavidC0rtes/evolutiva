require 'rubygems'
require 'bundler/setup'

require_relative 'Cromosoma.rb'

# Esta clase crea la población inicial
class CodigoGenetico
  
  attr_reader :cromosomas
   
  def initialize(tamaño)
    @cromosomas = Array.new(10) {Cromosoma.new(tamaño)}
    #ini_Cromosoma(tamaño)
  end

  def ini_Cromosoma(tamaño)
    (0...10).each do |i|
      @cromosomas [i] = Cromosoma.new(tamaño)
    end
  end

end
