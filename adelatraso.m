function [Gadat,k,t1,t2,alfa,beta] = adelatraso(L,os,ts,Kc,sd,t2)
% [Gadat,k,t1,t2,alfa,beta] = ADELATRASO(L,sd) devuelve un compensador de 
% adelanto-atraso de 1 grado de libertad
if nargin<5
sd=puntosd(os,ts);
end
if nargin<6
    t2=10;
end
fase=pi-phase(evalfr(L,sd));   %obtiene la ganancia de fase necesaria en el punto
Gplanta=abs(evalfr(L,sd));             %obtiene la ganancia en el punto
K=Kc/kss(L);
ro=1/(K*Gplanta);
kapa=(abs(real(sd))/imag(sd))^2;                            %solo para calcular titamax
titamax=acos((ro-sqrt(kapa^2+kapa*(1-ro^2)))/(1+kapa));     %para ver cant de etapas
ceroad=real(sd)+imag(sd)*((ro-cos(fase))/sin(fase));
poload=real(sd)+imag(sd)*((ro*cos(fase)-1)/(ro*sin(fase)));
t1=1/ceroad;
alfa=ceroad/poload;
beta=1/alfa;
ceroat=-1/t2;
poloat=(ceroat/beta);
Gadat=zpk([ceroad ceroat],[poload poloat],K);

end