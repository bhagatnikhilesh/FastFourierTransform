clc
clear all
close all
% function [XkR XkJ] = wfta_9pt(xinR, xinJ, WL ,WF)


N = 9;

xRin = [0 0 0 0 0 0 0 0 0];   %input('Enter the real part: ');
xJin = [0 1 0 0 0 0 0 0 0];   %input('Enter the imaginary part: ');

% xRin = [0    0.6367    0.9766    0.8633    0.3398   -0.3398   -0.8633   -0.9766   -0.6367];
% xJin = [1.0000    0.7617    0.1758   -0.5000   -0.9375   -0.9375   -0.5000    0.1758    0.7617];

% xRin = [1.0000    0.7617    0.1758   -0.5000   -0.9375   -0.9375   -0.5000    0.1758    0.7617];    % Cosine
% xJin = [0   -0.6367   -0.9766   -0.8633   -0.3398    0.3398    0.8633    0.9766    0.6367];

x = [0 1 0 0 0 0 0 0 0];
% x= [1.0000  0.7617 - 0.6367i   0.1758 - 0.9766i  -0.5000 - 0.8633i  -0.9375 - 0.3398i  -0.9375 + 0.3398i  -0.5000 + 0.8633i   0.1758 + 0.9766i   0.7617 + 0.6367i];

n = 1:1:9;
img = i;

k = 1/3;
RoundMode=2;
Signed=1;
WL = 8;
WF = 4;

for i = 1:1:N
    xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
    xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
end

%% =================================================================
half = fpDouble2FP(0.5, 16, 8, Signed, RoundMode);
one = fpDouble2FP(1, 16, 8, Signed, RoundMode);
two = fpDouble2FP(2, 16, 8, Signed, RoundMode);
zero = fpDouble2FP(0, 16, 8, Signed, RoundMode);
oneBy3 = fpDouble2FP(k, 16, 8, Signed, RoundMode);

u = ((2*pi)/N);
u2 = ((4*pi)/N);
u3 = ((6*pi)/N);
u4 = ((8*pi)/N);

s = sin(u);
c = cos(u);
s2 = sin(u2);
c2 = cos(u2);
s3 = sin(u3);
c3 = cos(u3);
s4 = sin(u4);
c4 = cos(u4);

kSin = fpDouble2FP(s, 16, 8, Signed, RoundMode);   % Sin(u)
kCos = fpDouble2FP(c, 16, 8, Signed, RoundMode);   % Cos(u)
kSin2 = fpDouble2FP(s2, 16, 8, Signed, RoundMode); % Sin(2*u)
kCos2 = fpDouble2FP(c2, 16, 8, Signed, RoundMode); % Cos(2*u)

C9_0Neg = fpNeg(half);

kSin3 = fpDouble2FP(s3, 16, 8, Signed, RoundMode); % Sin(3*u)
kSin3Neg = fpNeg(kSin3);
C9_1 = kSin3;
C9_1Neg = kSin3Neg;

kCos3 = fpDouble2FP(c3, 16, 8, Signed, RoundMode); % Cos(3*u)
C9_2 = fpSub(kCos3,one);% Cos(3*u)-1

kSin4 = fpDouble2FP(s4, 16, 8, Signed, RoundMode); % Sin(4*u)
kCos4 = fpDouble2FP(c4, 16, 8, Signed, RoundMode); % Cos(4*u)

temp1 = fpMul_Elementwise(kCos,two);
temp1 = fpReformat(temp1, 16, 8, fpGetSigned(temp1), RoundMode);
temp1 = fpSub(temp1,kCos2);
temp1 = fpSub(temp1,kCos4); % 2cos(u)-cos(2u)-cos(4u)
temp1 = fpMul_Elementwise(oneBy3,temp1);
C9_4 = fpReformat(temp1, 16, 8, fpGetSigned(temp1), RoundMode);  % (2cos(u)-cos(2u)-cos(4u))/3

temp2 = fpMul_Elementwise(kCos4,two);
temp2 = fpReformat(temp2, 16, 8, fpGetSigned(temp2), RoundMode); 
temp2 = fpSub(kCos2,temp2);
temp2 = fpAdd(kCos,temp2);  % cos(u)+cos(2u)-2cos(4u)
temp2 = fpMul_Elementwise(oneBy3,temp2);
C9_5 = fpReformat(temp2, 16, 8, fpGetSigned(temp2), RoundMode);     % (cos(u)+cos(2u)-2cos(4u))/3

