


% x = input('Enter the 2-dimensional array: ');
function Xout = RUR_Npt(x,N1,N2)

N = numel(x);
% For a 15-pt sequence N1=5, N2=3 and GCD(N1,N2)=1.
% N1 = 3;
% N2 = 5;

% Range for n1 = 0,1,2,..(N1-1); n2 = 0,1,2,...(N2-1);
% Applying the Ruritarian Corespondence mapping for output mapping.
% The frequency index 'k' is given by k = [n1*N2 + n2*N1]Mod(N)

X = zeros(1,N);

for n1 = 1:1:N1
    for n2 = 1:1:N2
        X(rem(((n1-1)*N2) + ((n2-1)*N1),N)+1) = x(n1,n2);
    end
end

 Xout = X;
% disp(x);
% disp(X);

end