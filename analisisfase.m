function grados = analisisfase(sd,polo,cero)
% ANALISISFASE(sd,polo,cero) devuelve el atraso/adelanto de fase que agrega
% el compensador en el punto de prueba sd.

% Agustin Avila
% Noviembre 2020
% Matlab r2020b
grados=(phase(sd-cero)-phase(sd-polo))*180/pi;

end
