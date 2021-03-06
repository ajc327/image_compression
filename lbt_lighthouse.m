%% This file contains lbt and dct runs on the lighthouse using quantisation tables


% Author: Andy Cai CRSID ajc327
% Date : 24/05/2020

%jpeg scheme with quantisation table
load lighthouse
%set parameters
D =33; 
N = 8; 
M = 8;
qf=1.005;
rise1=1;
Xs=X-128;
%use the modified jpeg encoding function, reptable is the repeated quantisation
%table

[vlc,reptable] = jpegenc_table(X-128,D,rise1,qf,N,M);
Z = jpegdec_table(vlc,D,rise1,N,M,qf)';
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

draw(Z2);
save_my_figs('jpeg_notable');

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

D =34; 
N = 8; 
M = 8;
qf =1.005; 
rise1 = 1; 
Xs=X-128;
[vlc,reptable] = lbtenc(X-128,D,rise1,qf,N,M);
Z = lbtdec(vlc,D,rise1,qf,N,M);
error_table= std(X(:)-Z(:)); 
mmsim_table = ssim_index(Xs,Z);

draw(Z); 
save_my_figs('lbt_table');


%%
load 2020
X= double(X);
D =20; 
N = 8; 
M = 8;
rise1 = 0.98; 
qf =1; 

Xs=X-128;
[vlc,reptable] = lbtenc(X-128,D,rise1,qf,N,M);
Z = lbtdec(vlc,D,rise1,qf,N,M);
error_table_optimised= std(X(:)-Z(:)); 
mmsim_table_optimised = ssim_index(Xs,Z);
disp(sum(vlc(:,2))-40900);
draw(Z); 
save_my_figs('lbt_table_optimised');

%%
load lighthouse;
draw(X);
save_my_figs('og');


%%
D =35; 
N = 8; 
M = 8;
qf =1; 
rise1 = 1; 
Xs=X-128;
[vlc,reptable] = lbtenc(X-128,D,rise1,qf,N,M);
Z = lbtdec(vlc,D,rise1,qf,N,M);
error_table= std(X(:)-Z(:)); 
mmsim_table = ssim_index(Xs,Z);

draw(Z); 
save_my_figs('lbt_notable');