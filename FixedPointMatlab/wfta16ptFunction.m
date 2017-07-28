
% clc
% clear all
% close all
function [XkR XkJ] = wfta16ptFunction(xR, xJ, WL ,WF, RoundMode, Signed)
N = 16;

% xRin = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; 
% xJin = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; 

% Sine
% xRin = [0    0.3789    0.7070    0.9219    1.0000    0.9219    0.7070    0.3789         0   -0.3789   -0.7070   -0.9219   -1.0000   -0.9219   -0.7070   -0.3789];
% xJin = [1.0000    0.9219    0.7070    0.3789         0   -0.3789   -0.7070   -0.9219   -1.0000   -0.9219   -0.7070   -0.3789         0    0.3789    0.7070    0.9219];

% Cosine
% xRin = [1.0000    0.8750    0.6875    0.3750         0   -0.3750   -0.6875   -0.8750   -1.0000   -0.8750   -0.6875   -0.3750         0    0.3750    0.6875    0.8750];
% xJin = [0   -0.3750   -0.6875   -0.8750   -1.0000   -0.8750   -0.6875   -0.3750         0    0.3750    0.6875    0.8750    1.0000    0.8750    0.6875    0.3750];

% x = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

% x = [1.0000                 % Cosine
%    0.8750 - 0.3750i
%    0.6875 - 0.6875i
%    0.3750 - 0.8750i
%         0 - 1.0000i
%   -0.3750 - 0.8750i
%   -0.6875 - 0.6875i
%   -0.8750 - 0.3750i
%   -1.0000          
%   -0.8750 + 0.3750i
%   -0.6875 + 0.6875i
%   -0.3750 + 0.8750i
%         0 + 1.0000i
%    0.3750 + 0.8750i
%    0.6875 + 0.6875i
%    0.8750 + 0.3750i];

% x = [0 + 1.0000i
%    0.3789 + 0.9219i
%    0.7070 + 0.7070i
%    0.9219 + 0.3789i
%    1.0000          
%    0.9219 - 0.3789i
%    0.7070 - 0.7070i
%    0.3789 - 0.9219i
%         0 - 1.0000i
%   -0.3789 - 0.9219i
%   -0.7070 - 0.7070i
%   -0.9219 - 0.3789i
%   -1.0000          
%   -0.9219 + 0.3789i
%   -0.7070 + 0.7070i
%   -0.3789 + 0.9219i];

% n = 1:1:16;
% img = i;

% RoundMode=2;
% Signed=1;
% WL = 8;
% WF = 4;
one = fpDouble2FP(1, 16, 8, Signed, RoundMode);
zero = fpDouble2FP(0, 16, 8, Signed, RoundMode);

% for i = 1:1:N
%     xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
%     xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
% end
%% =================================================================
u = ((2*pi)/16);
u2 = ((4*pi)/16);
u3 = ((6*pi)/16);

s = sin(u);
c = cos(u);
s2 = sin(u2);
c2 = cos(u2);
s3 = sin(u3);
c3 = cos(u3);

kSin = fpDouble2FP(s, 16, 8, Signed, RoundMode);   % Sin(u)
kCos = fpDouble2FP(c, 16, 8, Signed, RoundMode);   % Cos(u)
kSin2 = fpDouble2FP(s2, 16, 8, Signed, RoundMode); % Sin(2*u)
kCos2 = fpDouble2FP(c2, 16, 8, Signed, RoundMode); % Cos(2*u)
kSin3 = fpDouble2FP(s3, 16, 8, Signed, RoundMode); % Sin(3*u)
kCos3 = fpDouble2FP(c3, 16, 8, Signed, RoundMode); % Cos(3*u)

temp1 = fpSub(kSin,kSin3);  % sin(u)-sin(3u)
temp2 = fpAdd(kSin,kSin3);  % sin(u)+sin(3u)

temp3 = fpAdd(kCos,kCos3);  % cos(u)+cos(3u)
temp4 = fpSub(kCos,kCos3);  % cos(u)-cos(3u)

