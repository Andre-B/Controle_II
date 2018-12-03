%clc;
%clear all;
%close all;

Gs=tf(5,[1 1 0]);

Gz=c2d(Gs,0.2);

Gw=d2c(Gz,'tustin');
bode(Gw);
[Mg, Mp, Wg, Wp]=margin(Gw);

% Sistema estável

SysClose=feedback(Gw,1);
step(SysClose);
%%


K=1;
bode(Gw);
[Mg, Mp, Wg, Wp]=margin(Gw*K);

%% 45º
% Com K=1, preciso que o sistema cruze o 0 dB em w=0.84
% entao 20logK=-13.2

K=10^(-((13.2)/20));
margin(Gw*K);
SysClose=feedback(Gw*K,1);
step(SysClose);

%% 35º
% Com K=1, preciso que o sistema cruze o 0 dB em w=1.14
% entao 20logK=-9.23

K=10^(-((9.23)/20));
margin(Gw*K);
SysClose=feedback(Gw*K,1);
step(SysClose);


