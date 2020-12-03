# control2

Programas y trabajos escritos para la materia control 2

## adelantodefase()

[Gadelanto,sd]=ADELANTODEFASE(planta,os,ts,sd) devuelve la funcion de transferencia de un compensador de adelanto de fase con un oveshoot y tiempo de establecimiento dado, para  la FTLA de la planta a controlar. sd es opcional para no utilizar los calculos propios del programa.

## adelatraso()

[Gadat,k,t1,t2,alfa,beta] = ADELATRASO(L,os,ts,Kc,sd,t2) devuelve un compensador de adelanto-atraso de 1 grado de libertad, siendo obligatorio pasarle la planta L, el porcentaje de overshot OS, el tiempo de establecimiento ts y la ganancia estatica Kc (cabe aclarar que ahora calcula para plantas tipo rampa, habria que modificar como calcula). Además se puede llamar con un punto especifico sd deseado, y con T2 que seria el grado de libertad disponible.

## analisisfase()

ANALISISFASE(sd,planta) devuelve el atraso/adelanto de fase de una planta en un punto de interes sd.
[fase,ganancia] = analisisfase(sd,planta) devuelve ambos valores.

## atrasodefase()

Gatraso = ATRASODEFASE(K,Kc,T) realiza muy sencillamente un compensador de atraso de fase, siendo K la ganancia actual de la planta a controlar y Kc la ganancia deseada. T es un valor opcional (por defecto T=2) que dicta que tan cerca del origen estaran ubicados el polo y cero.  
