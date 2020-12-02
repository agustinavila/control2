function [fase,ganancia] = analisisfase(sd,planta)
% ANALISISFASE(sd,polo,cero) devuelve el atraso/adelanto de fase que agrega
% el compensador en el punto de prueba sd.

% Agustin Avila
% Noviembre 2020
% Matlab r2020b
fase=phase(evalfr(planta,sd))*180/pi ;  %obtiene la ganancia de fase necesaria en el punto
ganancia=abs(evalfr(planta,sd));             %obtiene la ganancia en el punto
end
