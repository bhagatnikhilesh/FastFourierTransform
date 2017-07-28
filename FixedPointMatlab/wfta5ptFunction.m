% clc
% clear all
% close all
% 
function [XkR XkJ] = wfta5ptFunction(xR, xJ, WL ,WF, RoundMode, Signed)
% N = input('Enter the number of points: ');
N = 5;
% N = 5;
% 
% RoundMode=2;
% Signed=1;
% WL = 8;
% WF = 4;
% 
% xRin = [0 1 0 0 0];
% xJin = [0 0 0 0 0];

% xRin = [1.0000    0.3086   -0.8086   -0.8086    0.3086];
% xJin = [0   -0.9492   -0.5859    0.5859    0.9492];
 
% xRin = [0    0.9492    0.5859   -0.5859   -0.9492];
% xJin = [1.0000    0.3086   -0.8086   -0.8086    0.3086];

% x = [0 1 0 0 0];

% x = [1.0000          
%    0.3086 - 0.9492i
%   -0.8086 - 0.5859i
%   -0.8086 + 0.5859i
%    0.3086 + 0.9492i];

% x = [0 + 1.0000i
%    0.9492 + 0.3086i
%    0.5859 - 0.8086i
%   -0.5859 - 0.8086i
%   -0.9492 + 0.3086i];

% for i = 1:1:N
%     xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
%     xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
% end

img = 1i;
n = 1:1:5;
%% =================================================================
% for i=1:1:5
%     xR(i) = fpGetElement(xinR,i);
%     xJ(i) = fpGetElement(xinJ,i);
% end

% temp_xR = zeros(1,5);
% temp_xJ = zeros(1,5);
% temp_xR = fpDouble2FP(temp_xR, WL, WF, Signed, RoundMode);
% temp_xJ = fpDouble2FP(temp_xJ, WL, WF, Signed, RoundMode);
%% =================================================================
one = fpDouble2FP(1, 16, 8, Signed, RoundMode);
% zero = fpDouble2FP(0, WL, WF, Signed, RoundMode);
half = fpDouble2FP(0.5, 16, 8, Signed, RoundMode);

u = ((pi)/5);
u2 = ((2*pi)/5);

s = sin(u);
c = cos(u);
s2 = sin(u2);
c2 = cos(u2);

kSin = fpDouble2FP(s, 16, 8, Signed, RoundMode);   % Sin(u)
kCos = fpDouble2FP(c, 16, 8, Signed, RoundMode);   % Cos(u)
kSin2 = fpDouble2FP(s2, 16, 8, Signed, RoundMode); % Sin(2*u)
kCos2 = fpDouble2FP(c2, 16, 8, Signed, RoundMode); % Cos(2*u)

temp1 = fpSub(kCos2,kCos);          % cos(2u)-cos(u)
temp2 = fpMul_Elementwise(temp1,half);
temp2 = fpReformat(temp2, 16, 8, fpGetSigned(temp2), RoundMode);
temp3 = fpSub(temp2,one);           % (((cos(2u)-cos(u))/2)-1)

temp4 = fpAdd(kCos,kCos2);
temp5 = fpMul_Elementwise(temp4,half);  % ((cos(u) + cos(2*u))/2)
temp5 = fpReformat(temp5, 16, 8, fpGetSigned(temp5), RoundMode);

temp6 = fpSub(kSin,kSin2);  % (sin(u) - sin(2*u))

temp7 = fpAdd(kSin,kSin2);  % (sin(u) + sin(2*u))

%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 3
%   # of sub = 2
%   # of mults = 5
%=================================================================

