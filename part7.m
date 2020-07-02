%% This code contains the experiments in section 7 of the hand out

% 




% Author: Andy Cai CRSID ajc327
% Date : 16/05/2020

%% 7.1 applying the DCT to images 

C8= dct_ii(8);
plot(C8');
%% 

Y = colxfm(colxfm(X-128,C8)',C8)';
%draw(Y);
N =8; 
draw(regroup(Y,N)/N);
subimages = regroup(Y,N)/N;
save_my_figs('part7dctdisp');

img_dim = size(subimages);
bin_size1 = img_dim(1)/N;
bin_size2 = img_dim(2)/N;
my_energyx=zeros(N);
for i = 1:N
    for k = 1:N
        Ys = subimages((i-1)*bin_size1+1:i*bin_size1,(k-1)*bin_size2+1:k*bin_size2);
        Y_energy = sum(Ys(:).^2);
        my_energy(i,k) = Y_energy;
     
    end 
end 

%% 
C4= dct_ii(4);

Z = colxfm(colxfm(Y',C4')',C4'); 

%draw(Z);
diff_matrix = abs(X-128-Z);
max_diff = max(diff_matrix(:));

bases = [zeros(1,4);C4';zeros(1,4)];
draw(255*bases(:)*bases(:)');
save_my_figs('part7basis4');


%% 

Yq = quantise(Y,17); 
Yr = regroup(Yq,N)/N;
Yr_bits = dctbpp(Yr,N);

Yr_bits_bpp = bpp(Yr)*size(Yr,1)*size(Yr,2); 

%% 
Xs = X-128;
Zq = colxfm(colxfm(Yq',C8')',C8'); 
rms_Zq = std(diff_matrix(:)); 
rms_Zq = std(Xs(:) - Zq(:));

Xq= quantise(X-128,17); 
rms_Xq = std(Xq(:) - X(:)); 
draw(Zq)
save_my_figs('part7Zq');
draw(Xq)


save_my_figs('part7Xq');

%%
N = 8; 

Y = colxfm(colxfm(X-128,C8)',C8)';

step_8= optimise_step_dct(8,X-128); 
step_8int = round(step_8); 

Yqo = quantise(Y,step_8int); 
Yr = regroup(Yqo,N)/N;
Yr_bits_optimal = dctbpp(Yr,N);
Zqo = colxfm(colxfm(Yqo',C8')',C8'); 
expe= dctbpp(Yr,256);

draw(Zqo);
save_my_figs('part7c8optimal_step');
%% 
my_step =17;
X_quantised = quantise(Xs,my_step);
original_bits = size(Xs,1)*size(Xs,2)*bpp(X_quantised);

dct_optimal_steps =[0 0 0 0 0];
dct_bits = [0 0 0 0 0];
dct_sizes=[4,8,16,32,64];
dct_stds = [0 0 0 0 0];
dct_compression = [0 0 0 0 0];
for i = 1: length(dct_sizes)
    N = dct_sizes(i);
    C = dct_ii(N);

    Y = colxfm(colxfm(X-128,C)',C)';

    stepi= optimise_step_dct(N,Xs); 
    step_int = round(stepi); 
    dct_optimal_steps(i) = stepi;
    Yq = quantise(Y,step_int); 
    Yr = regroup(Yq,N)/N;
    Yr_bits_optimal = dctbpp(Yr,N);
    Zq = colxfm(colxfm(Yq',C')',C'); 
    
    dct_bits(i) = Yr_bits_optimal;
    Xs = X-128;
    rms_Zq = std(Xs(:) - Zq(:));
    dct_stds(i) = rms_Zq;
    dct_compression(i)= original_bits/Yr_bits_optimal;
    mystr = strcat('part7_optimal_c',int2str(N));
    
    draw(Zq);
    save_my_figs(mystr);
end 

%% 
