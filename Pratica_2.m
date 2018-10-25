%%

clc;
clear;
close all;

T=0.005;
t=0:T:1;

f=10;

x=sin(2*pi*f*t);


for l=1:4

    
    
    switch (l)
        case 1
            fs1=50;
            figure('Name','50 Hz')
        case 2
            fs1=25;
            figure('Name','25 Hz')
        case 3
            fs1=11;
            figure('Name','11 Hz')
        case 4
            fs1=10;
            figure('Name','10 Hz')
    end
    
    plot(t,x);
    
    hold on;
    T1=(1/fs1);
    x1=[];
    ind=1;
    for k=1:round(T1/T):size(x,2)  % gera os pontos a serem amostrados,
                                   % espaçados de T1/T valores da função contínua
        x1(ind)=x(k);
        ind=ind+1;
        
    end
    
    stem(0:T1:1, x1);
    
    stairs(0:T1:1, x1);
end