C16_0 = kSin2;
C16_0Neg = fpNeg(C16_0);
C16_1 = kCos2;
C16_2 = kSin2;
C16_2Neg = fpNeg(C16_2);
C16_4 = kSin3;
C16_4Neg = fpNeg(C16_4);
C16_5 = temp1;
C16_5Neg = fpNeg(C16_5);
C16_6 = temp2;
C16_6Neg = fpNeg(C16_6);
C16_7 = kCos3;
C16_8 = temp3;
C16_8Neg = fpNeg(C16_8);
C16_9 = temp4;
C16_9Neg = fpNeg(C16_9);

%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 8
%   # of sub = 8
%   # of mults = 9
%=================================================================
for stage = 1:1:7
    switch stage
        case 1
            Stage1Add0OutR = fpAdd(xR(1),xR(9));     %bR(1)
            Stage1Add0OutJ = fpAdd(xJ(1),xJ(9));     %bJ(1)

            Stage1Sub0OutR = fpSub(xR(1),xR(9));     %bR(2)
            Stage1Sub0OutJ = fpSub(xJ(1),xJ(9));     %bJ(2)

            Stage1Add1OutR = fpAdd(xR(5),xR(13));     %bR(3)
            Stage1Add1OutJ = fpAdd(xJ(5),xJ(13));     %bJ(3)

            Stage1Sub1OutR = fpSub(xR(5),xR(13));     %bR(4)
            Stage1Sub1OutJ = fpSub(xJ(5),xJ(13));     %bJ(4)

            Stage1Add2OutR = fpAdd(xR(3),xR(11));     %bR(5)
            Stage1Add2OutJ = fpAdd(xJ(3),xJ(11));     %bJ(5)

            Stage1Sub2OutR = fpSub(xR(3),xR(11));     %bR(6)
            Stage1Sub2OutJ = fpSub(xJ(3),xJ(11));     %bJ(6)

            Stage1Add3OutR = fpAdd(xR(7),xR(15));     %bR(7)
            Stage1Add3OutJ = fpAdd(xJ(7),xJ(15));     %bJ(7)

            Stage1Sub3OutR = fpSub(xR(7),xR(15));     %bR(8)
            Stage1Sub3OutJ = fpSub(xJ(7),xJ(15));     %bJ(8)

            Stage1Add4OutR = fpAdd(xR(2),xR(10));     %bR(9)
            Stage1Add4OutJ = fpAdd(xJ(2),xJ(10));     %bJ(9)

            Stage1Sub4OutR = fpSub(xR(2),xR(10));     %bR(10)
            Stage1Sub4OutJ = fpSub(xJ(2),xJ(10));     %bJ(10)

            Stage1Add5OutR = fpAdd(xR(6),xR(14));     %bR(11)
            Stage1Add5OutJ = fpAdd(xJ(6),xJ(14));     %bJ(11)

            Stage1Sub5OutR = fpSub(xR(6),xR(14));     %bR(12)
            Stage1Sub5OutJ = fpSub(xJ(6),xJ(14));     %bJ(12)

            Stage1Add6OutR = fpAdd(xR(4),xR(12));     %bR(13)
            Stage1Add6OutJ = fpAdd(xJ(4),xJ(12));     %bJ(13)

            Stage1Sub6OutR = fpSub(xR(4),xR(12));     %bR(14)
            Stage1Sub6OutJ = fpSub(xJ(4),xJ(12));     %bJ(14)

            Stage1Add7OutR = fpAdd(xR(8),xR(16));     %bR(15)
            Stage1Add7OutJ = fpAdd(xJ(8),xJ(16));     %bJ(15)

            Stage1Sub7OutR = fpSub(xR(8),xR(16));     %bR(16)
            Stage1Sub7OutJ = fpSub(xJ(8),xJ(16));     %bJ(16)

