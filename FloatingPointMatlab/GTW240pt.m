%clc
%clear all
%close all
%
%% x = [1 zeros(1,239)];
%%x = [0 1 zeros(1,238)];
%% x = 1:1:240;
%x = randn(1,240);
function [XkOut] = GTW240pt(x)

n = 1:1:240;

N = 240;
N1 = 3;
N2 = 5;
N1N2 = 15;
N3 = 16;
%% ========================================================================
CRT0 = CRT_Npt(n,N1*N2,N3);     % CRT_Npt(x,N1,N2) and N1 > N2

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
xOut5ptFFT = [];
for i = 1:5:N
    xIn5ptFFT = xIn(i:i+5-1);
    xOut5ptFFT0 = wfta_5pt(xIn5ptFFT); 
    xOut5ptFFT = [xOut5ptFFT xOut5ptFFT0];
end
%% ========================================================================
xOut3ptFFT = [];
xIn3ptFFT = [];
xOutN1N2ptFFT = [];
k = 1;
indxIn = 1;
for row = 1:N1N2:N
    indxIn = 1;
    xIn3ptTemp = xOut5ptFFT(row:row+N1N2-1);
    xOut3ptTemp = [];
    for N1N2row = 1:1:N2
       xIn3ptFFT = [];
       indxIn =  N1N2row;
       for N1N2col = 1:1:N1
          xIn3ptFFT = [xIn3ptFFT xIn3ptTemp(indxIn)];
          indxIn = indxIn + N2;
       end
       xOut3ptFFT0 = wfta_3pt(xIn3ptFFT);       
       indxOut =  N1N2row;
       for N1N2col = 1:1:N1
          xOut3ptTemp(indxOut) = xOut3ptFFT0(N1N2col);
          indxOut = indxOut + N2;
       end
    end
    xOutN1N2ptFFT = [xOutN1N2ptFFT xOut3ptTemp];
end
%% ========================================================================
RCM_OutN1N1pt = [];
indxRCM = 1;
for i = 1:N1N2:N
    RCM_In = [];
    indxRCM = i;
    for j = 1:1:N1
       RCM_In(j,:) = xOutN1N2ptFFT(indxRCM:indxRCM+N2-1);
       indxRCM = indxRCM + N2;
    end
    RCM_OutN1N1pt = [RCM_OutN1N1pt ruritanianCorrespondenceNpt(RCM_In,N1,N2)]; % N2<N1
end
%% ========================================================================
xOutN3ptFFT0 = [];
xInN3ptFFT = [];
xOutN3ptFFT = [];
k = 1;
indxInN3pt = 1;
for col = 1:1:N1N2
    xInN3ptFFT = [];
    for row = 1:N1N2:N
        xInN3ptFFT = [xInN3ptFFT RCM_OutN1N1pt(row+col-1)];
    end
    xOutN3ptFFT0 = wfta_16pt(xInN3ptFFT);
    indxInN3pt = 1;
    for row = 1:N1N2:N
        xOutN3ptFFT(row+col-1) = xOutN3ptFFT0(indxInN3pt);
        indxInN3pt = indxInN3pt+1;
    end   
end

%% ========================================================================
RCM_OutNpt = [];
indxRCMout = 1;
for i = 1:N1N2:N
    RCM_InNpt(indxRCMout,:) = xOutN3ptFFT(i:i+N1N2-1); % N2<N1
    indxRCMout = indxRCMout+1;
end
%% ========================================================================
XkOut = ruritanianCorrespondenceNpt(RCM_InNpt,N3,N1N2); % N2<N1

end
% disp(XkOut);
%figure(1);
%stem(n,(XkOut));
%grid on;
%
%Xf = fft(x);
%figure(2);
%stem(n,(Xf));
%grid on;
% %% ========================================================================
% figure(3);
% plot(n,abs((Xf-XkOut)));
% title('Absolute error between fixed point and floating point transform implementation.')
% grid on;
