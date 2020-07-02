function test_dwt = gen_test_dwt(X,n, impulse_location)
%% this function creates a test pyramid with zero everywhere and an impulse at the centre 

% inputs: X is the reference image

%         n is an integer
    

% Author: Andy Cai CRSID ajc327
% Date : 20/05/2020

test_dwt = zeros(size(X)); 

m = size(X,1)/(2^n);

if (impulse_location(2) == n+1)
    test_dwt(size(X,1)/2^(impulse_location(2)),size(X,2)/2^(impulse_location(2)))=100; 
    return 
end 
if (impulse_location(2) <n+1)
    if (impulse_location(1)==1)
        test_dwt(size(X,1)/2^(impulse_location(2)+1),3*size(X,2)/2^(impulse_location(2)+1))=100; 
        return
    end 
    if (impulse_location(1)==2)
        test_dwt(3*size(X,1)/2^(impulse_location(2)+1),size(X,2)/2^(impulse_location(2)+1))=100; 
        return
    end
      
    if (impulse_location(1)==3)
        test_dwt(3*size(X,1)/2^(impulse_location(2)+1),3*size(X,2)/2^(impulse_location(2)+1))=100; 
        return
    end   
    
return


end