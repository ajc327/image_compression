%% This code contains the experiments in section 5 of the hand out

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
% Date : 10/05/2020

%% 

Xf=[];
n=15;
for i= 1:size(X)
    Xf = [Xf;conv(halfcos(n),X(i,:))];
end
Xf_trimmed = Xf(:,[1:256]+7);
draw(Xf(:,[1:256]+7));


save_my_figs('part5con');




% This part computes the covolution using the convse mirroring 

%ind = [3 2 [1:n] n-1 n-2];
%Xe= X(:,ind); 
Xfe=convse(X,halfcos(15));

draw(Xfe);
save_my_figs('part5conse_hor');


%now apply the vertical filter 
Xfe_hor_ver = convse(Xfe', halfcos(15))';
draw(Xfe_hor_ver); 
save_my_figs('part5conse_hor_ver');



%try applying the fiters the other way around

Xfe_ver = convse(X', halfcos(15))';
draw(Xfe_ver); 
save_my_figs('part5conse_ver');


Xfe_ver_hor = convse(Xfe_ver, halfcos(15));
draw(Xfe_ver_hor);
save_my_figs('part5conse_ver_hor');
%% 
% this is the filtered image using the conv2se function provided
Xfe_2d = conv2se(halfcos(15), halfcos(15),X);

draw(Xfe_2d);
save_my_figs('part5con2se');

%% 
%calculate the difference between the row-column and column-row filtered . This is done by calculating the frobenious norm of the
%difference matrix

diff = abs(Xfe_hor_ver- Xfe_ver_hor); 

max_absolute_diff = max(diff(:));


fprintf('the max absolute differnce is %f', max_absolute_diff);


diff2 = abs(Xfe_ver_hor - Xfe_2d); 

max_absolute_diff2 = max(diff2(:));
% the max absolute differnce is 1.1369E-13

%% 
% create a 2D high pass filter 

hp_filter = Xfe_hor_ver-X; 

Y= hp_filter; 

draw(Y);

save_my_figs('part5highpass_halfcos15');

my_halfcos_list =[5, 9, 21, 39];
my_lowenergies =[];
my_highenergies=[];

for i = 1:4
    halfcos_len= my_halfcos_list(i);
    Xfe_2d_halfcos = conv2se(halfcos(halfcos_len), halfcos(halfcos_len),X);
    
    draw(Xfe_2d_halfcos);
    my_lowenergies = [my_lowenergies, sum(Xfe_2d_halfcos(:).^2)];
    
    save_my_figs(strcat('part5_halfcos',int2str(halfcos_len)));
    hp_filter = X-Xfe_2d_halfcos; 
    draw(hp_filter);
    my_highenergies = [my_highenergies, sum(hp_filter(:).^2)];

    save_my_figs(strcat('part5highpass_halfcos',int2str(halfcos_len)));
    
end

my_energies=[my_halfcos_list;my_lowenergies; my_highenergies];

%% 
my_energies = [my_energies; my_lowenergies+my_highenergies];