temp3 = fpMul_Elementwise(kCos2,two);
temp3 = fpReformat(temp3, 16, 8, fpGetSigned(temp3), RoundMode); 
temp3 = fpSub(kCos,temp3);
temp3 = fpAdd(kCos4,temp3);  % cos(u)-2cos(2u)+cos(4u)
temp3 = fpMul_Elementwise(oneBy3,temp3);
C9_6 = fpReformat(temp3, 16, 8, fpGetSigned(temp3), RoundMode);  % (cos(u)-2cos(2u)+cos(4u) )/3

temp4 = fpMul_Elementwise(kSin,two);
temp4 = fpReformat(temp4, 16, 8, fpGetSigned(temp4), RoundMode); 
temp4 = fpAdd(kSin2,temp4);
temp4 = fpSub(temp4,kSin4);  % 2sin(u)+sin(2u)-sin(4u)
temp4 = fpMul_Elementwise(oneBy3,temp4);
C9_7 = fpReformat(temp4, 16, 8, fpGetSigned(temp4), RoundMode);  % (2sin(u)+sin(2u)-sin(4u))/3
C9_7Neg = fpNeg(C9_7);

temp5 = fpMul_Elementwise(kSin4,two);
temp5 = fpReformat(temp5, 16, 8, fpGetSigned(temp5), RoundMode); 
temp5 = fpSub(kSin,temp5);
temp5 = fpSub(temp5,kSin2);  % sin(u)-2sin(4u)-sin(2u)
temp5 = fpMul_Elementwise(oneBy3,temp5);
C9_8 = fpReformat(temp5, 16, 8, fpGetSigned(temp5), RoundMode);  % (sin(u)-2sin(4u)-sin(2u))/3
C9_8Neg = fpNeg(C9_8);

temp6 = fpMul_Elementwise(kSin2,two);
temp6 = fpReformat(temp6, 16, 8, fpGetSigned(temp6), RoundMode); 
temp6 = fpAdd(kSin,temp6);
temp6 = fpAdd(temp6,kSin4);  % sin(u)+sin(4u)+2sin(2u)
temp6 = fpMul_Elementwise(oneBy3,temp6);
C9_9 = fpReformat(temp6, 16, 8, fpGetSigned(temp6), RoundMode);   % (sin(u)+sin(4u)+2sin(2u))/3
C9_9Neg = fpNeg(C9_9);

%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 4
%   # of sub = 6
%   # of mults = 10
%=================================================================
for stage = 1:1:10
    switch stage
        case 1
            Stage1Add0OutR = fpAdd(xR(4),xR(7));     %bR(5)
            Stage1Add0OutJ = fpAdd(xJ(4),xJ(7));     %bJ(5)
            
            Stage1Add1OutR = fpAdd(xR(5),xR(6));     %bR(7)
            Stage1Add1OutJ = fpAdd(xJ(5),xJ(6));     %bJ(7)
            
            Stage1Add2OutR = fpAdd(xR(2),xR(9));     %bR(1)
            Stage1Add2OutJ = fpAdd(xJ(2),xJ(9));     %bJ(1)
            
            Stage1Add3OutR = fpAdd(xR(8),xR(3));     %bR(3)
            Stage1Add3OutJ = fpAdd(xJ(8),xJ(3));     %bJ(3)
            
            Stage1Sub0OutR = fpSub(xR(4),xR(7));     %bR(6)
            Stage1Sub0OutJ = fpSub(xJ(4),xJ(7));     %bJ(6)

            Stage1Sub1OutR = fpSub(xR(5),xR(6));     %bR(8)
            Stage1Sub1OutJ = fpSub(xJ(5),xJ(6));     %bJ(8)
            
            Stage1Sub2OutR = fpSub(xR(2),xR(9));     %bR(2)
            Stage1Sub2OutJ = fpSub(xJ(2),xJ(9));     %bJ(2)

            Stage1Sub3OutR = fpSub(xR(8),xR(3));     %bR(4)
            Stage1Sub3OutJ = fpSub(xJ(8),xJ(3));     %bJ(4)
