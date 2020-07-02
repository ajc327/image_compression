function optimal_stepsize = optimise_step(pyramid,h,X)
%% This function optimises the stepsize of a pyramid 
% Input:  pyramid is a cells object containing the unquantised X_lists and Y_lists
% Output: optimal_stepsize is a float, a number indicating the optimal
% stepsize for the pyramid structure 

% Author: Andy Cai CRSID ajc327
% Date : 12/05/2020

    errors = [];
    x = linspace(5,30,26);
    
    for i = 5: 30
        quantised_pyramidi = quantpyramid(pyramid, i);
        decodedi= pyndec(quantised_pyramidi,h);
        standard_devi = std(X(:)-decodedi(:));
        errors = [errors, standard_devi];
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