function pyramid_entropy= find_pyramid_ent(pyramid)
%% THis function computes the entropy of a pyramid
% Input: pyramid is a cells object containing the X_lists and Y_lists
% output: is a float, the pyramid's total entropy
    
% Author: Andy Cai CRSID ajc327
% Date : 12/05/2020
    
    X_listn= pyramid{1};
    Y_listn= pyramid{2};
    my_len = length(Y_listn);
    entropy_Y=[];
    X1 = X_listn{1};
    entropy_X=[];
    array_size = size(X1,1)*size(X1,2);
    entpp= bpp(X1);
    entropy_X=[entropy_X, array_size*entpp];
   
    for i = 1: my_len
        Xi1= X_listn{i+1};
        Yi = Y_listn{i};
        entropy_X=[entropy_X, size(Xi1,1)*size(Xi1,2)*bpp(Xi1)];
        entropy_Y=[entropy_Y, size(Yi,1)*size(Yi,2)*bpp(Yi)];
    end 
    pyramid_entropy = sum(entropy_Y)+entropy_X(my_len+1);

    return 
    
end 