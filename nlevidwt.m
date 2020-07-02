function X = nlevidwt(Y,n)
%% This function finds the inverse of a n level dwt 
% Input:  Y is the dwt
% Output: Xr is the reconstructed image
% Author: Andy Cai CRSID ajc327
% Date : 12/05/2020

%%
X = Y;
m = 256/(2^(n-1));
for i = 1:n

    t = 1:m; 
    X(t,t) = idwt(X(t,t)); 
    m=m*2;
end 

return; 

end 