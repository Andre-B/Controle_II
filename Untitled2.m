%%Par�metros iniciais
R=0.01; %ru�do
fs=2000; %frequ�ncia de amostragem
Rb=100; %resist�ncia
Cb=0.00047; %Capacit�ncia
Lb=0.0031; %indut�ncia
Vin=10; %Tens�o de entrada
D=0; %raz�oc�clica
%% Defini��o do modelo em espa�o de estados
A=[0 -1/Lb;1/Cb -1/(Rb*Cb)]; %Matriz A
B=[1/Lb;0]; %Matriz B
C=[0 1]; %Matriz C
D=0; %Matriz D

%% Discretiza��o da planta
T=1/fs; %per�odo de amostragem
npc=400; %n�mero de pontos de descretiza��o
Tc=T/npc; %per�odo da planta pseudocont�nua
I=eye(2); %Gera matriz identidade 2x2
Ada=I+A*Tc;%Discretiza��o da Matriz A
%Matriz para chave aberta
Bd=B*Tc; %Discretiza��o da Matriz B
Maux=[1 0;0 1]; %Matriz auxiliar
Adf=Ada.*Maux; %Matriz A para chave fechada
%% Configura��o da simula��o
Ts=0.4; %tempo de simula��o
nps=Ts/T; %numero de passos de simula��o
%% Ganho do controlador
Kp=0.0001; %ganho proporcional
Ki=60; %ganho integral
Kd=0.00080; %ganho derivativo
%% inicializa��o de vari�veis
r=zeros(1,nps+1); %referencia
ra=zeros(1,nps+1); %referencia adaptativa
e=zeros(1,nps+1); %erro
u=zeros(1,nps+1); %a��o de controle
uP=zeros(1,nps+1); %a��o de controle proporcional
uD=zeros(1,nps+1); %a��o de controle derivativo
uI=zeros(1,nps+1); %a��o de controle integral
Se=zeros(1,nps+1); %Soma do erro
X=zeros(2,nps+1); %sa�da
Xc=zeros(1,nps*npc+1); %sa�da continua
Xc=zeros(2,nps*npc+1); %sa�da continua
uc=zeros(1,nps*npc+1); %controle continuo
td=zeros(1,nps+1); %contador tempo discreto
tc=zeros(1,nps*npc+1); %contador pseudocont�nuo
kc=0; %Contador pseudo continuo
auxp=1; %utilizada no PWM (principal)
auxs=0; %utilizada no PWM (secundaria)
chave=0; %define a posicao da chave
%% simulacao em MF
for k=3:nps
td(k)=k*T; %incrementa contador
if k<300
r(k)=25; %refer�ncia
else
r(k)=25;
end
ra(k)=0.8*ra(k-1)+0.2*r(k);%varia��o da
%refer�ncia
%adaptativa
X(k)=Xc(2,kc+1)+R*(2*rand(1)-1); %amostragem
%com ru�do
e(k)=ra(k)-X(k); %define o erro
Se(k)=Se(k-1)+e(k); %somat�ria do erro
if Se(k)>(45/(Ki*T)) %condi��o para que o
%erro n�oextrapole +
Se(k)=45/(Ki*T);
end
if Se(k)<(-45/(Ki*T)) %condi��o para que o
%erro n�oextrapole -
Se(k)=-45/(Ki*T);
end
%% controlador PID discreto
uP(k)=Kp*e(k); %componente proporcional
uI(k)=Ki*T*Se(k); %componente integral
uD(k)=Kd/T*(e(k)-e(k-1));%componente
%derivativa
u(k)=uP(k)+uI(k)+uD(k); %a��o de controle
if u(k)>45 %condi��o para que
%n�oextrapole +
u(k)=45;
end
if u(k)<0 %condi��o para que n�oextrapole +
u(k)=0;
end
D(k)=(u(k)/45)*0.75; %define raz�oc�clica
%D=0.4;
if X(k)<Vin
D(k)=0;
end
if D(k)<0
D(k)=0;
end
%% Simula��o da planta pseudocont�nua
for k1=1:npc
kc=k*npc+k1; %contador pseudocont�nuo
tc(kc)=kc*Tc; %tempo pseudocont�nuo
if (k1)>(100*(auxp-1)+(D(k)*100))
%verifica condi��o para abertura ou
%fechamento da chave
chave=0;
else
chave=1;
end
if chave==0 %de acordo com a posi��o da
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
