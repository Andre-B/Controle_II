Ga=tf(10, [1 1]);
T1=0;
T2=5;
while(abs(T1-T2)>1e-7)
    T=(T1+T2)/2;
    
    Gz=c2d(Ga, T, 'zoh');
    Tz=feedback(Gz,1);
    r=pole(Tz);
    rm=max(abs(r));
    if(rm>=1)
        T2=T;
    else
        T1=T;
    end
    
end