G=zpk(-7,[-3 -5 roots([1 10 74])' roots([1 20 81])'],160)
Gss=ss(G)
[A,B,C,D]=ssdata(Gss)
Aa=[A zeros(length(A),1); -C 0];
Ba=[B; 0];
Ca=[C 0];
Da=D;

w0=0.5;
P_ITAE = [1 2.15*w0 5.63*(w0)^2 6.93*(w0)^3 6.79*(w0)^4 3.74*(w0)^5 (w0)^6];
lamb_deseados=[roots(P_ITAE)' -7]

Ka=acker(Aa,Ba,lamb_deseados);

Acl=Aa-Ba*Ka
Bcl=[zeros(length(B),1); 1];
Ccl=Ca;
Dcl=Da;

Gss_cl=minreal(ss(Acl,Bcl,Ccl,Dcl))

t=0:0.001:55;
u=ones(length(t),1);
x0=[1 -2 3 2 -0.5 -1];%condiciones iniciales
x0=x0*.001
[y0,t,x_salida]=lsim(Gss,u,t);
[y0_cl,t,xcl_salida]=lsim(Gss_cl,u,t);
[y_itae,t,x_itae]=lsim(tf(w0^6,P_ITAE),u,t);

figure(1);
plot(t,y0,'b','LineWidth',2);
hold on; grid on;
plot(t,y0_cl,'r','LineWidth',2)
plot(t,y_itae,'--k','LineWidth',2);
legend('respuesta sistema a lazo abierto','respuesta con controlador','respuesta polinomio ITAE','Location','NorthWest');
title('Respuesta del sistema con cond. iniciales nulas');

[y_x0,t,x_x0]=lsim(Gss,u,t,x0);
[ycl_x0,t,xcl_x0]=lsim(Gss_cl,u,t,x0);

figure(2);
plot(t,y_x0,'b','LineWidth',2);
hold on; grid on;
plot(t,ycl_x0,'--k')
legend('respuesta sistema a lazo abierto','respuesta con controlador','Location','NorthWest');
title('Respuesta del sistema con cond. iniciales distintas de cero');