%=================================================================            
        case 2
            Stage2Add0OutR = fpAdd(Stage1Add0OutR,Stage1Add1OutR);     %cR(1)
            Stage2Add0OutJ = fpAdd(Stage1Add0OutJ,Stage1Add1OutJ);     %cJ(1)

            Stage2Sub0OutR = fpSub(Stage1Add0OutR,Stage1Add1OutR);     %cR(2)
            Stage2Sub0OutJ = fpSub(Stage1Add0OutJ,Stage1Add1OutJ);     %cJ(2)

            Stage2Add1OutR = fpAdd(Stage1Add2OutR,Stage1Add3OutR);     %cR(3)
            Stage2Add1OutJ = fpAdd(Stage1Add2OutJ,Stage1Add3OutJ);     %cJ(3)

            Stage2Sub1OutR = fpSub(Stage1Add2OutR,Stage1Add3OutR);     %cR(4)
            Stage2Sub1OutJ = fpSub(Stage1Add2OutJ,Stage1Add3OutJ);     %cJ(4)

            Stage2Add2OutR = fpAdd(Stage1Add4OutR,Stage1Add5OutR);     %cR(5)
            Stage2Add2OutJ = fpAdd(Stage1Add4OutJ,Stage1Add5OutJ);     %cJ(5)

            Stage2Sub2OutR = fpSub(Stage1Add4OutR,Stage1Add5OutR);     %cR(6)
            Stage2Sub2OutJ = fpSub(Stage1Add4OutJ,Stage1Add5OutJ);     %cJ(6)

            Stage2Add3OutR = fpAdd(Stage1Add6OutR,Stage1Add7OutR);     %cR(7)
            Stage2Add3OutJ = fpAdd(Stage1Add6OutJ,Stage1Add7OutJ);     %cJ(7)

            Stage2Sub3OutR = fpSub(Stage1Add6OutR,Stage1Add7OutR);     %cR(8)
            Stage2Sub3OutJ = fpSub(Stage1Add6OutJ,Stage1Add7OutJ);     %cJ(8)

            Stage2Add4OutR = fpAdd(Stage1Sub2OutR,Stage1Sub3OutR);     %cR(9)
            Stage2Add4OutJ = fpAdd(Stage1Sub2OutJ,Stage1Sub3OutJ);     %cJ(9)

            Stage2Sub4OutR = fpSub(Stage1Sub2OutR,Stage1Sub3OutR);     %cR(10)
            Stage2Sub4OutJ = fpSub(Stage1Sub2OutJ,Stage1Sub3OutJ);     %cJ(10)

            Stage2Add5OutR = fpAdd(Stage1Sub4OutR,Stage1Sub7OutR);     %cR(11)
            Stage2Add5OutJ = fpAdd(Stage1Sub4OutJ,Stage1Sub7OutJ);     %cJ(11)

            Stage2Sub5OutR = fpSub(Stage1Sub4OutR,Stage1Sub7OutR);     %cR(12)
            Stage2Sub5OutJ = fpSub(Stage1Sub4OutJ,Stage1Sub7OutJ);     %cJ(12)

            Stage2Add6OutR = fpAdd(Stage1Sub5OutR,Stage1Sub6OutR);     %cR(13)
            Stage2Add6OutJ = fpAdd(Stage1Sub5OutJ,Stage1Sub6OutJ);     %cJ(13)

            Stage2Sub6OutR = fpSub(Stage1Sub5OutR,Stage1Sub6OutR);     %cR(14)
            Stage2Sub6OutJ = fpSub(Stage1Sub5OutJ,Stage1Sub6OutJ);     %cJ(14)

