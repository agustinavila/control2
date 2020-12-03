function Gadf = adelantofreq(planta,dseta,wn)
% Gadf = ADELANTOFREQ(planta,dseta,wn)
% Funcion que calcula un compensador de adelanto de fase para
% especificaciones frecuenciales dseta y wn. Hace falta previamente
% calcular los valores dseta y wn partiendo de alguna prestacion x
% Valores buenos de margen de fase y ganancia: fase entre 30 y 60°,
% ganancia entre 2 y 5

%Juan Agustin Avila
%Diciembre 2020
%Matlab r2020b

margenfase=atan(2*dseta/sqrt(sqrt(4*dseta^4+1)-2*dseta^2))*180/pi;  %calcula el margen de fase requerido
%wBW=wn*sqrt(1-2*dseta^2+sqrt((1-2*dseta^2)^2+1));   %no se usa?
%Gdeseado=tf(wn^2,[1 2*dseta*wn wn^2]);              %no se usa?
[MG,MF,wg,wc]=margin(planta);                       %obtiene los margenes de fase y ganancia de la planta
wcmin=wn*sqrt(sqrt(4*dseta^4+1)-2*dseta^2);         %Frecuencia minima en la cual se cumplen las especificaciones
wcl=max(wc,wcmin);                  %Frecuencia mayor entre la freq a 0db y la wcmin, frecuencia de cruce por cero
[magwcl,fasewcl]=bode(planta,wcl);  %analiza mag y fase para el punto anterior
titamax=margenfase-180-fasewcl;     %La maxima fase que tiene que entregar el compensador
n=1;
while 1
if titamax >70
    n=n+1;
    titamax=titamax/n;
    disp("el angulo es mayor a 70, probando con "+n+" etapas");
else
    break
end

alfa=(1-sind(titamax))/(1+sind(titamax));           %Marca la relacion entre polo y cero segun el angulo maximo a entregar
cero=-sqrt(alfa)*wcl;               %teniendo alfa, calcula cero
polo=-wcl/sqrt(alfa);               %y polo
Kc=1/(sqrt(alfa^n)*magwcl);        %Y obtiene la ganancia teniendo en cuenta la ganancia en la freq wcl
Gadf=zpk(cero*ones(1,n),polo*ones(1,n),Kc);

end