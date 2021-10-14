# En Fenotipo se debe implementar el problema, es decir, el sistema de ecuaciones.
require 'rubygems'
require 'bundler/setup'
require 'matrix'

class Fenotipo

  attr_reader :matriz_A, :matriz_B, :matriz_sol

  def initialize(tamaño)
    @tamaño = tamaño

    @matriz_A = Array.new(@tamaño) { Array.new(@tamaño) {rand(0...10)} }
    @matriz_sol = Array.new(@tamaño) {rand(0...10)} 
    @matriz_B = Matrix[*@matriz_A] * Matrix.column_vector(@matriz_sol)

    ini_matrices()
  end
  
  def ini_matrices()
    puts "Matriz A:"
    @matriz_A.each { |x| puts x.join(' ') }
    
    puts "Matriz Solución: #{@matriz_sol}"
    
    puts "Matriz B: #{@matriz_B}"
  end

  def getMatrices()
    return @matriz_A, @matriz_B, @matriz_sol
  end

  # Retorna el resultado de matriz*vector
  # matriz: Matriz mxn
  # vector: vector columna mx1
  def multiply(matriz, vector)
    matrixA = Matrix[*matriz]
    vectorC = Matrix.column_vector(vector)

    return matrixA * vectorC
  end
  
  # Función auxiliar para ayudar con el escenario 4
  # devuelve x = A^(-1)*B en forma de arreglo tradicional
  def checkSol(m1, m2)
    result = Matrix[*m1].inverse * m2
    arr = []
    result.each_with_index{ |v,i| 
      arr[i] = v
    }
    return arr
  end
  
end

#feno = Fenotipo.new(4)
#puts feno.multiply(feno.matriz_A, feno.matriz_sol)