%=================================================================
        case 3
            Stage3Add0OutR = fpAdd(Stage2Add0OutR,Stage2Add1OutR);     %dR(1)
            Stage3Add0OutJ = fpAdd(Stage2Add0OutJ,Stage2Add1OutJ);     %dJ(1)

            Stage3Sub0OutR = fpSub(Stage2Add0OutR,Stage2Add1OutR);     %dR(2)
            Stage3Sub0OutJ = fpSub(Stage2Add0OutJ,Stage2Add1OutJ);     %dJ(2)

            Stage3Add1OutR = fpAdd(Stage2Add2OutR,Stage2Add3OutR);     %dR(3)
            Stage3Add1OutJ = fpAdd(Stage2Add2OutJ,Stage2Add3OutJ);     %dJ(3)

            Stage3Sub1OutR = fpSub(Stage2Add2OutR,Stage2Add3OutR);     %dR(4)
            Stage3Sub1OutJ = fpSub(Stage2Add2OutJ,Stage2Add3OutJ);     %dJ(4)

            Stage3Add2OutR = fpAdd(Stage2Sub2OutR,Stage2Sub3OutR);     %dR(5)
            Stage3Add2OutJ = fpAdd(Stage2Sub2OutJ,Stage2Sub3OutJ);     %dJ(5)

            Stage3Sub2OutR = fpSub(Stage2Sub2OutR,Stage2Sub3OutR);     %dR(6)
            Stage3Sub2OutJ = fpSub(Stage2Sub2OutJ,Stage2Sub3OutJ);     %dJ(6)

            Stage3Add3OutR = fpAdd(Stage2Add5OutR,Stage2Add6OutR);     %dR(7)
            Stage3Add3OutJ = fpAdd(Stage2Add5OutJ,Stage2Add6OutJ);     %dJ(7)

            Stage3Add4OutR = fpAdd(Stage2Sub5OutR,Stage2Sub6OutR);     %dR(8)
            Stage3Add4OutJ = fpAdd(Stage2Sub5OutJ,Stage2Sub6OutJ);     %dJ(8)

%=================================================================        
        case 4
            Stage4Add0OutR = fpAdd(Stage3Add0OutR,Stage3Add1OutR);     %eR(1)
            Stage4Add0OutJ = fpAdd(Stage3Add0OutJ,Stage3Add1OutJ);     %eJ(1)

            Stage4Sub0OutR = fpSub(Stage3Add0OutR,Stage3Add1OutR);     %eR(2)
            Stage4Sub0OutJ = fpSub(Stage3Add0OutJ,Stage3Add1OutJ);     %eJ(2)

%             eR(3) = dR(2);
%             eJ(3) = dJ(2);

%             eR(4) = dJ(4);
%             eJ(4) = fpNeg(dR(4));
            Stage4Stage3Sub1OutR = Stage3Sub1OutJ;              %eR(4)
            Stage4Stage3Sub1OutJ = fpNeg(Stage3Sub1OutR);       %eJ(4)

%             eR(5) = cR(2);
%             eJ(5) = cJ(2);

%             eR(6) = cJ(4);
%             eJ(6) = fpNeg(cR(4));
            Stage4Stage2Sub1OutR = Stage2Sub1OutJ;              %eR(6)
            Stage4Stage2Sub1OutJ = fpNeg(Stage2Sub1OutR);       %eJ(6)

            Stage4Mul0OutR = fpMul_Elementwise(C16_0,Stage3Add2OutJ);
            Stage4Mul0OutR = fpReformat(Stage4Mul0OutR, WL, WF, fpGetSigned(Stage4Mul0OutR), RoundMode);       %eR(7)
            Stage4Mul0OutJ = fpMul_Elementwise(C16_0Neg,Stage3Add2OutR);
            Stage4Mul0OutJ = fpReformat(Stage4Mul0OutJ, WL, WF, fpGetSigned(Stage4Mul0OutJ), RoundMode);       %eJ(7)
%             eJ(7) = fpNeg(eJ7);

            Stage4Mul1OutR = fpMul_Elementwise(C16_1,Stage3Sub2OutR);
            Stage4Mul1OutR = fpReformat(Stage4Mul1OutR, WL, WF, fpGetSigned(Stage4Mul1OutR), RoundMode);       %eR(8)
            Stage4Mul1OutJ = fpMul_Elementwise(C16_1,Stage3Sub2OutJ);
            Stage4Mul1OutJ = fpReformat(Stage4Mul1OutJ, WL, WF, fpGetSigned(Stage4Mul1OutJ), RoundMode);       %eJ(8)

