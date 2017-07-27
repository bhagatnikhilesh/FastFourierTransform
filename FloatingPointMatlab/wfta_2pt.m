
%clc
%clear all
%close all

%x = input('Enter the 2-pt input sequence: ');

function X = wfta_2pt(x)

s = zeros(1,2);
m = zeros(1,2);
X = zeros(1,2);

s(1) = x(1)+x(2);
s(2) = x(1)-x(2);

m(1) = 1*s(1);
m(2) = 1*s(2);

X(1) = m(1);
X(2) = m(2);

%disp(X);
%stem(X);
end