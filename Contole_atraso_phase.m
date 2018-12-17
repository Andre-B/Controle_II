% Definição da planta
Gp=zpk([],[0 -1 -2],2);
a0=1;

% Tempo de amostragem e discretização 
Ts=0.05;
Gz=c2d(Gp,Ts);

% Ganho da margem de fase
phi_m=55;

% Angulo da freqência
ang_des=-180+phi_m+5;


margin(Gz);

% Cálculo da posição w0 w1
omega_w1=0.354;
omega_w0=0.1*omega_w1;


omega_wp=omega_w0/(db2mag(2.43));

% Montar controlador
Dw=a0*tf([1/omega_w0 1],[1/omega_wp 1]);

% Discretização do controlador
Dz=c2d(Dw,Ts,'tustin');

figure

margin(Dz*Gz)



% FEchar a malha e calcular resposta ao degrau e à rampa
figure
Sys_s=feedback(Gz,1);
step(Sys_s);


figure
Sys_c=feedback(Dz*Gz,1);
step(Sys_c);


% Erro pra rampa, [y,t]=step(Tz* T/(z-1))
% erro= t(end)-y(end);
rampa=tf([Ts],[1 -1],Ts);


[y,t]=step(Sys_c*rampa);
erro=t(end)-y(end);
disp(erro);
