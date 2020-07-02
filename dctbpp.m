function total_bits = dctbpp(Yr,N)
%% This function quantises the pyramid 
% Input:  Yr is the regrouped dct of the image and N is the block number
% Output: dctent is the entropy per pixel of the dct
% Author: Andy Cai CRSID ajc327
% Date : 16/05/2020

img_dim = size(Yr);
bin_size1 = img_dim(1)/N;
bin_size2 = img_dim(2)/N;
dctbits=zeros(N);
for i = 1:N
    for k = 1:N
        Ys = Yr((i-1)*bin_size1+1:i*bin_size1,(k-1)*bin_size2+1:k*bin_size2);
        Ysent = bpp(Ys);
        bits_ik = Ysent*size(Ys,1)*size(Ys,2); 
        dctbits(i,k) = bits_ik;
        
    end 
end 
total_bits = sum(dctbits(:)); 

end     