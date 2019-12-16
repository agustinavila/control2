G=zpk(-7,[-3 -5 roots([1 10 74])' roots([1 20 81])'],160)
Gss=ss(G)
[A,B,C,D]=ssdata(Gss)
n=length(A);
lambdasObs=[-14 -16 -10 -19 -17 -18];
F=diag(lambdasObs)
S=[1;2;3;1;2;3];
Co=ctrb(F,S)
R=rank(Co)

if R==n 
    disp('El par (F,S) es controlable')
else
    disp('El par (F,S) no es controlable')
end

T=sylvester(-F,A,S*C)

Ao=inv(T)*F*T;
Bo=[B inv(T)*S];
Co=eye(length(A));
Do=zeros(length(A),2);
Gobs=ss(Ao,Bo,Co,Do)

t=0:0.01:5; 
u=0*ones(length(t),1);
x0=[-1 2 -3 1 -0.5 -2]; %condiciones iniciales
[y,t,x]=lsim(Gss,u,t,x0);
[ye,t,xe]=lsim(Gobs,[u y]',t);
figure('Name','Evolucion de los estados y sus estimaciones');
title('Evolucion de todos los estados y sus estimaciones');
hold on;
% Grafico el estado 1 y sus estimaciones
subplot(2,3,1); 
plot(t,x(:,1),'k',t,xe(:,1),'b','LineWidth',1);
title('Estado 1');
grid on;
hold on;
legend('x1(t)','x_est1(t)');
% Grafico el estado 2 y sus estimaciones
subplot(2,3,2); 
plot(t,x(:,2),'k',t,xe(:,2),'b','LineWidth',1);
title('Estado 2');
grid on;
hold on;
legend('x2(t)','x_est2(t)');
% Grafico el estado 3 y sus estimaciones
subplot(2,3,3); 
plot(t,x(:,3),'k',t,xe(:,3),'b','LineWidth',1);
title('Estado 3');
grid on;
hold on;
legend('x3(t)','x_est3(t)');
% Grafico el estado 4 y sus estimaciones
subplot(2,3,4); 
plot(t,x(:,4),'k',t,xe(:,4),'b','LineWidth',1);
title('Estado 4');
grid on;
hold on;
legend('x4(t)','x_est4(t)');
% Grafico el estado 5 y sus estimaciones
subplot(2,3,5); 
plot(t,x(:,5),'k',t,xe(:,5),'b','LineWidth',1);
title('Estado 5');
grid on;
hold on;
legend('x5(t)','x_est5(t)');
% Grafico el estado 6 y sus estimaciones
subplot(2,3,6); 
plot(t,x(:,6),'k',t,xe(:,6),'b','LineWidth',1);
title('Estado 6');
grid on;
hold on;
legend('x6(t)','x_est6(t)');
