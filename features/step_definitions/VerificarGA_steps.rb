Dado (/^que hay un cromosoma$/) do
  @Cromosoma = Cromosoma.new(4)
  @padre = @Cromosoma.getGenes()
end

Cuando (/^el cromosoma muta$/) do
  @Cromosoma.mutate()
end

Entonces (/^el nuevo cromosoma debe ser distinto a su padre$/) do
  hijo = @Cromosoma.mutate()
  expect(hijo).not_to eq @padre
end

Dado (/^que hay una población de (.+?) cromosomas$/) do |n|
  @numPoblacionInicial = n.to_i
  @AlgoritmoGenetico = AlgoritmoGenetico.new(2, 'error cuadratico', n.to_i)
  @PI = @AlgoritmoGenetico.poblacion
end

Cuando (/^se cruzan uniformemente$/) do
  @nuevos = @AlgoritmoGenetico.reproducir(@PI)
end

Entonces (/^se generan (.+?) hijos nuevos que reemplazan a sus padres$/) do |nhijos|
  expect(@nuevos.length).to be == @numPoblacionInicial
  puts "hola"
  expect(@nuevos).not_to eq @PI
end

Cuando(/^se seleccionan los mejores$/) do
  @AlgoritmoGenetico.medirAptitud(@PI, 'error cuadratico')
  @matingPool = @AlgoritmoGenetico.torneo(@PI, 8)
end

Entonces(/^el mating pool tiene tamaño k<(.+?)$/) do |n|
  expect(@matingPool.length).to be < n.to_i
end

Dado(/^que existe un sistema de ecuaciones 2x2$/) do
  @feno = Fenotipo.new(2)
end

Entonces(/^el sistema tiene solución$/) do
  result = @feno.checkSol(@feno.matriz_A, @feno.matriz_B)
  expect(result).to eq @feno.matriz_sol
end
