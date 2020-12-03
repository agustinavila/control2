function Gatraso = atrasodefase(K,Kc,T)
% Gatraso = ATRASODEFASE(K,Kc,T) realiza muy sencillamente un compensador
% de atraso de fase, siendo K la ganancia actual de la planta a controlar y
% Kc la ganancia deseada. T es un valor opcional (por defecto T=2) que 
% dicta que tan cerca del origen estaran ubicados el polo y cero.

%Agustin Avila
%diciembre 2020
%matlab r2020b

alfa=Kc/K;
if nargin<3
T=2;
end
Gatraso=zpk(-1/T,-1/(alfa*T),1);
end