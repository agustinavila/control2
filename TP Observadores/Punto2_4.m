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
Gobs_r=ss(Ahat,[Bhat Fhat],eye(length(A)-1),zeros(length(A)-1,2))
w0=.5;
Pcd_itae5=[1 2.07*w0 4.5*w0^2 4.68*w0^3 3.26*w0^4 w0^5];
lambdas_des=[roots(Pcd_itae5)' -7];
Kcc=place(Acc,Bcc,lambdas_des);
Abar=Acc-Bcc*Kcc; 
Bbar=Kcc(1)*Bcc; 
Cbar=Ccc; 
Dbar=Dcc;
G_cl=minreal(ss(Abar,Bbar,Cbar,Dbar))
Acl2=[Acc-Bcc*Kcc*Dhat*Ccc -Bcc*Kcc*Chat; Bhat*Ccc-Fhat*Kcc*Dhat*Ccc Ahat-Fhat*Kcc*Chat];
Bcl2=[Bcc*Kcc(1); Fhat*Kcc(1)];
Ccl2=[Ccc zeros(1,n-1)];
Dcl2=0;
G_cl_obs=minreal(ss(Acl2,Bcl2,Ccl2,Dcl2))
x0_ss_cl=[x0, zeros(n-1,1)'];

t=0:0.001:15;
u=ones(1,length(t));
x0=[1 -2 3 -3 -0.5];%condiciones iniciales
x0=x0*.1;
[y,t,x]=lsim(Gcc1b,u,t);
[y_cl,t,xcl]=lsim(G_cl,u,t);
[y_cl_obs,t,x_cl_obs]=lsim(G_cl_obs,u,t);

figure(1);
plot(t,y,'b','LineWidth',2);
hold on; grid on;
plot(t,y_cl,'r','LineWidth',2);
plot(t,y_cl_obs,'--k','LineWidth',2);
%axis([0 15 0 1.2]);
legend('Salida a lazo abierto','Salida a lazo cerrado sin observador','Salida a lazo cerrado con controlador y observador','Location','NorthWest');
title('Respuesta de la planta para cond. iniciales nulas');

t=0:0.001:35;
u=ones(1,length(t));
[y,t,x]=lsim(Gcc1b,u,t,[x0 -3]);
[y_cl,t,xcl]=lsim(G_cl,u,t,x0);
[y_cl_obs,t,x_cl_obs]=lsim(G_cl_obs,u,t,x0);

figure(2);
plot(t,y,'b','LineWidth',2);
hold on; grid on;
plot(t,y_cl,'r','LineWidth',2);
plot(t,y_cl_obs,'--k','LineWidth',2);
legend('Salida a lazo abierto','Salida a lazo cerrado sin observador','Salida a lazo cerrado con controlador y observador','Location','NorthWest');
title('Respuesta de la planta para cond. iniciales no nulas');
