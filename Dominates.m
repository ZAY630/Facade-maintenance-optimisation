%% Dominate
% The code is inside the Non-dominant sorting mechanism to produce Pareto
% front solution set.

function b = Dominates(x, y)

    if isstruct(x)
        x = x.Cost;
    end

    if isstruct(y)
        y = y.Cost;
    end

    b = all(x <= y) && any(x<y);

end