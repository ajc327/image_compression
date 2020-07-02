function [qstep rise1 qf] = optimise_parameters(X)
%% optimise_parameters finds the best parameters for given image X 



%Author: Andy Cai CRSID ajc327
% Date : 30/05/2020
% gen_quantisation_matrix



options = optimoptions('fmincon','DiffMinChange',0.1,'MaxIterations',10,'PlotFcn',['optimplotfval']);

fun = @(x)lbt_obj(x,X);
lb = [2,1,1];
ub = [7,1,1];
A = [];
b = [];
Aeq = [];
beq = [];
x0 = [3.4,1,1];
nonlcon =  @(x)lbt_con(x,X);

[x,fval,exitflag,output] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);


qstep = x(1);


options = optimoptions('fmincon','DiffMinChange',0.01,'OptimalityTolerance',0.01,'MaxIterations',10,'PlotFcn',['optimplotfval']);

fun = @(x)lbt_obj(x,X);
lb = [qstep,0.6,1];
ub = [qstep,1.1,1.07];
A = [];
b = [];
Aeq = [];
beq = [];
x0 = (lb + ub)/2;
nonlcon =  @(x)lbt_con(x,X);

[x,fval,exitflag,output] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options);
%[4.1,0.93,1]
%[4.1,1.1,1.07]
qstep = round(x(1)*10);
rise1= x(2);
qf = x(3);
return;
end 