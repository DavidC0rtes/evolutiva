# Aquí se corre el algoritmo genetico, se halla la solución al problema.
require 'rubygems'
require 'bundler/setup'
require 'matrix'
require 'set'

require_relative 'Cromosoma'
require_relative 'Fenotipo'
require_relative 'Diversidad'

class AlgoritmoGenetico

	attr_accessor :poblacion
  attr_reader :bestCromosome

  def initialize(tamaño, metodo='error cuadratico', n=100)
    @tamaño = tamaño
    
	  @fenotipo = Fenotipo.new(@tamaño)

	  @matriz_A, @matriz_B, @matriz_sol = @fenotipo.getMatrices()
    
	  @poblacion = ini_Poblacion(n)

    @bestCromosome = @poblacion[rand(0...n)]

    if (metodo != 'error cuadratico')
      @diversidad = Diversidad.new
    end

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
      toReturn = diversidad(pool)
    elsif (metodo == 'combinado')
      toReturn = combinado(pool)
    end

    toReturn
  end

  def diversidad(pool)
    solution = nil
    interesantes = @diversidad.calcularDiversidad(pool)
   
    # Se revisan los candidatos interesantes a ver si alguno es solución
    for candidato in interesantes do
      solution = checkSolution(candidato)

      if (candidato.aptitud > @bestCromosome.aptitud)
        @bestCromosome = candidato
      end

      if (solution != nil)
        break
      end
    end

    solution
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
        #exit
    end
    return nil
  end

  # Calculo de aptitud usando error cuadrático
  def errorCuadratico(pool)
    solution = nil
    for cromosoma in pool do
  
      cromosoma.aptitud, resultado = getErrorIndividual(cromosoma)
    
      if (cromosoma.aptitud > @bestCromosome.aptitud)
        @bestCromosome = cromosoma
      end

      if (cromosoma.aptitud == 0)
        valores = cromosoma.getGenes()
        puts "Solución propuesta: #{valores}"
        puts "Cuando se multiplica la solución propuesta con la matriz A, el resultado es: #{resultado}"
        puts ''
  
        puts "Solución real: #{@matriz_sol}"
        puts "El resultado debe dar #{@matriz_B}"
  
        solution = valores
        break
      end
    end
    
    return solution
  end

  # Calcula que tan alejado esta un cromosoma individual
  # de la respuesta. Metodo de ayuda a errorCuadratico()
  def getErrorIndividual(cromosoma)
      valores = cromosoma.getGenes()
      resultado = Matrix[*@fenotipo.matriz_A] * Matrix.column_vector(valores)
      
      resta = resultado - @fenotipo.matriz_B
      restaArr = []
      resta.each_with_index {|val, index| 
        restaArr[index] = -val**2
      }
  
      sum = restaArr.sum()
      return sum, resultado
  end


  # Se divide la población en 2 aleatoriamente, generando una "bolsa" con
  # todos los posibles indices, se van sacando numeros de la bolsa al azar
  # hasta que ya no queden más indices. Se utiliza la clase Set de ruby.
  def combinado(pool)

    indices = Set[*(0...pool.length)]

    lista1 = randn(pool.length/2, pool.length)
    lista2 = indices - lista1
    
    pool1 = pool2 = []
    for i in lista1 do
      pool1.push( pool[i] ) 
    end

    for i in lista2 do
      pool2.push( pool[i] )
    end

    sol1 = errorCuadratico(pool1)
    sol2 = diversidad(pool2)

    if (sol1 != nil)
      return sol1
    elsif (sol2 != nil)
      return sol2
    end
  end


  def randn(n, max)
    randoms = Set.new
    loop do
        randoms << rand(max)
        return randoms if randoms.size >= n
    end
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
		
      if (candidato1.aptitud == nil || candidato2.aptitud == nil)
        puts candidato1.inspect
        puts candidato2.inspect
        abort('error aptitud nula')
      end

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
    poblacionNueva = []

	  for i in (0...pool.length).step(2) do
		  padre = pool[i].genes
		  madre = pool[i+1].genes
      # Se inicializan los hijos a instancias
      # de la clase Cromosoma, inicialmente
      # no importa que se le asignen genes.
		  hijo1 = Cromosoma.new(@tamaño)
		  hijo2 = Cromosoma.new(@tamaño)
		
		  for k in (0...@tamaño) do
			  genes = [padre[k], madre[k]]
			  hijo1.genes[k] = genes[rand(0..1)]
			  hijo2.genes[k] = genes[rand(0..1)]
		  end

		  # Reemplaza padres por hijos
		  poblacionNueva[i] = hijo1
		  poblacionNueva[i+1] = hijo2
	  end

    return poblacionNueva # Pongo esto para el escenario de cucumber
  end

  def mutar(pool)
	  for cromosoma in pool do
		  moneda = rand(0..1)
		  if (moneda == 1)
			  cromosoma.mutate()
		  end
	  end
  end

  def replace(poblacionNueva)
    @poblacion = poblacionNueva
  end


end

#algo = AlgoritmoGenetico.new(2, 'error_cuadratico', 2)
#algo.poblacion.each{ |cromo| puts cromo.getGenes()}