clc;
clear all;
close all;

Gs=tf(5,[1 1 0]);

Gz=c2d(Gs,0.2);

K=1;

SysD=feedback(Gz*K,1);

rlocus(SysD);

[K_marg,P_marg]=rlocfind(SysD);

K=1;
a=0.3;
b=5;

while(abs(a-b)>1e-7)


    SysD=feedback(Gz*K,1);
    r=pole(SysD);
    rm=max(abs(r));
    if(rm>1)
        b=K;
    else
        a=K;
    end
    
end
