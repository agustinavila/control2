function [k1,k2]=kss(L)
% [k1,k2]=kss(L) devuelve la ganancia estacionaria para
% rampa y aceleracion
k1=dcgain(minreal(L*tf([1 0],1)));
k2=dcgain(minreal(L*tf([1 0 0],1)));
end