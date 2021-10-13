#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require_relative 'AlgoritmoGenetico'

def run(tamaño)
  algo = AlgoritmoGenetico.new(tamaño)

  for i in(0..200) do
    algo.medirAptitud(algo.poblacion)
    ganadores = algo.torneo(algo.poblacion, 6)
    algo.reproducir(ganadores) #Aquí mismo se hace el reemplazo
    algo.mutar(algo.poblacion) # Mutar hijos
    algo.medirAptitud(algo.poblacion) # Medir aptitud de los hijos
  end
end

run(2)