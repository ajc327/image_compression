function lbt_objective = lbt_obj(x,X)
%% This function finds the step size of the dwt to quantise 
% Input:  my_dwt is a dwt, n is the level number
          
% Author: Andy Cai CRSID ajc327
% Date : 31/05/2020
D = round(x(1)*10);
N = 8; 
M = 8;
rise1 = x(2); 
qf=x(3);

Xs=X-128;
[vlc,reptable] = lbtenc(X-128,D,rise1,qf,N,M);
Z = lbtdec(vlc,D,rise1,qf,N,M);
error_table= std(X(:)-Z(:)); 
mmsim_table = ssim_index(Xs,Z);
lbt_objective = 1/mmsim_table;
return;
end 


