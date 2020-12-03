function [polo,cero,titamax] = polocero(sd,tita,ops)
% POLOCERO(sd,tita) devuelve la ubicacion del polo y el cero de un
% compensador de adelanto de fase. Sin mas argumentos, utiliza el metodo de
% la bisectriz.
%
% POLOCERO(sd,tita,"real") utiliza la parte real del punto sd para
% localizar el polo y el cero.
%
% POLOCERO(sd,tita,sp) utiliza un punto dado (ej un polo dominante) para
% colocar el cero en ese punto y cancelarlo.

% Juan Agustin Avila
% Noviembre 2020
% Matlab r2020b
titamax=phase(sd)*180/pi;
if(titamax<tita)
    error('Polocero:Titamax',"El angulo a compensar es mayor al maximo angulo permitido, es necesario dos compensadores");
end
switch nargin
    case 3
        %parsear el tercer argumento
        if strcmp("real",ops)
            %disp("Calculando con el metodo de la parte real")
            cero=real(sd);
        elseif isreal(ops)
            %disp("cancelando el polo ubicado en "+ops)
            cero=ops;
        else
            error('Polocero:arginvalido',"Argumento invalido");
        end
        titacero=phase(sd-cero)*180/pi;
        if titacero<tita
            error('Polocero:ceromin',"el cero es menor al valor minimo de cero realizable (%.5f)",real(sd)-imag(sd)/tan(tita*pi/180))
        end
        polo=real(sd)-imag(sd)*(1/tan((titacero-tita)*pi/180));
    case 2
        %utiliza el metodo de la bisectriz
        titapolo=(titamax-tita)/2;     %obtiene angulo del polo
        titacero=(titamax+tita)/2;     %obtiene angulo del cero
        polo= real(sd)-imag(sd)/tan(titapolo*pi/180); %obtiene posicion del polo
        cero= real(sd)-imag(sd)/tan(titacero*pi/180);%obtiene posicion del cero
    otherwise
        %print ayuda o algo asi.
        error('Polocero:arginvalido',"Argumento invalido");
end
end