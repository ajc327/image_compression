%finding ref step for the equal mse scheme, same as direct quantisation
%using ref_step 

%change to load different images
load SF2_competition_image_2020
% load lighthouse
X = double(X)
n = 3
draw(X)
ref_step = 30

%%
%choose the optimal method for optimisation
method = 'mse'
dwtstepratio = dwtstep_mse(n)
%
[n_kb,rms_error_jpeg,ssim] = jpeg_dwt(X,'mse',ref_step,dwtstepratio)

%% Optimisation for parameters
while n_kb > 5
    ref_step = ref_step+1
    [n_kb,rms_error_jpeg,ssim] = jpeg_dwt(X,method,ref_step,dwtstepratio)
%     [total_bits,rms_error]=quantdwt(X,N,method,rise1,ref_step,dwtstepratio)
    
end

while n_kb < 5
    ref_step = ref_step - 0.5
    [n_kb,rms_error_jpeg,ssim] = jpeg_dwt(X,method,ref_step,dwtstepratio)
%     [total_bits,rms_error]=quantdwt(X,N,method,rise1,ref_step,dwtstepratio)
end

while abs(n_kb-5) > 0.1
    if n_kb > 5
        ref_step = ref_step+1
        [n_kb,rms_error_jpeg,ssim] = jpeg_dwt(X,method,ref_step,dwtstepratio)
    end 
    
    if n_kb < 5
        ref_step = ref_step-0.1
        [n_kb,rms_error_jpeg,ssim] = jpeg_dwt(X,method,ref_step,dwtstepratio)
    end 
    
end

while n_kb >5 
    ref_step = ref_step+0.1
    [n_kb,rms_error_jpeg,ssim] = jpeg_dwt(X,method,ref_step,dwtstepratio)
end 


qstep = ref_step*dwtstepratio
vlc = jpegenc_dwt(X, qstep)
n_bits = sum(vlc(:,2))
n_kb = n_bits/8/1024
%save the variables to the mat file
image_name = input('Please enter the name of the input image','s')
file_name = append(image_name(1:5),'cmp.mat')
save file_name vlc n_bits qstep image_name

clear all
load compecmp
Z = jpegdec_dwt(vlc, qstep)
rms_error_jpeg = std(X(:)-Z(:))
psnr = 10*log(max(Z(:))/rms_error_jpeg)
% [mssim, ssim_map] = ssim_index(X,Z)

Z = double(Z+128)
draw (Z)
rms_error_jpeg = std(X(:)-Z(:))
file_name = append(image_name(1:5),'dec.mat')
save file_name Z

%%