for stage = 1:1:7
    switch stage
        case 1
            Stage1Add1OutR = fpAdd(xR(2),xR(5));  % Adder1R
            Stage1Add1OutJ = fpAdd(xJ(2),xJ(5));  % Adder1J

            Stage1Add2OutR = fpAdd(xR(4),xR(3));  % Adder2R
            Stage1Add2OutJ = fpAdd(xJ(4),xJ(3));  % Adder2J
            
            Stage1Sub1OutR = fpSub(xR(2),xR(5));  % Sub1R
            Stage1Sub1OutJ = fpSub(xJ(2),xJ(5));  % Sub1J

            Stage1Sub2OutR = fpSub(xR(3),xR(4));  % Sub2R
            Stage1Sub2OutJ = fpSub(xJ(3),xJ(4));  % Sub2J
%=================================================================            
        case 2
            Stage2Add1OutR = fpAdd(Stage1Add1OutR,Stage1Add2OutR);  % Adder3R
            Stage2Add1OutJ = fpAdd(Stage1Add1OutJ,Stage1Add2OutJ);  % Adder3J
            
            Stage2Sub1OutR = fpSub(Stage1Add1OutR,Stage1Add2OutR);  % Sub3R
            Stage2Sub1OutJ = fpSub(Stage1Add1OutJ,Stage1Add2OutJ);  % Sub3J
%=================================================================
       case 3
            Stage3Add1OutR = fpAdd(xR(1),Stage2Add1OutR);  % Adder4R
            Stage3Add1OutJ = fpAdd(xJ(1),Stage2Add1OutJ);  % Adder4J

            Stage3Add2OutR = fpAdd(Stage1Sub1OutR,Stage1Sub2OutR);  % Adder5R
            Stage3Add2OutJ = fpAdd(Stage1Sub1OutJ,Stage1Sub2OutJ);  % Adder5J
%=================================================================        
        case 4
            mult1OutR = fpMul_Elementwise(temp3,Stage2Add1OutR);  % Mult1R
            mult1OutR = fpReformat(mult1OutR, WL, WF, fpGetSigned(mult1OutR), RoundMode);
            mult1OutJ = fpMul_Elementwise(temp3,Stage2Add1OutJ);  % Mult1J
            mult1OutJ = fpReformat(mult1OutJ, WL, WF, fpGetSigned(mult1OutJ), RoundMode);

            mult2OutR = fpMul_Elementwise(temp5,Stage2Sub1OutR);  % Mult2R
            mult2OutR = fpReformat(mult2OutR, WL, WF, fpGetSigned(mult2OutR), RoundMode);
            mult2OutJ = fpMul_Elementwise(temp5,Stage2Sub1OutJ);  % Mult2J
            mult2OutJ = fpReformat(mult2OutJ, WL, WF, fpGetSigned(mult2OutJ), RoundMode);

            mult3OutR = fpMul_Elementwise(temp6,Stage1Sub1OutR);  % Mult3R
            mult3OutR = fpReformat(mult3OutR, WL, WF, fpGetSigned(mult3OutR), RoundMode);
            mult3OutJ = fpMul_Elementwise(fpNeg(temp6),Stage1Sub1OutJ);  % Mult3J
            mult3OutJ = fpReformat(mult3OutJ, WL, WF, fpGetSigned(mult3OutJ), RoundMode);
%             mult3Neg1OutR = fpNeg(mult3OutJ);
            mult3Neg1OutR = mult3OutJ;
            mult3Neg1OutJ = mult3OutR;

            mult4OutR = fpMul_Elementwise(temp7,Stage1Sub2OutR);  % Mult4R
            mult4OutR = fpReformat(mult4OutR, WL, WF, fpGetSigned(mult4OutR), RoundMode);
            mult4OutJ = fpMul_Elementwise(fpNeg(temp7),Stage1Sub2OutJ);  % Mult4J
            mult4OutJ = fpReformat(mult4OutJ, WL, WF, fpGetSigned(mult4OutJ), RoundMode);
