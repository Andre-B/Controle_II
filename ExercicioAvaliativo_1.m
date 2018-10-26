% Exerc�cio avaliativo - Parte pr�tica
% Sistemas de Controle II
% Andr� Bicalho


%% Defini��o das fun��es das plantas e realimenta��o

G1=tf(1, [1 0], -1);
H1=-0.9; % Negativo porque o feedback considera realimenta��o negativa

G2=tf(1, [1 0], -1);
H2=-0.8; % Negativo porque o feedback considera realimenta��o negativa

% Realimenta��o dos la�os
L1=feedback(G1,H1);
L2=feedback(G2,H2);

% Defini��o da fun��o de transfer�ncia
Gz=L1*L2;

% Resposta ao impulso
impulse(Gz)

% Resposta ao degrau para computar o erro

[y,t]=step(Gz);



