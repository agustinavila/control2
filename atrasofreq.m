function Gatf = atrasofreq(planta,Kn,margenfase)
% Gatf = atrasofreq(planta,Kn,margenfase)
% Funcion que calcula un compensador de atraso de fase para
% especificaciones frecuenciales
% margenfase es opcional.

%Juan Agustin Avila
%Diciembre 2020
%Matlab r2020b

%K es la ganancia de la planta, Kn es la ganancia deseada
Klag=Kn/dcgain(planta); %si es planta tipo 1 deberia ser kss
alfa=1/Klag;
[~,~,~,wc]=margin(planta);
if nargin==3
    cota_del_error=0.1;
    delta_w=0.001;
    error=inf;
    delta=6;
    wc_new=wc;
    while abs(error) > cota_del_error && wc_new>.001
        [~,fase]=bode(G1,wc_new); 
        error=fase+(180-margenfase-delta);
        wc_new = wc_new-delta_w;
    end  % while
    wc=wc_new;
end
cero=-wc/10;    %el polo esta una decada abajo de wc
polo=cero/alfa; %el polo esta relacionado con el cero por alfa
Gatf=zpk(cero,polo,1);
end