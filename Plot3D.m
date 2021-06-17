%% 3D Plot
% This function is to plot the scatter points on 3 dimensions. Since there
% are three objectives defined in the algorithm, the output should
% correspondingly be 3D.

function PlotCostResilience(pop)
    ashgrey = [0.6, 0.6, 0.6];
    Costs = [pop.Cost];   
    plot3(-Costs(1,:), Costs(2, :), 1 - Costs(3, :), '.', 'Color', ashgrey, 'MarkerSize', 10);
    xlabel('1^{st} Objective: Service life', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    ylabel('2^{nd} Objective: Cost', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
    zlabel('3^{rd} Objective: Efficiency', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14)
    title('Non-dominated solutions', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 16);
    grid on;

end