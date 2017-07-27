


function [M1,M2] = m1m2Values(N1,N2)
% solves the equation N1M1+N2M2 = 1 using Euclidean algorithm
%  N1,N2 - scalar, integer coefficients of the
%  linear Diophantine equation, N1M1 + N2M2 = 1

R1 = N1;
R2 = N2; 

[x1,x2] = deal(1,0);    % is same as writing x1 = 1; x2 = 0;
[y1,y2] = deal(0,1);    % is same as writing x1 = 0; x2 = 1;

% get the particular solution by iteratively calling quotient.
% this loop recursively solves the diaphontine equation N1M1+N2M2 = 1
% to give the values of M1 and M2.

R = 1;
while (R~=0)
    [Q,R] = quotient(R1,R2);    % returns quotient and remainder for R1 and R2.
    if R == 0
        M1 = x2;
        M2 = y2;
    else
        [R1,R2] = deal(R2,R);
        [x1,x2] = deal(x2,x1 - x2*Q);
        [y1,y2] = deal(y2,y1 - y2*Q);
    end
end

% Since M1 and M2 are multiplicative inverse of each other
% the negative value is converted to get positive value.

if(M1<0)
    M1 = fix(((N1*N2 + 1) - M2*N2)/N1);
elseif(M2<0)
    M2 = fix(((N1*N2 + 1) - M1*N1)/N1);
end

end


