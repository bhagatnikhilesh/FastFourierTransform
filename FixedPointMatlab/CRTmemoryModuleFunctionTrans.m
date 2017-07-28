% clc
% clear all
% close all
function memCRTvalues = CRTmemoryModuleFunctionTrans(x, N1, N2)
% x = 0:1:62;
% 
% N = 63;
% N1 = 9;    % columns
% N2 = 7;    % rows

% RoundMode=1;
% Signed=0;
% WL = ceil(log2(N));
% WF = 0;
%% =================================================================
x1 = transpose(CRT_Npt(x,N2,N1));     % CRT_Npt(x,N1,N2) and N1 > N2
% x1 = CRT_Npt(x,N1,N2);                  % CRT_Npt(x,N1,N2) and N1 > N2

out = [];
for i=1:1:N2
%     out(1,:) = x1(i,:);
    out = [out x1(i,:)];
end
% out = ((x1(:)));
% bin = dec2bin((out));
% memCRTvalues = reshape(bin',1,N*ceil(log2(N)));
memCRTvalues = out;


%% =================================================================

% xIn_FP = fpDouble2FP(out, WL, WF, Signed, RoundMode);
% 
% fpGenBinCOE(xIn_FP,'memCRT63pt.coe')

end


% temp = fopen('memAddMapIn.txt','w');
% % fprintf(temp,'%c',data);
% 
% fprintf(temp,'%d\t',out);
% 
% % for (i = 1:N) 
% %     if(i<=N)
% %         fprintf(temp,'%c',bin(i,:));
% %     end
% %     fprintf(temp,' \n');
% %     
% % end




