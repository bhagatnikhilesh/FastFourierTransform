% clc
% clear all
% close all
% 
% x = input('Enter the 7-pt input sequence: ');
function Xk = wfta_7pt(xR)

% x = [0 1 0 0 0 0 0];

% Sine
%x = [0.0000 + 1.0000i   0.7818 + 0.6235i   0.9749 - 0.2225i   0.4339 - 0.9010i  -0.4339 - 0.9010i  -0.9749 - 0.2225i  -0.7818 + 0.6235i];

% Cosine
% x = [ 1.0000 + 0.0000i   0.6235 - 0.7818i  -0.2225 - 0.9749i  -0.9010 - 0.4339i  -0.9010 + 0.4339i  -0.2225 + 0.9749i   0.6235 + 0.7818i];

%n = 1:1:7;
%
%u = 2*pi/7;
%v = transpose(x);
%
%A = [1 1 1 1 1 1 1;
%    0 1 1 1 1 1 1;
%    0 1 0 -1 -1 0 1;
%    0 0 -1 1 1 -1 0;
%    0 -1 1 0 0 1 -1;
%    0 1 1 -1 1 -1 -1;
%    0 1 0 1 -1 0 -1;
%    0 0 -1 -1 1 1 0;
%    0 -1 1 0 0 -1 1];
%
%C = [1 0 0 0 0 0 0 0 0;
%    1 1 1 1 0 -i -i -i 0;
%    1 1 -1 0 -1 -i i 0 i;
%    1 1 0 -1 1 i 0 -i i;
%    1 1 0 -1 1 -i 0 i -i;
%    1 1 -1 0 -1 i -i 0 -i;
%    1 1 1 1 0 i i i 0];
%
%b(1) = 1;
%b(2) = ((cos(u)+cos(2*u)+cos(3*u))/3)-1;
%b(3) = (2*cos(u)-cos(2*u)-cos(3*u))/3;
%b(4) = (cos(u)-(2*cos(2*u))+cos(3*u));
%b(5) = ((cos(u)+cos(2*u)-2*cos(3*u))/3);
%b(6) = ((sin(u)+sin(2*u)-sin(3*u))/3);
%b(7) = ((2*sin(u)-sin(2*u)+sin(3*u))/3);
%b(8) = ((sin(u)-2*sin(2*u)-sin(3*u))/3);
%b(9) = ((sin(u)+sin(2*u)+2*sin(3*u))/3);
%
%B = diag(b);
%
%a = A*v;
%r = B*a;
%Xk = C*r;


%%% ========================================================================
%%% ========================================================================
%%% ========================================================================
%%% ========================================================================




N = 7;

%xR = [0 i 0 0 0 0 0];

n = 1:1:7;
img = i;

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

kSin = sin(u);
kCos = cos(u);
kSin2 = sin(2*u);
kCos2 = cos(2*u);
kSin3 = sin(3*u);
kCos3 = cos(3*u);

C7_1 = -1 + (cos(u)+cos(2*u)+cos(3*u))/3;

C7_2 = (2*cos(u)-cos(2*u)-cos(3*u))/3;

C7_3 = (cos(u)-2*cos(2*u)+cos(3*u))/3;

C7_4 =  (cos(u)+cos(2*u)-2*cos(3*u))/3;

C7_5 = (sin(u)+sin(2*u)-sin(3*u))/3;

C7_6 =  (2*sin(u)-sin(2*u)+sin(3*u))/3;

C7_7 = (sin(u)-2*sin(2*u)-sin(3*u))/3;

C7_8 = (sin(u)+sin(2*u)+2*sin(3*u))/3;

%% =================================================================
%           ADDER AND MULTIPLIER MODULES
%   # of adders = 3
%   # of sub = 6
%   # of mults = 8
%=================================================================
for stage = 1:1:8
    switch stage
        case 1
            Stage1Add0Out = (xR(2)+xR(7));    %bR(1)

            Stage1Add1Out = (xR(5)+xR(4));    %bR(3)

            Stage1Add2Out = (xR(3)+xR(6));    %bR(5)
            
            Stage1Sub0Out = (xR(2)-xR(7));    %bR(2)

            Stage1Sub1Out = (xR(5)-xR(4));    %bR(4)

            Stage1Sub2Out = (xR(3)-xR(6));    %bR(6)

