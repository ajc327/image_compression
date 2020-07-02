function test_pyramid = gen_test_pyramid(X,depth, impulse_location, impulse_size)
%% this function creates a test pyramid with zero everywhere and an impulse at the centre 

% inputs: X is the reference image

%         depth is an integer indicating the # of layers of the pyramid 
%         impulse location is an integer indicating which layer (Y0, Y1 etc
%         ) the impulse is located 
%         impulse_size is the maginitude of the impulse 

    
% outputs: test_pyramid is a cells object containing the matrices
%          Y0,Y1,...X0,X1..

% Author: Andy Cai CRSID ajc327
% Date : 13/05/2020

X_list = {zeros(size(X))};
Y_list ={};
for i =1:depth

    X_list{i+1} = zeros(size(X)/(2^i)); 
    Y_list{i} = zeros(size(X)/(2^(i-1)));
    if (i==impulse_location)
        modified_array = zeros(size(X)/(2^(i-1)));
        modified_array(size(X,1)/(2^i),size(X,2)/(2^i))=impulse_size;
        Y_list{i} = modified_array;
    end 
end 

modified_Xarray = zeros(size(X)/(2^(impulse_location-1)));
modified_Xarray(ceil(size(X,1)/(2^impulse_location)),ceil(size(X,2)/(2^impulse_location)))=impulse_size;

X_list{impulse_location} = modified_Xarray;


test_pyramid = {X_list, Y_list};

return


end