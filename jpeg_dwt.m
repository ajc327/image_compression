%this file execute jpec with dwt on the image 
function [n_kb,rms_error_jpeg,mssim] = jpeg_dwt(X,method,ref_step,dwtstepratio)
% load lighthouse
% X = double (X-128)
n = 3
rise1 = 1
[size_x,size_y] = size(X)
% X_dwt = nlevdwt(X,n)
% ref_step = 33
% qstep = ref_step
% 
% Y = quantise(X_dwt,qstep,qstep)
% Z = nlevidwt(Y,n)
% rms_error_recovered = std(X(:)-Z(:))

% method = 'mse'
% 
% if strcmp(method, 'mse')
%     
%     qstep = dwt_mse_optimiser_polyfit(X,n,rise1,ref_step,dwtstepratio);
%     
% elseif strcmp(method, 'freq')
%     
%     qstep = dwt_freq_optimiser_polyfit(X,n,rise1,ref_step,dwtstepratio);
%     
% elseif strcmp(method, 'eqstep')
%     
%     qstep = ones([3,n+1]);
%     qstep = qstep * dwt_equal_step_optimiser(X,n,rise1,ref_step,dwtstepratio); %equal_step
% end 

qstep = ref_step*dwtstepratio
vlc = jpegenc_dwt(X, qstep)
n_bits = sum(vlc(:,2))
n_kb = n_bits/8/1024
% recover to get Zq from Yq
% clear all
% load compecmp
Z = jpegdec_dwt(vlc, qstep)
rms_error_jpeg = std(X(:)-Z(:))
psnr = 10*log(max(Z(:))/rms_error_jpeg)
[mssim, ssim_map] = ssim_index(X,Z)

% Z = double(Z+128)


    