%=================================================================            
        case 2
            Stage2Sub0OutR = fpSub(Stage1Add1OutR,Stage1Add2OutR);       %cR(6)
            Stage2Sub0OutJ = fpSub(Stage1Add1OutJ,Stage1Add2OutJ);       %cJ(6)
            
            Stage2Sub1OutR = fpSub(Stage1Add3OutR,Stage1Add1OutR);       %cR(5)
            Stage2Sub1OutJ = fpSub(Stage1Add3OutJ,Stage1Add1OutJ);       %cJ(5)
            
            Stage2Add0OutR = fpAdd(Stage1Add2OutR,Stage1Add3OutR);       %cR(1)
            Stage2Add0OutJ = fpAdd(Stage1Add2OutJ,Stage1Add3OutJ);       %cJ(1)
            
            Stage2Sub2OutR = fpSub(Stage1Add2OutR,Stage1Add3OutR);       %cR(2)
            Stage2Sub2OutJ = fpSub(Stage1Add2OutJ,Stage1Add3OutJ);       %cJ(2)
            
            Stage2Sub3OutR = fpSub(Stage1Sub3OutR,Stage1Sub1OutR);       %cR(7)
            Stage2Sub3OutJ = fpSub(Stage1Sub3OutJ,Stage1Sub1OutJ);       %cJ(7)

            Stage2Sub4OutR = fpSub(Stage1Sub1OutR,Stage1Sub2OutR);       %cR(8)
            Stage2Sub4OutJ = fpSub(Stage1Sub1OutJ,Stage1Sub2OutJ);       %cJ(8)

            Stage2Add1OutR = fpAdd(Stage1Sub2OutR,Stage1Sub3OutR);       %cR(3)
            Stage2Add1OutJ = fpAdd(Stage1Sub2OutJ,Stage1Sub3OutJ);       %cJ(3)

            Stage2Sub5OutR = fpSub(Stage1Sub2OutR,Stage1Sub3OutR);       %cR(4)
            Stage2Sub5OutJ = fpSub(Stage1Sub2OutJ,Stage1Sub3OutJ);       %cJ(4)

%=================================================================
        case 3
            Stage3Add0OutR = fpAdd(Stage2Add0OutR,Stage1Add1OutR);       %dR(1)
            Stage3Add0OutJ = fpAdd(Stage2Add0OutJ,Stage1Add1OutJ);       %dJ(1)

            Stage3Add1OutR = fpAdd(Stage2Add1OutR,Stage1Sub1OutR);       %dR(2)
            Stage3Add1OutJ = fpAdd(Stage2Add1OutJ,Stage1Sub1OutJ);       %dJ(2)
            
            Stage3Add2OutR = fpAdd(Stage1Add0OutR,xR(1));       %dR(3)
            Stage3Add2OutJ = fpAdd(Stage1Add0OutJ,xJ(1));       %dJ(3)
            
%=================================================================        
        case 4

