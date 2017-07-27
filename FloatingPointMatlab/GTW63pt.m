
%
%clc
%clear all
%close all
function Xk = GTW63pt(x)
%x = [0 i zeros(1,61)];
%%%%%n = 1:1:63;

N1 = 7;
N2 = 9;
x1 = CRT_Npt(x,N2,N1);

    % Performing the column transformations using a 3-pt fft.
for n1 = 1:1:9
  xtemp1 = wfta_7pt(x1(:,n1));
%  x2(:,n1) = wfta_5pt(x1(:,n1));
  x2(:,n1) = xtemp1;
end
% 
%%     % Performing the row transformations using a 16-pt fft.
for n2 = 1:1:7
  xtemp2 = wfta_9pt(x2(n2,:));
  x3(n2,:) = xtemp2;
end
%
X = ruritanianCorrespondenceNpt(x3,N1,N2); % N1<N2
Xk = X;
end


%figure(1);
%stem(n,(Xk));
%grid on;

