#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'benchmark'

require_relative 'AlgoritmoGenetico'

def run(tamaño, metodo, generaciones)
  time = Benchmark.measure {
    algo = AlgoritmoGenetico.new(tamaño, metodo)
    sol = nil  
    for i in(0..generaciones) do
      sol = algo.medirAptitud(algo.poblacion, metodo)
      if (sol != nil)
        break
      else 
        ganadores = algo.torneo(algo.poblacion, 80)
        nuevos = algo.reproducir(ganadores)
        algo.poblacion = nuevos # Reemplazo
        algo.mutar(algo.poblacion) # Mutar hijos
      end
    end

    if (sol == nil)
      puts "No se encontró una solución absoluta. El mejor cromosoma en la última generación fue:"
      puts algo.bestCromosome.getGenes()
      puts "Su error cuadrático es de #{algo.getErrorIndividual(algo.bestCromosome)[0]}"
    end
  }
  puts "El tiempo de ejecuión fue de #{time.real}(s)"
end

puts "¿De qué dimensión desea que sea la matriz?"
tamaño = gets.chomp.to_i
puts "¿Qué metodo desea usar? (error cuadratico, diversidad o combinado)."
metodo = gets.chomp
puts "¿Cuantas generaciones desea correr?"
generaciones = gets.chomp.to_i

run(tamaño, metodo, generaciones)