function [fase,ganancia] = analisisfase(sd,planta)
% ANALISISFASE(sd,planta) devuelve el atraso/adelanto de fase de una planta
% en un punto de interes sd.
% [fase,ganancia] = analisisfase(sd,planta) devuelve ambos valores.

% Agustin Avila
% Noviembre 2020
% Matlab r2020b
fase=phase(evalfr(planta,sd))*180/pi ;  %obtiene la ganancia de fase necesaria en el punto
ganancia=abs(evalfr(planta,sd));        %obtiene la ganancia en el punto
end