%=================================================================            
        case 2
            Stage2Add0Out = (Stage1Add0Out+Stage1Add1Out);   %cR(1)

            Stage2Sub0Out = (Stage1Add1Out-Stage1Add2Out);   %cR(2)

            Stage2Sub1Out = (Stage1Add0Out-Stage1Add1Out);   %cR(3)

            Stage2Sub2Out = (Stage1Add2Out-Stage1Add0Out);   %cR(4)

            Stage2Add1Out = (Stage1Sub0Out+Stage1Sub1Out);   %cR(5)

            Stage2Sub3Out = (Stage1Sub0Out-Stage1Sub1Out);   %cR(6)

            Stage2Sub4Out = (Stage1Sub1Out-Stage1Sub2Out);   %cR(7)

            Stage2Sub5Out = (Stage1Sub2Out-Stage1Sub0Out);   %cR(8)

%=================================================================
        case 3
            Stage3Add0Out = (Stage1Add2Out+Stage2Add0Out);   %dR(1)

            Stage3Add1Out = (Stage1Sub2Out+Stage2Add1Out);   %dR(2)

%=================================================================        
        case 4
            Stage4Add0Out = (xR(1)+Stage3Add0Out);   %eR(1)

            Stage4Mul0Out = (C7_1*Stage3Add0Out);     %eR(2)
%            Stage4Mul0OutR = fpReformat(Stage4Mul0OutR, WL, WF, fpGetSigned(Stage4Mul0OutR), RoundMode);
%            Stage4Mul0OutJ = fpMul_Elementwise(C7_1,Stage3Add0OutJ);     %eJ(2)
%            Stage4Mul0OutJ = fpReformat(Stage4Mul0OutJ, WL, WF, fpGetSigned(Stage4Mul0OutJ), RoundMode);

            Stage4Mul1Out = (C7_2*Stage2Sub1Out);     %eR(3)
%            Stage4Mul1OutR = fpReformat(Stage4Mul1OutR, WL, WF, fpGetSigned(Stage4Mul1OutR), RoundMode);
%            Stage4Mul1OutJ = fpMul_Elementwise(C7_2,Stage2Sub1OutJ);     %eJ(3)
%            Stage4Mul1OutJ = fpReformat(Stage4Mul1OutJ, WL, WF, fpGetSigned(Stage4Mul1OutJ), RoundMode);

            Stage4Mul2Out = (C7_3*Stage2Sub0Out);     %eR(4)
%            Stage4Mul2OutR = fpReformat(Stage4Mul2OutR, WL, WF, fpGetSigned(Stage4Mul2OutR), RoundMode);
%            Stage4Mul2OutJ = fpMul_Elementwise(C7_3,Stage2Sub0OutJ);     %eJ(4)
%            Stage4Mul2OutJ = fpReformat(Stage4Mul2OutJ, WL, WF, fpGetSigned(Stage4Mul2OutJ), RoundMode);

            Stage4Mul3Out = (C7_4*Stage2Sub2Out);     %eR(5)
%            Stage4Mul3OutR = fpReformat(Stage4Mul3OutR, WL, WF, fpGetSigned(Stage4Mul3OutR), RoundMode);
%            Stage4Mul3OutJ = fpMul_Elementwise(C7_4,Stage2Sub2OutJ);     %eJ(5)
%            Stage4Mul3OutJ = fpReformat(Stage4Mul3OutJ, WL, WF, fpGetSigned(Stage4Mul3OutJ), RoundMode);

            Stage4Mul4Out = img*(C7_5*Stage3Add1Out);
%            Stage4Mul4OutR = fpMul_Elementwise(C7_5Neg,Stage3Add1OutJ);     %eR(6)
%            Stage4Mul4OutR = fpReformat(Stage4Mul4OutR, WL, WF, fpGetSigned(Stage4Mul4OutR), RoundMode);           
%            Stage4Mul4OutJ = fpMul_Elementwise(C7_5,Stage3Add1OutR);     %eJ(6)
%            Stage4Mul4OutJ = fpReformat(Stage4Mul4OutJ, WL, WF, fpGetSigned(Stage4Mul4OutJ), RoundMode);

            Stage4Mul5Out = img*(C7_6*Stage2Sub3Out);
