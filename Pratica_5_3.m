Ga=tf(27, [1 27 0]);

Gz=c2d(Ga, 0.1, 'zoh');

for k=1:0.1:100
    Tz=feedback(k*Gz,1);
    r=pole(Tz);
    rm=max(abs(r));
    if(rm>1)
        break;
    end
end