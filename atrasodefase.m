function Gatraso = atrasodefase(L,K,Kc,T)
alfa=Kc/K;
if nargin<4
T=2;
end
Gatraso=zpk(-1/T,-1/(alfa*T),1);
end