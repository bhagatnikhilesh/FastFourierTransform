clc
clear all
close all

N = 840;     % input('Enter the number of points: ');
N1 = 35;     % columns
N2 = 24;     % rows
%% =================================================================
initCRT = 1:1:840;

n = initCRT;

img = i;

debug = 1;

sigma = 0.1;
% x = [0 1 zeros(1,1006)];
% x = sigma*randn(1,1008);
% 
% xRin = [0 1 zeros(1,1006)];
% xJin = [0 0 zeros(1,1006)];

xRin = sigma*randn(1,840);
xJin = sigma*randn(1,840);

% % xRin = real(x);
% % xJin = imag(x);

RoundMode=2;
Signed=1;
WL = 16;
WF = 8;

x = xRin + i*xJin;

% xRin = xR; %[0 1 zeros(1,1006)];
% xJin = xJ; %[0 0 zeros(1,1006)];

% for i = 1:1:N
%     xFP(i) = fpDouble2FP(x(i), WL, WF, Signed, RoundMode);
% end
% 
% 
% xRin = fpReal(xFP(1));
% xJin = fpImag(xFP(1));

for i = 1:1:N
    xR_FP(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
    xJ_FP(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
end

% for i = 1:1:N
%     xR_D(i) = fpFP2Double(xR_FP(i));
%     xJ_D(i) = fpFP2Double(xJ_FP(i));
% end
%% =================================================================
%                    CRT MAPPING
CRTindexValueDouble = CRTmemoryModuleFunction(initCRT, N1, N2); 

for num = 1:1:N
    DataMemR63ptIn(num) = xR_FP(CRTindexValueDouble(num));
    DataMemJ63ptIn(num) = xJ_FP(CRTindexValueDouble(num));
end
%% =================================================================
%            ROW TRANSFORMATION (N1-point FFT) (Good-Thomas 63-pt)
for row = 1:N1:N
    [DataMemR63pt(row:row+N1-1) DataMemJ63pt(row:row+N1-1)] = goodThomas35ptFunction(DataMemR63ptIn(row:row+N1-1), DataMemJ63ptIn(row:row+N1-1), WL ,WF, RoundMode, Signed);
end

%% =================================================================
%            COLUMN TRANSFORMATION (N2-point FFT) (wfta16pt)
for row = 1:1:N1
    InindxN2 = row;
    OutindxN2 = row;
    for col = 1:1:N2
        InN2ptFFTR(col) = DataMemR63pt(InindxN2);
        InN2ptFFTJ(col) = DataMemJ63pt(InindxN2);
        InindxN2 = InindxN2 + N1;
    end
    [OutN2ptFFTR OutN2ptFFTJ] = goodThomas24ptFunction(InN2ptFFTR, InN2ptFFTJ, WL ,WF, RoundMode, Signed);
    for col = 1:1:N2
        DataMemR(OutindxN2) = OutN2ptFFTR(col);
        DataMemJ(OutindxN2) = OutN2ptFFTJ(col);
        OutindxN2 = OutindxN2 + N1;
    end    
end
%% =================================================================
%                    RUR MAPPING
RURindexValueDouble = RURmemoryModuleFunction(N, N1, N2);

for val = 1:1:N
    DataMemOutR(val) = DataMemR(RURindexValueDouble(val));
    DataMemOutJ(val) = DataMemJ(RURindexValueDouble(val));
end

%% =================================================================
for i = 1:1:N
    XkR(i) = fpFP2Double(DataMemOutR(i));
    XkJ(i) = fpFP2Double(DataMemOutJ(i));
end

for i=1:1:N
    Xk(i) = XkR(i) + img*XkJ(i);
end


% Floating point FFT calculation
% Xf = GoodThomas1008ptVer1(xRin, xJin, img); 



% disp(Xk);
figure(1);
subplot(2,1,1);
stem(n,(Xk));
grid on;

Xf = fft(x);
% figure(2);
subplot(2,1,2);
stem(n,(Xf));
grid on;
%% ========================================================================
% figure(3);
% plot(n,abs((Xf-Xk)));
% title('Absolute error between fixed point and floating point transform implementation.')
% grid on;

% meanErr = abs(mean(((Xf-Xk))));
% maxErr = (max(abs((Xf-Xk))));
% stdErr = (std(((Xf-Xk))));

% norm1 = norm((Xf-Xk), 1)/norm(Xk)
% norm2 = norm((Xf-Xk), 2)/norm(Xk)
% normInf = norm((Xf-Xk), Inf)/norm(Xk)

