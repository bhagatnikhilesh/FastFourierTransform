% clc
% clear all
% close all
% 
% xRin = [0 0 0];
% xJin = [0 1 0];

% xRin = [1.0000   -0.5000   -0.5000];        % Cosine
% xJin = [0   -0.8438    0.8438];

% xRin = [0    0.8125   -0.8125];               % Sine
% xJin = [1.0000   -0.5000   -0.5000];
function [XkR XkJ] = wfta3ptFunction(xR, xJ, WL ,WF, RoundMode, Signed)
N = 3;

% img = i;
% n = 1:1:3;

% x = [0 1 0];
% x = [0 + 1.0000i   0.8438 - 0.5000i  -0.8438 - 0.5000i];       % Sine
% x = [1.0000       -0.5000 - 0.8438i  -0.5000 + 0.8438i];      % Cosine

% for i=1:1:3
%     xR(i) = fpGetElement(xRin,i);
%     xJ(i) = fpGetElement(xJin,i);
% end

% RoundMode=2;
% Signed=1;
% WL = 8;
% WF = 4;
one = fpDouble2FP(1, 16, 8, Signed, RoundMode);
%% =================================================================
% u = ((2*pi)/3);
u = ((pi)/3);
s = sin(u);
c = cos(u);
kSin = fpDouble2FP(s, 16, 8, Signed, RoundMode);
kCos = fpDouble2FP(c, 16, 8, Signed, RoundMode);
temp1 = fpAdd(kCos,one);     % (cos(u)+1)
C3_0 = fpNeg(temp1);        % -(cos(u)+1)
C3_1 = kSin;

% for i = 1:1:N
%     xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
%     xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
% end
%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 1
%   # of sub = 1
%   # of mults = 2
%=================================================================
for stage = 1:1:5
    switch stage
        case 1
            Stage1Add0OutR = fpAdd(xR(2),xR(3));     % bR(1)
            Stage1Add0OutJ = fpAdd(xJ(2),xJ(3));     % bJ(1)

            Stage1Sub0OutR = fpSub(xR(2),xR(3));     % bR(2)
            Stage1Sub0OutJ = fpSub(xJ(2),xJ(3));     % bJ(2)
%=================================================================            
        case 2
            Stage2Add0OutR = fpAdd(Stage1Add0OutR,xR(1));     % cR(1)
            Stage2Add0OutJ = fpAdd(Stage1Add0OutJ,xJ(1));     % cJ(1)
%=================================================================
        case 3
            Stage3Mul0OutR = fpMul_Elementwise(C3_0,Stage1Add0OutR);
            Stage3Mul0OutR = fpReformat(Stage3Mul0OutR, WL, WF, fpGetSigned(Stage3Mul0OutR), RoundMode);       % cR(5)
            Stage3Mul0OutJ = fpMul_Elementwise(C3_0,Stage1Add0OutJ);
            Stage3Mul0OutJ = fpReformat(Stage3Mul0OutJ, WL, WF, fpGetSigned(Stage3Mul0OutJ), RoundMode);       % cJ(5)

            Stage3Mul1OutJ = fpMul_Elementwise(fpNeg(C3_1),Stage1Sub0OutR);
            Stage3Mul1OutJ = fpReformat(Stage3Mul1OutJ, WL, WF, fpGetSigned(Stage3Mul1OutJ), RoundMode);       % cR(6)
            Stage3Mul1OutR = fpMul_Elementwise(C3_1,Stage1Sub0OutJ);
            Stage3Mul1OutR = fpReformat(Stage3Mul1OutR, WL, WF, fpGetSigned(Stage3Mul1OutR), RoundMode);       % cJ(6)         
%=================================================================        
        case 4
            Stage4Add0OutR = fpAdd(Stage2Add0OutR,Stage3Mul0OutR);     % dR(1)
            Stage4Add0OutJ = fpAdd(Stage2Add0OutJ,Stage3Mul0OutJ);     % dJ(1)
%=================================================================
        case 5
            Stage5Add0OutR = fpAdd(Stage4Add0OutR,Stage3Mul1OutR);     %XR(4)
            Stage5Add0OutJ = fpAdd(Stage4Add0OutJ,Stage3Mul1OutJ);     %XJ(4)

            Stage5Sub0OutR = fpSub(Stage4Add0OutR,Stage3Mul1OutR);     %XR(6)
            Stage5Sub0OutJ = fpSub(Stage4Add0OutJ,Stage3Mul1OutJ);     %XJ(6)
%=================================================================
        otherwise
            disp('Invalid Stage!')
    end
end
%% =================================================================
XoutR(1) = Stage2Add0OutR;
XoutJ(1) = Stage2Add0OutJ;

XoutR(2) = Stage5Add0OutR;
XoutJ(2) = Stage5Add0OutJ;

XoutR(3) = Stage5Sub0OutR;
XoutJ(3) = Stage5Sub0OutJ;
%% =================================================================


XkR = XoutR;
XkJ = XoutJ;

end


% for(i = 1:1:N)
%     XkR(i) = fpFP2Double(XoutR(i));
%     XkJ(i) = fpFP2Double(XoutJ(i));
% %     disp(XkR(i));
% %     disp(XkJ(i));
% end
% 
% for i=1:1:N
%     Xk(i) = XkR(i) + img*XkJ(i);
% end
% 
% disp(Xk);
% figure(1);
% stem(n,(Xk));
% grid on;
% 
% Xf = fft(x);
% figure(2);
% stem(n,(Xf));
% grid on;
