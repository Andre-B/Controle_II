% Definição da planta
Gp=zpk([],[0 -1 -2],2);
a0=1;
K=2;
% Tempo de amostragem e discretização 
Ts=0.05;
Gz=c2d(K*Gp,Ts);

% Ganho da margem de fase
phi_m=55;

% Angulo da freqência
ang_des=-180+phi_m;

margin(Gz);

% Cálculo da posição w0 w1
omega_w1=2.4;

fase_w1=-211;
mag_w1=db2mag(-13.7);

teta=ang_des-fase_w1;

if(cosd(teta)>mag_w1)
    disp("Ok");
end


a1=(1-(mag_w1)*cosd(teta))/(omega_w1*mag_w1*sind(teta));

b1=(cosd(teta)-mag_w1)/(omega_w1*sind(teta));

% Montar controlador
Dw=tf([a1 1],[1 0]);

% Discretização do controlador
Dz=c2d(Dw,Ts,'tustin');

figure

margin(Dz*Gz)

% Fechar a malha e calcular resposta ao degrau e à rampa
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


% Erro pra rampa, [y,t]=step(Tz* T/(z-1))
% erro= t(end)-y(end);

