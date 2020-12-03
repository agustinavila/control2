function [compensador1,sd] = adelantodefase(planta,os,ts,sd)
% [Gadelanto,sd]=ADELANTODEFASE(planta,os,ts,sd)
% devuelve la funcion de transferencia de un compensador de adelanto
% de fase con un oveshoot y tiempo de establecimiento dado, para
% la FTLA de la planta a controlar. sd es opcional para no utilizar los
% calculos propios del programa.

% Agustin Avila
% Noviembre 2020
% Matlab r2020b
if nargin < 4
    disp("no pusiste el punto sd");
    sd=puntosd(os,ts);
end
fase=180-phase(evalfr(planta,sd))*180/pi ;  %obtiene la ganancia de fase necesaria en el punto
Gplanta=abs(evalfr(planta,sd));             %obtiene la ganancia en el punto
n=1;
while 1
    try
        [polo,cero]=polocero(sd,fase/n,-3);              %obtiene polo y cero del compensador
        break;
    catch ME
        if(strcmp(ME.identifier,'Polocero:Titamax'))
            n=n+1;
            disp("El angulo a compensar es mayor a titamax, se utilizaran "+n+" etapas")
        end
    end
end
t=-1/cero(1) ;                                 %obtiene el t
alfa=-1/(polo(1)*t);                           %obtiene el alfa
pz=zpk(cero*ones(1,n),polo*ones(1,n),1);
gpz=abs(evalfr(pz,sd));
Kc=abs(1/(gpz*Gplanta)); %obtiene el kc
compensador1=pz*Kc;      %genera la ft
end

