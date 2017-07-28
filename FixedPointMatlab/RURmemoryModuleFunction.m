% clc ;
% clear all;
% close all;

function memRURvalues = RURmemoryModuleFunction(N, N1, N2)

% N = 63;
% N1 = 9;        % Columns
% N2 = 7;        % Rows
 
Mat = zeros(N2,N1);
temp = 0;
 %% =================================================================
 for i = 1:N2
%     Mat(i,1) = temp;
    Mat(i,1) = temp+1;
    for j = 2:(N1)
       temp = temp + N2;
%        Mat(i,j) = rem(temp,N);
       Mat(i,j) = 1+rem(temp,N);
    end
    temp = i*N1;
 end
  %% =================================================================
 Xk = RUR_Npt(Mat,N2,N1); % N2<N1
 
RurOut = [];
for i=1:1:N2
    RurOut = [RurOut Mat(i,:)];
end

for num = 1:1:N
    RURindexValueTemp(num) = find(RurOut==num);
end

memRURvalues = RURindexValueTemp;

end
  %% =================================================================
% temp = fopen('memAddMap_Out.txt','w');
% fprintf(temp,'%d \t',Out);
% 
% % % for i=1:1:N1
% % %     out = [out transpose(Mat(:,i))];
% % % end
% % 
% % bin = dec2bin((Out));
% % data = reshape(bin',1,N*ceil(log2(N)));
% 
% % fprintf(temp,'%c',data);
% % 
% % 
% 
% %  
% % % for (i = 1:N) 
% % %     if(i<=N)
% % %         fprintf(temp,'%c',bin(i,:));
% % %     end
% % %     fprintf(temp,' \n');
% % %     
% % % end