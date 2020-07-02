function dwt_step = dwtstep_mse(N)

%This function returns the ratio of steps based on the energies of impulse
%responses of the DWT pyramid. 
%N is the number of layers
%h is the filter 

for i = 1:N
    E = impulse_dwt(i)
    dwt_step(1:3,i) = E(2:4)
end
dwt_step(1,N+1) = E(1)
dwt_step = 1./sqrt(dwt_step)*200

