 clc
 clear all
 close all
%function x_wfta = wfta_3pt(x)
%x = input('Enter the 3 input sequence: ');

x = [0 1 0];
% x = [ 1.0000 + 0.0000i  -0.5000 - 0.8660i  -0.5000 + 0.8660i];      % Cosine
%x = [0.0000 + 1.0000i   0.8660 - 0.5000i  -0.8660 - 0.5000i];       % Sine
 n = 1:1:3;

s = zeros(1,6);
m = zeros(1,3);
X = zeros(1,3);
u = ((pi)/3);

s(1) = x(2) + x(3);
s(2) = x(2) - x(3);
s(3) = s(1) + x(1);

m(1) = 1*s(3);
m(2) = (-cos(u) - 1)*s(1);
m(3) = (-j*sin(u))*s(2);

s(4) = m(1) + m(2);
s(5) = s(4) + m(3);
s(6) = s(4) - m(3);

X(1) = m(1);
X(2) = s(5);
X(3) = s(6);

%disp(X);

% x_wfta = transpose(X');
x_wfta = X;



% stem(x_wfta);

%end


 Xk = X;
 disp(Xk);
 figure(1);
 stem(n,(Xk));
 grid on;
 
 Xf = fft(x);
 figure(2);
 stem(n,(Xf));
 grid on;




