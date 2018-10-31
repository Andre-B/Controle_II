% Exercício avaliativo - Parte prática
% Sistemas de Controle II
% André Bicalho

%% Parte 1

Dz=1/2;
K=1;
Gs=tf(20,[1 6]);
Hz=0.9;

T=0.05;

Gz=c2d(Gs,T,'zoh');




a=1;
b=30;

while(abs(a-b)>1e-7)

    K=(a+b)/2;
    
    SysD=feedback(Dz*K*Gz,Hz);

    r=pole(SysD);
    rm=max(abs(r));
    if(rm>1)
        b=K;
    else
        a=K;
    end
    
end
format long;
disp(K)
