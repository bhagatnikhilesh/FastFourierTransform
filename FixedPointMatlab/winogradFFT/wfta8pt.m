
clc
clear all
close all

N = 8; %input('Enter the number of points: ');

% for i = 1:1:N
%     xRin(i) = input('Enter the real part: ');
%     xJin(i) = input('Enter the imaginary part: ');
% end

xRin = [0 0 0 0 0 0 0 0];
xJin = [0 1 0 0 0 0 0 0];

% xRin = [1.0000    0.7070         0   -0.7070   -1.0000   -0.7070         0    0.7070]; % Cosin
% xJin = [0   -0.7070   -1.0000   -0.7070         0    0.7070    1.0000    0.7070];

% xRin = [0    0.7070    1.0000    0.7070         0   -0.7070   -1.0000   -0.7070];       % Sine
% xJin = [1.0000    0.7070         0   -0.7070   -1.0000   -0.7070         0    0.7070];

% x = [0 i 0 0 0 0 0 0];
x = [1.0000   0.7070 - 0.7070i  0 - 1.0000i  -0.7070 - 0.7070i  -1.0000   -0.7070 + 0.7070i   0 + 1.0000i   0.7070 + 0.7070i];
% x = [0 + 1.0000i   0.7070 + 0.7070i   1.0000             0.7070 - 0.7070i        0 - 1.0000i  -0.7070 - 0.7070i  -1.0000            -0.7070 + 0.7070i];

img = i;
n = 1:1:8;

RoundMode=2;
Signed=1;
WL = 8;
CoeffWL = 16;
CoeffWF = 8;
WF = 4;
one = fpDouble2FP(1, 16, 8, Signed, RoundMode);
zero = fpDouble2FP(0, 16, 8, Signed, RoundMode);

%% =================================================================
for i = 1:1:N
    xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
    xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
end

u = ((pi)/4);

c = cos(u);

% kSin = fpDouble2FP(s, WL, WF, Signed, RoundMode);   % Sin(u)
kCos = fpDouble2FP(c, CoeffWL, CoeffWF, Signed, RoundMode);   % Cos(u)

%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 4
%   # of sub = 4
%   # of mults = 2
%=================================================================
for stage = 1:1:5
    switch stage
        case 1
            Stage1Add0OutR = fpAdd(xR(1),xR(5));     % bR(1)
            Stage1Add0OutJ = fpAdd(xJ(1),xJ(5));     % bJ(1)

            Stage1Sub0OutR = fpSub(xR(1),xR(5));     % bR(2)
            Stage1Sub0OutJ = fpSub(xJ(1),xJ(5));     % bJ(2)

            Stage1Add1OutR = fpAdd(xR(2),xR(6));     % bR(3)
            Stage1Add1OutJ = fpAdd(xJ(2),xJ(6));     % bJ(3)

            Stage1Sub1OutR = fpSub(xR(2),xR(6));     % bR(4)
            Stage1Sub1OutJ = fpSub(xJ(2),xJ(6));     % bJ(4)

            Stage1Add2OutR = fpAdd(xR(3),xR(7));     % bR(5)
            Stage1Add2OutJ = fpAdd(xJ(3),xJ(7));     % bJ(5)

            Stage1Sub2OutR = fpSub(xR(3),xR(7));     % bR(6)
            Stage1Sub2OutJ = fpSub(xJ(3),xJ(7));     % bJ(6)

            Stage1Add3OutR = fpAdd(xR(4),xR(8));     % bR(7)
            Stage1Add3OutJ = fpAdd(xJ(4),xJ(8));     % bJ(7)

            Stage1Sub3OutR = fpSub(xR(4),xR(8));     % bR(8)
            Stage1Sub3OutJ = fpSub(xJ(4),xJ(8));     % bJ(8)

%=================================================================            
        case 2
            Stage2Add0OutR = fpAdd(Stage1Add0OutR,Stage1Add2OutR);     % cR(1)
            Stage2Add0OutJ = fpAdd(Stage1Add0OutJ,Stage1Add2OutJ);     % cJ(1)

            Stage2Sub0OutR = fpSub(Stage1Add0OutR,Stage1Add2OutR);     % cR(2)
            Stage2Sub0OutJ = fpSub(Stage1Add0OutJ,Stage1Add2OutJ);     % cJ(2)

            Stage2Add1OutR = fpAdd(Stage1Add1OutR,Stage1Add3OutR);     % cR(3)
            Stage2Add1OutJ = fpAdd(Stage1Add1OutJ,Stage1Add3OutJ);     % cJ(3)

            Stage2Sub1OutR = fpSub(Stage1Add1OutR,Stage1Add3OutR);     % cR(4)
            Stage2Sub1OutJ = fpSub(Stage1Add1OutJ,Stage1Add3OutJ);     % cJ(4)

            Stage2Add2OutR = fpAdd(Stage1Sub1OutR,Stage1Sub3OutR);     % cR(5)
            Stage2Add2OutJ = fpAdd(Stage1Sub1OutJ,Stage1Sub3OutJ);     % cJ(5)

            Stage2Sub2OutR = fpSub(Stage1Sub1OutR,Stage1Sub3OutR);     % cR(6)
            Stage2Sub2OutJ = fpSub(Stage1Sub1OutJ,Stage1Sub3OutJ);     % cJ(6)

