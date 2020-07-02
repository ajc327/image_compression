%% This code contains the experiments in section 6 of the hand out

% the code familiarises with column/row decimations then finds the coding
% efficiency of laplacian pyramids of differnt depths from 1-8. It also
% calculates the standard deviation between the reconstructed images from the 
% quantised laplacian pyramids and the orininal image

% this code uses functions:
% pynenc : creates laplacian pyramids of depth n 
% pyndec : decodes the laplacian pyramids 
% quantpyramid: quantises the a laplacian pyramid using the quant function 
% find_pyramid_ent: finds the entropy of a laplacian pyramid 


% Author: Andy Cai CRSID ajc327
% Date : 12/05/2020

%% 


%defines h and does the row and column row decimations in order
h = (1/4)*[1 2 1];

X11 = rowdec(X,h);

draw(X11); 
save_my_figs('part6rowdec_r');

X1 = rowdec(X11',h)';
draw(X1); 

save_my_figs('part6rowdec_rc');


%% This section does the interpolation of the quarter size lowpass iamge 

X12 = rowint(X1,2*h); 
draw(X12); 

X12 = rowint(X12',2*h)'; 
draw(X12); 

save_my_figs('part6rowdec_interpolatedX12');


%% 
Y0 = X-X12; 
draw(Y0);
save_my_figs('part6rowdec_highpassY0');

%% 


%% entropy calculation 

%this is now redundant as the following sections would do everything
%collectively 

% entropy_cells ={['X','X1','Y0']};
% my_step = 17;
% entropy_cells{2} = my_step*[1 1 1];
% 
% entropy_per_pixel = [bpp(quantise(X,my_step)), bpp(quantise(X1,my_step)), bpp(quantise(Y0,my_step))];
% entropy_cells{3}= entropy_per_pixel;
% total_encode_bits = [size(X,1)*size(X,2)*entropy_per_pixel(1), size(X1,1)*size(X1,2)*entropy_per_pixel(2), size(Y0,1)*size(Y0,2)*entropy_per_pixel(3) ];
% entropy_original = total_encode_bits(1);
% entropy_compressed = total_encode_bits(2)+total_encode_bits(3);
% 
% compression_ratio_onestage = entropy_compressed/entropy_original; 
% 
% fprintf('the compression ratio for one stage is: ');
% disp(compression_ratio_onestage);

%% This section calculates the standard deviation of the 4 layer laplacian
%pyramid. this is now redundant as the last section does everything

% pyramid4= pynenc(X,4,h);
% quantised_pyramid4 = quantpyramid(pyramid4,my_step);
% decoded4= pyndec(quantised_pyramid4,h);
% draw(decoded4);
% standard_dev_4 = std(X(:)-decoded4(:));

%% pyramids of different depths quantised 
%5 layers
% pyramid5= pynenc(X,5,h);
% quantised_pyramid5 = quantpyramid(pyramid5,my_step);
% decoded5= pyndec(quantised_pyramid5,h);
% standard_dev_5 = std(X(:)-decoded5(:));
% 
% draw(decoded5);
% save_my_figs('part6decoded5');


%% 6 layers

% pyramid5= pynenc(X,6,h);
% quantised_pyramid5 = quantpyramid(pyramid5,my_step);
% decoded5= pyndec(quantised_pyramid5,h);
% 
% draw(decoded5);
% save_my_figs('part6decoded6');
% standard_dev_6 = std(X(:)-decoded5(:));
% entropy_decoded6 = find_pyramid_ent(mystep)
%% 8 layers
% 
% pyramid5= pynenc(X,8,h);
% quantised_pyramid5 = quantpyramid(pyramid5,my_step);
% decoded5= pyndec(quantised_pyramid5,h);
% draw(decoded5);
% save_my_figs('part6decoded8');
% standard_dev_8 = std(X(:)-decoded5(:));


%% for loop to generate them automaticallly 
standard_devs=[]; 
unquantised_entropies=[];
quantised_entropies=[]; 
my_step =17;
X_quantised = quantise(X,my_step);
original_entropy = size(X,1)*size(X,2)*bpp(X_quantised);
for i = 1:8
    pyramidi= pynenc(X,i,h);
    quantised_pyramidi = quantpyramid(pyramidi,my_step);
    decodedi= pyndec(quantised_pyramidi,h);
    draw(decodedi);
    mystr = strcat('part6decoded',int2str(i));
    save_my_figs(mystr);
    standard_dev = std(X(:)-decodedi(:));
    unquantised_entropies=[unquantised_entropies,find_pyramid_ent(pyramidi)];
    quantised_entropies=[quantised_entropies,find_pyramid_ent(quantised_pyramidi)]; 
    standard_devs=[standard_devs, standard_dev];
end 

compression_ratios= original_entropy./quantised_entropies;

%% quantise the original image and see the difference 
original_quantised_error = std(X(:)-X_quantised(:));
draw(X_quantised);
save_my_figs('part6originalquantised17');
%% optimise for step size in order to get the same error as for direct 
%quantisation at step size of 17, assuming a layer depth of 4 

optimal_step4 = optimise_step(pynenc(X,5,h),h,X);
%find the optimal step size for every depth
optimal_step_array= zeros(1,8);
optimal_step_raw = zeros(1,8);
for i = 1:8
    optimal_stepi = optimise_step(pynenc(X,i,h),h,X);
    optimal_step_array(i) = round(optimal_stepi);
    optimal_step_raw(i) = optimal_stepi;
end 
%% measure the compression for pyramid scheme with optimal constant stepsize
% generate the images for visual inspection 
% find the compression ratios and the errors at optimal constant stepsize 
standard_devs_constant_optimal=[]; 
unquantised_entropies_constant_optimal=[];
quantised_entropies_constant_optimal=[]; 

for i = 1:8
    pyramidi= pynenc(X,i,h);
    quantised_pyramidi = quantpyramid(pyramidi,optimal_step_array(i));
    decodedi= pyndec(quantised_pyramidi,h);
    draw(decodedi);
    mystr = strcat('part6_constantoptimalstep',int2str(i));
    save_my_figs(mystr);
    standard_dev = std(X(:)-decodedi(:));
    unquantised_entropies_contstant_optimal=[unquantised_entropies_constant_optimal,find_pyramid_ent(pyramidi)];
    quantised_entropies_constant_optimal=[quantised_entropies_constant_optimal,find_pyramid_ent(quantised_pyramidi)]; 
    standard_devs_constant_optimal=[standard_devs_constant_optimal, standard_dev];
end 

compression_ratios_constant_optimal= original_entropy./quantised_entropies_constant_optimal;





%% impulse response measurement for MSE
%generate a test pyramid of depth n 

%first we need to find the optimal step size for every layer of every
%laplacian pyramid depth 
optimal_sizes = [];
energies = {};
MSE_steps_normalised = {};

for i = 1:8
    energiesi =[];
    for k = 1:i+1 
        test_pyramidi = gen_test_pyramid(X,i,k,100);
        constructed = pyndec(test_pyramidi,h);
        energyi = sum(constructed(:).^2);
        energiesi=[energiesi,energyi];
    end 
    energies{i} = energiesi;
    MSE_steps_normalised{i}= 100.*energiesi.^(-0.5);
end 

MSE_ratios = MSE_steps_normalised{end};

%% for each laplacian pyramid size we need to find scalings such that the
% error is close to the reference level 
pyramid4 = pynenc(X,4,h);
mse_steps4 = optimise_step_mse(pyramid4,h,X,MSE_ratios);


%% 

standard_devs_mse=[]; 
unquantised_entropies_mse=[];
quantised_entropies_mse=[]; 
mse_steps_mse={};
for i = 1:8
    pyramidi= pynenc(X,i,h);
    steps_msei=optimise_step_mse(pyramidi,h,X,MSE_ratios);
    mse_steps_mse{i} = steps_msei;
    quantised_pyramidi = quantpyramid(pyramidi,steps_msei);
    decodedi= pyndec(quantised_pyramidi,h);
    draw(decodedi);
    mystr = strcat('part6_mse',int2str(i));
    save_my_figs(mystr);
    standard_dev = std(X(:)-decodedi(:));
    unquantised_entropies_mse=[unquantised_entropies_mse,find_pyramid_ent(pyramidi)];
    quantised_entropies_mse=[quantised_entropies_mse,find_pyramid_ent(quantised_pyramidi)]; 
    standard_devs_mse=[standard_devs_mse, standard_dev];
end 

compression_ratios_mse= original_entropy./quantised_entropies_mse;

%% new decimation filter
% this uses a new filter h 

h2 = (1/16)*[1 4 6 4 1];

standard_devs_mse_h2=[]; 
unquantised_entropies_mse_h2=[];
quantised_entropies_mse_h2=[]; 
mse_steps_mse_h2={};
for i = 1:7
    pyramidi= pynenc(X,i,h2);
    steps_msei_h2=optimise_step_mse(pyramidi,h2,X,MSE_ratios);
    mse_steps_mse_h2{i} = steps_msei_h2;
    quantised_pyramidi = quantpyramid(pyramidi,steps_msei_h2);
    decodedi= pyndec(quantised_pyramidi,h2);
    draw(decodedi);
    mystr = strcat('part6_mse_h2',int2str(i));
    save_my_figs(mystr);
    standard_dev_h2 = std(X(:)-decodedi(:));
    unquantised_entropies_mse_h2=[unquantised_entropies_mse_h2,find_pyramid_ent(pyramidi)];
    quantised_entropies_mse_h2=[quantised_entropies_mse_h2,find_pyramid_ent(quantised_pyramidi)]; 
    standard_devs_mse_h2=[standard_devs_mse_h2, standard_dev_h2];
end 

compression_ratios_mse_h2= original_entropy./quantised_entropies_mse_h2;

%% 
draw(X);
save_my_figs('original');


