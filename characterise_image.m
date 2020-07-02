function freq_ratio = characterise_image(X)
%% gen_quant_table2 is the function for generating a custom quantisation table 


%Author: Andy Cai CRSID ajc327
% Date : 30/05/2020
% gen_quantisation_matrix
    if (nargin<3)
        M = 8;
    end 

    %// initialise the matrix
    Tb = zeros(M);
    %scale the elements according to their location such that the lower
    %right corner has the highest scaling
    for i=1:M
        for k =1:M
            Tb(i,k) = 1*Q^(i+k);
        end
    end 

    %round to integers 
    Ts = round(Tb*stepsize);
    
    Ts(Ts == 0) = 1; % // Prevent divide by 0 err
    
    return;
end 