%             mult4Neg2OutR = fpNeg(mult4OutJ);
            mult4Neg2OutR = mult4OutJ;
            mult4Neg2OutJ = mult4OutR;

            mult5OutR = fpMul_Elementwise(fpNeg(kSin),Stage3Add2OutR);  % Mult5R
            mult5OutR = fpReformat(mult5OutR, WL, WF, fpGetSigned(mult5OutR), RoundMode);
            mult5OutJ = fpMul_Elementwise(kSin,Stage3Add2OutJ);  % Mult5J
            mult5OutJ = fpReformat(mult5OutJ, WL, WF, fpGetSigned(mult5OutJ), RoundMode);
            mult5Neg3OutR = mult5OutJ;
            mult5Neg3OutJ = mult5OutR;
%             mult5Neg3OutJ = fpNeg(mult5OutR);            
%=================================================================            
        case 5
            Stage5Add1OutR = fpAdd(Stage3Add1OutR,mult1OutR);  % Adder6R
            Stage5Add1OutJ = fpAdd(Stage3Add1OutJ,mult1OutJ);  % Adder6J

            Stage5Add2OutR = fpAdd(mult3Neg1OutR,mult5Neg3OutR);  % Adder7R
            Stage5Add2OutJ = fpAdd(mult3Neg1OutJ,mult5Neg3OutJ);  % Adder7J

            Stage5Add3OutR = fpAdd(mult4Neg2OutR,mult5Neg3OutR);  % Adder8R
            Stage5Add3OutJ = fpAdd(mult4Neg2OutJ,mult5Neg3OutJ);  % Adder8J
%=================================================================            
        case 6
            Stage6Add1OutR = fpAdd(Stage5Add1OutR,mult2OutR);  % Adder9R
            Stage6Add1OutJ = fpAdd(Stage5Add1OutJ,mult2OutJ);  % Adder9J
            
            Stage6Sub1OutR = fpSub(Stage5Add1OutR,mult2OutR);  % Sub4R
            Stage6Sub1OutJ = fpSub(Stage5Add1OutJ,mult2OutJ);  % Sub4J
%=================================================================            
        case 7
            Stage7Add1OutR = fpAdd(Stage6Add1OutR,Stage5Add2OutR);  % Adder10R
            Stage7Add1OutJ = fpAdd(Stage6Add1OutJ,Stage5Add2OutJ);  % Adder10J

            Stage7Add2OutR = fpAdd(Stage6Sub1OutR,Stage5Add3OutR);  % Adder11R
            Stage7Add2OutJ = fpAdd(Stage6Sub1OutJ,Stage5Add3OutJ);  % Adder11J
            
            Stage7Sub1OutR = fpSub(Stage6Add1OutR,Stage5Add2OutR);  % Sub5R
            Stage7Sub1OutJ = fpSub(Stage6Add1OutJ,Stage5Add2OutJ);  % Sub5J

            Stage7Sub2OutR = fpSub(Stage6Sub1OutR,Stage5Add3OutR);  % Sub6R
            Stage7Sub2OutJ = fpSub(Stage6Sub1OutJ,Stage5Add3OutJ);  % Sub6J
%=================================================================            
        otherwise
            disp('Invalid Stage!')
    end
end
%% =================================================================
XoutR(1) = Stage3Add1OutR;
XoutJ(1) = Stage3Add1OutJ;

XoutR(2) = Stage7Add1OutR;
XoutJ(2) = Stage7Add1OutJ;

XoutR(3) = Stage7Add2OutR;
XoutJ(3) = Stage7Add2OutJ;

XoutR(4) = Stage7Sub2OutR;
XoutJ(4) = Stage7Sub2OutJ;

XoutR(5) = Stage7Sub1OutR;
XoutJ(5) = Stage7Sub1OutJ;

%% =================================================================
XkR = XoutR;
XkJ = XoutJ;

% for(i = 1:1:N)
%     XkR(i) = fpFP2Double(XoutR(i));
%     XkJ(i) = fpFP2Double(XoutJ(i));
% %     disp(XkR(i));
% %     disp(XkJ(i));
% end

end
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






