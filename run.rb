#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'benchmark'

require_relative 'AlgoritmoGenetico'

def run(tamaño, metodo)
  time = Benchmark.measure {
    algo = AlgoritmoGenetico.new(tamaño)

    for i in(0..100000) do
      foo = algo.medirAptitud(algo.poblacion, metodo)
      if (foo != nil)
        break
      else 
        ganadores = algo.torneo(algo.poblacion, 80)
        algo.reproducir(ganadores) #Aquí mismo se hace el reemplazo
        algo.mutar(algo.poblacion) # Mutar hijos
      end
    end
  }
  puts "Tiempo que tardó en hallar la solución: #{time.real}(s)"
end

puts "¿De qué dimensión desea que sea la matriz?"
tamaño = gets.chomp.to_i
puts "¿Qué metodo desea usar? (error cuadratico, diversidad o combinado)."
metodo = gets.chomp

run(tamaño, metodo)