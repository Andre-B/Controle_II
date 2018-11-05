% Exercício avaliativo - Parte prática
% Sistemas de Controle II
% André Bicalho


%% Parte 1
Ts=0.1;

Gz=tf([1 -0.02926],[1 -(0.375+0.3608) (0.375*0.3608)],Ts);
Hz=0.5;
K=1;

Dz=tf([0.2*K 0.23*K],[1 -1],Ts);



Sys=feedback(Dz*Gz,Hz);

if max(abs(pole(Sys)))<1
    disp('Estável');
else disp('Instável');
end

%% Parte 2

Ts=0.1;

Gz=tf([1 -0.02926],[1 -(0.375+0.3608) (0.375*0.3608)],Ts);
Hz=0.5;

a=1;
b=100;

while(abs(a-b)>10e-7)

    K=(a+b)/2;
    
    Dz=tf([0.2*K 0.23*K],[1 -1],Ts);
    Sys=feedback(Dz*Gz,Hz);

    r=pole(Sys);
    rm=max(abs(r));
    if(rm>1)
        b=K;
    else
        a=K;
    end
    
end

disp(K);
