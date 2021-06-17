%% Service life and maintenance efficiency plot
% This function is to plot the 1st obective service life, and the 3rd objective
% maintenance effiency calculated as resilience loss.

function PlotServicelifeResilience(pop)

    Costs = [pop.Cost];
    ashgrey = [0.6, 0.6, 0.6];
    plot(-Costs(1, :), 1 - Costs(3, :), '*', 'Color', ashgrey, 'MarkerSize', 3);
    xlabel('1^{st} Objective: Service life', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    ylabel('3^{rd} Objective: Efficiency', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    title('Non-dominated solutions', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 16);
    grid on;

end