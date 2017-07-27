clc
close all
clear all

A       = 1;                %amplitude of the cosine wave
fc      = 10;               %frequency of the wave
phase   = 0;                %desired phase shift of the cosine in degrees
Tsec    = 2;                %duration
fsampFactor = 32;           %sampling factor 32
fs      = fsampFactor*fc;          %sampling frequency with over
t       = 0:(1/fs):(Tsec-(1/fs));  %seconds duration

phi     = phase*pi/180;         %convert phase shift in degrees in radians
x       = A*cos(2*pi*fc*t+phi); %time domain signal with phase shift

figure(1);
plot(t,x);                  %plot the signal

N       = 256; %FFT size
X       = 1/N*fftshift(fft(x,N));%N-point complex DFT

% ========== EXTRACT PHASE AND FREQUENCY COMPONENTS ==================

df          = fs/N;           %frequency resolution
sampleIndex = -N/2:N/2-1;     %ordered index for FFT plot
f           = sampleIndex*df; %x-axis index converted to ordered frequencies
figure(2);
subplot(2,1,1);
stem(f,abs(X));               %magnitudes vs frequencies
xlabel('f(Hz)'); 
ylabel('|X(k)|');

X2=X;%store the FFT results in another array
%detect noise (very small numbers (eps)) and ignore them
threshold = max(abs(X))/10000; %tolerance threshold
X2(abs(X)<threshold) = 0; %maskout values that are below the threshold
phase=atan2(imag(X2),real(X2))*180/pi; %phase information
subplot(2,1,2);
plot(f,phase); %phase vs frequencies


