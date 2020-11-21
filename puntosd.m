function sd = puntosd(OS,Ts)
% PUNTOSD  devuelve el punto complejo que satisface
% las especificaciones temporales requeridas.
%
% PUNTOSD(os,ts) devuelve el punto complejo que cumple con los
% requerimientos de un overshoot(expresado porcentualmente, por ejemplo
% 20%) y un tiempo de establecimiento expresado en segundos.
%
% Juan Agustin Avila
% Noviembre 2020
% Matlab r2020b
a=(1/pi)*log(OS/100);
dseta=a/(sqrt(1+a^2));
wn=4/(dseta*Ts);
sd=-dseta*wn+abs((wn*sqrt(1-dseta^2)))*1i;

end