%             eR(9) = bR(2);
%             eJ(9) = bJ(2);

%             eR(10) = bJ(4);
%             eJ(10) = fpNeg(bR(4));
            Stage4Stage1Sub1OutR = Stage1Sub1OutJ;              %eR(10)
            Stage4Stage1Sub1OutJ = fpNeg(Stage1Sub1OutR);       %eJ(10)
            
            Stage4Mul2OutR = fpMul_Elementwise(C16_2,Stage2Add4OutJ);
            Stage4Mul2OutR = fpReformat(Stage4Mul2OutR, WL, WF, fpGetSigned(Stage4Mul2OutR), RoundMode);       %eR(11)
            Stage4Mul2OutJ = fpMul_Elementwise(C16_2Neg,Stage2Add4OutR);
            Stage4Mul2OutJ = fpReformat(Stage4Mul2OutJ, WL, WF, fpGetSigned(Stage4Mul2OutJ), RoundMode);       %eJ(11)
%             eJ(11) = fpNeg(eJ11);

            Stage4Mul3OutR = fpMul_Elementwise(C16_1,Stage2Sub4OutR);
            Stage4Mul3OutR = fpReformat(Stage4Mul3OutR, WL, WF, fpGetSigned(Stage4Mul3OutR), RoundMode);       %eR(12)
            Stage4Mul3OutJ = fpMul_Elementwise(C16_1,Stage2Sub4OutJ);
            Stage4Mul3OutJ = fpReformat(Stage4Mul3OutJ, WL, WF, fpGetSigned(Stage4Mul3OutJ), RoundMode);       %eJ(12)

            Stage4Mul4OutR = fpMul_Elementwise(C16_4,Stage3Add3OutJ);
            Stage4Mul4OutR = fpReformat(Stage4Mul4OutR, WL, WF, fpGetSigned(Stage4Mul4OutR), RoundMode);               %eR(13)
            Stage4Mul4OutJ = fpMul_Elementwise(C16_4Neg,Stage3Add3OutR);
            Stage4Mul4OutJ = fpReformat(Stage4Mul4OutJ, WL, WF, fpGetSigned(Stage4Mul4OutJ), RoundMode);       %eJ(13)
%             eJ(13) = fpNeg(eJ13);

            Stage4Mul5OutR = fpMul_Elementwise(C16_5,Stage2Add5OutJ);
            Stage4Mul5OutR = fpReformat(Stage4Mul5OutR, WL, WF, fpGetSigned(Stage4Mul5OutR), RoundMode);       %eR(14)
            Stage4Mul5OutJ = fpMul_Elementwise(C16_5Neg,Stage2Add5OutR);
            Stage4Mul5OutJ = fpReformat(Stage4Mul5OutJ, WL, WF, fpGetSigned(Stage4Mul5OutJ), RoundMode);       %eJ(14)
%             eJ(14) = fpNeg(eJ14);

            Stage4Mul6OutR = fpMul_Elementwise(C16_6,Stage2Add6OutJ);
            Stage4Mul6OutR = fpReformat(Stage4Mul6OutR, WL, WF, fpGetSigned(Stage4Mul6OutR), RoundMode);       %eR(15)
            Stage4Mul6OutJ = fpMul_Elementwise(C16_6Neg,Stage2Add6OutR);
            Stage4Mul6OutJ = fpReformat(Stage4Mul6OutJ, WL, WF, fpGetSigned(Stage4Mul6OutJ), RoundMode);       %eJ(15)
