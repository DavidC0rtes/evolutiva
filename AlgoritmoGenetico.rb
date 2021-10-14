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
    
	  @poblacion = ini_Poblacion(100)

    @mediaPoblacional = nil

  end
  
  # Inicializa una población de n cromosomas
  def ini_Poblacion(n)
    Array.new(n) { Cromosoma.new(@tamaño) }
  end

  # Asigna un valor de utilidad a la población dada.
  def medirAptitud(pool, metodo)
    toReturn = nil
    if (metodo == 'error cuadratico')
      toReturn = errorCuadratico(pool)
    elsif (metodo == 'diversidad')
      @mediaPoblacional = calcularMediaPoblacional(pool)
      toReturn = diversidad(pool)
    end

    return toReturn
  end

  def diversidad(pool)
    solution = nil
    interesantes = []
    for cromosoma in pool do
      valores = cromosoma.getGenes()
      sum = 0
      valores.each{ |x| sum += x}
      media = sum / @tamaño

      cromosoma.aptitud = (media - @mediaPoblacional).abs

      #puts "media poblacional es #{@mediaPoblacional}, la media del cromosoma es #{media}"

      if (cromosoma.aptitud >= 10)
        interesantes << cromosoma 
      end
    end
    # Se revisan los candidatos interesantes
    # a ver si alguno es solución
    for candidato in interesantes do
      solution = checkSolution(candidato)
      if (solution != nil)
        break
      end
    end

    return solution

  end


  def checkSolution(candidato)
    valores = candidato.getGenes()
    resultado = Matrix[*@fenotipo.matriz_A] * Matrix.column_vector(valores)

    diff = resultado - @fenotipo.matriz_B
    if (diff.zero?)
        puts "Solución propuesta: #{valores}"
        puts "Cuando se multiplica la solución propuesta con la matriz A, el resultado es: #{resultado}"
        puts ''
  
        puts "Solución real: #{@matriz_sol}"
        puts "El resultado debe dar #{@matriz_B}"
  
        return valores
    end
    return nil
  end

  def calcularMediaPoblacional(pool)
    acumm = 0

    for cromosoma in pool do
      val = cromosoma.getGenes()
      val.each{ |x| acumm += x }
    end

    return acumm / pool.length
  end


  # Calculo de aptitud usando error cuadrático
  def errorCuadratico(pool)
    for cromosoma in pool do
      valores = cromosoma.getGenes()
      resultado = Matrix[*@fenotipo.matriz_A] * Matrix.column_vector(valores)
      
      resta = resultado - @fenotipo.matriz_B
      restaArr = []
      resta.each_with_index {|val, index| 
        restaArr[index] = -val**2
      }
  
      sum = 0
      # No usé array.sum() porque la versión de ruby que tengo no tiene ese metodo
      #puts restaArr
      restaArr.each { |a| sum += a } 
  
      cromosoma.aptitud = sum
    
      if (cromosoma.aptitud == 0)
        puts "Solución propuesta: #{valores}"
        puts "Cuando se multiplica la solución propuesta con la matriz A, el resultado es: #{resultado}"
        puts ''
  
        puts "Solución real: #{@matriz_sol}"
        puts "El resultado debe dar #{@matriz_B}"
  
        return valores
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
		  #puts candidato1.aptitud
		
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

end