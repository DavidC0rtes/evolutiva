require 'rubygems'
require 'bundler/setup'

require_relative 'Cromosoma'

class Diversidad

	def calcularDiversidad(pool)
		solution = nil
		interesantes = []
		
		mediaPoblacional = calcularMediaPoblacional(pool)

		for cromosoma in pool do
			valores = cromosoma.getGenes()
		  
		  	media = valores.sum() / valores.length
	
		  	cromosoma.aptitud = (media - mediaPoblacional).abs
	
		  	#puts "media poblacional es #{@mediaPoblacional}, la media del cromosoma es #{media}"
	
		 	if (cromosoma.aptitud >= 10)
				#puts "El cromosoma #{cromosoma} es intersante #{cromosoma.aptitud}" 
				interesantes << cromosoma 
		  	end
		end

		return interesantes

	end

	def calcularMediaPoblacional(pool)
		acumm = 0
	
		for cromosoma in pool do
		  val = cromosoma.getGenes()
		  acumm += val.sum() # Comentar esta línea si está usando ruby < 2.4
		  #val.each{ |x| acumm += x } Descomentar esta línea si esta usando ruby < 2.4
		end
	
		return acumm / pool.length
	  end

end