%             eJ(15) = fpNeg(eJ15);

            Stage4Mul7OutR = fpMul_Elementwise(C16_7,Stage3Add4OutR);
            Stage4Mul7OutR = fpReformat(Stage4Mul7OutR, WL, WF, fpGetSigned(Stage4Mul7OutR), RoundMode);       %eR(16)
            Stage4Mul7OutJ = fpMul_Elementwise(C16_7,Stage3Add4OutJ);
            Stage4Mul7OutJ = fpReformat(Stage4Mul7OutJ, WL, WF, fpGetSigned(Stage4Mul7OutJ), RoundMode);       %eJ(16)

            Stage4Mul8OutR = fpMul_Elementwise(C16_8,Stage2Sub5OutR);
            Stage4Mul8OutR = fpReformat(Stage4Mul8OutR, WL, WF, fpGetSigned(Stage4Mul8OutR), RoundMode);       %eR(17)
            Stage4Mul8OutJ = fpMul_Elementwise(C16_8,Stage2Sub5OutJ);
            Stage4Mul8OutJ = fpReformat(Stage4Mul8OutJ, WL, WF, fpGetSigned(Stage4Mul8OutJ), RoundMode);       %eJ(17)

            Stage4Mul9OutR =  fpMul_Elementwise(C16_9Neg,Stage2Sub6OutR);
            Stage4Mul9OutR = fpReformat(Stage4Mul9OutR, WL, WF, fpGetSigned(Stage4Mul9OutR), RoundMode);       %eR(18)
%             eR(18) = fpNeg(eR18);
            Stage4Mul9OutJ =  fpMul_Elementwise(C16_9Neg,Stage2Sub6OutJ);
            Stage4Mul9OutJ = fpReformat(Stage4Mul9OutJ, WL, WF, fpGetSigned(Stage4Mul9OutJ), RoundMode);       %eJ(18)
%             eJ(18) = fpNeg(eJ18);

%=================================================================
        case 5
            Stage5Add0OutR = fpAdd(Stage3Sub0OutR,Stage4Stage3Sub1OutR);     %fR(1)
            Stage5Add0OutJ = fpAdd(Stage3Sub0OutJ,Stage4Stage3Sub1OutJ);     %fJ(1)

            Stage5Sub0OutR = fpSub(Stage3Sub0OutR,Stage4Stage3Sub1OutR);     %fR(2)
            Stage5Sub0OutJ = fpSub(Stage3Sub0OutJ,Stage4Stage3Sub1OutJ);     %fJ(2)

            Stage5Add1OutR = fpAdd(Stage2Sub0OutR,Stage4Mul0OutR);     %fR(3)
            Stage5Add1OutJ = fpAdd(Stage2Sub0OutJ,Stage4Mul0OutJ);     %fJ(3)

            Stage5Sub1OutR = fpSub(Stage2Sub0OutR,Stage4Mul0OutR);     %fR(4)
            Stage5Sub1OutJ = fpSub(Stage2Sub0OutJ,Stage4Mul0OutJ);     %fJ(4)

            Stage5Add2OutR = fpAdd(Stage4Stage2Sub1OutR,Stage4Mul1OutR);     %fR(5)
            Stage5Add2OutJ = fpAdd(Stage4Stage2Sub1OutJ,Stage4Mul1OutJ);     %fJ(5)

            Stage5Sub2OutR = fpSub(Stage4Stage2Sub1OutR,Stage4Mul1OutR);     %fR(6)
            Stage5Sub2OutJ = fpSub(Stage4Stage2Sub1OutJ,Stage4Mul1OutJ);     %fJ(6)

            Stage5Add3OutR = fpAdd(Stage1Sub0OutR,Stage4Mul3OutR);     %fR(7)
            Stage5Add3OutJ = fpAdd(Stage1Sub0OutJ,Stage4Mul3OutJ);     %fJ(7)

            Stage5Sub3OutR = fpSub(Stage1Sub0OutR,Stage4Mul3OutR);     %fR(8)
            Stage5Sub3OutJ = fpSub(Stage1Sub0OutJ,Stage4Mul3OutJ);     %fJ(8)

            Stage5Add4OutR = fpAdd(Stage4Stage1Sub1OutR,Stage4Mul2OutR);     %fR(9)
            Stage5Add4OutJ = fpAdd(Stage4Stage1Sub1OutJ,Stage4Mul2OutJ);     %fJ(9)

            Stage5Sub4OutR = fpSub(Stage4Stage1Sub1OutR,Stage4Mul2OutR);     %fR(10)
            Stage5Sub4OutJ = fpSub(Stage4Stage1Sub1OutJ,Stage4Mul2OutJ);     %fJ(10)

            Stage5Add5OutR = fpAdd(Stage4Mul4OutR,Stage4Mul5OutR);     %fR(11)
            Stage5Add5OutJ = fpAdd(Stage4Mul4OutJ,Stage4Mul5OutJ);     %fJ(11)

            Stage5Sub5OutR = fpSub(Stage4Mul4OutR,Stage4Mul6OutR);     %fR(12)
            Stage5Sub5OutJ = fpSub(Stage4Mul4OutJ,Stage4Mul6OutJ);     %fJ(12)

            Stage5Sub6OutR = fpSub(Stage4Mul8OutR,Stage4Mul7OutR);     %fR(13)
            Stage5Sub6OutJ = fpSub(Stage4Mul8OutJ,Stage4Mul7OutJ);     %fJ(13)

            Stage5Sub7OutR = fpSub(Stage4Mul9OutR,Stage4Mul7OutR);     %fR(14)
            Stage5Sub7OutJ = fpSub(Stage4Mul9OutJ,Stage4Mul7OutJ);     %fJ(14)