%=================================================================
        case 5
            Stage5Add2OutR = fpAdd(Stage3Add2OutR,Stage3Add1OutR);       %fR(1)
            Stage5Add2OutJ = fpAdd(Stage3Add2OutJ,Stage3Add1OutJ);       %fJ(1)
            
            Stage3Mul0OutR = fpMul_Elementwise(C9_0Neg,Stage3Add0OutR);
            Stage3Mul0OutR = fpReformat(Stage3Mul0OutR, WL, WF, fpGetSigned(Stage3Mul0OutR), RoundMode);       %fR(2)
            Stage3Mul0OutJ = fpMul_Elementwise(C9_0Neg,Stage3Add0OutJ);
            Stage3Mul0OutJ = fpReformat(Stage3Mul0OutJ, WL, WF, fpGetSigned(Stage3Mul0OutJ), RoundMode);       %fJ(2)

            Stage3Mul1OutR = fpMul_Elementwise(C9_1,Stage3Add1OutJ);
            Stage3Mul1OutR = fpReformat(Stage3Mul1OutR, WL, WF, fpGetSigned(Stage3Mul1OutR), RoundMode);       %fR(3)
            Stage3Mul1OutJ = fpMul_Elementwise(C9_1,Stage3Add1OutR);
            Stage3Mul1OutJ = fpReformat(Stage3Mul1OutJ, WL, WF, fpGetSigned(Stage3Mul1OutJ), RoundMode);       %fJ(3)

            Stage3Mul2OutR = fpMul_Elementwise(C9_2,Stage1Add0OutR);
            Stage3Mul2OutR = fpReformat(Stage3Mul2OutR, WL, WF, fpGetSigned(Stage3Mul2OutR), RoundMode);       %fR(4)
            Stage3Mul2OutJ = fpMul_Elementwise(C9_2,Stage1Add0OutJ);
            Stage3Mul2OutJ = fpReformat(Stage3Mul2OutJ, WL, WF, fpGetSigned(Stage3Mul2OutJ), RoundMode);       %fJ(4)

            Stage3Mul3OutR = fpMul_Elementwise(C9_1Neg,Stage1Sub0OutJ);
            Stage3Mul3OutR = fpReformat(Stage3Mul3OutR, WL, WF, fpGetSigned(Stage3Mul3OutR), RoundMode);       %fR(5)
            Stage3Mul3OutJ = fpMul_Elementwise(C9_1,Stage1Sub0OutR);
            Stage3Mul3OutJ = fpReformat(Stage3Mul3OutJ, WL, WF, fpGetSigned(Stage3Mul3OutJ), RoundMode);       %fJ(5)
   
            Stage3Mul4OutR = fpMul_Elementwise(C9_4,Stage2Sub2OutR);
            Stage3Mul4OutR = fpReformat(Stage3Mul4OutR, WL, WF, fpGetSigned(Stage3Mul4OutR), RoundMode);       %fR(6)  
            Stage3Mul4OutJ = fpMul_Elementwise(C9_4,Stage2Sub2OutJ);
            Stage3Mul4OutJ = fpReformat(Stage3Mul4OutJ, WL, WF, fpGetSigned(Stage3Mul4OutJ), RoundMode);       %fJ(6)
 
            Stage3Mul5OutR = fpMul_Elementwise(C9_5,Stage2Sub1OutR);
            Stage3Mul5OutR = fpReformat(Stage3Mul5OutR, WL, WF, fpGetSigned(Stage3Mul5OutR), RoundMode);       %fR(7) 
            Stage3Mul5OutJ = fpMul_Elementwise(C9_5,Stage2Sub1OutJ);
            Stage3Mul5OutJ = fpReformat(Stage3Mul5OutJ, WL, WF, fpGetSigned(Stage3Mul5OutJ), RoundMode);       %fJ(7)
 
            Stage3Mul6OutR = fpMul_Elementwise(C9_6,Stage2Sub0OutR);
            Stage3Mul6OutR = fpReformat(Stage3Mul6OutR, WL, WF, fpGetSigned(Stage3Mul6OutR), RoundMode);       %fR(8)
            Stage3Mul6OutJ = fpMul_Elementwise(C9_6,Stage2Sub0OutJ);
            Stage3Mul6OutJ = fpReformat(Stage3Mul6OutJ, WL, WF, fpGetSigned(Stage3Mul6OutJ), RoundMode);       %fJ(8)

            Stage3Mul7OutR = fpMul_Elementwise(C9_7,Stage2Sub5OutJ);
            Stage3Mul7OutR = fpReformat(Stage3Mul7OutR, WL, WF, fpGetSigned(Stage3Mul7OutR), RoundMode);       %fR(9)
            Stage3Mul7OutJ = fpMul_Elementwise(C9_7Neg,Stage2Sub5OutR);
            Stage3Mul7OutJ = fpReformat(Stage3Mul7OutJ, WL, WF, fpGetSigned(Stage3Mul7OutJ), RoundMode);       %fJ(9)

            Stage3Mul8OutR = fpMul_Elementwise(C9_8,Stage2Sub3OutJ);
            Stage3Mul8OutR = fpReformat(Stage3Mul8OutR, WL, WF, fpGetSigned(Stage3Mul8OutR), RoundMode);       %fR(10)
            Stage3Mul8OutJ = fpMul_Elementwise(C9_8Neg,Stage2Sub3OutR);
            Stage3Mul8OutJ = fpReformat(Stage3Mul8OutJ, WL, WF, fpGetSigned(Stage3Mul8OutJ), RoundMode);       %fJ(10)
            
            Stage3Mul9OutR = fpMul_Elementwise(C9_9,Stage2Sub4OutJ);
            Stage3Mul9OutR = fpReformat(Stage3Mul9OutR, WL, WF, fpGetSigned(Stage3Mul9OutR), RoundMode);       %fR(11)
            Stage3Mul9OutJ = fpMul_Elementwise(C9_9Neg,Stage2Sub4OutR);
            Stage3Mul9OutJ = fpReformat(Stage3Mul9OutJ, WL, WF, fpGetSigned(Stage3Mul9OutJ), RoundMode);       %fJ(11)


