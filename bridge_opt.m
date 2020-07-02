%% This file contains lbt optimisation surface plats


% Author: Andy Cai CRSID ajc327
% Date : 31/05/2020

%jpeg scheme with quantisation table
%set parameters


%%

load bridge
D =4.1; 
res=40;
qf_bridge = linspace(1,1.05,res);
rise1_bridge = linspace(0.9,1.1,res);
my_heights_bridge= zeros(res);
B_bridge = zeros(res);
for i=1:length(qf_bridge)
    for k = 1:length(rise1_bridge)
        x = [D, rise1_bridge(k), qf_bridge(i)];
        my_heights_bridge(i,k) = lbt_obj(x);
        B_bridge(i,k) = lbt_con(x);
        disp([i,k]);
    end 
end 


%%

qf_bridge = linspace(1,1.05,res);
rise1_bridge = linspace(0.9,1.1,res);
[Qf,Rise1] = meshgrid(qf_bridge,rise1_bridge);
my_heights_bridge(B_bridge>=0)=nan;
surf(my_heights_bridge);
min_obj= min(my_heights_bridge(:));
disp(min_obj);
disp([Qf((my_heights_bridge==min_obj)'),Rise1((my_heights_bridge==min_obj)')]);

%%

% optimal parameters for bridge: 
% 41 0.9872 1.0321   1.32710
