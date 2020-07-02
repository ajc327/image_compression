function [lbt_ine, lbt_eq] = lbt_con(x,X)
%% This function evaluates the nonlinear constraint to be used in the optimiser for the lbt 
% Input: step size: int around 33,  rise1 is around 1, qf is slightly greater than 1
%
          
% Author: Andy Cai CRSID ajc327
% Date : 31/05/2020
D = round(x(1)*10);
N = 8; 
M = 8;
rise1 = x(2); 
qf=x(3);
Xs=X-128;
[vlc,reptable] = lbtenc(X-128,D,rise1,qf,N,M);

lbt_ine =sum(vlc(:,2))-40960+192;
lbt_eq = [];
return;
end 