%=================================================================
        case 6
            Stage6Add0OutR = fpAdd(Stage5Add1OutR,Stage5Add2OutR);     %gR(1)
            Stage6Add0OutJ = fpAdd(Stage5Add1OutJ,Stage5Add2OutJ);     %gJ(1)

            Stage6Sub0OutR = fpSub(Stage5Add1OutR,Stage5Add2OutR);     %gR(2)
            Stage6Sub0OutJ = fpSub(Stage5Add1OutJ,Stage5Add2OutJ);     %gJ(2)

            Stage6Add1OutR = fpAdd(Stage5Sub1OutR,Stage5Sub2OutR);     %gR(3)
            Stage6Add1OutJ = fpAdd(Stage5Sub1OutJ,Stage5Sub2OutJ);     %gJ(3)

            Stage6Sub1OutR = fpSub(Stage5Sub1OutR,Stage5Sub2OutR);     %gR(4)
            Stage6Sub1OutJ = fpSub(Stage5Sub1OutJ,Stage5Sub2OutJ);     %gJ(4)

            Stage6Add2OutR = fpAdd(Stage5Add3OutR,Stage5Add5OutR);     %gR(5)
            Stage6Add2OutJ = fpAdd(Stage5Add3OutJ,Stage5Add5OutJ);     %gJ(5)

            Stage6Sub2OutR = fpSub(Stage5Add3OutR,Stage5Add5OutR);     %gR(6)
            Stage6Sub2OutJ = fpSub(Stage5Add3OutJ,Stage5Add5OutJ);     %gJ(6)

            Stage6Add3OutR = fpAdd(Stage5Sub3OutR,Stage5Sub5OutR);     %gR(7)
            Stage6Add3OutJ = fpAdd(Stage5Sub3OutJ,Stage5Sub5OutJ);     %gJ(7)

            Stage6Sub3OutR = fpSub(Stage5Sub3OutR,Stage5Sub5OutR);     %gR(8)
            Stage6Sub3OutJ = fpSub(Stage5Sub3OutJ,Stage5Sub5OutJ);     %gJ(8)

            Stage6Add4OutR = fpAdd(Stage5Add4OutR,Stage5Sub6OutR);     %gR(9)
            Stage6Add4OutJ = fpAdd(Stage5Add4OutJ,Stage5Sub6OutJ);     %gJ(9)

            Stage6Sub4OutR = fpSub(Stage5Add4OutR,Stage5Sub6OutR);     %gR(10)
            Stage6Sub4OutJ = fpSub(Stage5Add4OutJ,Stage5Sub6OutJ);     %gJ(10)

            Stage6Add5OutR = fpAdd(Stage5Sub4OutR,Stage5Sub7OutR);     %gR(11)
            Stage6Add5OutJ = fpAdd(Stage5Sub4OutJ,Stage5Sub7OutJ);     %gJ(11)

            Stage6Sub5OutR = fpSub(Stage5Sub4OutR,Stage5Sub7OutR);     %gR(12)
            Stage6Sub5OutJ = fpSub(Stage5Sub4OutJ,Stage5Sub7OutJ);     %gJ(12)

