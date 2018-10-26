% Exercício avaliativo - Parte prática
% Sistemas de Controle II
% André Bicalho


%% Definição das funções das plantas e realimentação

G1=tf(1, [1 0], -1);
H1=-0.9; % Negativo porque o feedback considera realimentação negativa

G2=tf(1, [1 0], -1);
H2=-0.8; % Negativo porque o feedback considera realimentação negativa

% Realimentação dos laços
L1=feedback(G1,H1);
L2=feedback(G2,H2);

% Definição da função de transferência
Gz=L1*L2;

% Resposta ao impulso
impulse(Gz)

% Resposta ao degrau para computar o erro

[y,t]=step(Gz);



