%//-----------------------------------------------------------------------
%//                                               
%//                  All rights reserved.                     
%//-----------------------------------------------------------------------
%//                                                           
%// File name   : GoodThomasFFT.m                        
%// Author      : Nikhilesh Bhagat
%// Description : Performs Good-Thomas FFT for specified value of 'N' 
%// 7/11/2015   : Initial version.                                 
%//-----------------------------------------------------------------------

clc
clear all
close all

%====== FIGURE PROPERTIES =======================
xylabel_fontsize = 16;
fig_linewidth    = 2;
%================================================
A           = 1;                %amplitude of the cosine wave
fc          = 1;                %frequency of the wave
phase       = 0;                %desired phase shift of the cosine in degrees
Tsec        = 1;                %duration
fsampFactor = 360;              %sampling factor
N           = fsampFactor;
fs          = fsampFactor*fc;          %sampling frequency with over
t           = 0:(1/fs):(Tsec-(1/fs));  %seconds duration

phi         = phase*pi/180;            %convert phase shift in degrees in radians
x           = A*exp(i*2*pi*fc*t+phi);  %time domain signal with phase shift

figure(1);
plot(t,real(x),"linewidth",fig_linewidth,t,imag(x),'r',"linewidth",fig_linewidth);                  %plot the signal
xlabel('t(sec)','fontweight','bold',"fontsize",xylabel_fontsize); 
ylabel('x[n]','fontweight','bold',"fontsize",xylabel_fontsize);
grid on;
set(gca, 'fontweight','bold', "linewidth", fig_linewidth, "fontsize", xylabel_fontsize)

fft_len   = sprintf('GTW%dpt(x)',N);
XfGTW     = eval(fft_len);
X2        = XfGTW;                           %store the FFT results in another array
threshold = max(abs(XfGTW))/10000;           %tolerance threshold | %detect noise (very small numbers (eps)) and ignore them
X2(abs(XfGTW)<threshold) = 0;                %maskout values that are below the threshold
phase     = atan2(imag(X2),real(X2))*180/pi; %phase information

figure(2);
subplot(2,1,1);
stem((1:1:N)/N,abs(XfGTW),"linewidth",fig_linewidth);
grid on;
xlabel('f/fs','fontweight','bold',"fontsize",xylabel_fontsize); 
ylabel('|X(k)|','fontweight','bold',"fontsize",xylabel_fontsize);
set(gca, 'fontweight','bold', "linewidth", fig_linewidth, "fontsize", xylabel_fontsize)
subplot(2,1,2);
stem((1:1:N)/N,phase,"linewidth",fig_linewidth);
grid on;
xlabel('f/fs','fontweight','bold',"fontsize",xylabel_fontsize); 
ylabel('angle(X(k))','fontweight','bold',"fontsize",xylabel_fontsize);
set(gca, 'fontweight','bold', "linewidth", fig_linewidth, "fontsize", xylabel_fontsize)

FFT_diff = fft(x) - XfGTW;
err_margin = 1/1000;
FFT_diff(abs(FFT_diff)<err_margin) = 0;

assert(sum(FFT_diff)==0,'Good-Thomas FFT value does not match with Matlab computed FFT!!');


%================================================