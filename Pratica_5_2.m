
D=tf(27,[1 27 0]);      %Define fun��o da din�mica de fuzelagem 
K=20;            %Define ganho
G1=c2d(K*D,0.1,'zoh');  %Define a fun��o G do sistema discreto (amostrador, controle e planta)

T1=feedback(G1,1);
K=100;
G2=c2d(K*D,0.1,'zoh');


T2=feedback(G2,1);
