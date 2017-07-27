
% Implemented from Nussbaumer.
% clc
% clear all
% close all

% x = [0 i 0 0 0 0 0 0 0];
% n = 1:1:9;
% 
% x = input('Enter the 9-pt input sequence: ');

% Cosine
% x = [1.0000 + 0.0000i
%    0.7660 - 0.6428i
%    0.1736 - 0.9848i
%   -0.5000 - 0.8660i
%   -0.9397 - 0.3420i
%   -0.9397 + 0.3420i
%   -0.5000 + 0.8660i
%    0.1736 + 0.9848i
%    0.7660 + 0.6428i];

% Sine
% x = [0.0000 + 1.0000i
%    0.6428 + 0.7660i
%    0.9848 + 0.1736i
%    0.8660 - 0.5000i
%    0.3420 - 0.9397i
%   -0.3420 - 0.9397i
%   -0.8660 - 0.5000i
%   -0.9848 + 0.1736i
%   -0.6428 + 0.7660i];


function Xk = wfta_9pt(x)
u = 2*pi/9;


t(1) = x(2)+x(9);
t(2) = x(3)+x(8);
t(3) = x(4)+x(7);
t(4) = x(5)+x(6);
t(5) = t(1)+t(2)+t(4);
t(6) = x(2)-x(9);
t(7) = x(8)-x(3);
t(8) = x(4)-x(7);
t(9) = x(5)-x(6);
t(10) = t(6)+t(7)+t(9);
t(11) = t(1)-t(2);
t(12) = t(2)-t(4);
t(13) = t(7)-t(6);
t(14) = t(7)-t(9);

m(1) = 1*(x(1)+t(3)+t(5));
m(2) = (3/2)*(t(3));
m(3) = -t(5)/2;

t(15) = -t(12)-t(11);
m(4) = ((2*cos(u)-cos(2*u)-cos(4*u))/3)*t(11);
m(5) = ((cos(u)+cos(2*u)-2*cos(4*u))/3)*t(12);
m(6) = ((cos(u)-2*cos(2*u)+cos(4*u))/3)*t(15);
s(1) = -m(4)-m(5);
s(2) = m(6)-m(5);

m(7) = -i*(sin(3*u))*(t(10));
m(8) = -i*(sin(3*u))*(t(8));

t(16) = -t(13) + t(14);
m(9) = i*(sin(u))*(t(13));
m(10) = i*(sin(4*u))*(t(14));
m(11) = i*(sin(2*u))*(t(16));

s(3) = -m(9)-m(10);
s(4) = m(10)-m(11);
s(5) = m(1)+m(3)+m(3);
s(6) = s(5)-m(2);
s(7) = s(5)+m(3);
s(8) = s(6)-s(1);
s(9) = s(2)+s(6);
s(10) = s(1)-s(2)+s(6);
s(11) = m(8) - s(3);
s(12) = m(8) - s(4);
s(13) = m(8)+s(3)+s(4);

X(1) = m(1);
X(2) = s(8)+s(11);
X(3) = s(9)-s(12);
X(4) = s(7)+m(7);
X(5) = s(10)+s(13);
X(6) = s(10)-s(13);
X(7) = s(7)-m(7);
X(8) = s(9)+s(12);
X(9) = s(8)-s(11);

% stem(X);

Xk = X;

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














