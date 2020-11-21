function [polo,cero] = polocero(sd,tita,ops)
% POLOCERO(sd,tita) devuelve la ubicacion del polo y el cero de un
% compensador de adelanto de fase. Sin mas argumentos, utiliza el metodo de
% la bisectriz.
%
% POLOCERO(sd,tita,"real") utiliza la parte real del punto sd para
% localizar el polo y el cero.
%
% POLOCERO(sd,tita,sp) utiliza un punto dado (ej un polo dominante) para
% colocar el cero en ese punto y cancelarlo.
%
% Juan Agustin Avila
% Noviembre 2020
% Matlab r2020b

switch nargin
    case 3
        %parsear el tercer argumento
        disp("en contruccion")
        if strcmp("real",ops)
           disp("Calculando con el metodo de la parte real")
           cero=real(sd);
           titacero=phase(sd-cero)*180/pi;
           polo=real(sd)-imag(sd)*((1/tan((titacero-tita)*pi/180))+(1/tan(titacero*pi/180)));
        elseif isreal(ops)
            disp("cancelando el polo ubicado en "+ops)
            cero=ops;
            titacero=phase(sd-cero)*180/pi;
            partepolo=1/tan((titacero-tita)*pi/180);
            partecero=1/tan(titacero*pi/180);
            polo=real(sd)-imag(sd)*(abs(partepolo)+abs(partecero));
        else
            disp("Argumento invalido");
            return;
        end
    case 2
        %utiliza el metodo de la bisectriz
        TitaMax=phase(sd)*180/pi;               %obtiene el tita maximo para ese punto
        bisectriz=TitaMax/2;             %calcula bisectriz
        TitaPolo=bisectriz-(tita/2);     %obtiene angulo del polo
        TitaCero=bisectriz+(tita/2);     %obtiene angulo del cero
        polo= real(sd)-imag(sd)/tan(TitaPolo*pi/180); %obtiene posicion del polo
        cero= real(sd)-imag(sd)/tan(TitaCero*pi/180);%obtiene posicion del cero
    otherwise
        %print ayuda o algo asi.
        disp("le pifiaste hermano");
end




end