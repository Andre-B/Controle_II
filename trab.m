
% Variaveis

R=3900;
Rl=0.1;
c=100e-6;
L=3e-3;
f=10e3;
Ts=1/f;

D=0.656;
V=12;

% Matrizes
A1=[-1/(R*c)    0; 
    0           -Rl/L ];
B1=[0
    1/L];
C1=[1   0];

A2=[-1/(R*c)    1/c; 
    -1/L           -Rl/L ];
B2=[0
    1/L];
C2=[1   0];


% Modelos

Modelo_aberto_cont=ss(A1,B1,C1,0);
Modelo_aberto_disc=c2d(Modelo_aberto_cont, Ts);


Modelo_fechado_cont=ss(A2,B2,C2,0);
Modelo_fechado_disc=c2d(Modelo_fechado_cont, Ts);

% Sistema medio
 
A= A1*D + A2*(1-D);
B= B1*D + B2*(1-D);
C= C1*D + C2*(1-D);

X= -inv(A)*B*V;
Bfinal = (A1 - A2)*X + (B1 - B2)*V;
Dfinal = (C1 - C2)*X;
[num,den] = ss2tf(A,Bfinal,C,Dfinal);
GV = tf(num,den);

Gz=c2d(GV,Ts);

% Ganho da margem de fase
phi_m=25;

% Angulo da freqência
ang_des=-180+phi_m;


margin(Gz);

% Cálculo da posição w1

omega_w1=636;
fase_w1=-7.93;
mag_w1=db2mag(41.3);


teta=ang_des-fase_w1;
Kp=cosd(teta)/mag_w1;
Ki=-(sind(teta)/mag_w1)*omega_w1;

% Montar controlador
Dw=tf([Kp Ki],[1 0]);

% Discretização do controlador
Dz=c2d(Dw,Ts,'tustin');

figure

margin(Dz*Gz)

step(mf)
