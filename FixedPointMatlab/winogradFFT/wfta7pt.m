
clc
close all
clear all


% N = input('Enter the number of points: ');
N = 7;
% for i = 1:1:N
%     xRin(i) = input('Enter the real part: ');
%     xJin(i) = input('Enter the imaginary part: ');
% end
xRin = [0 1 0 0 0 0 0];
xJin = [0 0 0 0 0 0 0];

WL = 8;
WF = 4;

% xRin = [0    0.7734    0.9688    0.4297   -0.4297   -0.9688   -0.7734];           % Sine   
% xJin = [1.0000    0.6172   -0.2227   -0.8984   -0.8984   -0.2227    0.6172];

% xRin = [1.0000    0.6172   -0.2227   -0.8984   -0.8984   -0.2227    0.6172];        % Cosine
% xJin = [0   -0.7734   -0.9688   -0.4297    0.4297    0.9688    0.7734];

x = [0 1 0 0 0 0 0];
% x= [1.0000  0.6172 - 0.7734i  -0.2227 - 0.9688i  -0.8984 - 0.4297i  -0.8984 + 0.4297i  -0.2227 + 0.9688i   0.6172 + 0.7734i];
% x = [0 + 1.0000i   0.7734 + 0.6172i   0.9688 - 0.2227i   0.4297 - 0.8984i  -0.4297 - 0.8984i  -0.9688 - 0.2227i  -0.7734 + 0.6172i];

n = 1:1:7;
img = i;

k = 1/3;
RoundMode=2;
Signed=1;
one = fpDouble2FP(1, 16, 8, Signed, RoundMode);
two = fpDouble2FP(2, 16, 8, Signed, RoundMode);
zero = fpDouble2FP(0, 16, 8, Signed, RoundMode);
oneBy3 = fpDouble2FP(k, 16, 8, Signed, RoundMode);

