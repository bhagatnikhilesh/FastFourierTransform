clc
clear all
close all

N = 63;     % input('Enter the number of points: ');
N1 = 9;     % columns
N2 = 7;     % rows

initCRT = 1:1:63;

n = initCRT;

img = i;
x = [0 1 zeros(1,61)];

xRin = [0 1 zeros(1,61)];
xJin = [0 0 zeros(1,61)];

RoundMode=2;
Signed=1;
WL = 16;
WF = 8;

for i = 1:1:N
    xR_FP(i) = fpDouble2FP(xRin(i), WL, WF, Signed, RoundMode);
    xJ_FP(i) = fpDouble2FP(xJin(i), WL, WF, Signed, RoundMode);
end
%% =================================================================
%                    CRT MAPPING
CRTindexValue63ptDouble = CRTmemoryModuleFunction(initCRT, N1, N2); 
% for i = 1:1:N
%     CRTindexValue63ptFP(i) = fpDouble2FP(CRTindexValue63ptDouble(i), ceil(log2(N)), 0, 0, 1);
% end
for num = 1:1:N
    DataMemR(num) = xR_FP(CRTindexValue63ptDouble(num));
    DataMemJ(num) = xJ_FP(CRTindexValue63ptDouble(num));
end
%% =================================================================
%            ROW TRANSFORMATION (N1-point FFT) (wfta9pt)
for row = 1:N1:N
    [DataMemR(row:row+N1-1) DataMemJ(row:row+N1-1)] = wfta9ptFunction(DataMemR(row:row+N1-1), DataMemJ(row:row+N1-1), WL ,WF, RoundMode, Signed);
end

%% =================================================================
%            COLUMN TRANSFORMATION (N2-point FFT) (wfta7pt)
for row = 1:1:N1
    InindxN2 = row;
    OutindxN2 = row;
    for col = 1:1:N2
        InN2ptFFTR(col) = DataMemR(InindxN2);
        InN2ptFFTJ(col) = DataMemJ(InindxN2);
        InindxN2 = InindxN2 + N1;
    end
    [OutN2ptFFTR OutN2ptFFTJ] = wfta7ptFunction(InN2ptFFTR, InN2ptFFTJ, WL ,WF, RoundMode, Signed);
    for col = 1:1:N2
        DataMemR(OutindxN2) = OutN2ptFFTR(col);
        DataMemJ(OutindxN2) = OutN2ptFFTJ(col);
        OutindxN2 = OutindxN2 + N1;
    end    
end
%% =================================================================
%                    RUR MAPPING
RURindexValue63ptDouble = RURmemoryModuleFunction(N, N1, N2);

for val = 1:1:N
    DataMemOutR(val) = DataMemR(RURindexValue63ptDouble(val));
    DataMemOutJ(val) = DataMemJ(RURindexValue63ptDouble(val));
end

%% =================================================================
for i = 1:1:N
    XkR(i) = fpFP2Double(DataMemOutR(i));
    XkJ(i) = fpFP2Double(DataMemOutJ(i));
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

