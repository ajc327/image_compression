%% This file contains dwt runs on the lighthouse using quantisation tables


% Author: Andy Cai CRSID ajc327
% Date : 24/05/2020

load lighthouse;

Xs=X-128;
n=3;
dwti = nleldwt(Xs,n);
dwtstep= optimal_step_dwt2(dwti,n,1,X); 
vlc2 = jpegenc_dwt(Xs,dwtstep);

Z2 = jpegdec_dwt(vlc2,dwtstep); 
error_dwt =std(Xs(:)-Z2(:));
mmsim_dwt = ssim_index(Xs,Z2);

%%
draw(Z2);