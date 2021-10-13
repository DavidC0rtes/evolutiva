require_relative 'Fenotipo.rb'

puts "De qué dimensión desea que sea la matriz?"
tamaño = gets.chomp.to_i
proyecto = Fenotipo.new(tamaño)
