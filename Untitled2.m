%%Parâmetros iniciais
R=0.01; %ruído
fs=2000; %frequência de amostragem
Rb=100; %resistência
Cb=0.00047; %Capacitância
Lb=0.0031; %indutância
Vin=10; %Tensão de entrada
D=0; %razãocíclica
%% Definição do modelo em espaço de estados
A=[0 -1/Lb;1/Cb -1/(Rb*Cb)]; %Matriz A
B=[1/Lb;0]; %Matriz B
C=[0 1]; %Matriz C
D=0; %Matriz D

%% Discretização da planta
T=1/fs; %período de amostragem
npc=400; %número de pontos de descretização
Tc=T/npc; %período da planta pseudocontínua
I=eye(2); %Gera matriz identidade 2x2
Ada=I+A*Tc;%Discretização da Matriz A
%Matriz para chave aberta
Bd=B*Tc; %Discretização da Matriz B
Maux=[1 0;0 1]; %Matriz auxiliar
Adf=Ada.*Maux; %Matriz A para chave fechada
%% Configuração da simulação
Ts=0.4; %tempo de simulação
nps=Ts/T; %numero de passos de simulação
%% Ganho do controlador
Kp=0.0001; %ganho proporcional
Ki=60; %ganho integral
Kd=0.00080; %ganho derivativo
%% inicialização de variáveis
r=zeros(1,nps+1); %referencia
ra=zeros(1,nps+1); %referencia adaptativa
e=zeros(1,nps+1); %erro
u=zeros(1,nps+1); %ação de controle
uP=zeros(1,nps+1); %ação de controle proporcional
uD=zeros(1,nps+1); %ação de controle derivativo
uI=zeros(1,nps+1); %ação de controle integral
Se=zeros(1,nps+1); %Soma do erro
X=zeros(2,nps+1); %saída
Xc=zeros(1,nps*npc+1); %saída continua
Xc=zeros(2,nps*npc+1); %saída continua
uc=zeros(1,nps*npc+1); %controle continuo
td=zeros(1,nps+1); %contador tempo discreto
tc=zeros(1,nps*npc+1); %contador pseudocontínuo
kc=0; %Contador pseudo continuo
auxp=1; %utilizada no PWM (principal)
auxs=0; %utilizada no PWM (secundaria)
chave=0; %define a posicao da chave
%% simulacao em MF
for k=3:nps
td(k)=k*T; %incrementa contador
if k<300
r(k)=25; %referência
else
r(k)=25;
end
ra(k)=0.8*ra(k-1)+0.2*r(k);%variação da
%referência
%adaptativa
X(k)=Xc(2,kc+1)+R*(2*rand(1)-1); %amostragem
%com ruído
e(k)=ra(k)-X(k); %define o erro
Se(k)=Se(k-1)+e(k); %somatória do erro
if Se(k)>(45/(Ki*T)) %condição para que o
%erro nãoextrapole +
Se(k)=45/(Ki*T);
end
if Se(k)<(-45/(Ki*T)) %condição para que o
%erro nãoextrapole -
Se(k)=-45/(Ki*T);
end
%% controlador PID discreto
uP(k)=Kp*e(k); %componente proporcional
uI(k)=Ki*T*Se(k); %componente integral
uD(k)=Kd/T*(e(k)-e(k-1));%componente
%derivativa
u(k)=uP(k)+uI(k)+uD(k); %ação de controle
if u(k)>45 %condição para que
%nãoextrapole +
u(k)=45;
end
if u(k)<0 %condição para que nãoextrapole +
u(k)=0;
end
D(k)=(u(k)/45)*0.75; %define razãocíclica
%D=0.4;
if X(k)<Vin
D(k)=0;
end
if D(k)<0
D(k)=0;
end
%% Simulação da planta pseudocontínua
for k1=1:npc
kc=k*npc+k1; %contador pseudocontínuo
tc(kc)=kc*Tc; %tempo pseudocontínuo
if (k1)>(100*(auxp-1)+(D(k)*100))
%verifica condição para abertura ou
%fechamento da chave
chave=0;
else
chave=1;
end
if chave==0 %de acordo com a posição da
%chave escolhe uma matriz
%Ad. Chave = 0 significa
%chaveaberta e chave=1
%significa chave fechada
Xc(:,kc+1) = Ada*Xc(:,kc)+Bd*Vin;
else
Xc(:,kc+1) = Adf*Xc(:,kc)+Bd*Vin;
end
auxs=auxs+1; %contador para PWM
if auxs==100
auxs=0;
auxp=auxp+1;
end
end
auxp=1; %contador para PWM
auxs=0; %contador para PWM
end
