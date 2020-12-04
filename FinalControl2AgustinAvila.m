%% Examen final control 2
% Juan Agustin Avila

%%Punto 1:
%Considere el sistema a lazo cerrado con realimentación unitaria.

G=zpk([],[0 -5 -10],1)
%% Punto a: Halle el valor de K para que la sobreelongacion sea del 20%
stepinfo(feedback(G,1))
OS=20
a=-(1/pi)*log(20/100);
dseta=a/(sqrt(1+a^2))
sd=-asin(dseta)+acos(dseta)*1i;
x=-10:0.1:0;
y=-1/dseta*x;
rlocus(G);hold on;
plot(x,y);
%sd=ginput();
%sd=sd(1)+sd(2)*i
% El punto sd perteneciente al lugar de las raices es
sd = -1.5405 + 3.3070i
%%
K=1/abs(evalfr(G,sd));
%K=K*.96;
R=rlocus(G,K);
G2=zpk([],[0 -5 -10],K)

%% Punto b: Para el sistema con el valor de K hallado anteriormente 
% determinar el tiempo del primer pico Tp y constante
% estática del error al escalón K1. 
FTLC=feedback(G2,1);
info=stepinfo(FTLC);
Tp=info.PeakTime;
disp("El tiempo del primer pico es de "+Tp);
rampa=tf([1 0],1);
Kv=dcgain(minreal(G2*rampa)) %La planta es tipo 1, anulo el polo en cero y analizo la ganancia estatica

%% Punto 2:Diseñar un compensador de adelanto-atraso con el lugar de las 
% raíces que cumpla con las siguientes especificaciones:
% a) Máxima sobreelongación: La misma obtenida en el punto 1 (20%).
% b) Tiempo de primer pico: Tres veces menor que el hallado en el punto 1.
% c) Constante estática del error al escalón: Cinco veces mayor la determinada en el punto 1.
Tpn=Tp/3;
Kc=5*Kv;
%el dseta es el mismo que en el punto anterior
wn=pi/(Tpn*sqrt(1-dseta^2));    %wn cuando la especificacion es el tiempo de pico
sd=-dseta*wn+abs((wn*sqrt(1-dseta^2)))*1i;
% fase=pi-phase(evalfr(G,sd));   %analizo la ganancia de fase a compensar en el punto sd
% kapa=(abs(real(sd))/imag(sd))^2;%solo para calcular titamax
% titamax=phase(acos((ro-sqrt(kapa^2+kapa*(1-ro^2)))/(1+kapa)));     %para ver cant de etapas
% if(fase<titamax) disp("Se puede realizar en una etapa");end;
% Gplanta=abs(evalfr(G,sd));     %obtengo la ganancia en el punto
% K=5; %Directamente es 5, es el deseado sobre el real
% ro=1/(K*Gplanta);
% ceroad=real(sd)+imag(sd)*((ro-cos(fase))/sin(fase));
% poload=real(sd)+imag(sd)*((ro*cos(fase)-1)/(ro*sin(fase)));
% t1=1/ceroad;
% alfa=ceroad/poload;
% beta=1/alfa;
% ceroat=-1/10;
% poloat=(ceroat/beta);
% Gcomp=zpk([ceroad ceroat],[poload poloat],K)

%% No pude realizarlo con 1gdl, asi que hice primero uno de adelanto y luego uno de atraso
titamax=phase(sd)*180/pi;
fase=180-phase(evalfr(G,sd))*180/pi ;  %obtengo la ganancia de fase necesaria en el punto
Gplanta=abs(evalfr(G,sd));             %obtengo la ganancia en el punto        
titapolo=(titamax-fase)/2;     %obtengo angulo del polo
titacero=(titamax+fase)/2;     %obtengo angulo del cero
polo= real(sd)-imag(sd)/tan(titapolo*pi/180); %obtengo posicion del polo
cero= real(sd)-imag(sd)/tan(titacero*pi/180);%obtengo posicion del cero
pz=zpk(cero,polo,1);    %armo la ft sin la ganancia
gpz=abs(evalfr(pz,sd)); %evaluo la ganancia para ese punto
Kc=abs(1/(gpz*Gplanta));%Y obtengo la ganancia del controlador
Gadelanto=pz*Kc
%compensador de atraso
alfa=K;
T=10;
Gatraso=zpk((-1/T),(-1/(alfa*T)),1)
Gcomp=Gadelanto*Gatraso;
Gtotal=Gcomp*G;
FTLC=feedback(Gtotal,1);
stepinfo(FTLC)

%% Punto 3: servosistema tipo 1 con esquema de ogata
[A,B,C,D]=ssdata(G)
Gcc1b=ss2ss(ss(G),obsv(ss(G)));
[Acc,Bcc,Ccc,Dcc]=ssdata(Gcc1b)
lambdas=[sd conj(sd) -15];
K=place(Acc,Bcc,lambdas)
Gcomp=ss(Acc,Bcc*K(1),Ccc,Dcc)
t=0:.01:1;
y=t;
[Y,t,X]=lsim(Gcomp,y,t)
plot(t,y,t,Y)
