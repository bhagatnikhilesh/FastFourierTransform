%clc
%clear all
%close all
function [XkOut] = GTW840pt(x)

N = 840;
N1 = 7;
N2 = 5;
N3 = 8;
N4 = 3;
N1N2 = N1*N2;
N3N4 = N3*N4;
% x = [1 zeros(1,N-1)];
%x = [0 1 zeros(1,N-2)];
% x = 1:1:N;
%x = randn(1,N);
n = 1:1:N;
%a = 1:1:N1N2;
%b = 1:1:N3N4;

%% ========================================================================
CRT0 = transpose(CRT_Npt(n,N3N4,N1N2));     % CRT_Npt(x,N1,N2) and N1 > N2
% testCRT = CRT_Npt(a,N1,N2);     % CRT_Npt(x,N1,N2) and N1 > N2
CRT1 = [];
CRT1Temp0 = [];
CRT1Temp1 = [];

for n3n4 = 1:1:N3N4
    CRT1Temp0 = CRT_Npt(CRT0(n3n4,:),N1,N2);
    CRT1Temp1 = [];
    for n1 = 1:1:N2
        CRT1Temp1 = [CRT1Temp1 CRT1Temp0(n1,:)];
    end
    CRT1(n3n4,:) = CRT1Temp1;
end
%%% ========================================================================
%             WRITE CRTN1pt IN .coe FILE
%%% ========================================================================
CRTN1pt = [];
for n3n4 = 1:1:N3N4
    CRTN1pt = [CRTN1pt CRT1(n3n4,:)];
end

for i = 1:1:N
    xIn(i) = x(CRTN1pt(i));
end
%% ========================================================================
xOutN1ptFFT = [];
for n1 = 1:N1:N
    xInN1ptFFT = xIn(n1:n1+N1-1);
    xOutN1ptFFT0 = wfta_7pt(xInN1ptFFT); 
    xOutN1ptFFT = [xOutN1ptFFT xOutN1ptFFT0];
end
%% ========================================================================
xOutN2ptFFT = [];
xInN2ptFFT = [];
xOutN1N2ptFFT = [];
k = 1;
indxIn = 1;
for row = 1:N1N2:N
    indxIn = 1;
    xInN2ptTemp = xOutN1ptFFT(row:row+N1N2-1);
    xOutN2ptTemp = [];
    for N1N2row = 1:1:N1
       xInN2ptFFT = [];
       indxIn =  N1N2row;
       for N1N2col = 1:1:N2
          xInN2ptFFT = [xInN2ptFFT xInN2ptTemp(indxIn)];
          indxIn = indxIn + N1;
       end
       xOutN2ptFFT0 = wfta_5pt(xInN2ptFFT);       
       indxOut =  N1N2row;
       for N1N2col = 1:1:N2
          xOutN2ptTemp(indxOut) = xOutN2ptFFT0(N1N2col);
          indxOut = indxOut + N1;
       end
    end
    xOutN1N2ptFFT = [xOutN1N2ptFFT xOutN2ptTemp];
end
%% ========================================================================
Mat = zeros(N2,N1);
temp = 0;
 for i = 1:N2
%     Mat(i,1) = temp;
    Mat(i,1) = temp+1;
    for j = 2:(N1)
       temp = temp + N2;
%        Mat(i,j) = rem(temp,N);
       Mat(i,j) = 1+rem(temp,N1N2);
    end
    temp = i*N1;
 end
 %% =================================================================
% Xk = RUR_Npt(Mat,N2,N1); % N2<N1
RurOut = [];
for i=1:1:N2
    RurOut = [RurOut Mat(i,:)];
end
%% 
for num = 1:1:N1N2
    RURindexValueTemp(num) = find(RurOut==(num));
end
%
RURindexN1N2 = [];
for i = 1:1:N3N4
   RURindexN1N2 = [RURindexN1N2 RURindexValueTemp];
   RURindexValueTemp = RURindexValueTemp+N1N2;
end
%% ========================================================================
indxInRURN3ptFFT = [];
for i = 1:1:N1N2
    indx = i;
    for j = 1:1:N3N4
        indxInRURN3ptFFT = [indxInRURN3ptFFT RURindexN1N2(indx)];
        indx = indx + N1N2;    
    end