%=================================================================            
        case 7
            XoutR(1) = Stage4Add0OutR;      %XR(1)
            XoutJ(1) = Stage4Add0OutJ;      %XJ(1)

            XoutR(2) = fpAdd(Stage6Add2OutR,Stage6Add4OutR);      %XR(2)
            XoutJ(2) = fpAdd(Stage6Add2OutJ,Stage6Add4OutJ);      %XJ(2)

            XoutR(3) = Stage6Add0OutR;      %XR(3)
            XoutJ(3) = Stage6Add0OutJ;      %XJ(3)

            XoutR(4) = fpSub(Stage6Add3OutR,Stage6Add5OutR);      %XR(4)
            XoutJ(4) = fpSub(Stage6Add3OutJ,Stage6Add5OutJ);      %XJ(4)

            XoutR(5) = Stage5Add0OutR;      %XR(5)
            XoutJ(5) = Stage5Add0OutJ;      %XJ(5)

            XoutR(6) = fpAdd(Stage6Add3OutR,Stage6Add5OutR);      %XR(6)
            XoutJ(6) = fpAdd(Stage6Add3OutJ,Stage6Add5OutJ);      %XJ(6)

            XoutR(7) = Stage6Sub0OutR;      %XR(7)
            XoutJ(7) = Stage6Sub0OutJ;      %XJ(7)

            XoutR(8) = fpSub(Stage6Add2OutR,Stage6Add4OutR);      %XR(8)
            XoutJ(8) = fpSub(Stage6Add2OutJ,Stage6Add4OutJ);      %XJ(8)

            XoutR(9) = Stage4Sub0OutR;      %XR(9)
            XoutJ(9) = Stage4Sub0OutJ;      %XJ(9)

            XoutR(10) = fpAdd(Stage6Sub2OutR,Stage6Sub4OutR);      %XR(10)
            XoutJ(10) = fpAdd(Stage6Sub2OutJ,Stage6Sub4OutJ);      %XJ(10)

            XoutR(11) = Stage6Add1OutR;      %XR(11)
            XoutJ(11) = Stage6Add1OutJ;      %XJ(11)

            XoutR(12) = fpSub(Stage6Sub3OutR,Stage6Sub5OutR);      %XR(12)
            XoutJ(12) = fpSub(Stage6Sub3OutJ,Stage6Sub5OutJ);      %XJ(12)

            XoutR(13) = Stage5Sub0OutR;      %XR(13)
            XoutJ(13) = Stage5Sub0OutJ;      %XJ(13)

            XoutR(14) = fpAdd(Stage6Sub3OutR,Stage6Sub5OutR);      %XR(14)
            XoutJ(14) = fpAdd(Stage6Sub3OutJ,Stage6Sub5OutJ);      %XJ(14)

            XoutR(15) = Stage6Sub1OutR;      %XR(15)
            XoutJ(15) = Stage6Sub1OutJ;      %XJ(15)

            XoutR(16) = fpSub(Stage6Sub2OutR,Stage6Sub4OutR);      %XR(16)
            XoutJ(16) = fpSub(Stage6Sub2OutJ,Stage6Sub4OutJ);      %XJ(16)

%=================================================================
        otherwise
            disp('Invalid Stage!')
    end
end

%% =================================================================

XkR = XoutR;
XkJ = XoutJ;

end
%% =================================================================
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

