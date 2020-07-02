function [vlc, qstep, rise1, qf] = group1enc(X)
%% encodes the image using lbt



%Author: Andy Cai CRSID ajc327
% Date : 30/05/2020

[qstep, rise1, qf] = optimise_parameters(X);

vlc= lbtenc(X-128,qstep,rise1,qf);


return 
end 

