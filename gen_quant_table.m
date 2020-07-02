function Ts = gen_quant_table(stepsize,Q)
%% gen_quant_table generates a quantisation table accordign to the stepsize 

% Q is the quality factor, ranges form 20-95


%Author: Andy Cai CRSID ajc327
% Date : 30/05/2020
% gen_quantisation_matrix


    %// Define base quantization matrix
    Tb = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; ...
         14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; ...
         18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; ...
         49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];
    
    %// Determine S
    if (Q < 50)
        S = 5000/Q;
    else
        S = 200 - 2*Q;
    end
    
    Ts = floor((S*Tb + 50) / 100);
    Ts = round(Ts/Ts(1,1)*stepsize);
    
    Ts(Ts == 0) = 1; % // Prevent divide by 0 err
    
    return;
end 