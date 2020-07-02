%% This file contains lbt optimisation surface plats


% Author: Andy Cai CRSID ajc327
% Date : 31/05/2020

%jpeg scheme with quantisation table
%set parameters

%%
load lighthouse
D =3.3; 
res=60;
qf = linspace(1,1.05,res);
rise1 = linspace(0.85,1.1,res);
my_heights= zeros(res);
B = zeros(res);
for i=1:length(qf)
    for k = 1:length(rise1)
        x = [D, rise1(k), qf(i)];
        my_heights(i,k) = lbt_obj(x,X);
        B(i,k) = lbt_con(x,X);
        disp([i,k]);
    end 
end 

%%
my_heights(B>=0)=nan;
surf(qf,rise1,my_heights);

%%
%stepsize 34
D =3.4; 
res=80;
qf = linspace(1,1.05,res);
rise1 = linspace(0.8,1.2,res);
my_heights= zeros(res);
B = zeros(res);
for i=1:length(qf)
    for k = 1:length(rise1)
        x = [D, rise1(k), qf(i)];
        my_heights(i,k) = lbt_obj(x);
        B(i,k) = lbt_con(x);
        disp([i,k]);
    end 
end 


%%

qf = linspace(1,1.05,res);
rise1 = linspace(0.8,1.2,res);
[Qf,Rise1] = meshgrid(qf,rise1);
my_heights(B>=0)=nan;
surf(my_heights);
min_obj= min(my_heights(:));
disp(min_obj);
disp([Qf((my_heights==min_obj)'),Rise1((my_heights==min_obj)')]);

%%

% optimal parameters for lighthouse: 
% 33 0.992 1.034   1.1770
