function optimal_stepsize = optimise_step_lbt(N,X,s,rise1)
%% This function optimises the stepsize  a lbt
% Input:  Y is the dct matrix, N is the size of the dct and X is th
% eoriginal image 

% Author: Andy Cai CRSID ajc327
% Date : 18/05/2020

    errors = [];
    x = linspace(20,50,31);
    Xs = X-128;
    cn= dct_ii(N);
    [pf,pr] = pot_ii(N,s); 
    I = size(Xs,1);
    t =[(1+N/2):(I-N/2)];
    Xp = Xs; 
    Xp(t,:) = colxfm(Xp(t,:),pf); 
    Xp(:,t) = colxfm(Xp(:,t)', pf)';
    Y = colxfm(colxfm(Xp,cn)',cn)';
    
    for i = 20: 50
        Yq = quantise(Y, i,rise1*i);
        Yr = regroup(Yq,N)/N;
        
        Z = colxfm(colxfm(Yq,cn')',cn'); 
        Zp =Z;
        Zp(:,t) = colxfm(Zp(:,t)',pr')';
        Zp(t,:)= colxfm(Zp(t,:),pr');
        Zp = Zp';
        rms_Zq = std(Xs(:) - Zp(:));
        errors = [errors, rms_Zq];
    end 
    X_quantised = quantise(Xs,17);
    orig_error = std(Xs(:)-X_quantised(:));
    
    plot(x, errors);
    p = polyfit(x, errors, 4); 
    x1 = linspace(5,35,200);
    p1 = polyfit(errors, x,4);
    
    my_fit = polyval(p, x1); 
    hold on; 
    lighthouse_rms=9;
    bridge_rms=13;
    flamingo_rms=11;
    optimal_stepsize = polyval(p1,flamingo_rms); 
    plot(optimal_stepsize,orig_error,'o');
    
    
    plot(x1, my_fit); 
    my_text = strcat('\leftarrow optimal step size at ', string(optimal_stepsize));
    text(optimal_stepsize,orig_error, '\leftarrow optimal step size');
    hold off; 
    
    return 
     

end 