%=================================================================
        case 6
            Stage6Add0OutR = fpAdd(Stage3Mul0OutR,Stage3Mul0OutR);       %gR(1)
            Stage6Add0OutJ = fpAdd(Stage3Mul0OutJ,Stage3Mul0OutJ);       %gJ(1)

            Stage6Sub0OutR = fpSub(Stage3Mul0OutR,Stage3Add0OutR);       %gR(2)
            Stage6Sub0OutJ = fpSub(Stage3Mul0OutJ,Stage3Add0OutJ);       %gJ(2)

            Stage6Add1OutR = fpAdd(Stage5Add2OutR,Stage3Mul2OutR);       %gR(3)
            Stage6Add1OutJ = fpAdd(Stage5Add2OutJ,Stage3Mul2OutJ);       %gJ(3)

            Stage6Add2OutR = fpAdd(Stage3Mul3OutR,Stage3Mul7OutR);       %gR(4)
            Stage6Add2OutJ = fpAdd(Stage3Mul3OutJ,Stage3Mul7OutJ);       %gJ(4)

            Stage6Sub1OutR = fpSub(Stage3Mul3OutR,Stage3Mul8OutR);       %gR(5)
            Stage6Sub1OutJ = fpSub(Stage3Mul3OutJ,Stage3Mul8OutJ);       %gJ(5)

            Stage6Sub2OutR = fpSub(Stage3Mul3OutR,Stage3Mul7OutR);       %gR(6)
            Stage6Sub2OutJ = fpSub(Stage3Mul3OutJ,Stage3Mul7OutJ);       %gJ(6)

%=================================================================            
        case 7
            Stage7Add0OutR = fpAdd(Stage5Add2OutR,Stage6Sub0OutR);     %hR(1)
            Stage7Add0OutJ = fpAdd(Stage5Add2OutJ,Stage6Sub0OutJ);     %hJ(1)
%             mR(5) = hR(1);                  %mR(5)
%             mJ(5) = hJ(1);                  %mJ(5)

            Stage7Add1OutR = fpAdd(Stage6Add0OutR,Stage6Add1OutR);     %hR(2)
            Stage7Add1OutJ = fpAdd(Stage6Add0OutJ,Stage6Add1OutJ);     %hJ(2)

            Stage7Add2OutR = fpAdd(Stage6Add2OutR,Stage3Mul8OutR);     %hR(3)
            Stage7Add2OutJ = fpAdd(Stage6Add2OutJ,Stage3Mul8OutJ);     %hJ(3)
            
%             mR(2) = hR(3);                                   %mR(2)
            Stage7Add2OutJ = fpNeg(Stage7Add2OutJ);            %mJ(2)

            Stage7Sub0OutR = fpSub(Stage6Sub2OutR,Stage3Mul9OutR);     %hR(4)
            Stage7Sub0OutJ = fpSub(Stage6Sub2OutJ,Stage3Mul9OutJ);     %hJ(4)
            
%             mR(8) = hR(4);                                   %mR(8)
            Stage7Sub0OutJ = fpNeg(Stage7Sub0OutJ);            %mR(8)

            Stage7Add3OutR = fpAdd(Stage6Sub1OutR,Stage3Mul9OutR);     %hR(5)
            Stage7Add3OutJ = fpAdd(Stage6Sub1OutJ,Stage3Mul9OutJ);     %hJ(5)
            
            Stage7Add3OutR = fpNeg(Stage7Add3OutR);             %mR(4)
%             mJ(4) = hJ(5);                                    %mJ(4)

%=================================================================
        case 8
            Stage8Add0OutR = fpAdd(Stage7Add1OutR,Stage3Mul4OutR);     %kR(1)
            Stage8Add0OutJ = fpAdd(Stage7Add1OutJ,Stage3Mul4OutJ);     %kJ(1)

            Stage8Sub0OutR = fpSub(Stage7Add1OutR,Stage3Mul5OutR);     %kR(2)
            Stage8Sub0OutJ = fpSub(Stage7Add1OutJ,Stage3Mul5OutJ);     %kJ(2)

            Stage8Sub1OutR = fpSub(Stage7Add1OutR,Stage3Mul4OutR);     %kR(3)
            Stage8Sub1OutJ = fpSub(Stage7Add1OutJ,Stage3Mul4OutJ);     %kJ(3)
            
