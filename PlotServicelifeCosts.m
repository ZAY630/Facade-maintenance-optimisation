%% Service life and cost plot
% This function is to plot the 1st obective service life, and the 2nd objective
% maintenance annual cost.

function PlotServicelifeCosts(pop)

    Costs = [pop.Cost];
    ashgrey = [0.6, 0.6, 0.6];
    plot(-Costs(1, :), Costs(2, :), '*', 'Color', ashgrey, 'MarkerSize', 3);
    xlabel('1^{st} Objective: Service life', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    ylabel('2^{nd} Objective: Cost', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    title('Non-dominated solutions', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 16);
    grid on;

end