%% This code contains the experiments in designing a lbt scheme for image compression 
% has some code for optimising rise1, not very important anymore as we will
% optimise everything together later. 



% 




% Author: Andy Cai CRSID ajc327
% Date : 24/05/2020

%% as before, implement the lbt 
%for all test images, the 4x4 case offers the best compression 
load flamingo;
Xs= X-128;
s = 2^0.5;
my_step =17;
X_quantised = quantise(Xs,my_step);

original_bits = size(Xs,1)*size(Xs,2)*bpp(X_quantised);

%initialise variables 
lbt_optimal_steps =zeros(5,1);

lbt_bits = zeros(5,1);
lbt_sizes=[2 4 8 16 32];
lbt_stds = zeros(5,1);
lbt_compression = zeros(5,1);


%for loop to go through the different lbt sizes 
for i = 1: length(lbt_sizes)
    N = lbt_sizes(i);
    %create the dct transform and the pre/post filters
    cn = dct_ii(N);
    [pf,pr] = pot_ii(lbt_sizes(i),s); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    
    %apply the pre filter and the dct
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Y = colxfm(colxfm(Xp,cn)',cn)';
    
    %find the optimal step according to the lbt size and default s=sqrt(2)
    stepi= optimise_step_lbt(N,X,s,0.9); 
    step_int = round(stepi); 
    lbt_optimal_steps(i) = stepi;
    %quantise the transformed matrix according to the optimal step found 
    Yq = quantise(Y,step_int); 
    Yr = regroup(Yq,N)/N;
    
    %here the number of bits is estimated
    Yr_bits_optimal = dctbpp(Yr,16);
    
    %apply the post filter and recover the original image
    Z = colxfm(colxfm(Yq,cn')',cn'); 
    Zp =Z;
    Zp(:,t) = colxfm(Zp(:,t)',pr')';
    Zp(t,:)= colxfm(Zp(t,:),pr');
    Zp = Zp';
    
    %record the data and saving the figure 
    lbt_bits(i) = Yr_bits_optimal;
    rms_Zp = std(Xs(:) - Zp(:));
    lbt_stds(i) = rms_Zp;
    lbt_compression(i)= original_bits/Yr_bits_optimal;
    mystr = strcat('lbt_schemetest',int2str(N));
    
    disp(mystr);
    draw(Zp);
    %save_my_figs(mystr);
end 


%% investigate the effect of using different rise 1 in the quantiser 
x = [-100:100];
my_step= 20;
rise1 = 1.5*my_step;
y=quantise(x,my_step,rise1); 
plot(x,y), grid

%%
%for all test images, the 4x4 case offers the best compression 
load flamingo;
Xs= X-128;
s = 2^0.5;
my_step =17;
X_quantised = quantise(Xs,my_step);

original_bits = size(Xs,1)*size(Xs,2)*bpp(X_quantised);

%initialise variables 
v = 100;
lbt_optimal_steps =zeros(v,1);

lbt_bits = zeros(v,1);
lbt_rise1=linspace(0.5,1.5,v);
lbt_stds = zeros(v,1);
lbt_compression = zeros(v,1);

%for loop to go through the different lbt sizes 
for i = 1: length(lbt_rise1)
    N = 4;
    %create the dct transform and the pre/post filters
    cn = dct_ii(N);
    [pf,pr] = pot_ii(N,s); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    
    %apply the pre filter and the dct
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Y = colxfm(colxfm(Xp,cn)',cn)';
    
    %find the optimal step according to the lbt size and default s=sqrt(2)
    rise1 = lbt_rise1(i);

    stepi= optimise_step_lbt(N,X,s,rise1); 
    
    step_int = round(stepi); 
    lbt_optimal_steps(i) = stepi;
    %quantise the transformed matrix according to the optimal step found 
    Yq = quantise(Y,step_int,rise1*step_int); 
    Yr = regroup(Yq,N)/N;
    
    %here the number of bits is estimated
    Yr_bits_optimal = dctbpp(Yr,16);
    
    %apply the post filter and recover the original image
    Z = colxfm(colxfm(Yq,cn')',cn'); 
    Zp =Z;
    Zp(:,t) = colxfm(Zp(:,t)',pr')';
    Zp(t,:)= colxfm(Zp(t,:),pr');
    Zp = Zp';
    
    %record the data and saving the figure 
    lbt_bits(i) = Yr_bits_optimal;
    rms_Zp = std(Xs(:) - Zp(:));
    lbt_stds(i) = rms_Zp;
    lbt_compression(i)= original_bits/Yr_bits_optimal;
    mystr = strcat('lbt_scheme_rise1',int2str(i));
    disp(mystr);
    draw(Zp);
    save_my_figs(mystr);
end 

%% find the optimal ratios 
plot(lbt_rise1,lbt_bits);
xlabel('rise1 ratio'); 
ylabel('bits to encode'); 

%% see if throwing away some sub images will help 
    load lighthouse;
    N = 8;
    %create the dct transform and the pre/post filters
    cn = dct_ii(N);
    [pf,pr] = pot_ii(N,s); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    
    %apply the pre filter and the dct
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Y = colxfm(colxfm(Xp,cn)',cn)';
    
    %find the optimal step according to the lbt size and default s=sqrt(2)

    stepi= optimise_step_lbt(N,X,s,1); 
    
    step_int = round(stepi); 
    lbt_optimal_steps(i) = stepi;
    
    
    %quantise the transformed matrix according to the optimal step found 
    Yq = quantise(Y,step_int,1*step_int); 
    
    %throwaway the highest frequency subimage
    Yq(N:N:end,N:N:end)=0;

    Yr = regroup(Yq,N)/N;
    
    %here the number of bits is estimated
    Yr_bits_optimal = dctbpp(Yr,16);
    
    %apply the post filter and recover the original image
    Z = colxfm(colxfm(Yq,cn')',cn'); 
    Zp =Z;
    Zp(:,t) = colxfm(Zp(:,t)',pr')';
    Zp(t,:)= colxfm(Zp(t,:),pr');
    Zp = Zp';
    
    %record the data and saving the figure 
    rms_Zp = std(Xs(:) - Zp(:));
    lbt_compressioni= original_bits/Yr_bits_optimal;
    
    draw(Zp);
    save_my_figs(mystr);
