require_relative 'CodigoGenetico.rb'

class Fenotipo

  def initialize(tamaño)
    @tamaño = tamaño
    @codigoGenetico = Array.new(10){[]}
    @matriz_A = Array.new(@tamaño){[]}
    @matriz_sol = Array.new(@tamaño)
    @matriz_B = Array.new(@tamaño) {0}
    ini_matrices()
    ini_Poblacion()
    medir_Aptitud_Torneo()
  end
  
  def ini_matrices()
    (0...@tamaño).each do |i|
      (0...@tamaño).each do |j|
        @matriz_A[i][j] = rand(0..10)
      end
      @matriz_sol[i] = rand(0..10)
    end

    (0...@tamaño).each do |i|
      (0...@tamaño).each do |j|
        @matriz_B[i] = @matriz_B[i] + (@matriz_A[i][j] * @matriz_sol[j])
      end
    end
    puts "Matriz A: #{@matriz_A}"
    puts "Matriz Solución: #{@matriz_sol}"
    puts "Matriz B: #{@matriz_B}"
  end
  

  def ini_Poblacion()
    (0...10).each do |i|
      (0...@tamaño).each do |j|
        @codigoGenetico[i][j] = rand(0..10)
      end
    end
    puts "Lista de 10 cromosomas: #{@codigoGenetico}"
  end

  def medir_Aptitud_Torneo()
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
        abort
      
      elsif(aptitud_cand2 == 0)
        puts "La respuesta final al sistema de ecuaciones es: #{candidato2}"
        puts "Mientras nuestra matriz solución es: #{@matriz_sol}"
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

end