for i = 1:1:N
    xR(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
    xJ(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
end

%% =================================================================
u = ((2*pi)/7);
u2 = ((4*pi)/7);
u3 = ((6*pi)/7);

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

temp1 = fpAdd(kCos,kCos2);  % cos(u)+cos(2u)
temp1 = fpAdd(temp1,kCos3); % cos(u)+cos(2u)+cos(3u)
temp1 = fpMul_Elementwise(temp1,oneBy3);
temp1 = fpReformat(temp1, 16, 8, fpGetSigned(temp1), RoundMode);
C7_1 = fpSub(temp1,one);    % -1 + (cos(u)+cos(2u)+cos(3u))/3

temp2 = fpMul_Elementwise(kCos,two);
temp2 = fpReformat(temp2, 16, 8, fpGetSigned(temp2), RoundMode);
temp2 = fpSub(temp2,kCos2);
temp2 = fpSub(temp2,kCos3); % 2*cos(u)-cos(2u)-cos(3u)
temp2 = fpMul_Elementwise(temp2,oneBy3);% (2*cos(u)-cos(2u)-cos(3u))/3
C7_2 = fpReformat(temp2, 16, 8, fpGetSigned(temp2), RoundMode);

temp3 = fpMul_Elementwise(kCos2,two);
temp3 = fpReformat(temp3, 16, 8, fpGetSigned(temp3), RoundMode);
temp3 = fpSub(kCos,temp3);
temp3 = fpAdd(temp3,kCos3); % cos(u)-2*cos(2u)+cos(3u)
temp3 = fpMul_Elementwise(temp3,oneBy3);% (cos(u)-2*cos(2u)+cos(3u))/3
C7_3 = fpReformat(temp3, 16, 8, fpGetSigned(temp3), RoundMode);

temp4 = fpMul_Elementwise(kCos3,two);
temp4 = fpReformat(temp4, 16, 8, fpGetSigned(temp4), RoundMode);
temp4 = fpSub(kCos2,temp4);
temp4 = fpAdd(temp4,kCos); % cos(u)+cos(2u)-2*cos(3u)
temp4 = fpMul_Elementwise(temp4,oneBy3);% (cos(u)+cos(2u)-2*cos(3u))/3
C7_4 = fpReformat(temp4, 16, 8, fpGetSigned(temp4), RoundMode);

temp5 = fpAdd(kSin,kSin2);
temp5 = fpSub(temp5,kSin3); % sin(u)+sin(2u)-sin(3u)
temp5 = fpMul_Elementwise(temp5,oneBy3);% (sin(u)+sin(2u)-sin(3u))/3
C7_5 = fpReformat(temp5, 16, 8, fpGetSigned(temp5), RoundMode);
C7_5Neg = fpNeg(C7_5);

temp6 = fpMul_Elementwise(kSin,two);
temp6 = fpReformat(temp6, 16, 8, fpGetSigned(temp6), RoundMode);
temp6 = fpSub(temp6,kSin2);
temp6 = fpAdd(temp6,kSin3); % 2*sin(u)-sin(2u)+sin(3u)
temp6 = fpMul_Elementwise(temp6,oneBy3);% (2*sin(u)-sin(2u)+sin(3u))/3
C7_6 = fpReformat(temp6, 16, 8, fpGetSigned(temp6), RoundMode);
C7_6Neg = fpNeg(C7_6);

temp7 = fpMul_Elementwise(kSin2,two);
temp7 = fpReformat(temp7, 16, 8, fpGetSigned(temp7), RoundMode);
temp7 = fpSub(kSin,temp7);
temp7 = fpSub(temp7,kSin3); % sin(u)-2*sin(2u)-sin(3u)
temp7 = fpMul_Elementwise(temp7,oneBy3);% (sin(u)-2*sin(2u)-sin(3u))/3
C7_7 = fpReformat(temp7, 16, 8, fpGetSigned(temp7), RoundMode);
C7_7Neg = fpNeg(C7_7);

temp8 = fpMul_Elementwise(kSin3,two);
temp8 = fpReformat(temp8, 16, 8, fpGetSigned(temp8), RoundMode);
temp8 = fpAdd(kSin,temp8);
temp8 = fpAdd(kSin2,temp8); % Sin(u)+sin(2u)+2*sin(3u)
temp8 = fpMul_Elementwise(temp8,oneBy3);% (Sin(u)+sin(2u)+2*sin(3u))/3
C7_8 = fpReformat(temp8, 16, 8, fpGetSigned(temp8), RoundMode);
C7_8Neg = fpNeg(C7_8);

%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 3
%   # of sub = 6
%   # of mults = 8
%=================================================================
for stage = 1:1:8
    switch stage
        case 1
            Stage1Add0OutR = fpAdd(xR(2),xR(7));    %bR(1)
            Stage1Add0OutJ = fpAdd(xJ(2),xJ(7));

            Stage1Add1OutR = fpAdd(xR(5),xR(4));    %bR(3)
            Stage1Add1OutJ = fpAdd(xJ(5),xJ(4));

            Stage1Add2OutR = fpAdd(xR(3),xR(6));    %bR(5)
            Stage1Add2OutJ = fpAdd(xJ(3),xJ(6));
            
            Stage1Sub0OutR = fpSub(xR(2),xR(7));    %bR(2)
            Stage1Sub0OutJ = fpSub(xJ(2),xJ(7));

            Stage1Sub1OutR = fpSub(xR(5),xR(4));    %bR(4)
            Stage1Sub1OutJ = fpSub(xJ(5),xJ(4));

            Stage1Sub2OutR = fpSub(xR(3),xR(6));    %bR(6)
            Stage1Sub2OutJ = fpSub(xJ(3),xJ(6));

%=================================================================            
        case 2
            Stage2Add0OutR = fpAdd(Stage1Add0OutR,Stage1Add1OutR);   %cR(1)
            Stage2Add0OutJ = fpAdd(Stage1Add0OutJ,Stage1Add1OutJ);   %cJ(1)

            Stage2Sub0OutR = fpSub(Stage1Add1OutR,Stage1Add2OutR);   %cR(2)
            Stage2Sub0OutJ = fpSub(Stage1Add1OutJ,Stage1Add2OutJ);   %cJ(2)

            Stage2Sub1OutR = fpSub(Stage1Add0OutR,Stage1Add1OutR);   %cR(3)
            Stage2Sub1OutJ = fpSub(Stage1Add0OutJ,Stage1Add1OutJ);   %cJ(3)

            Stage2Sub2OutR = fpSub(Stage1Add2OutR,Stage1Add0OutR);   %cR(4)
            Stage2Sub2OutJ = fpSub(Stage1Add2OutJ,Stage1Add0OutJ);   %cJ(4)

            Stage2Add1OutR = fpAdd(Stage1Sub0OutR,Stage1Sub1OutR);   %cR(5)
            Stage2Add1OutJ = fpAdd(Stage1Sub0OutJ,Stage1Sub1OutJ);   %cJ(5)

            Stage2Sub3OutR = fpSub(Stage1Sub0OutR,Stage1Sub1OutR);   %cR(6)
            Stage2Sub3OutJ = fpSub(Stage1Sub0OutJ,Stage1Sub1OutJ);   %cJ(6)

            Stage2Sub4OutR = fpSub(Stage1Sub1OutR,Stage1Sub2OutR);   %cR(7)
            Stage2Sub4OutJ = fpSub(Stage1Sub1OutJ,Stage1Sub2OutJ);   %cJ(7)

            Stage2Sub5OutR = fpSub(Stage1Sub2OutR,Stage1Sub0OutR);   %cR(8)
            Stage2Sub5OutJ = fpSub(Stage1Sub2OutJ,Stage1Sub0OutJ);   %cJ(8)

%=================================================================
        case 3
            Stage3Add0OutR = fpAdd(Stage1Add2OutR,Stage2Add0OutR);   %dR(1)
            Stage3Add0OutJ = fpAdd(Stage1Add2OutJ,Stage2Add0OutJ);   %dJ(1)

            Stage3Add1OutR = fpAdd(Stage1Sub2OutR,Stage2Add1OutR);   %dR(2)
            Stage3Add1OutJ = fpAdd(Stage1Sub2OutJ,Stage2Add1OutJ);   %dJ(2)

%=================================================================        
        case 4
            Stage4Add0OutR = fpAdd(xR(1),Stage3Add0OutR);   %eR(1)
            Stage4Add0OutJ = fpAdd(xJ(1),Stage3Add0OutJ);   %eJ(1)

            Stage4Mul0OutR = fpMul_Elementwise(C7_1,Stage3Add0OutR);     %eR(2)
            Stage4Mul0OutR = fpReformat(Stage4Mul0OutR, WL, WF, fpGetSigned(Stage4Mul0OutR), RoundMode);
            Stage4Mul0OutJ = fpMul_Elementwise(C7_1,Stage3Add0OutJ);     %eJ(2)
            Stage4Mul0OutJ = fpReformat(Stage4Mul0OutJ, WL, WF, fpGetSigned(Stage4Mul0OutJ), RoundMode);

            Stage4Mul1OutR = fpMul_Elementwise(C7_2,Stage2Sub1OutR);     %eR(3)
            Stage4Mul1OutR = fpReformat(Stage4Mul1OutR, WL, WF, fpGetSigned(Stage4Mul1OutR), RoundMode);
            Stage4Mul1OutJ = fpMul_Elementwise(C7_2,Stage2Sub1OutJ);     %eJ(3)
            Stage4Mul1OutJ = fpReformat(Stage4Mul1OutJ, WL, WF, fpGetSigned(Stage4Mul1OutJ), RoundMode);

            Stage4Mul2OutR = fpMul_Elementwise(C7_3,Stage2Sub0OutR);     %eR(4)
            Stage4Mul2OutR = fpReformat(Stage4Mul2OutR, WL, WF, fpGetSigned(Stage4Mul2OutR), RoundMode);
            Stage4Mul2OutJ = fpMul_Elementwise(C7_3,Stage2Sub0OutJ);     %eJ(4)
            Stage4Mul2OutJ = fpReformat(Stage4Mul2OutJ, WL, WF, fpGetSigned(Stage4Mul2OutJ), RoundMode);

            Stage4Mul3OutR = fpMul_Elementwise(C7_4,Stage2Sub2OutR);     %eR(5)
            Stage4Mul3OutR = fpReformat(Stage4Mul3OutR, WL, WF, fpGetSigned(Stage4Mul3OutR), RoundMode);
            Stage4Mul3OutJ = fpMul_Elementwise(C7_4,Stage2Sub2OutJ);     %eJ(5)
            Stage4Mul3OutJ = fpReformat(Stage4Mul3OutJ, WL, WF, fpGetSigned(Stage4Mul3OutJ), RoundMode);

            Stage4Mul4OutR = fpMul_Elementwise(C7_5Neg,Stage3Add1OutJ);     %eR(6)
            Stage4Mul4OutR = fpReformat(Stage4Mul4OutR, WL, WF, fpGetSigned(Stage4Mul4OutR), RoundMode);           
            Stage4Mul4OutJ = fpMul_Elementwise(C7_5,Stage3Add1OutR);     %eJ(6)
            Stage4Mul4OutJ = fpReformat(Stage4Mul4OutJ, WL, WF, fpGetSigned(Stage4Mul4OutJ), RoundMode);

            Stage4Mul5OutR = fpMul_Elementwise(C7_6Neg,Stage2Sub3OutJ);     %eR(7)
            Stage4Mul5OutR = fpReformat(Stage4Mul5OutR, WL, WF, fpGetSigned(Stage4Mul5OutR), RoundMode);
            Stage4Mul5OutJ = fpMul_Elementwise(C7_6,Stage2Sub3OutR);     %eJ(7)
            Stage4Mul5OutJ = fpReformat(Stage4Mul5OutJ, WL, WF, fpGetSigned(Stage4Mul5OutJ), RoundMode);

            Stage4Mul6OutR = fpMul_Elementwise(C7_7Neg,Stage2Sub4OutJ);     %eR(8)
            Stage4Mul6OutR = fpReformat(Stage4Mul6OutR, WL, WF, fpGetSigned(Stage4Mul6OutR), RoundMode);
            Stage4Mul6OutJ = fpMul_Elementwise(C7_7,Stage2Sub4OutR);     %eJ(8)
            Stage4Mul6OutJ = fpReformat(Stage4Mul6OutJ, WL, WF, fpGetSigned(Stage4Mul6OutJ), RoundMode);

            Stage4Mul7OutR = fpMul_Elementwise(C7_8Neg,Stage2Sub5OutJ);     %eR(9)
            Stage4Mul7OutR = fpReformat(Stage4Mul7OutR, WL, WF, fpGetSigned(Stage4Mul7OutR), RoundMode);
            Stage4Mul7OutJ = fpMul_Elementwise(C7_8,Stage2Sub5OutR);     %eJ(9)
            Stage4Mul7OutJ = fpReformat(Stage4Mul7OutJ, WL, WF, fpGetSigned(Stage4Mul7OutJ), RoundMode);
        
%=================================================================
        case 5
            Stage5Add0OutR = fpAdd(Stage4Add0OutR,Stage4Mul0OutR);     %fR(1)
            Stage5Add0OutJ = fpAdd(Stage4Add0OutJ,Stage4Mul0OutJ);     %fJ(1)

            Stage5Add1OutR = fpAdd(Stage4Mul4OutR,Stage4Mul5OutR);     %fR(2)
            Stage5Add1OutJ = fpAdd(Stage4Mul4OutJ,Stage4Mul5OutJ);     %fJ(2)

            Stage5Sub0OutR = fpSub(Stage4Mul4OutR,Stage4Mul5OutR);     %fR(3)
            Stage5Sub0OutJ = fpSub(Stage4Mul4OutJ,Stage4Mul5OutJ);     %fJ(3)

            Stage5Sub1OutR = fpSub(Stage4Mul4OutR,Stage4Mul6OutR);     %fR(4)
            Stage5Sub1OutJ = fpSub(Stage4Mul4OutJ,Stage4Mul6OutJ);     %fJ(4)

%=================================================================            
        case 6
            Stage6Add0OutR = fpAdd(Stage5Add0OutR,Stage4Mul1OutR);     %gR(1)
            Stage6Add0OutJ = fpAdd(Stage5Add0OutJ,Stage4Mul1OutJ);     %gJ(1)

            Stage6Sub0OutR = fpSub(Stage5Add0OutR,Stage4Mul1OutR);     %gR(2)
            Stage6Sub0OutJ = fpSub(Stage5Add0OutJ,Stage4Mul1OutJ);     %gJ(2)

            Stage6Sub1OutR = fpSub(Stage5Add0OutR,Stage4Mul2OutR);     %gR(3)
            Stage6Sub1OutJ = fpSub(Stage5Add0OutJ,Stage4Mul2OutJ);     %gJ(3)

            Stage6Add1OutR = fpAdd(Stage5Add1OutR,Stage4Mul6OutR);     %gR(4)
            Stage6Add1OutJ = fpAdd(Stage5Add1OutJ,Stage4Mul6OutJ);     %gJ(4)

            Stage6Sub2OutR = fpSub(Stage5Sub0OutR,Stage4Mul7OutR);     %gR(5)
            Stage6Sub2OutJ = fpSub(Stage5Sub0OutJ,Stage4Mul7OutJ);     %gJ(5)

            Stage6Add2OutR = fpAdd(Stage5Sub1OutR,Stage4Mul7OutR);     %gR(6)
            Stage6Add2OutJ = fpAdd(Stage5Sub1OutJ,Stage4Mul7OutJ);     %gJ(6)

%=================================================================            
        case 7
            Stage7Add0OutR = fpAdd(Stage6Add0OutR,Stage4Mul2OutR);     %hR(1)
            Stage7Add0OutJ = fpAdd(Stage6Add0OutJ,Stage4Mul2OutJ);     %hJ(1)

            Stage7Sub0OutR = fpSub(Stage6Sub0OutR,Stage4Mul3OutR);     %hR(2)
            Stage7Sub0OutJ = fpSub(Stage6Sub0OutJ,Stage4Mul3OutJ);     %hJ(2)

            Stage7Add1OutR = fpAdd(Stage6Sub1OutR,Stage4Mul3OutR);     %hR(3)
            Stage7Add1OutJ = fpAdd(Stage6Sub1OutJ,Stage4Mul3OutJ);     %hJ(3)

%=================================================================  
        case 8
            Stage8Sub0OutR = fpSub(Stage7Add0OutR,Stage6Add1OutR);     %XR(2)
            Stage8Sub0OutJ = fpSub(Stage7Add0OutJ,Stage6Add1OutJ);     %XJ(2)

            Stage8Sub1OutR = fpSub(Stage7Sub0OutR,Stage6Sub2OutR);     %XR(3)
            Stage8Sub1OutJ = fpSub(Stage7Sub0OutJ,Stage6Sub2OutJ);     %XJ(3)

            Stage8Add0OutR = fpAdd(Stage7Add1OutR,Stage6Add2OutR);     %XR(4)
            Stage8Add0OutJ = fpAdd(Stage7Add1OutJ,Stage6Add2OutJ);     %XJ(4)

            Stage8Sub2OutR = fpSub(Stage7Add1OutR,Stage6Add2OutR);     %XR(5)
            Stage8Sub2OutJ = fpSub(Stage7Add1OutJ,Stage6Add2OutJ);     %XJ(5)

            Stage8Add1OutR = fpAdd(Stage7Sub0OutR,Stage6Sub2OutR);     %XR(6)
            Stage8Add1OutJ = fpAdd(Stage7Sub0OutJ,Stage6Sub2OutJ);     %XJ(6)

            Stage8Add2OutR = fpAdd(Stage7Add0OutR,Stage6Add1OutR);     %XR(7)
            Stage8Add2OutJ = fpAdd(Stage7Add0OutJ,Stage6Add1OutJ);     %XJ(7)

%================================================================= 
        otherwise
            disp('Invalid Stage!')
    end
end

%% =================================================================
XoutR(1) = Stage4Add0OutR;
XoutJ(1) = Stage4Add0OutJ;

XoutR(2) = Stage8Sub0OutR;
XoutJ(2) = Stage8Sub0OutJ;

XoutR(3) = Stage8Sub1OutR;
XoutJ(3) = Stage8Sub1OutJ;

XoutR(4) = Stage8Add0OutR;
XoutJ(4) = Stage8Add0OutJ;

XoutR(5) = Stage8Sub2OutR;
XoutJ(5) = Stage8Sub2OutJ;

XoutR(6) = Stage8Add1OutR;
XoutJ(6) = Stage8Add1OutJ;

XoutR(7) = Stage8Add2OutR;
XoutJ(7) = Stage8Add2OutJ;

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



