%% Crossover
% The function is defined to mimic the process of gene crossover to produce
% offsprings by swapping certain gene sequence sections. alpha is defined
% as a constant controlling how much should be inherited.

function [y1, y2] = Crossover(x1, x2)

    alpha = rand(size(x1));
    
    y1 = alpha.*x1+(1-alpha).*x2;
    y2 = alpha.*x2+(1-alpha).*x1;
    
end