end
%%% ========================================================================
%             WRITE CRTN2N3 IN .coe FILE
%%% ========================================================================
CRT2 = [];
CRT2Temp0 = [];
CRT2Temp1 = [];
CRTN2N3 = [];
for n3n4 = 1:N3N4:N
    CRT2Temp0 = transpose(CRT_Npt(indxInRURN3ptFFT(n3n4:n3n4+N3N4-1),N4,N3));
    CRT2Temp1 = [];
    for n4 = 1:1:N4
        CRT2Temp1 = [CRT2Temp1 CRT2Temp0(n4,:)];
    end
    CRTN2N3 = [CRTN2N3 CRT2Temp1];
end
%% ========================================================================
for i = 1:1:N
    xInN3ptFFT(i) = xOutN1N2ptFFT(CRTN2N3(i));
end
%% ========================================================================
xOutN1N2N3ptFFT = [];
for n3 = 1:N3:N
    xInN3ptFFTtemp = xInN3ptFFT(n3:n3+N3-1);
    xOutN3ptFFT0 = wfta_8pt(transpose(xInN3ptFFTtemp)); 
    xOutN1N2N3ptFFT = [xOutN1N2N3ptFFT xOutN3ptFFT0];
end
%% ========================================================================
xOutN1N2N3N4ptFFT = [];
xInN4ptFFT = [];
xOutN4ptFFT = [];
k = 1;
indxIn = 1;
for row = 1:N3N4:N
    indxIn = 1;
    xInN4ptTemp = xOutN1N2N3ptFFT(row:row+N3N4-1);
    xOutN4ptTemp = [];
    for N3N4row = 1:1:N3
       xInN4ptFFT = [];
       indxIn =  N3N4row;
       for N2N3col = 1:1:N4
          xInN4ptFFT = [xInN4ptFFT xInN4ptTemp(indxIn)];
          indxIn = indxIn + N3;
       end
       xOutN4ptFFT0 = wfta_3pt(xInN4ptFFT);       
       indxOut =  N3N4row;
       for N3N4col = 1:1:N4
          xOutN4ptTemp(indxOut) = xOutN4ptFFT0(N3N4col);
          indxOut = indxOut + N3;
       end
    end
    xOutN1N2N3N4ptFFT = [xOutN1N2N3N4ptFFT xOutN4ptTemp];
end
%% ========================================================================
MatN3N4 = zeros(N4,N3);
temp = 0;
 for i = 1:N4
%     Mat(i,1) = temp;
    MatN3N4(i,1) = temp+1;
    for j = 2:(N3)
       temp = temp + N4;
%        Mat(i,j) = rem(temp,N);
       MatN3N4(i,j) = 1+rem(temp,N3N4);
    end
    temp = i*N3;
 end
 %% =================================================================
%Xk = RUR_Npt(MatN3N4,N4,N3); % N2<N1
 
RurOutN3N4 = [];
for i=1:1:N4
    RurOutN3N4 = [RurOutN3N4 MatN3N4(i,:)];
end
% 
for num = 1:1:N3N4
    RURindexValueTempN3N4(num) = find(RurOutN3N4==(num));
end
%
RURindexN3N4 = [];
for i = 1:1:N1N2
   RURindexN3N4 = [RURindexN3N4 RURindexValueTempN3N4];
   RURindexValueTempN3N4 = RURindexValueTempN3N4+N3N4;
end
 %% =================================================================
RURindexN3N4_2D = [];
indxRCMn3n4 = 1;
for i = 1:1:N1N2
   RURindexN3N4_2D(:,i) =  RURindexN3N4(indxRCMn3n4:indxRCMn3n4+N3N4-1);
   indxRCMn3n4=indxRCMn3n4+N3N4;
end

RCMout = ruritanianCorrespondenceNpt(RURindexN3N4_2D,N3N4,N1N2); % N2<N1
%%% ========================================================================
%             WRITE RCMout IN .coe FILE
%%% ========================================================================
XkOut = [];

for i = 1:1:N
   XkOut(i) =  xOutN1N2N3N4ptFFT(RCMout(i)); 
end
%% ========================================================================
end
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
