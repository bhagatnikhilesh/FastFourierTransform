clc
clear all
close all

N = 360;

n = 1:1:N;

x = [0 1 zeros(1,N-2)];

fft_len = sprintf('GTW%dpt(x)',N);

XfMat = fft(x);
figure(1);
subplot(3,1,1);
stem(n,(XfMat));
grid on;
title('FFT Matlab');
axis([0 N]);

XfGTW = eval(fft_len);
subplot(3,1,2);
stem(n,(XfGTW));
grid on;
title('FFT GTW');
axis([0 N]);

subplot(3,1,3);
plot(n,abs(XfMat-XfGTW));
grid on;
title('Diff. b/n FFT Matlab and FFT GTW');
axis([0 N]);

%================================================