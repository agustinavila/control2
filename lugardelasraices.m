function [centroide,angulos,raices,salida,llegada,routha]=lugardelasraices(L)
% analisis paso a paso del lugar de las raices
% [centroid,asint,p_quiebre,angsalida,angllegada,routh]=LUGARDELASRAICES(L)
%
% Esta funcion calcula y imprime en pantalla los distintos pasos para
% graficar el lugar de las raices segun las instrucciones de la catedra.
% seguro no es infalible pero en principio anda. Hay que pasarle como
% argumento la FTLA de la planta a analizar con el parametro k
% multiplicando al numerador.

% Agustin Avila
% diciembre 2020
% Matlab r2020b


syms k;
[num,den]=tfdata(L,'v');    %obtiene numerador y denom como vectores
pc=num*k+den;
[p,z]=pzmap(L);
disp("1 - Cantidad de ramas: "+length(p));
disp("2 - El lugar debe ser simetrico respecto al eje real");
disp("3 - Segmentos reales:");
pz=sort([p' z']);
reales=[];
for i=1:length(pz)
    if isreal(pz(i))
        reales=[reales pz(i)];
    end
end
reales=fliplr(reales);
for i=1:2:length(reales)
    try
        superior=reales(i+1);
    catch exception
        superior=-inf;
    end
    disp("Es parte del eje real entre "+reales(i)+" y "+superior);
end
disp("4 - Puntos de comienzo y final de las ramas:");
try
    difpolocero=length(p)-length(z);
    disp("Puntos de origen:");
    disp(p);
    disp("Puntos de llegada:");
    disp(z);
    disp(inf*ones(difpolocero,1));
    disp("5 - comportamiento en el inf (asintotas):");
    centroide=(sum(p)-sum(z))/difpolocero;
    angulos=[];
    for k=1:difpolocero
        angulos=[angulos mod(((2*k)+1)*180/difpolocero,360)];
    end
    angulos=sort(angulos);
    disp("Hay "+difpolocero+" asintotas:");
    disp("Hay una asintota con centroide en "+centroide+" y angulo "+angulos'+"°");
    %polos=ones(1,difpolocero)*centroide;
    %L_asintota=zpk([],polos,1);
catch exception
    disp("No se pudo calcular las asintotas");
end

disp("6 - Conservacion de la suma de las raices:");
%chequea los lugares, no se si se pueden evaluar con rlocus
%K=0:.01:100;
%rlocus(L,K)

disp("7 - puntos de ruptura en el eje real:");
syms s;
ecpolo=0;eccero=0;
for i=1:length(p)
    ecpolo=ecpolo+(1/(s-p(i)));
end
for i=1:length(z)
    eccero=eccero+(1/(s-z(i)));
end
try
    [numpolo denpolo]=numden(collect(ecpolo));
    try
    [numcero dencero]=numden(collect(eccero));
    catch exception
        numcero=1;dencero=1;
    end
    ecuacion=collect((numpolo*dencero)-(numcero*denpolo));
    ecuacion=coeffs(ecuacion,s,'All');
    %ecuacion=fliplr(ecuacion);
    raices=double(roots(ecuacion));
    disp("Los puntos de ruptura están en:");
    disp(real(raices));
    disp("(Revisar que esten dentro del trayecto sobre el eje real)");
catch exception
    disp("No hay puntos de ruptura");
end
[routha]=routh(pc,eps);

disp("8 - Angulos de salida y llegada");
salida=zeros(1,length(p));
llegada=zeros(1,length(z));
for i=1:length(p)
    for j=1:length(p)
        if i~=j
            %calcula
            salida(i)=salida(i)-phase(p(i)+.001-p(j));
        end
    end
    for j=1:length(z)
        %calcula
        salida(i)=salida(i)+phase(p(i)+.001-z(j));
    end
    salida(i)=(salida(i)*180/pi)-180;
    salida(i)=mod(salida(i),360);
    disp("El angulo de salida para el polo en "+p(i)+" es "+salida(i)+"°");
end

for i=1:length(z)
    for j=1:length(z)
        if i~=j
            %calcula
            llegada(i)=llegada(i)+phase(z(i)+.001-z(j));
        end
    end
    for j=1:length(p)
        %calcula
        llegada(i)=llegada(i)-phase(z(i)+.001-p(j));
    end
    llegada(i)=(llegada(i)*180/pi)-180;
    llegada(i)=mod(llegada(i),360);
    disp("El angulo de llegada para el cero en "+z(i)+" es "+salida(i)+"°");
end
disp(" ");
disp("9 - Cruces de las ramas por el eje imaginario");
[routha]=routh(pc,eps)
disp("Ahi tenes el routh, hacelo a mano");

disp("10 - calibrado del lugar de las raices");
disp("El LR debe cumplir las cond de ganancia y fase");

end
