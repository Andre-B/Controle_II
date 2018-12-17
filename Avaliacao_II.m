%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Exercicio Avaliativo II     %
%   Controle II                 %
%   Andre Bicalho M. Almeida    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Definicao da planta e variaveis

Gs = tf(40, [1 6 0]);
Ts = 0.015;
Gz = c2d(Gs, Ts);

%% Analise de estabilidade

[Gm, Pm, ~, ~] = margin(Gz);

if( Gm>0 && Pm>0 )
    disp("Sistema estavel");
else
    disp("Sistema instavel");
end

%% Controlador por atraso

a0 = 1;
phi_m = 70;
ang_des = -180+phi_m+5;

omega_w1 = 1.534;         % Utilizando bode de Gz
omega_w0 = 0.1*omega_w1;
mag_w1 = 4.2104;

omega_wp = omega_w0/mag_w1;

Dw = a0*tf([1/omega_w0 1],[1/omega_wp 1]);
Dz = c2d(Dw,Ts,'tustin');

[~, Pm, ~, ~] = margin(Dz*Gz);

if( Pm>70 )
    disp("Margem de fase atendida");
else
    disp("Margem de fase nao atendida");
end

%% Erro para rampa


Sys_c=feedback(Dz*Gz,1);

step(Sys_c);

rampa = tf(Ts, [1 -1], Ts);
[y,t] = step(Sys_c*rampa, 75); % Melhor resultado para o erro *
erro = t(end)-y(end);
disp(erro);

%% Ajuste do controlador por atraso

a0 = 3;
omega_wp = omega_w0/(a0*mag_w1);
Dw = a0*tf([1/omega_w0 1],[1/omega_wp 1]);
Dz = c2d(Dw,Ts,'tustin');

Sys_c=feedback(Dz*Gz,1);

step(Sys_c);

rampa = tf(Ts, [1 -1], Ts);
[y,t] = step(Sys_c*rampa, 75); % Melhor resultado para o erro *
erro = t(end)-y(end);
disp(erro);

%% Controlador por avanco

k = 3;
phi_m = 70;
ang_des = -180+phi_m;

omega_w1 = 40;
fase_w1 = -188.65;
mag_w1 = 0.073;

teta = ang_des-fase_w1;

if(cosd(teta)>mag_w1)
    disp("Ok");
end

a1 = (1-(mag_w1)*cosd(teta))/(omega_w1*mag_w1*sind(teta));
b1 = (cosd(teta)-mag_w1)/(omega_w1*sind(teta));

Dw = k*tf([a1 1],[b1 1]);
Dz = c2d(Dw,Ts,'tustin');

Sys_c=feedback(Dz*Gz,1);

step(Sys_c);

rampa = tf(Ts, [1 -1], Ts);
[y,t] = step(Sys_c*rampa, 75); % Melhor resultado para o erro *
erro = t(end)-y(end);
disp(erro);


%% Controlador PID

phi_m = 70;
ang_des = -180+phi_m;

omega_w1 = 12;
fase_w1 = -158.5914;
mag_w1 = 0.2481;

teta = ang_des-fase_w1;

Kp = cosd(teta)/mag_w1;
Kd = 0.3;
Ki = (Kd*omega_w1 - (sind(teta)/mag_w1)) * omega_w1;

Dw = Kp + tf( Ki, [1 0] ) + tf( [Kd 0], [Ts/2 1] );
Dz = c2d(Dw,Ts,'tustin');

Sys_c = feedback(Dz*Gz,1);

step(Sys_c)

%% Projeto pelo LGR

rlocus(Gz);

zeta = 0.7; % Como Mp=100zeta
tempo_assentamento = 0.95;
wn = 5/(zeta*tempo_assentamento);

r = exp(-zeta*wn*Ts);
ang = wn*Ts*sqrt(1-zeta^2);

zb = r*cos(ang)+1j*r*sin(ang);

z = 0.9139;

teta_p = -( -180 + ( 90 + atand( (1-real(zb))/imag(zb))) - atand( imag(zb)/(real(zb) + 0.9704  ) )  );

p = real(zb)-( imag(zb)/tand(teta_p) );

Dz = zpk(z, p, 1, Ts);


Sys_c=feedback(Dz*Gz,1);

step(Sys_c);
