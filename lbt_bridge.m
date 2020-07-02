%% This file contains lbt and dct runs on the bridge using quantisation tables


% Author: Andy Cai CRSID ajc327
% Date : 24/05/2020

%jpeg scheme with quantisation table
load bridge
%set parameters
D =33; 
N = 8; 
M = 8;
qf=1.032;
rise1=1;
Xs=X-128;
%use the modified jpeg encoding function, reptable is the repeated quantisation
%table

[vlc,reptable] = jpegenc_table(X-128,D,rise1,qf,N,M);
Z = jpegdec_table(vlc,D,rise1,N,M,reptable)';
error_jpeg_table= std(X(:)-Z(:)); 
mmsim__jpeg_table = ssim_index(Xs,Z);
draw(Z);
save_my_figs('jpeg_table');
%% this is the original jpeg encoding and decoding 
D =34; 
N = 8; 
M = 8;
Xs=X-128;
vlc2 = jpegenc(X-128,D,N);
Z2 = jpegdec(vlc2,D,N)'; 
error_jpeg =std(Xs(:)-Z2(:));
mmsim_jpeg = ssim_index(Xs,Z2);
draw(Z);
%% original lbt encoding
D =35; 
N = 8; 
M = 8;
Xs=X-128;
vlc = lbtenc_base(X-128,D,N,M);
Z = lbtdec_base(vlc,D,N,M);
error = std(Xs(:)-Z(:)); 
mmsim_lbt = ssim_index(Xs,Z);

draw(Z); 
%% lbt encoding with the quantisation table


%%
load bridge
D =41; 
N = 8; 
M = 8;
rise1 = 0.9924; 
qf =1.0342; 

Xs=X-128;
[vlc,reptable] = lbtenc(X-128,D,rise1,qf);
Z = lbtdec(vlc,D,rise1,qf);
error_table_optimised= std(X(:)-Z(:)); 
mmsim_table_optimised = ssim_index(Xs,Z);
disp(sum(vlc(:,2))-40900);
draw(Z); 
save_my_figs('lbt_bridge_optimised');


%%
load 2020
X=double(X);
D =33; 
N = 8; 
M = 8;
rise1 = 1; 
qf =1; 

Xs=X-128;
[vlc,reptable] = lbtenc(X-128,D,rise1,qf);
Z = lbtdec(vlc,D,rise1,qf);
error_table_optimised= std(X(:)-Z(:)); 
mmsim_table_optimised = ssim_index(Xs,Z);
disp(sum(vlc(:,2))-40900);
draw(Z); 
save_my_figs('lbt_competition_optimised');