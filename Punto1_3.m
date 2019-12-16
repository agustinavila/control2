G=zpk(-7,[-3 -5 roots([1 10 74])' roots([1 20 81])'],160)
Gss=ss(G)
[A,B,C,D]=ssdata(Gss);
n=length(A);
lamb_obs=[-14 -16 -10 -19 -17 -18 ];
lamb_obs=lamb_obs*2
F=diag(lamb_obs);
S=[1;2;3;1;2;3];
Cont=ctrb(F,S);
R=rank(Cont);

if R==n 
    disp('El par (F,S) es controlable')
else
    disp('El par (F,S) no es controlable')
end

T=sylvester(-F,A,S*C);
Aobs=inv(T)*F*T;
Bobs=[B inv(T)*S];
Cobs=eye(length(A));
Dobs=zeros(length(A),2);
Gobs=ss(Aobs,Bobs,Cobs,Dobs);
Aa=[A zeros(length(A),1); -C 0];
Ba=[B; 0];
Ca=[C 0];
Da=D;
w0=0.5;
P_ITAE = [1 2.15*w0 5.63*(w0)^2 6.93*(w0)^3 6.79*(w0)^4 3.74*(w0)^5 (w0)^6];
lamb_deseados=[roots(P_ITAE)' -7]
Ka=acker(Aa,Ba,lamb_deseados);
Acl=Aa-Ba*Ka;
Bcl=[zeros(length(B),1); 1];
Ccl=Ca;
Dcl=Da;
Gss_cl=minreal(ss(Acl,Bcl,Ccl,Dcl));
K=Ka(1:length(A));
Ki=-Ka(end);

Acl_obs=[A -B*K*inv(T) B*Ki; S*C F-T*B*K*inv(T) T*B*Ki;-C zeros(1,length(C)) 0];
Bcl_obs=[zeros(2*length(B),1);1];
Ccl_obs=[C zeros(1,length(C)) 0];
Dcl_obs=0;
Gss_cl_obs=minreal(ss(Acl_obs,Bcl_obs,Ccl_obs,Dcl_obs))

% simulacion
t=0:0.01:45;
u=ones(1,length(t));
x0=[1 -2 3 2 -0.5 -1];%condiciones iniciales
x0=x0*.0001
[y,t,x]=lsim(Gss,u,t);
[y_cl,t,xcl]=lsim(Gss_cl,u,t);
[y_cl_obs,t,x_cl_obs]=lsim(Gss_cl_obs,u,t);

figure(1);
plot(t,y,'b','LineWidth',2);
hold on; grid on;
plot(t,y_cl,'r','LineWidth',2);
plot(t,y_cl_obs,'--k','LineWidth',2);
legend('Salida a lazo abierto','Salida a lazo cerrado sin observador','Salida a lazo cerrado con controlador y observador','Location','NorthWest');
title('Respuesta de la planta para cond. iniciales nulas');

t=0:0.01:50;
u=ones(length(t),1);
[y,t,x]=lsim(Gss,u,t,x0);
[y_cl,t,xcl]=lsim(Gss_cl,u,t,x0);
[y_cl_obs,t,x_cl_obs]=lsim(Gss_cl_obs,u,t,x0);
figure(2);
plot(t,y,'b','LineWidth',2);
hold on; grid on;
plot(t,y_cl,'r','LineWidth',2);
plot(t,y_cl_obs,'--k','LineWidth',2);
legend('Salida a lazo abierto','Salida a lazo cerrado sin observador','Salida a lazo cerrado con controlador y observador','Location','NorthWest');
title('Respuesta de la planta para cond. iniciales no nulas');
