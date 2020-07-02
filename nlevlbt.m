function dwtout = nlevlbt(X,n)
%% This function quantises the pyramid 
% Input:  X is the image array
% Output: dwtout is the n-level dwt.
% Author: Andy Cai CRSID ajc327
% Date : 12/05/2020

%%
m=256; 
Y = lbt(X); 

for i = 1:n-1
    m=m/2; 
    t = 1:m; 
    Y(t,t) = dwt(Y(t,t)); 
    
end 

dwtout=Y; 
return; 

end 