G=zpk(-7,[-3 -5 roots([1 10 74])' roots([1 20 81])'],160)
Gss=ss(G)
[A,B,C,D]=ssdata(Gss);
[Acc,Bcc,Ccc,Dcc]= ss2ss(A,B,C,D,obsv(A,C))
Gcc1b=ss(Acc,Bcc,Ccc,Dcc)

w0=0.5;
P_ITAE5=[1 2.07*w0 4.5*w0^2 4.68*w0^3 3.26*w0^4 w0^5];
lambdas_des=[roots(P_ITAE5)' -7];
Kcc=place(Acc,Bcc,lambdas_des);
Abar=Acc-Bcc*Kcc; 
Bbar=Kcc(1)*Bcc; 
Cbar=Ccc; 
Dbar=Dcc;
Gss_cl=minreal(ss(Abar,Bbar,Cbar,Dbar));

t=0:0.001:15;
u=ones(1,length(t));
x0=[-1 -2 3 -3 -0.5];
x0=x0*.01; %se usaron cond iniciales mas pequeñas para que converja antes
[y0,t,x_salida]=lsim(Gcc1b,u,t);
[y0_cl,t,xcl_salida]=lsim(Gss_cl,u,t);
[y_itae,t,x_itae]=lsim(tf(w0^5,P_ITAE5),u,t);

figure(1);
plot(t,y0,'b','LineWidth',2);
hold on; grid on;
plot(t,y0_cl,'r','LineWidth',2)
plot(t,y_itae,'--k','LineWidth',2);
legend('respuesta sistema a lazo abierto','respuesta con controlador','respuesta polinomio ITAE','Location','NorthWest');
title('Respuesta del sistema con cond. iniciales nulas');

[y_x0,t,x_x0]=lsim(Gcc1b,u,t,[x0 -3]);
[ycl_x0,t,xcl_x0]=lsim(Gss_cl,u,t,x0);
figure(2);
plot(t,y_x0,'b','LineWidth',2);
hold on; grid on;
plot(t,ycl_x0,'--k')
legend('respuesta sistema a lazo abierto','respuesta con controlador','Location','NorthWest');
title('Respuesta del sistema con cond. iniciales distintas de cero');