function dwtstep = optimal_step_dwt(my_dwt,n,mse_option,X)
%% This function finds the step size of the dwt to quantise 
% Input:  my_dwt is a dwt, n is the level number
          
% Author: Andy Cai CRSID ajc327
% Date : 20/05/2020

dwtstep=zeros(3,n+1);
Xs =  X-128;
Xq = quantise(Xs,17);
original_error = std(Xs(:) - Xq(:));
%%
    if (mse_option==0)
        x = linspace(5,35,31);
        errors =[];
        %then the equal step size is used
        for i = 5:35
            Yq = quantise(my_dwt,i); 
            Zq = nlelidwt(Yq,n); 
            error = std(Xs(:) - Zq(:));
            errors = [errors, error];
          
        end 
        p1 = polyfit(errors, x,4);
        dwtstep = dwtstep + polyval(p1,original_error); 
        return;
    end 
    
    if (mse_option==1)
        
        test_energies= zeros(3,n+1);
        for k=1:3
            for p = 1:n
                impulse_location =[k p];
                test_dwt = gen_test_dwt(X,n,impulse_location);
                test_dwt_energy =sum(test_dwt(:).^2);
                
                Zq_test = nlelidwt(test_dwt,n);
                test_energies(k,p) = sum(Zq_test(:).^2);
            end
        end
        
        test_dwt = gen_test_dwt(X,n,[1 n+1]); 
        Zq_test = nlelidwt(test_dwt,n); 
        test_energies(1, n+1) = sum(Zq_test(:).^2);
        
        
        test_energies = 100.*test_energies.^(-0.5);
        test_energies(1, :) = test_energies(1,:)./test_energies(1,1); 
        test_energies(2, :) = test_energies(2,:)./test_energies(2,1); 
        test_energies(3, :) = test_energies(3,:)./test_energies(3,1);
        
        x = linspace(5,35,31);
        errors =[];
        for i = 5:35
            dwt_steps = round(i.*test_energies); 
            
            [Yq, mybits] = quantdwt(my_dwt,n,dwt_steps); 
            
            Zq = nlelidwt(Yq,n); 
            
            error = std(Xs(:) - Zq(:));
            errors = [errors, error];
          
        end 
        p1 = polyfit(errors, x,4);
        dwtstep = round(polyval(p1,original_error)*test_energies);
        return;
    end 
    
    return
end     