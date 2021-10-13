# language: es
# encoding: utf-8
# Archivo: VerificarGA.feature
Característica: Verificar mutación, cruce uniforme, selección por torneo y un sistema 2x2 

    Escenario: Se genera una mutación en un cromosoma
        Dado que hay un cromosoma
        Cuando el cromosoma muta
        Entonces el nuevo cromosoma debe ser distinto a su padre

    Escenario: Se lleva a cabo un cruce uniforme
        Dado que hay una población de 2 cromosomas
        Cuando se cruzan uniformemente
        Entonces se generan 2 hijos nuevos


    Escenario: Ocurre selección por torneo
        Dado que hay una población de 10 cromosomas
        Cuando se seleccionan los mejores
        Entonces el mating pool tiene tamaño k<=10
