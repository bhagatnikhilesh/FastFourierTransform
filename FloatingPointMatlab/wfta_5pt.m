
% clc
% clear all
% close all
function x_wfta = wfta_5pt(x)
% x = input('Enter the 5 input sequence: ');

% x = [0 i 0 0 0];
% n = 1:1:5;

s = zeros(1,17);
m = zeros(1,6);
X = zeros(1,5);
u = pi/5;

s(1) = x(2) + x(5);
s(2) = x(2) - x(5);

s(3) = x(4) + x(3);
%s(4) = x(4) - x(3);
s(4) = x(3) - x(4);

s(5) = s(1) + s(3);
s(6) = s(1) - s(3);

s(7) = s(2) + s(4);
s(8) = s(5) + x(1);

m(1) = 1*s(8);
%m(2) = (((cos(u) + cos(2*u))/2) - 1)*s(5);
m(2) = (((cos(2*u) - cos(u))/2) - 1)*s(5);
%m(3) = ((cos(u) - cos(2*u))/2)*s(6);
m(3) = ((cos(2*u) + cos(u))/2)*s(6);
%m(4) = j*(sin(u) + sin(2*u))*s(2);
m(4) = j*(-sin(2*u) + sin(u))*s(2);
%m(5) = j*(sin(2*u))*s(7);
m(5) = -j*(sin(u))*s(7);
%m(6) = j*(sin(u) - sin(2*u))*s(4);
m(6) = j*(sin(u) + sin(2*u))*s(4);

s(9) = m(1) + m(2);
s(10) = s(9) + m(3);
s(11) = s(9) - m(3);

%s(12) = m(4) - m(5);
s(12) = m(4) + m(5);
s(13) = m(5) + m(6);

s(14) = s(10) + s(12);
s(15) = s(10) - s(12);
s(16) = s(11) + s(13);
s(17) = s(11) - s(13);

X(1) = m(1);
X(2) = s(14);
X(3) = s(16);
X(4) = s(17);
X(5) = s(15);

% disp(X);
% stem(X);
% grid on;

% x_wfta = transpose(X');
x_wfta = X;

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







