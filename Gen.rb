require 'rubygems'
require 'bundler/setup'

class Gen

  attr_reader :genotipo
  
  def initialize()
    #@genotipo = genotipo
    #@genotipo = SecureRandom.random_number(21)
    @genotipo = rand(21)
    #inicializarGen()
  end

  def inicializarGen()
    @genotipo = SecureRandom.random_number(21)
  end

  def getGenotipo
    @genotipo
  end

end