%% This code contains the experiments in section 9 of the hand out

% 




% Author: Andy Cai CRSID ajc327
% Date : 20/05/2020

%%
h1 = [-1 2 6 2 -1]/8;
h2 =[-1 2 -1]/4;

U = rowdec(Xs,h1); 
V = rowdec2(X,h2); 
draw([U V]);
save_my_figs('part9uv');
U_energy  = sum(U(:).^2);
V_energy = sum(V(:).^2);

%%
UU = rowdec(U', h1)';
UV = rowdec2(U',h2)'; 
VU = rowdec(V',h1)'; 
VV= rowdec2(V',h2)'; 
k=2.1;
draw([UU, VU*k; UV*k VV*k]);
save_my_figs('part9uuvu');

%%
g1=[1 2 1]/2;
g2 = [-1 -2 6 -2 -1]/4;
Ur = rowint(UU',g1)'+rowint2(UV',g2)';
Vr = rowint(VU',g1)'+rowint2(VV',g2)'; 

Ur_error = std(Ur(:)-U(:));
Vr_error = std(Vr(:)-V(:));

%%
Y = dwt(X);
figure(1); 
draw(Y); 
Xr = idwt(Y); figure(2); 
draw(Xr);

%%
m=256; Y = dwt(X); draw(Y); 
m=m/2; 
t = 1:m; 
Y(t,t) = dwt(Y(t,t)); 
draw(Y);

Xr = idwt(Y); 
%draw(Xr); 

%%
dwt4= nleldwt(Xs,4); 
draw(dwt4);
Xr = nlelidwt(dwt4,4); 

draw(Xr); 
error_noquantise = std(Xs(:)-Xr(:));

%% 
dwtstep4 = optimal_step_dwt(dwt4,4,0,X);

quant4 = quantdwt(dwt4,4,dwtstep4); 
Xr4 = nlelidwt(quant4,4); 
draw(Xr4);
%% %% impulse response measurement for equal step size
dwt_n = [1 2 3 4 5 6]; 
dwt_steps_bridge = {};
Xs = X-128;
dwt_bits_bridge = zeros(1,6);
dwt_compressions_bridge = zeros(1,6); 
dwt_errors_bridge = zeros(1,6);
Xq = quantise(Xs,17);
original_bits = size(Xq,1)*size(Xq,2)*bpp(Xq);
for i=1:length(dwt_n)
    n = dwt_n(i);
    dwti = nleldwt(Xs,n); 
    dwtstepi= optimal_step_dwt(dwti,n,0,X); 
    dwt_steps_bridge{i} = dwtstepi;
    
    [Yqi, mybitsi] = quantdwt(dwti,n,dwtstepi); 
    dwt_bits_bridge(i) = mybitsi;
    Xri = nlelidwt(Yqi,n);
    errori = std(Xri(:) - Xs(:)); 
    dwt_compressions_bridge(i) = original_bits/mybitsi;
    dwt_errors_bridge(i) = errori; 
    draw(Xri); 
    my_string= strcat('part9_optimal_equal_bridge_n',int2str(n));
    save_my_figs(my_string);
end 
    

%% 
dwt_n = [1 2 3 4 5 6]; 
dwt_steps_mse_bridge = {};
dwt_bits_mse_bridge = zeros(1,6);
dwt_compressions_mse_bridge = zeros(1,6); 
dwt_errors_mse_bridge = zeros(1,6);
Xs = X-128; 
Xq = quantise(Xs,17);
original_bits = size(Xq,1)*size(Xq,2)*bpp(Xq);
for i=1:length(dwt_n)
    n = dwt_n(i);
    dwti = nleldwt(Xs,n); 
    dwtstepi= optimal_step_dwt(dwti,n,1,X); 
    dwt_steps_mse_bridge{i} = dwtstepi;
    
    [Yqi, mybitsi] = quantdwt(dwti,n,dwtstepi); 
    dwt_bits_mse_bridge(i) = mybitsi;
    Xri = nlelidwt(Yqi,n);
    errori = std(Xri(:) - Xs(:)); 
    dwt_compressions_mse_bridge(i) = original_bits/mybitsi;
    dwt_errors_mse_bridge(i) = errori; 
    draw(Xri); 
    my_string= strcat('part9_optimal_mse_bridge_n',int2str(n));
    save_my_figs(my_string);
end 

%% %% impulse response measurement for equal step size
load lighthouse;
dwt_n = [1 2 3 4 5 6]; 
dwt_steps = {};
Xs = X-128;
dwt_bits = zeros(1,6);
dwt_compressions = zeros(1,6); 
dwt_errors = zeros(1,6);
Xq = quantise(Xs,17);
original_bits = size(Xq,1)*size(Xq,2)*bpp(Xq);
for i=1:length(dwt_n)
    n = dwt_n(i);
    dwti = nleldwt(Xs,n); 
    dwtstepi= optimal_step_dwt(dwti,n,0,X); 
    dwt_steps{i} = dwtstepi;
    
    [Yqi, mybitsi] = quantdwt(dwti,n,dwtstepi); 
    dwt_bits(i) = mybitsi;
    Xri = nlelidwt(Yqi,n);
    errori = std(Xri(:) - Xs(:)); 
    dwt_compressions(i) = original_bits/mybitsi;
    dwt_errors(i) = errori; 
    draw(Xri); 
    my_string= strcat('part9_optimal_equal_n',int2str(n));
    save_my_figs(my_string);
end 
    

%% 
dwt_n = [1 2 3 4 5 6]; 
dwt_steps_mse = {};
dwt_bits_mse = zeros(1,6);
dwt_compressions_mse = zeros(1,6); 
dwt_errors_mse = zeros(1,6);
Xs = X-128; 
Xq = quantise(Xs,17);
original_bits = size(Xq,1)*size(Xq,2)*bpp(Xq);
for i=1:length(dwt_n)
    n = dwt_n(i);
    dwti = nleldwt(Xs,n); 
    dwtstepi= optimal_step_dwt(dwti,n,1,X); 
    dwt_steps_mse{i} = dwtstepi;
    
    [Yqi, mybitsi] = quantdwt(dwti,n,dwtstepi); 
    dwt_bits_mse(i) = mybitsi;
    Xri = nlelidwt(Yqi,n);
    errori = std(Xri(:) - Xs(:)); 
    dwt_compressions_mse(i) = original_bits/mybitsi;
    dwt_errors_mse(i) = errori; 
    draw(Xri); 
    my_string= strcat('part9_optimal_mse_n',int2str(n));
    save_my_figs(my_string);
end 
    

