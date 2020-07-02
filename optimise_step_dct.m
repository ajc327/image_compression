function optimal_stepsize = optimise_step_dct(N,X)
%% This function optimises the stepsize of a pyramid 
% Input:  Y is the dct matrix, N is the size of the dct and X is th
% eoriginal image 

% Author: Andy Cai CRSID ajc327
% Date : 16/05/2020

    errors = [];
    x = linspace(5,30,26);
    Xs = X-128;
    C= dct_ii(N);
    Y = colxfm(colxfm(X-128,C)',C)';

    for i = 5: 30
        Yq = quantise(Y, i);
        Yr = regroup(Yq,N)/N;
        Zq = colxfm(colxfm(Yq',C')',C'); 
        rms_Zq = std(Xs(:) - Zq(:));
        errors = [errors, rms_Zq];
    end 
    X_quantised = quantise(X,17);
    orig_error = std(X(:)-X_quantised(:));
    
    plot(x, errors);
    p = polyfit(x, errors, 1); 
    x1 = linspace(5,30,200);
    p1 = polyfit(errors, x,1);
    
    my_fit = polyval(p, x1); 
    hold on; 
    optimal_stepsize = polyval(p1,orig_error); 
    plot(optimal_stepsize,orig_error,'o');
    
    
    plot(x1, my_fit); 
    my_text = strcat('\leftarrow optimal step size at ', string(optimal_stepsize));
    text(optimal_stepsize,orig_error, '\leftarrow optimal step size');
    hold off; 
    
    return 
     

end 