%=================================================================
        case 3
            Stage3Mul0OutR = fpMul_Elementwise(kCos,Stage2Add2OutR);
            Stage3Mul0OutR = fpReformat(Stage3Mul0OutR, WL, WF, fpGetSigned(Stage3Mul0OutR), RoundMode);       % cR(5)
            Stage3Mul0OutJ = fpMul_Elementwise(kCos,Stage2Add2OutJ);
            Stage3Mul0OutJ = fpReformat(Stage3Mul0OutJ, WL, WF, fpGetSigned(Stage3Mul0OutJ), RoundMode);       % cJ(5)

            Stage3Mul1OutR = fpMul_Elementwise(kCos,Stage2Sub2OutR);
            Stage3Mul1OutR = fpReformat(Stage3Mul1OutR, WL, WF, fpGetSigned(Stage3Mul1OutR), RoundMode);       % cR(6)
            Stage3Mul1OutJ = fpMul_Elementwise(kCos,Stage2Sub2OutJ);
            Stage3Mul1OutJ = fpReformat(Stage3Mul1OutJ, WL, WF, fpGetSigned(Stage3Mul1OutJ), RoundMode);       % cJ(6)
            
%=================================================================        
        case 4
            Stage4Add0OutR = fpAdd(Stage2Add0OutR,Stage2Add1OutR);     % dR(1)
            Stage4Add0OutJ = fpAdd(Stage2Add0OutJ,Stage2Add1OutJ);     % dJ(1)
            
            Stage4Add1OutR = fpAdd(Stage1Sub0OutR,Stage3Mul1OutR);     % dR(2)
            Stage4Add1OutJ = fpAdd(Stage1Sub0OutJ,Stage3Mul1OutJ);     % dJ(2)

            Stage4AddSubOutR = fpAdd(Stage2Sub0OutR,Stage2Sub1OutJ);     % dR(3)
            Stage4AddSubOutJ = fpSub(Stage2Sub0OutJ,Stage2Sub1OutR);     % dJ(3)
            
            Stage4Add2OutR = fpAdd(Stage1Sub2OutJ,Stage3Mul0OutJ);     % dR(4)
            Stage4Add2OutJ = fpAdd(Stage1Sub2OutR,Stage3Mul0OutR);     % dJ(4)
            
            Stage4Sub0OutR = fpSub(Stage2Add0OutR,Stage2Add1OutR);     % dR(5)
            Stage4Sub0OutJ = fpSub(Stage2Add0OutJ,Stage2Add1OutJ);     % dJ(5)

            Stage4Sub1OutR = fpSub(Stage1Sub0OutR,Stage3Mul1OutR);     % dR(6)
            Stage4Sub1OutJ = fpSub(Stage1Sub0OutJ,Stage3Mul1OutJ);     % dJ(6)
            
            Stage4SubAddOutR = fpSub(Stage2Sub0OutR,Stage2Sub1OutJ);     % dR(7)
            Stage4SubAddOutJ = fpAdd(Stage2Sub0OutJ,Stage2Sub1OutR);     % dJ(7)

            Stage4Sub2OutR = fpSub(Stage3Mul0OutJ,Stage1Sub2OutJ);     % dR(8)
            Stage4Sub2OutJ = fpSub(Stage1Sub2OutR,Stage3Mul0OutR);     % dJ(8)

%=================================================================
        case 5
            Stage5AddSubOutR = fpAdd(Stage4Add1OutR,Stage4Add2OutR);     %XR(2)
            Stage5AddSubOutJ = fpSub(Stage4Add1OutJ,Stage4Add2OutJ);     %XJ(2)

            Stage5Add0OutR = fpAdd(Stage4Sub1OutR,Stage4Sub2OutR);     %XR(4)
            Stage5Add0OutJ = fpAdd(Stage4Sub1OutJ,Stage4Sub2OutJ);     %XJ(4)

            Stage5Sub0OutR = fpSub(Stage4Sub1OutR,Stage4Sub2OutR);     %XR(6)
            Stage5Sub0OutJ = fpSub(Stage4Sub1OutJ,Stage4Sub2OutJ);     %XJ(6)

            Stage5SubAddOutR = fpSub(Stage4Add1OutR,Stage4Add2OutR);     %XR(8)
            Stage5SubAddOutJ = fpAdd(Stage4Add1OutJ,Stage4Add2OutJ);     %XJ(8)

%=================================================================
        otherwise
            disp('Invalid Stage!')
    end
end

%% =================================================================
XoutR(1) = Stage4Add0OutR;
XoutJ(1) = Stage4Add0OutJ;

XoutR(2) = Stage5AddSubOutR;
XoutJ(2) = Stage5AddSubOutJ;

XoutR(3) = Stage4AddSubOutR;
XoutJ(3) = Stage4AddSubOutJ;

XoutR(4) = Stage5Add0OutR;
XoutJ(4) = Stage5Add0OutJ;

XoutR(5) = Stage4Sub0OutR;
XoutJ(5) = Stage4Sub0OutJ;

XoutR(6) = Stage5Sub0OutR;
XoutJ(6) = Stage5Sub0OutJ;

XoutR(7) = Stage4SubAddOutR;
XoutJ(7) = Stage4SubAddOutJ;

XoutR(8) = Stage5SubAddOutR;
XoutJ(8) = Stage5SubAddOutJ;

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