%            Stage4Mul5OutR = fpMul_Elementwise(C7_6Neg,Stage2Sub3OutJ);     %eR(7)
%            Stage4Mul5OutR = fpReformat(Stage4Mul5OutR, WL, WF, fpGetSigned(Stage4Mul5OutR), RoundMode);
%            Stage4Mul5OutJ = fpMul_Elementwise(C7_6,Stage2Sub3OutR);     %eJ(7)
%            Stage4Mul5OutJ = fpReformat(Stage4Mul5OutJ, WL, WF, fpGetSigned(Stage4Mul5OutJ), RoundMode);

            Stage4Mul6Out = img*(C7_7*Stage2Sub4Out);
%            Stage4Mul6OutR = fpMul_Elementwise(C7_7Neg,Stage2Sub4OutJ);     %eR(8)
%            Stage4Mul6OutR = fpReformat(Stage4Mul6OutR, WL, WF, fpGetSigned(Stage4Mul6OutR), RoundMode);
%            Stage4Mul6OutJ = fpMul_Elementwise(C7_7,Stage2Sub4OutR);     %eJ(8)
%            Stage4Mul6OutJ = fpReformat(Stage4Mul6OutJ, WL, WF, fpGetSigned(Stage4Mul6OutJ), RoundMode);

            Stage4Mul7Out = img*(C7_8*Stage2Sub5Out);
%            Stage4Mul7OutR = fpMul_Elementwise(C7_8Neg,Stage2Sub5OutJ);     %eR(9)
%            Stage4Mul7OutR = fpReformat(Stage4Mul7OutR, WL, WF, fpGetSigned(Stage4Mul7OutR), RoundMode);
%            Stage4Mul7OutJ = fpMul_Elementwise(C7_8,Stage2Sub5OutR);     %eJ(9)
%            Stage4Mul7OutJ = fpReformat(Stage4Mul7OutJ, WL, WF, fpGetSigned(Stage4Mul7OutJ), RoundMode);
        
%=================================================================
        case 5
            Stage5Add0Out = (Stage4Add0Out+Stage4Mul0Out);     %fR(1)
%            Stage5Add0OutJ = fpAdd(Stage4Add0OutJ,Stage4Mul0OutJ);     %fJ(1)

            Stage5Add1Out = (Stage4Mul4Out+Stage4Mul5Out);     %fR(2)
%            Stage5Add1OutJ = fpAdd(Stage4Mul4OutJ,Stage4Mul5OutJ);     %fJ(2)

            Stage5Sub0Out = (Stage4Mul4Out-Stage4Mul5Out);     %fR(3)
%            Stage5Sub0OutJ = fpSub(Stage4Mul4OutJ,Stage4Mul5OutJ);     %fJ(3)

            Stage5Sub1Out = (Stage4Mul4Out-Stage4Mul6Out);     %fR(4)
%            Stage5Sub1OutJ = fpSub(Stage4Mul4OutJ,Stage4Mul6OutJ);     %fJ(4)

%=================================================================            
        case 6
            Stage6Add0Out = (Stage5Add0Out+Stage4Mul1Out);     %gR(1)
%            Stage6Add0OutJ = fpAdd(Stage5Add0OutJ,Stage4Mul1OutJ);     %gJ(1)

            Stage6Sub0Out = (Stage5Add0Out-Stage4Mul1Out);     %gR(2)
%            Stage6Sub0OutJ = fpSub(Stage5Add0OutJ,Stage4Mul1OutJ);     %gJ(2)

            Stage6Sub1Out = (Stage5Add0Out-Stage4Mul2Out);     %gR(3)
%            Stage6Sub1OutJ = fpSub(Stage5Add0OutJ,Stage4Mul2OutJ);     %gJ(3)

            Stage6Add1Out = (Stage5Add1Out+Stage4Mul6Out);     %gR(4)
%            Stage6Add1OutJ = fpAdd(Stage5Add1OutJ,Stage4Mul6OutJ);     %gJ(4)

            Stage6Sub2Out = (Stage5Sub0Out-Stage4Mul7Out);     %gR(5)
%            Stage6Sub2OutJ = fpSub(Stage5Sub0OutJ,Stage4Mul7OutJ);     %gJ(5)

            Stage6Add2Out = (Stage5Sub1Out+Stage4Mul7Out);     %gR(6)
%            Stage6Add2OutJ = fpAdd(Stage5Sub1OutJ,Stage4Mul7OutJ);     %gJ(6)

%=================================================================            
        case 7
            Stage7Add0Out = (Stage6Add0Out+Stage4Mul2Out);     %hR(1)
%            Stage7Add0OutJ = fpAdd(Stage6Add0OutJ,Stage4Mul2OutJ);     %hJ(1)

            Stage7Sub0Out = (Stage6Sub0Out-Stage4Mul3Out);     %hR(2)
