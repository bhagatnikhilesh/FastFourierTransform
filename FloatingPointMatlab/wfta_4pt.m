

% clc
% clear all
% close all
% 
% x = input('Enter the 4-pt input sequence: ');
function Xk = wfta_4pt(x)
% x = [0 1 0 0];

% Sine
% x = [ 0.0000 + 1.0000i   1.0000 + 0.0000i   0.0000 - 1.0000i  -1.0000 + 0.0000i];

% Cosine
% x = [ 1.0000 + 0.0000i   0.0000 - 1.0000i  -1.0000 + 0.0000i   0.0000 + 1.0000i];
% n = 1:1:4;

t(1) = x(1)+x(3);
t(2) = x(2)+x(4);

m(1) = t(1)+t(2);
m(2) = t(1)-t(2);
m(3) = x(1)-x(3);
m(4) = x(2)-x(4);
% m(4) = i*(x(4)-x(2));

m(5) = i*m(4);

X(1) = m(1);
X(4) = m(3)+m(5);
X(3) = m(2);
X(2) = m(3)-m(5);

Xk = X;

% stem(X);
end

% Xk = X;
% disp(Xk);
% figure(1);
% stem(n,(Xk));
% grid on;
% 
% Xf = fft(x);
% figure(2);
% stem(n,(Xf));
% grid on;



