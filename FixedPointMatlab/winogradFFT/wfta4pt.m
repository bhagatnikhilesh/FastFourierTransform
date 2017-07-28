clc
clear all
close all

xRin = [0 1 0 0];
xJin = [0 0 0 0];

% xRin = [1     0    -1     0];           % Cosine
% xJin = [0    -1     0     1];

% xRin = [0     1     0    -1];           % Sine
% xJin = [1     0    -1     0];

x = [0 1 0 0];

% x = [1.0000 0 - 1.0000i  -1.0000  0 + 1.0000i];     % Cosin
% x = [0 + 1.0000i   1.0000  0 - 1.0000i  -1.0000];   % Sine

N = 4;
n = 1:1:4;
img = i;

RoundMode=2;
Signed=1;
WL = 8;
WF = 4;
one = fpDouble2FP(1, WL, WF, Signed, RoundMode);
zero = fpDouble2FP(0, WL, WF, Signed, RoundMode);
%% =================================================================
for i = 1:1:N
    xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
    xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
end
%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 2
%   # of sub = 2
%   # of mults = 0
%=================================================================
for stage = 1:1:2
    switch stage
        case 1
            Stage1Add0OutR = fpAdd(xR(1),xR(3));     % sR(1)
            Stage1Add0OutJ = fpAdd(xJ(1),xJ(3));     % sJ(1)
            
            Stage1Add1OutR = fpAdd(xR(2),xR(4));     % sR(2)
            Stage1Add1OutJ = fpAdd(xJ(2),xJ(4));     % sJ(2)

            Stage1Sub0OutR = fpSub(xR(1),xR(3));     % mR(3)
            Stage1Sub0OutJ = fpSub(xJ(1),xJ(3));     % mJ(3)

            Stage1Sub1OutR = fpSub(xR(2),xR(4));     % mR(4)
            Stage1Sub1OutJ = fpSub(xJ(2),xJ(4));     % mJ(4)
%=================================================================            
        case 2
            Stage2Add0OutR = fpAdd(Stage1Add0OutR,Stage1Add1OutR);     % mR(1)
            Stage2Add0OutJ = fpAdd(Stage1Add0OutJ,Stage1Add1OutJ);     % mJ(1)

            Stage2Sub0OutR = fpSub(Stage1Add0OutR,Stage1Add1OutR);     % mR(2)
            Stage2Sub0OutJ = fpSub(Stage1Add0OutJ,Stage1Add1OutJ);     % mJ(2)

            Stage2Add1OutR = fpAdd(Stage1Sub0OutR,fpNeg(Stage1Sub1OutJ));     % XR(4)
            Stage2Add1OutJ = fpAdd(Stage1Sub0OutJ,Stage1Sub1OutR);     % XJ(4)

            Stage2Sub1OutR = fpSub(Stage1Sub0OutR,fpNeg(Stage1Sub1OutJ));     % XR(2)
            Stage2Sub1OutJ = fpSub(Stage1Sub0OutJ,Stage1Sub1OutR);     % XJ(2)
%=================================================================
        otherwise
            disp('Invalid Stage!')
    end
end
%% =================================================================
XoutR(1) = Stage2Add0OutR;
XoutJ(1) = Stage2Add0OutJ;

XoutR(2) = Stage2Sub1OutR;
XoutJ(2) = Stage2Sub1OutJ;

XoutR(3) = Stage2Sub0OutR;
XoutJ(3) = Stage2Sub0OutJ;

XoutR(4) = Stage2Add1OutR;
XoutJ(4) = Stage2Add1OutJ;
%% =================================================================
for(i = 1:1:N)
    XkR(i) = fpFP2Double(XoutR(i));
    XkJ(i) = fpFP2Double(XoutJ(i));
%     disp(XkR(i));
%     disp(XkJ(i));
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


