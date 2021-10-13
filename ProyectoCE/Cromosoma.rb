require_relative 'Gen.rb' 

def Cromosoma
  
  def initialize(tamaño)
    @genes = []
    ini_Cromosoma(tamaño)
  end

  def ini_Cromosoma(tamaño)
    (0...tamaño).each do |i|
      @genes [i] = Gen.new()
    end
  end

end