
%clc
%clear all
%close all
function [XkOut] = GTW35pt(x)
N = 35;
N1 = 7;
N2 = 5;

%x = [0 1 zeros(1,N-2)];


%x = randn(1,N);
%x = randn(1,7);
%Xk = wfta_7pt(x);
%imag(x)
n = 1:1:N;

x1 = CRT_Npt(x,N1,N2);

%    % Performing the column transformations using a 3-pt fft.
for n1 = 1:1:N1
  xtemp1 = (wfta_5pt((x1(:,n1))));
%  x2(:,n1) = wfta_5pt(x1(:,n1));
  x2(:,n1) = xtemp1;
end
%%% 
%%%     % Performing the row transformations using a 16-pt fft.
for n2 = 1:1:N2
  xtemp2 = wfta_7pt((x2(n2,:)));
  x3(n2,:) = xtemp2;
end
%%
X = ruritanianCorrespondenceNpt((x3),N2,N1); % N1<N2
XkOut = X;

end
%figure(1);
%stem(n,(Xk));
%grid on;
%%
%Xf = fft(x);
%figure(2);
%stem(n,(Xf));
%grid on;
%
%% %% ========================================================================
% figure(3);
% plot(n,abs((Xf-Xk)));
% title('Absolute error between fixed point and floating point transform implementation.')
% grid on;

