G=zpk(-7,[-3 -5 roots([1 10 74])' roots([1 20 81])'],160)
Gss=ss(G)
[A,B,C,D]=ssdata(Gss);
[Acc,Bcc,Ccc,Dcc]= ss2ss(A,B,C,D,obsv(A,C))
Gcc1b=ss(Acc,Bcc,Ccc,Dcc)
Aaa=Acc(1,1);
Aab=Acc(1,2:end);
Aba=Acc(2:end,1);
Abb=Acc(2:end,2:end);
Ba=Bcc(1);
Bb=Bcc(2:end);
lambdas_obs2=[-14 -16 -10 -19 -17];
L=acker(Abb',Aab',lambdas_obs2)';

Ahat=Abb-L*Aab;
Bhat=Ahat*L+Aba-L*Aaa;
Chat=[zeros(1,length(A)-1);eye(length(A)-1)];
Dhat=[1;L];
Fhat=Bb-L*Ba;


Gobs_r=ss( Ahat,[Bhat Fhat],eye(length(A)-1),zeros(length(A)-1,2));

t=[0:0.01:5];
u=zeros(length(t),1);
x0=[1 -2 3 2 -0.5 -1];%condiciones iniciales
x0=x0*.1
[y,t,x]=lsim(Gcc1b,u,t,x0);

% Simulamos el observador de estados y obtenemos los estados estimados
[z,t]=lsim(Gobs_r,[y u]',t);
z=z';
for i=1:length(t);
    xe(i,:)=Chat*z(:,i)+Dhat*y(i);
end;

% Graficación de los estados
% Grafico el estado 1 y sus estimaciones
subplot(2,3,1); plot(t,x(:,1),'k',t,xe(:,1),'b','LineWidth',1);
title('Estado 1');
grid on;
legend('x1(t)','x_e1(t)');
% Grafico el estado 2 y sus estimaciones
subplot(2,3,2); plot(t,x(:,2),'k',t,xe(:,2),'b','LineWidth',1);
title('Estado 2');
grid on;
legend('x2(t)','x_e2(t)');
% Grafico el estado 3 y sus estimaciones
subplot(2,3,3); plot(t,x(:,3),'k',t,xe(:,3),'b','LineWidth',1);
title('Estado 3');
grid on;
legend('x3(t)','x_e3(t)');
% Grafico el estado 4 y sus estimaciones
subplot(2,3,4); plot(t,x(:,4),'k',t,xe(:,4),'b','LineWidth',1);
title('Estado 4');
grid on;
legend('x4(t)','x_e4(t)');
% Grafico el estado 5 y sus estimaciones
subplot(2,3,5); plot(t,x(:,5),'k',t,xe(:,5),'b','LineWidth',1);
title('Estado 5');
grid on;
legend('x5(t)','x_e5(t)');