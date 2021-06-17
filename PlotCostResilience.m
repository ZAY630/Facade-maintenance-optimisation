%% Cost and maintenance efficiency plot
% This function is to plot the 2nd obective maintenance annual cost, and 
% the 3rd objective maintenance efficiency claculated as resiliece loss.

function PlotCostResilience(pop)
    ashgrey = [0.6, 0.6, 0.6];
    Costs = [pop.Cost];   
    plot(Costs(2, :), 1 - Costs(3, :), '.', 'Color', ashgrey, 'MarkerSize', 10);
    xlabel('2^{nd} Objective: Cost', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    ylabel('3^{rd} Objective: Efficiency', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    title('Non-dominated solutions', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 16);
    grid on;

end