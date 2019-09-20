function [compensador1] = adelantodefase(planta,os,ts)
%Funcion que determina un compensador de adelanto de fase
% Dandole como entrada la ftla de la planta a controlar,
% el porcentaje de sobreimpulso y el tiempo de establecimiento
d = sqrt(1/(1+(1/(1/(1/(log(os/100)/pi))^2))));  %obtiene el d a partir del os
wn=4/(d*ts)              ;                   %obtiene el wn
sd=-wn*d+wn*sqrt((d^2)-1);                   %con el wn, obtiene el polo deseado
P=pole(planta);                              %obtiene los polos
Z=zero(planta);                             %obtiene los ceros
fase=180-phase(evalfr(planta,sd))*180/pi ;  %obtiene la ganancia de fase necesaria en el punto
Gplanta=abs(evalfr(planta,sd));             %obtiene la ganancia en el punto
TitaMax=180-(acos(d)*180/pi);               %obtiene el tita maximo para ese punto
if(TitaMax<fase)
    fprintf('El angulo requerido es mayor al que puede adelantar un solo filtro\n');
    %aca deberia manejar para hacer dos filtros
    %tendria que dividir fase en N y a la disposicion de filtros, agregarle
    %coso
end
bisectriz=TitaMax/2;                        %calcula bisectriz
TitaPolo=bisectriz-(fase/2);                %obtiene angulo del polo
TitaCero=bisectriz+(fase/2);                %obtiene angulo del cero
polo= -(-real(sd)+(imag(sd)/tan(TitaPolo*pi/180))); %obtiene posicion del polo
cero= -(-real(sd)+(imag(sd)/tan(TitaCero*pi/180))); %obtiene posicion del cero
t=-1/cero ;                                 %obtiene el t
alfa=-1/(polo*t);                           %obtiene el alfa
Kc=abs((alfa*t*sd)+1)/(alfa*abs((t*sd)+1)*Gplanta); %obtiene el kc
compensador1=zpk(cero,polo,Kc);             %genera la ft
%de aca para abajo es para comprobar resultados
ftla=planta*compensador1;                   %para probarlo, las pone en serie
ftlc=feedback(ftla,1);                      %obtiene ftlc
[p z]=pzmap(ftlc)  ;                         %obtiene ubicacion de polos y ceros
stepinfo(ftlc)                              %se fija si cumple los requisitos
end