%            Stage7Sub0OutJ = fpSub(Stage6Sub0OutJ,Stage4Mul3OutJ);     %hJ(2)

            Stage7Add1Out = (Stage6Sub1Out+Stage4Mul3Out);     %hR(3)
%            Stage7Add1OutJ = fpAdd(Stage6Sub1OutJ,Stage4Mul3OutJ);     %hJ(3)

%=================================================================  
        case 8
            Stage8Sub0Out = (Stage7Add0Out-Stage6Add1Out);     %XR(2)
%            Stage8Sub0OutJ = fpSub(Stage7Add0OutJ,Stage6Add1OutJ);     %XJ(2)

            Stage8Sub1Out = (Stage7Sub0Out-Stage6Sub2Out);     %XR(3)
%            Stage8Sub1OutJ = fpSub(Stage7Sub0OutJ,Stage6Sub2OutJ);     %XJ(3)

            Stage8Add0Out = (Stage7Add1Out+Stage6Add2Out);     %XR(4)
%            Stage8Add0OutJ = fpAdd(Stage7Add1OutJ,Stage6Add2OutJ);     %XJ(4)

            Stage8Sub2Out = (Stage7Add1Out-Stage6Add2Out);     %XR(5)
%            Stage8Sub2OutJ = fpSub(Stage7Add1OutJ,Stage6Add2OutJ);     %XJ(5)

            Stage8Add1Out = (Stage7Sub0Out+Stage6Sub2Out);     %XR(6)
%            Stage8Add1OutJ = fpAdd(Stage7Sub0OutJ,Stage6Sub2OutJ);     %XJ(6)

            Stage8Add2Out = (Stage7Add0Out+Stage6Add1Out);     %XR(7)
%            Stage8Add2OutJ = fpAdd(Stage7Add0OutJ,Stage6Add1OutJ);     %XJ(7)

%================================================================= 
        otherwise
            disp('Invalid Stage!')
    end
end

%% =================================================================
Xout(1) = Stage4Add0Out;
%XoutJ(1) = Stage4Add0OutJ;

Xout(2) = Stage8Sub0Out;
%XoutJ(2) = Stage8Sub0OutJ;

Xout(3) = Stage8Sub1Out;
%XoutJ(3) = Stage8Sub1OutJ;

Xout(4) = Stage8Add0Out;
%XoutJ(4) = Stage8Add0OutJ;

Xout(5) = Stage8Sub2Out;
%XoutJ(5) = Stage8Sub2OutJ;

Xout(6) = Stage8Add1Out;
%XoutJ(6) = Stage8Add1OutJ;

Xout(7) = Stage8Add2Out;
%XoutJ(7) = Stage8Add2OutJ;

Xk = (Xout);
%% ========================================================================

%for(i = 1:1:N)
%    XkR(i) = fpFP2Double(XoutR(i));
%    XkJ(i) = fpFP2Double(XoutJ(i));
%%     disp(XkR(i));
%%     disp(XkJ(i));
%end
%
%for i=1:1:N
%    Xk(i) = XkR(i) + img*XkJ(i);
%end
%
% disp(Xk);
%figure(1);
%stem(n,(Xout));
%grid on;
%
%[c2 XkROld XkJOld] = wfta_7pt(xR, xJ, WL ,WF, RoundMode, Signed);
%
%for(i = 1:1:N)
%    XkRDouble(i) = fpFP2Double(XkROld(i));
%    XkJDouble(i) = fpFP2Double(XkJOld(i));
%%     disp(XkR(i));
%%     disp(XkJ(i));
%end
%
%for i=1:1:N
%    XkOld(i) = XkRDouble(i) + img*XkJDouble(i);
%end
%
%% disp(Xk);
%figure(2);
%stem(n,(XkOld));
%grid on;
%
%Xf = fft(x);
%figure(3);
%stem(n,(Xf));
%grid on;
%
%Error = abs((XkOld-Xk));
%
%%% ========================================================================
%figure(4);
%plot(n,Error);
%disp(Error);
%title('Absolute error between fixed point and floating point transform implementation.')
%grid on;



end

% Xk = X;
% end
% disp(Xk);
% figure(1);
% stem(n,(Xk));
% grid on;
% 
% Xf = fft(x);
% figure(2);
% stem(n,(Xf));
% grid on;


