# Aquí se corre el algoritmo genetico, se halla la solución al problema.
require 'rubygems'
require 'bundler/setup'
require 'matrix'

require_relative 'Cromosoma'
require_relative 'Fenotipo'

class AlgoritmoGenetico

	attr_reader :poblacion

  def initialize(tamaño, metodo='error cuadratico')
    @tamaño = tamaño
    
	@fenotipo = Fenotipo.new(@tamaño)

	@matriz_A, @matriz_B, @matriz_sol = @fenotipo.getMatrices()
    
	@poblacion = ini_Poblacion(10)
	#puts "Lista de 10 cromosomas:"
	#puts @poblacion
	#ganadorTemprano = medirAptitud(@poblacion)

	#if (ganadorTemprano != nil)
	#	abort("Solución encontrada")
	#end
    #medir_Aptitud_Torneo()
  end
  
  # Inicializa una población de n cromosomas
  def ini_Poblacion(n)
    Array.new(n) { Cromosoma.new(@tamaño) }
  end

  # Asigna un valor de utilidad a la población dada.
  def medirAptitud(pool)
	for cromosoma in pool do
		valores = cromosoma.getGenes()
		resultado = Matrix[*@fenotipo.matriz_A] * Matrix.column_vector(valores)
		
		resta = resultado - @fenotipo.matriz_B
		restaArr = []
		resta.each_with_index {|val, index| 
			restaArr[index] = -val**2 # Se accede [fila, columna]
		}

		sum = 0
		# No usé array.sum() porque la versión de ruby que tengo no tiene ese metodo
		#puts restaArr
		restaArr.each { |a| sum += a } 

		cromosoma.aptitud = sum
	
		if (cromosoma.aptitud == 0)
			puts cromosoma.getGenes()
			abort('Solución encontrada')
		end
	end
	return nil
  end


  # Selección por torneo
  # es el sistema más rápido: se toman al azar 2 o 3
  # cromosomas, y se selecciona el que tenga mayor función de
  # aptitud. Se repite este procedimiento k veces.
  def torneo(pool, k)
	ganadores = Array.new(k)
	for i in 0...k do
	
		num1 = rand(0...pool.length)
		num2 = rand(0...pool.length)

		candidato1 = pool[num1]
		candidato2 = pool[num2]
		puts candidato1.aptitud
		
		if (candidato1.aptitud > candidato2.aptitud)
			ganadores[i] = candidato1
		elsif(candidato2.aptitud > candidato1.aptitud)
			ganadores[i] = candidato2
		else
			# Si hay empate, tirar moneda
			draw = [candidato1, candidato2]
			ganadores[i] = draw[rand(0..1)]
		end
	end

	return ganadores
  end

  # uniform crossover
  def reproducir(pool)
	for i in (0...pool.length).step(2) do
		padre = pool[i].genes
		madre = pool[i+1].genes
		hijo1 = []
		hijo2 = []
		
		for k in (0...@tamaño) do
			genes = [padre[k], madre[k]]
			hijo1[k] = genes[rand(0..1)]
			hijo2[k] = genes[rand(0..1)]
		end

		# Reemplaza padres por hijos
		pool[i] = hijo1
		pool[i+1] = hijo2
	end
  end

  def mutar(pool)
	for cromosoma in pool do
		moneda = rand(0..1)
		if (moneda == 1)
			cromosoma.mutate()
		end
	end
end
=begin
  def medir_Aptitud_Torneo()- @fenotipo.matriz_B
    ganadores = Array.new()
    candidato1 = Array.new(@tamaño)
    candidato2 = Array.new(@tamaño)
    matriz_B_cand1 = Array.new(@tamaño) {0}
    matriz_B_cand2 = Array.new(@tamaño) {0}
    aptitud_cand1 = 0
    aptitud_cand2 = 0
    num = 0
    (0...5).each do |i|
      num = rand(0...@codigoGenetico.length)
      candidato1 = @codigoGenetico[num]
      @codigoGenetico.delete_at(num)

      num = rand(0...@codigoGenetico.length)
      candidato2 = @codigoGenetico[num]
      @codigoGenetico.delete_at(num)

      (0...@tamaño).each do |i|
        (0...@tamaño).each do |j|
          matriz_B_cand1[i] = matriz_B_cand1[i] + (@matriz_A[i][j] * candidato1[j])
          matriz_B_cand2[i] = matriz_B_cand2[i] + (@matriz_A[i][j] * candidato2[j])
        end
      end

      (0...@tamaño).each do |i|
        aptitud_cand1 = aptitud_cand1 - ((matriz_B_cand1[i] - @matriz_B[i]) ** 2)
        aptitud_cand2 = aptitud_cand2 - ((matriz_B_cand2[i] - @matriz_B[i]) ** 2)
      end

      if(aptitud_cand1 == 0)
        puts "La respuesta final al sistema de ecuaciones es: #{candidato1}"
        puts "Mientras nuestra matriz solución es: #{@matriz_sol}"
        puts "Tiempo requerido: #{Time.now - @startTime}"
        abort
      
      elsif(aptitud_cand2 == 0)
        puts "La respuesta final al sistema de ecuaciones es: #{candidato2}"
        puts "Mientras nuestra matriz solución es: #{@matriz_sol}"
        puts "Tiempo requerido: #{Time.now - @startTime}"
        abort
      
      elsif(aptitud_cand1 > aptitud_cand2)
        ganadores.push(candidato1)
      else
        ganadores.push(candidato2)
      end

      puts "Candidato 1: #{candidato1}"
      puts "Matriz B Candidato 1: #{matriz_B_cand1}"
      puts "Aptitud: #{aptitud_cand1}"
      puts "Candidato 2: #{candidato2}"
      puts "Matriz B Candidato 2: #{matriz_B_cand2}"
      puts "Aptitud: #{aptitud_cand2}"

    end
    puts "Arreglo ganadores: #{ganadores}"
    cruce_mutacion(ganadores)
  end

  def cruce_mutacion(ganadores)
    arregloaux = Array.new()
    arregloaux2 = Array.new()
    candidato1 = Array.new(@tamaño)
    candidato2 = Array.new(@tamaño)
    arg = Array.new()
    (0...ganadores.length).each do |i|
      arregloaux.push(ganadores[i])
      arregloaux.push(ganadores[i])
    end
    puts "Arreglo para Cruce y Mutación: #{arregloaux}"

    (0...5).each do |i|
      aux = 0
      num = rand(0...arregloaux.length)
      candidato1 = arregloaux[num]
      arregloaux.delete_at(num)
      puts "Cand 1: #{candidato1}"

      num = rand(0...arregloaux.length)
      candidato2 = arregloaux[num]
      arregloaux.delete_at(num)
      puts "Cand 2: #{candidato2}"
      (0...@tamaño).each do |i|
        aux = rand(1..2)
        if(aux == 1)
          arg.push(candidato1[i])
        else
          arg.push(candidato2[i])
        end
      end
      puts "Cruce: #{arg}"
      aux = rand(0...@tamaño)
      arg[aux] = rand(0..10) 
      ganadores.push(arg)
      puts "Mutación: #{arg}"
      arg = []
    end

    #puts "#{ganadores}"
    @codigoGenetico = ganadores
    puts "#{@codigoGenetico}"
    medir_Aptitud_Torneo()

  end
=end

end