
clc;
clear;
close all;


num=[0.4673 -0.3393];
den=[1 -1.5327 0.6607];

x=[1 zeros(1,40)];
k=0:40;
y=filter(num,den,x);
plot(k,y,'o')
v=[0 40 -1 1];
axis(v);
grid
title('Resposta à entrada Delta Kronecker')
xlabel('k')
ylabel('y(k)')

