Ga=tf(27, [1 27 0]);

Gz=c2d(Ga, 0.1, 'zoh');
a=1;
b=100;

while(abs(a-b)>1e-7)

    k=(a+b)/2;
    
    Tz=feedback(k*Gz,1);
    r=pole(Tz);
    rm=max(abs(r));
    if(rm>1)
        b=k;
    else
        a=k;
    end
    
end