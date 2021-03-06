

% clc
% clear all
% close all

% x = input('Enter the 8-pt input sequence: ');
function Xk = wfta_8pt(x)

% x = [0 1 0 0 0 0 0 0];

% Sine
% x = [0.0000 + 1.0000i
%    0.7071 + 0.7071i
%    1.0000 + 0.0000i
%    0.7071 - 0.7071i
%    0.0000 - 1.0000i
%   -0.7071 - 0.7071i
%   -1.0000 + 0.0000i
%   -0.7071 + 0.7071i];

% Cosine
% x = [1.0000 + 0.0000i
%    0.7071 - 0.7071i
%    0.0000 - 1.0000i
%   -0.7071 - 0.7071i
%   -1.0000 + 0.0000i
%   -0.7071 + 0.7071i
%    0.0000 + 1.0000i
%    0.7071 + 0.7071i];


n = 1:1:8;
u = 2*pi/8;
v = x;%transpose(x);

A = [1 1 1 1 1 1 1 1;
    1 -1 1 -1 1 -1 1 -1;
    1 0 -1 0 1 0 -1 0;
    1 0 0 0 -1 0 0 0;
    0 1 0 -1 0 -1 0 1;
    0 1 0 -1 0 1 0 -1;
    0 0 1 0 0 0 -1 0;
    0 1 0 1 0 -1 0 -1];

C = [1 0 0 0 0 0 0 0;
    0 0 0 1 1 0 -i -i;
    0 0 1 0 0 -i 0 0 ;
    0 0 0 1 -1 0 i -i;
    0 1 0 0 0 0 0 0;
    0 0 0 1 -1 0 -i i;
    0 0 1 0 0 i 0 0 ;
    0 0 0 1 1 0 i i];

b(1) = 1;
b(2) = 1;
b(3) = 1;
b(4) = 1;
b(5) = cos(u);
b(6) = 1;
b(7) = 1;
b(8) = sin(u);

B = diag(b);

a = A*v;
r = B*a;
X = C*r;
Xk = transpose(X);
% stem(X);
% grid on;
% end

% Xk = X;
end
% disp(Xk);
% figure(1);
% stem(n,(Xk));
% grid on;
% 
% Xf = fft(x);
% figure(2);
% stem(n,(Xf));
% grid on;




