require 'rubygems'
require 'bundler/setup'
require_relative('Gen')

class Cromosoma

  attr_accessor :aptitud, :genes

  def initialize(tamaño)
    @tamaño = tamaño
    @genes = Array.new(tamaño) { Gen.new() }
    @aptitud = -999999
    #ini_Cromosoma(tamaño)
  end

  def ini_Cromosoma(tamaño)
    (0...tamaño).each do |i|
      @genes [i] = Gen.new()
    end
  end

  def mutate()
    prng = Random.new
    newGenes = @genes.dup
    newGenes[prng.rand(@tamaño)] = Gen.new()
    replaceWith(newGenes)
  end

  def replaceWith(nuevo)
    @genes = nuevo
  end

  # Devuelve un arreglo de números, dónde cada número representa el "gen"
  def getGenes
    arr = Array.new(@tamaño)
    arr.each_with_index do |_v, index|
      arr[index] = @genes[index].getGenotipo()
    end

    return arr
  end
  
end