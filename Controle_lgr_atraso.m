
Gs=zpk([],[-1,0],1);
Gz=c2d(Gs,1);

rlocus(Gz);
zgrid(0.7,[]); % traça linha do zeta com wn vazio
ku=0.196;

kc=0.8; %projeto

kd=ku/kc;

zp=0.999; %define

z0=1-(1-zp)/kd;

Dz=zpk([z0], zp, kd, -1);

figure
rlocus(Dz*Gz);

Sys=feedback(Dz*Gz,1);
step(Sys);
Rampa=tf(1, [1 -1], 1);
[y,t]=step(Sys*Rampa,10e3);
erro=t(end)-y(end);

figure
Sys2=feedback(ku*Gz,1);
step(Sys2);
[y,t]=step(Sys2*Rampa,10e3);
erro2=t(end)-y(end);
