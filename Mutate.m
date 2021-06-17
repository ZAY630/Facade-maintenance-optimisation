%% Mutate
% This code is to mimic the bionic gene mutation process to encourage
% diversity of the populaton. Parameter mu and sigma together control how
% many mutants should be placed in the population and how much mutation
% should be implemented. Similar to crossover, The two functions are
% deisgned to avoid solutioln congregate at local minimum. 

function y = Mutate(x, mu, sigma)

    nVar = numel(x);
    
    nMu = ceil(mu*nVar);

    j = randsample(nVar, nMu);
    if numel(sigma)>1
        sigma = sigma(j);
    end
    
    y = x;
    
    y(j) = x(j)+sigma.*randn(size(j));

end