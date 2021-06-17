%% Wood cladding degradation function
% This function is to record the degradation function of wooden facade and
% used in the maintenance optimisation file. 

function S = WoodCladding(x)
    S = (1e-4)*power(x, 2) + (0.0024)*x;
end


