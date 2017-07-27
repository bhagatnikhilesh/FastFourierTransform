% clc
% clear all
% close all

%function [XkOut] = GoodThomas1008ptVer1(xR, xJ, img)
function [XkOut] = GTW1008pt(x)
% x = [0 1 zeros(1,1006)];
% xR = randn(1,1008);
% xJ = randn(1,1008);

%x = xR + img*xJ;
% x = [0 i zeros(1,1006)];
n = 1:1:1008;

N = 1008;
N1 = 7;
N2 = 9;
N1N2 = N1*N2;
N3 = 16;
%% ========================================================================
CRT0 = CRT_Npt(n,N1N2,N3);     % CRT_Npt(x,N1,N2) and N1 > N2

CRT1 = [];
CRT1Temp0 = [];
CRT1Temp1 = [];

for n3 = 1:1:N3
    CRT1Temp0 = CRT_Npt(CRT0(n3,:),N2,N1);
    CRT1Temp1 = [];
    for n1 = 1:1:N1
        CRT1Temp1 = [CRT1Temp1 CRT1Temp0(n1,:)];
    end
    CRT1(n3,:) = CRT1Temp1;
end
%% ========================================================================
CRTN1pt = [];
for n1 = 1:1:N3
    CRTN1pt = [CRTN1pt CRT1(n1,:)];
end

for i = 1:1:N
    xIn(i) = x(CRTN1pt(i));
end
%% ========================================================================
xOutN2ptFFT = [];
for i = 1:N2:N
    xInN2ptFFT = xIn(i:i+N2-1);
    xOutN2ptFFT0 = wfta_9pt(xInN2ptFFT); 
    xOutN2ptFFT = [xOutN2ptFFT xOutN2ptFFT0];
end
%% ========================================================================
xOutN1ptFFT = [];
xInN1ptFFT = [];
xOutN1N2ptFFT = [];
k = 1;
indxIn = 1;
for row = 1:N1N2:N
    indxIn = 1;
    xInN1ptTemp = xOutN2ptFFT(row:row+N1N2-1);
    xOutN1ptTemp = [];
    for N1N2row = 1:1:N2
       xInN1ptFFT = [];
       indxIn =  N1N2row;
       for N1N2col = 1:1:N1
          xInN1ptFFT = [xInN1ptFFT xInN1ptTemp(indxIn)];
          indxIn = indxIn + N2;
       end
       xOutN1ptFFT0 = wfta_7pt(xInN1ptFFT);       
       indxOut =  N1N2row;
       for N1N2col = 1:1:N1
          xOutN1ptTemp(indxOut) = xOutN1ptFFT0(N1N2col);
          indxOut = indxOut + N2;
       end
    end
    xOutN1N2ptFFT = [xOutN1N2ptFFT xOutN1ptTemp];
end
%% ========================================================================
Mat = zeros(N1,N2);
temp = 0;
 for i = 1:N1
%     Mat(i,1) = temp;
    Mat(i,1) = temp+1;
    for j = 2:(N2)
       temp = temp + N1;
%        Mat(i,j) = rem(temp,N);
       Mat(i,j) = 1+rem(temp,N1N2);
    end
    temp = i*N2;
 end
 %% =================================================================
%  Xk = RUR_Npt(Mat,N1,N2); % N2<N1
 
RurOut = [];
for i=1:1:N1
    RurOut = [RurOut Mat(i,:)];
end
% 
for num = 1:1:N1N2
    RURindexValueTemp(num) = find(RurOut==(num));
end

RURindexN1N2 = [];
for i = 1:1:N3
   RURindexN1N2 = [RURindexN1N2 RURindexValueTemp];
   RURindexValueTemp = RURindexValueTemp+63;
end

RURindexN1N2_2D = [];
indxRCM = 1;
for i = 1:1:N3
   RURindexN1N2_2D(i,:) =  RURindexN1N2(indxRCM:indxRCM+N1N2-1);
   indxRCM=indxRCM+N1N2;
end

RCMout = ruritanianCorrespondenceNpt(RURindexN1N2_2D,N3,N1N2); % N2<N1

% RURindexValueTemp = RURindexValueTemp-1;

%% ========================================================================
indxInRURN3ptFFT = [];
for i = 1:1:N1N2
    indx = i;
    for j = 1:1:N3
        indxInRURN3ptFFT = [indxInRURN3ptFFT RURindexN1N2(indx)];
        indx = indx + N1N2;    
    end
end

xOutN3ptFFT = [];
xInN3ptFFT = [];
xOutNptFFT = [];
k = 0;
l = 0;
for i=1:N3:N
%     indexInN3 = indxInRURN3ptFFT(i);
    xInN3ptFFT = [];
   for j=1:1:N3
       k = k+1;
       indexInN3 = indxInRURN3ptFFT(k);
       xInN3ptFFT = [xInN3ptFFT xOutN1N2ptFFT(indexInN3)];
   end
%    xInN3ptFFT
    xOutN3ptFFT0 = wfta_16pt(xInN3ptFFT);
   for j=1:1:N3
       l = l + 1;
       indexInN3 = indxInRURN3ptFFT(l);
       xOutNptFFT(indexInN3) = xOutN3ptFFT0(j);
   end
end
%% ========================================================================
XkOut = [];

for i = 1:1:N
   XkOut(i) =  xOutNptFFT(RCMout(i)); 
end

end

% % disp(XkOut);
% figure(1);
% stem(n,(XkOut));
% grid on;
% 
% Xf = fft(x);
% figure(2);
% stem(n,(Xf));
% grid on;
% %% ========================================================================
% figure(3);
% plot(n,abs((Xf-XkOut)));
% title('Absolute error between fixed point and floating point transform implementation.')
% grid on;




