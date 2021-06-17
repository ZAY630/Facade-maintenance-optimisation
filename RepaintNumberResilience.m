%% Regression file
% The function is defined to extract the number of preventative and
% corrective maintenance interventions numbers for scatter agglomeration
% regression using cubic form.

function Number = RepaintNumberResilience(pop)

    Number = zeros(length(pop), 1);
    for i = 1:length(pop)
    
        [f1, f2] = ReverseMOP5(pop(i).Position);  
        Number(i, 1) = length(nonzeros(unique(f1)));
        Number(i, 2) = length(nonzeros(unique(f2)));

    end

end