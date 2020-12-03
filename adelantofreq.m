function Gadf = adelantofreq(planta,dseta,wn)
% Gadf = ADELANTOFREQ(planta,dseta,wn)
% Funcion que calcula un compensador de adelanto de fase para
% especificaciones frecuenciales dseta y wn

%Juan Agustin Avila
%Diciembre 2020
%Matlab r2020b

margenfase=atan(2*dseta/sqrt(sqrt(4*dseta^4+1)-2*dseta^2))*180/pi;
wBW=wn*sqrt(1-2*dseta^2+sqrt((1-2*dseta^2)^2+1));%no se usa
Gdeseado=tf(wn^2,[1 2*dseta*wn wn^2]);  %no se usa
[MG,MF,wg,wc]=margin(planta);
wcmin=wn*sqrt(sqrt(4*dseta^4+1)-2*dseta^2);
wcl=max(wc,wcmin);
[magwcl,fasewcl]=bode(planta,wcl);
titamax=margenfase-180-fasewcl;
alfa=(1-sind(titamax))/(1+sind(titamax));
cero=-sqrt(alfa)*wcl;
polo=-wcl/sqrt(alfa);
Kc=sqrt(alfa)/(alfa*magwcl);
Gadf=zpk(cero,polo,Kc);

end