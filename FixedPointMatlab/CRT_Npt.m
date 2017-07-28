

% This function maps the 1-dimensional input sequence to a 2-dimensional
% input sequence based on Chinese Remainder Theorem mapping.

% N1 and N2 are the co prime numbers and denote the number of columns and
% rows respectively.
% The values of N1 and N2 are fixed and determined by the user.
% x is the input sequence.
% Also, (N1*M1 + N2*M2 = 1). The values of M1 and M2 are fixed and
% calculated by the user. The values for M1 and M2 are calculated by
% using Euclidean Algorithm.
% Make sure that (N1>N2)

function xMap = CRT_Npt(x,N1,N2)   

N = numel(x);       % returns number of elements in x

% Applying the Chinese Remainder theorem for input mapping.
% The time index 'n' is given by n = [n1*N2*M2 + n2*N1*M1]Mod(N)

[M1,M2] = m1m2Values(N1,N2);    % this function computes the values of M1 and M2.
x1 = zeros(N2,N1);

for n1 = 1 : N2
    for n2 = 1 : N1
        x1(n1,n2) = x(rem(((n2-1)*N2*M2)+((n1-1)*N1*M1),N)+1);  % index calculation.
    end
end

xMap = x1;

end