%=================================================================        
        case 9
            Stage9Add0OutR = fpAdd(Stage8Add0OutR,Stage3Mul5OutR);     %lR(1)
            Stage9Add0OutJ = fpAdd(Stage8Add0OutJ,Stage3Mul5OutJ);     %lJ(1)
%             mR(1) = lR(1);
%             mJ(1) = lJ(1);

            Stage9Add1OutR = fpAdd(Stage8Sub0OutR,Stage3Mul6OutR);     %lR(2)
            Stage9Add1OutJ = fpAdd(Stage8Sub0OutJ,Stage3Mul6OutJ);     %lJ(2)
%             mR(3) = lR(2);
%             mJ(3) = lJ(2);

            Stage9Sub0OutR = fpSub(Stage8Sub1OutR,Stage3Mul6OutR);     %lR(1)
            Stage9Sub0OutJ = fpSub(Stage8Sub1OutJ,Stage3Mul6OutJ);     %lJ(3)
%             mR(7) = lR(3);
%             mJ(7) = lJ(3);

%             mR(6) = fR(3);
%             mJ(6) = fpNeg(fJ(3));

%=================================================================
        case 10
%             XR(1) = fR(1);
%             XJ(1) = fJ(1);

            Stage10AddSub0OutR = fpAdd(Stage9Add0OutR,Stage7Add2OutR);     %XR(2)
            Stage10AddSub0OutJ = fpSub(Stage9Add0OutJ,Stage7Add2OutJ);     %XJ(2)

            Stage10AddSub1OutR = fpAdd(Stage9Add1OutR,Stage7Add3OutR);     %XR(3)
            Stage10AddSub1OutJ = fpSub(Stage9Add1OutJ,Stage7Add3OutJ);     %XJ(3)

            Stage10AddSub2OutR = fpAdd(Stage7Add0OutR,Stage3Mul1OutR);     %XR(4)
            Stage10AddSub2OutJ = fpSub(Stage7Add0OutJ,Stage3Mul1OutJ);     %XJ(4)

            Stage10AddSub3OutR = fpAdd(Stage9Sub0OutR,Stage7Sub0OutR);     %XR(5)
            Stage10AddSub3OutJ = fpSub(Stage9Sub0OutJ,Stage7Sub0OutJ);     %XJ(5)

            Stage10SubAdd0OutR = fpSub(Stage9Sub0OutR,Stage7Sub0OutR);     %XR(6)
            Stage10SubAdd0OutJ = fpAdd(Stage9Sub0OutJ,Stage7Sub0OutJ);     %XJ(6)

            Stage10SubAdd1OutR = fpSub(Stage7Add0OutR,Stage3Mul1OutR);     %XR(7)
            Stage10SubAdd1OutJ = fpAdd(Stage7Add0OutJ,Stage3Mul1OutJ);     %XJ(7)

            Stage10SubAdd2OutR = fpSub(Stage9Add1OutR,Stage7Add3OutR);     %XR(8)
            Stage10SubAdd2OutJ = fpAdd(Stage9Add1OutJ,Stage7Add3OutJ);     %XJ(8)

            Stage10SubAdd3OutR = fpSub(Stage9Add0OutR,Stage7Add2OutR);     %XR(9)
            Stage10SubAdd3OutJ = fpAdd(Stage9Add0OutJ,Stage7Add2OutJ);     %XJ(9)

%=================================================================
        otherwise
            disp('Invalid Stage!')
    end
end

%% =================================================================
XoutR(1) = Stage5Add2OutR;
XoutJ(1) = Stage5Add2OutJ;

XoutR(2) = Stage10AddSub0OutR;
XoutJ(2) = Stage10AddSub0OutJ;

XoutR(3) = Stage10AddSub1OutR;
XoutJ(3) = Stage10AddSub1OutJ;

XoutR(4) = Stage10AddSub2OutR;
XoutJ(4) = Stage10AddSub2OutJ;

XoutR(5) = Stage10AddSub3OutR;
XoutJ(5) = Stage10AddSub3OutJ;

XoutR(6) = Stage10SubAdd0OutR;
XoutJ(6) = Stage10SubAdd0OutJ;

XoutR(7) = Stage10SubAdd1OutR;
XoutJ(7) = Stage10SubAdd1OutJ;

XoutR(8) = Stage10SubAdd2OutR;
XoutJ(8) = Stage10SubAdd2OutJ;

XoutR(9) = Stage10SubAdd3OutR;
XoutJ(9) = Stage10SubAdd3OutJ;
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