Dado (/^que hay un cromosoma$/) do
  @Cromosoma = Cromosoma.new(4)
  @padre = @Cromosoma.getGenes
end

Cuando (/^el cromosoma muta$/) do
  @Cromosoma.mutate()
end

Entonces (/^el nuevo cromosoma debe ser distinto a su padre$/) do
  hijo = @Cromosoma.mutate()
  expect(hijo).not_to eq @padre
end

Dado (/^que hay una población de (.+?) cromosomas$/) do |n|
  @AlgoritmoGenetico = AlgoritmoGenetico.new(n.to_i)
end

Cuando (/^se cruzan uniformemente$/) do
  @AlgoritmoGenetico.crossover()
end

Entonces (/^se generan (.+?) hijos nuevos$/) do |nhijos|
  @AlgoritmoGenetico.getPopulation().length() == nhijos.to_i * 2
end

Cuando(/^se seleccionan los mejores$/) do
  @matingPool = @AlgoritmoGenetico.doSelection()
end

Entonces(/^el mating pool tiene tamaño k<=(.+?)$/) do |n|
  expect(@matingPool.length).to be <= n.to_i
end
