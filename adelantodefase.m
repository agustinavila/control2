function [compensador1,sd] = adelantodefase(planta,os,ts,sd)
% [Gadelanto,sd]=ADELANTODEFASE(planta,os,ts) 
% devuelve la funcion de transferencia de un compensador de adelanto
% de fase con un oveshoot y tiempo de establecimiento dado, para 
% la FTLA de la planta a controlar

% Agustin Avila
% Noviembre 2020
% Matlab r2020b
if nargin < 4
    disp("no pusiste el punto sd");
sd=puntosd(os,ts);
end
fase=180-phase(evalfr(planta,sd))*180/pi ;  %obtiene la ganancia de fase necesaria en el punto
Gplanta=abs(evalfr(planta,sd));             %obtiene la ganancia en el punto
try
    [polo,cero]=polocero(sd,fase);              %obtiene polo y cero del compensador
catch ME
    if(strcmp(ME.identifier,'Polocero:Titamax'))
        disp("El angulo a compensar es mayor a titamax, se utilizaran dos polos y dos ceros")
        [polo,cero]=polocero(sd,fase/2);
        polo=[polo polo];
        cero=[cero cero];
    end
end
t=-1/cero(1) ;                                 %obtiene el t
alfa=-1/(polo(1)*t);                           %obtiene el alfa
Kc=abs((alfa*t*sd)+1)/(alfa*abs((t*sd)+1)*Gplanta); %obtiene el kc
compensador1=zpk(cero,polo,Kc);             %genera la ft
end

