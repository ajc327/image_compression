%% This code contains the experiments in section 8 of the hand out

% 




% Author: Andy Cai CRSID ajc327
% Date : 18/05/2020
%% 

N=8;
Xs= X-128;

my_step =17;
X_quantised = quantise(Xs,my_step);
original_bits = size(Xs,1)*size(Xs,2)*bpp(X_quantised);

lbt_optimal_steps_pot =zeros(10,1);

lbt_bits_pot = zeros(10,1);
lbt_pots=[1 1.1 1.2 1.3 2^(0.5) 1.5 1.6 1.7 1.8 1.9];
lbt_stds_pot = zeros(10,1);
lbt_compression_pot = zeros(10,1);

for i = 1: length(lbt_pots)
    N = 8;
    cn = dct_ii(N);
    [pf,pr] = pot_ii(N,lbt_pots(i)); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Y = colxfm(colxfm(Xp,cn)',cn)';
    s= lbt_pots(i);
    stepi= optimise_step_lbt(N,X,s); 
    step_int = round(stepi); 
    lbt_optimal_steps_pot(i) = stepi;
    Yq = quantise(Y,step_int); 
    Yr = regroup(Yq,N)/N;
    Yr_bits_optimal = dctbpp(Yr,N);
    
    Z = colxfm(colxfm(Yq,cn')',cn'); 
    Zp =Z;
    Zp(:,t) = colxfm(Zp(:,t)',pr')';
    Zp(t,:)= colxfm(Zp(t,:),pr');
    Zp = Zp';
        
    lbt_bits_pot(i) = Yr_bits_optimal;
    rms_Zp = std(Xs(:) - Zp(:));
    lbt_stds_pot(i) = rms_Zp;
    lbt_compression_pot(i)= original_bits/Yr_bits_optimal;
    mystr = strcat('part8_c8_s',int2str(i));
    
    disp(mystr);
    draw(Zp);
    save_my_figs(mystr);
    
    mystr = strcat('part8_c8_s1_',int2str(i));
    
    draw(Zp1-Zp);
    save_my_figs(mystr);
end 

%% 
N=8;
Xs= X-128;

my_step =17;
X_quantised = quantise(Xs,my_step);
original_bits = size(Xs,1)*size(Xs,2)*bpp(X_quantised);

lbt_optimal_steps_pot =zeros(10,1);

lbt_bits_pot = zeros(10,1);
lbt_pots=linspace(1.2,1.41,10);
lbt_stds_pot = zeros(10,1);
lbt_compression_pot = zeros(10,1);

for i = 1: length(lbt_pots)
    N = 8;
    cn = dct_ii(N);
    [pf,pr] = pot_ii(N,lbt_pots(i)); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Y = colxfm(colxfm(Xp,cn)',cn)';
    s= lbt_pots(i);
    stepi= optimise_step_lbt(N,X,s); 
    step_int = round(stepi); 
    lbt_optimal_steps_pot(i) = stepi;
    Yq = quantise(Y,step_int); 
    Yr = regroup(Yq,N)/N;
    Yr_bits_optimal = dctbpp(Yr,N);
    
    Z = colxfm(colxfm(Yq,cn')',cn'); 
    Zp =Z;
    Zp(:,t) = colxfm(Zp(:,t)',pr')';
    Zp(t,:)= colxfm(Zp(t,:),pr');
    Zp = Zp';
        
    lbt_bits_pot(i) = Yr_bits_optimal;
    rms_Zp = std(Xs(:) - Zp(:));
    lbt_stds_pot(i) = rms_Zp;
    lbt_compression_pot(i)= original_bits/Yr_bits_optimal;
    mystr = strcat('part8_c8_s',int2str(i));
    if (1==1)
        Zp1=Zp;
    end 
    
    %draw(Zp);
    %save_my_figs(mystr);
    

end 
%% 
lbt_sizes=[4 8 16 32 64];
Xs=X-128;

for i = 1: length(lbt_pots)
    N=8;
    cn = dct_ii(N);
    [pf,pr] = pot_ii(N,lbt_pots(i)); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Xp = Xp*0.5;
    bases = [zeros(1,8); pf'; zeros(1,8)];
    draw(255*bases(:)*bases(:)');
    mystr = strcat('part8_c8_bases_s',int2str(i));
    save_my_figs(mystr);
    draw(Xp);
    mystr = strcat('part8_c8_xp_s',int2str(i));
    save_my_figs(mystr);

end 


%% 

Xs= X-128;
s = 2^0.5;
my_step =17;
X_quantised = quantise(Xs,my_step);
original_bits = size(Xs,1)*size(Xs,2)*bpp(X_quantised);

lbt_optimal_steps =zeros(5,1);

lbt_bits = zeros(5,1);
lbt_sizes=[4 8 16 32 64];
lbt_stds = zeros(5,1);
lbt_compression = zeros(5,1);

for i = 1: length(lbt_sizes)
    N = lbt_sizes(i);
    cn = dct_ii(N);
    [pf,pr] = pot_ii(lbt_sizes(i),s); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Y = colxfm(colxfm(Xp,cn)',cn)';
    stepi= optimise_step_lbt(N,X,s); 
    step_int = round(stepi); 
    lbt_optimal_steps(i) = stepi;
    Yq = quantise(Y,step_int); 
    Yr = regroup(Yq,N)/N;
    Yr_bits_optimal = dctbpp(Yr,16);
    
    Z = colxfm(colxfm(Yq,cn')',cn'); 
    Zp =Z;
    Zp(:,t) = colxfm(Zp(:,t)',pr')';
    Zp(t,:)= colxfm(Zp(t,:),pr');
    Zp = Zp';
        
    lbt_bits(i) = Yr_bits_optimal;
    rms_Zp = std(Xs(:) - Zp(:));
    lbt_stds(i) = rms_Zp;
    lbt_compression(i)= original_bits/Yr_bits_optimal;
    mystr = strcat('part8_optimal_c',int2str(N));
    
    disp(mystr);
    draw(Zp);
    save_my_figs(mystr);
end 


%% 
lbt_compression =lbt_compression';

