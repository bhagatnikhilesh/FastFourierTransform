clc
close all
clear all

N = 2; %input('Enter the number of points: ');

% for i = 1:1:N
%     xRin(i) = input('Enter the real part: ');
%     xJin(i) = input('Enter the imaginary part: ');
% end

xRin = [0 0];
xJin = [0 1];

x = [0 1];

img = i;
n = 1:1:2;

RoundMode=2;
Signed=1;
WL = 16;
WF = 8;

%% =================================================================
for i = 1:1:N
    xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
    xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
end
%% =================================================================
sR(1) = fpAdd(xR(1),xR(2));
sJ(1) = fpAdd(xJ(1),xJ(2));

sR(2) = fpSub(xR(1),xR(2));
sJ(2) = fpSub(xJ(1),xJ(2));
%% =================================================================
XR(1) = sR(1);
XJ(1) = sJ(1);
XR(2) = sR(2);
XJ(2) = sJ(2);
%% =================================================================
for(i = 1:1:N)
    XkR(i) = fpFP2Double(XR(i));
    XkJ(i) = fpFP2Double(XJ(i));
end

for i=1:1:N
    Xk(i) = XkR(i) + img*XkJ(i);
end

disp(Xk);
figure(1);
stem(n,(Xk));
grid on;

Xf = fft(x);
figure(2);
stem(n,(Xf));
grid on;
