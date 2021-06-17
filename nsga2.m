%% Code description
% The code is produced based on an open source NGSA-II algorithm developed
% by Mostapha Kalami Heris, 2015. The information of the open source is
% shown below. Based on the theory of gene mutation and crossover, crowding
% distance and non-dominant sorting, the algorithm is modified to suit the
% purpose of facade manitenance optimisation. The main frame of the
% optimisation process is developed in this file from parameter initiation
% and results display and regression.

% Open source information:
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% Developer: Mostapha Kalami Heris (Member of Yarpiz Team)
% Reference: Mostapha Kalami Heris, NSGA-II in MATLAB (URL: https://yarpiz.com/56/ypea120-nsga2), Yarpiz, 2015.

%% Preparation
clc;
clear;
close all;

%% Problem Definition

% Multi-objective Function;
CostFunction = @(x) MOP5(x);
nVar = 5;             % Number of Decision Variables

VarSize = [1 nVar];   % Size of Decision Variables Matrix

VarMin1 = 5;          % Lower Bound of Variables (5Wood: 5; 6Concrete: 5; 7Cementitous: 5; 8NatiralStone: 5)
VarMax1 = 70;        % Upper Bound of Variables (5Wood: 70; 6Concrete: 100; 7Cementitous: 50; 8NatiralStone: 150)
VarMin2 = 10;         % Lower Bound of Variables (5Wood: 10; 6Concrete: 10; 7Cementitous: 5; 8NatiralStone: 30)
VarMax2 = 70;        % Upper Bound of Variables (5Wood: 70; 6Concrete: 100; 7Cementitous: 50; 8NatiralStone: 150)

% Number of Objective Functions
nObj = numel(CostFunction(unifrnd(VarMin1, VarMax1, [2 nVar])));

%% NSGA-II Parameters

MaxIt = 250;      % Maximum Number of Iterations

nPop = 100;       % Population Size

% Crossover Percentage
pCrossover = 0.25;
nCrossover = 2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

% Mutation Percentage
pMutation = 0.25;
nMutation = round(pMutation*nPop);        % Number of Mutants

% Mutation Rate (If nVar is large, reduce mutation rate to avoid error in Mutate.m)
mu = 0.02;

sigma = 0.1*(VarMax1-VarMin1);  % Mutation Step Size

%% Initialization

empty_individual.Position = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.CrowdingDistance = [];
empty_individual.Cost = [];
empty_individual.Resilience = [];
empty_individual.ServiceLife = [];
empty_individual.RepaintSchedule = [];
empty_individual.RepairSchedule = [];
empty_individual.RepaintNumber = [];
empty_individual.RepairNumber = [];
pop = repmat(empty_individual, nPop, 1);

for i = 1:nPop
    
    pop(i).Position(1,:) = unifrnd(VarMin1, VarMax1, VarSize);
    pop(i).Position(2,:) = unifrnd(VarMin2, VarMax2, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    
end

% Non-Dominated Sorting
[pop, F] = NonDominatedSorting(pop);

% Calculate Crowding Distance
pop = CalcCrowdingDistance(pop, F);

% Sort Population
[pop, F] = SortPopulation(pop);


%% NSGA-II Main Loop
Number = [];
for it = 1:MaxIt
    
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2
        
        % Select Parents
        i1 = randi([1 nPop]);
        p1 = pop(i1);
        
        i2 = randi([1 nPop]);
        p2 = pop(i2);
        
        % Crossover implmentation
        [y1, y2] = Crossover(p1.Position(1,:), p2.Position(1,:));
        [y3, y4] = Crossover(p1.Position(2,:), p2.Position(2,:));
        
        % Check offspring
        while sum(y1 < VarMin1 | y1>VarMax1 | y2 < VarMin1 | y2 > VarMax1)
            [y1, y2] = Crossover(p1.Position(1,:), p2.Position(1,:));
        end
        while sum(y3 < VarMin2 | y3>VarMax2 | y4 < VarMin2 | y4 > VarMax2)
            [y3, y4] = Crossover(p1.Position(2,:), p2.Position(2,:));
        end
        
        % Display crossover results
        popc(k, 1).Position(1,:) = y1;
        popc(k, 2).Position(1,:) = y2;
        popc(k, 1).Position(2,:) = y3;
        popc(k, 2).Position(2,:) = y4;
        popc(k, 1).Cost = CostFunction(popc(k, 1).Position);
        popc(k, 2).Cost = CostFunction(popc(k, 2).Position);
        
    end
    popc = popc(:);
    
    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation
        
        % Select individual
        i = randi([1 nPop]);
        p = pop(i);
        
        % Mutation implementation
        y5 = Mutate(p.Position(1,:), mu, sigma);
        y6 = Mutate(p.Position(2,:), mu, sigma);
        
        % Check mutants
        while sum(y5 < VarMin1 | y5 > VarMax1)
            y5 = Mutate(p.Position(1,:), mu, sigma);
        end
        popm(k).Position(1,:) = y5;
        
        while sum(y6 < VarMin2 | y6 > VarMax2)
            y6 = Mutate(p.Position(2,:), mu, sigma);
        end
        
        % Display results
        popm(k).Position(2,:) = y6;
        popm(k).Cost = CostFunction(popm(k).Position);
        
    end
    
    % Merge
    pop = [pop
         popc
         popm]; %#ok
     
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    pop = SortPopulation(pop);
    
    % Truncate
    pop = pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F] = NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop, F);

    % Sort Population
    [pop, F] = SortPopulation(pop);
    
    % Store F1
    F1 = pop(F{1});
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot 1st and 2nd objectives
    figure(1);
    PlotServicelifeCosts(F1);
    hold on;
    % pause(0.01);
    ax1 = gca;
    
    % Plot 1st and 3rd objectives
    figure(2);
    PlotServicelifeResilience(F1);
    hold on;
    % pause(0.01);
    ax2 = gca;
    
    % Plot 2nd and 3rd objectives
    figure(3);
    PlotCostResilience2(F1);
    hold on;
    ax3 = gca;
    
    % Plot 2nd and 3rd objectives for regression
    figure(4);
    PlotCostResilience(F1);
    hold on;
    % pause(0.01);
    ax4 = gca;
    ylim([0.45, 0.8]);
    % ylim([0.55, 0.9]);
    % ylim([0.35, 0.65]);
    % ylim([0.55, 0.9]);
    Append = RepaintNumberResilience(F1);
    Number = [Append; Number];
    
    figure(5);
    Plot3D(F1);
    hold on;
    ax5 = gca;
end


%% Results summary and display

schedule = zeros(MaxIt, 15);
for i = 1:nPop
    
    [f1, f2] = ReverseMOP5(pop(i).Position);
    schedule(i, 1:length(f1), 1) = f1;
    schedule(i, 1:length(f2), 2) = f2;
    pop(i).RepaintSchedule = nonzeros(unique(schedule(i, :, 1)));
    pop(i).RepaintNumber = length(pop(i).RepaintSchedule);
    pop(i).RepairSchedule = nonzeros(unique(schedule(i, :, 2)));
    pop(i).RepairNumber = length(pop(i).RepairSchedule);
    pop(i).Resilience = 1 - pop(i).Cost(3);
    pop(i).ServiceLife = - pop(i).Cost(1);
    pop(i).Cost = pop(i).Cost(2);
    
end

[q, index] = sort([pop.ServiceLife]);
pop = pop(index);
% writetable(struct2table(pop), 'WoodResult.csv');

%% Pareto front
% Retrive data input
g1 = get(ax1, 'Children');
g2 = get(ax2, 'Children');
g3 = get(ax3, 'Children');
g5 = get(ax5, 'Children');
xdata = get(g1, 'XData');
xdata = reshape(xdata, 1, MaxIt);
ydata = get(g1, 'YData');
ydata = reshape(ydata, 1, MaxIt);
y2data = get(g2, 'YData');
y2data = reshape(y2data, 1, MaxIt);
x2data = get(g2, 'XData');
x2data = reshape(x2data, 1, MaxIt);

a = cell2mat(xdata);
[a index] = sort(a);
b = cell2mat(ydata);
b1 = b(index);

% Pareto front between 1st objective and 2nd objective
count = 1;
start = 1;
for i = 2:length(a)
    if a(i) ~= a(i-1)
        c(count) = min(b1(start:i-1));
        start = i;
        count = count + 1;
    elseif i == length(a)
        c(count) = min(b1(start:i));
    else
        continue;
    end
end
a1 = unique(a);
for i = 2:length(a1)
    if c(i) < c(i - 1)
        a1(i - 1) = 0;
        c(i - 1) = 0;
    else
    end
end
a1 = nonzeros(a1);
c = [0 nonzeros(c)'];
p = plot(ax1, a1, c, 'r', 'LineWidth',0.8);
lgd = legend(p, {'Pareto Front'}, 'Location', 'southeast');
lgd.FontSize = 12;

% Pareto front between 1st objective and 3rd objective
l = cell2mat(x2data);
[l index] = sort(l);
m = cell2mat(y2data);
m = m(index);
c = [];
count = 1;
start = 1;
for i = 2:length(l)
    if l(i) ~= l(i-1)
        c(count) = max(m(start:i-1));
        start = i;
        count = count + 1;
    elseif i == length(a)
        c(count) = max(m(start:i));
    else
        continue;
    end
end
l1 = unique(l);
for i = 1:length(l1)
    if any(c(i) < c(i:end))
        l1(i) = 0;
        c(i) = 0;
    else
    end
end
p = plot(ax2, nonzeros(l1'), nonzeros(c), 'r', 'LineWidth',0.8);
lgd = legend(p, {'Pareto Front'}, 'Location', 'southeast');
lgd.FontSize = 12;

% Pareto front between 2nd objective and 3rd objective
b = get(g3, 'XData');
b = reshape(b, 1, MaxIt);
d = get(g3, 'YData');
d = reshape(d, 1, MaxIt);
b = cell2mat(b);
[b1 index] = sort(b);

d = cell2mat(d);
d1 = d(index);
c = [];
count = 1;
start = 1;
for i = 2:length(b1)
    if b1(i) ~= b1(i-1)
        c(count) = max(d1(start:i-1));
        start = i;
        count = count + 1;
    elseif i == length(b1)
        c(count) = max(d1(start:i));
    else
        continue;
    end
end
b1 = unique(b1);
for i = 2:length(b1)
    if any(c(i) < c(1:i-1))
        b1(i) = 0;
        c(i) = 0;
    else
    end
end
p = plot(ax3, [0, nonzeros(b1)'], nonzeros(c), 'r', 'LineWidth',0.8);
lgd = legend(p, {'Pareto Front'}, 'Location', 'southeast');
lgd.FontSize = 12;

% Maintenance combination regression using cubic expression
b2 = cell2mat(y2data);

[Number index] = sortrows(Number, [1, 2]);
x2data = Number(:, 1);
x3data = Number(:, 2);

b1 = b(index);
b2 = b2(index);

v = 1:36; 
cm = colormap(jet(numel(v)));
k = 1;
FigNum = [];
start = 1;
for i = 2:length(x2data)
    if x2data(i) == x2data(i-1) & x3data(i) ~= x3data(i-1)
        d = polyfit(b1(start:i-1), b2(start:i-1), 3);
        % d = polyfit(log(b1(start:i-1)), b2(start:i-1), 1);
        b1_interm = sort(unique(b1(start:i-1)));
        b3  = polyval(d, b1_interm);
        % b3 = polyval(d,log(b1_interm));
        FigNum(k) = plot(ax4, b1_interm, b3, 'Color',cm(k,:), 'LineWidth', 1.5);
        leg{k} = sprintf('%d Preventative + %d Corrective',x2data(i-1), x3data(i-1));
        start = i;
        hold on;
        k = k + 1;
    elseif x2data(i) ~= x2data(i-1)
        d = polyfit(b1(start:i-1), b2(start:i-1), 3);
        % d = polyfit(log(b1(start:i-1)), b2(start:i-1), 1);
        b1_interm = sort(unique(b1(start:i-1)));
        b3  = polyval(d, b1_interm);
        % b3 = polyval(d,log(b1_interm));
        FigNum(k) = plot(ax4, b1_interm, b3, 'Color',cm(k,:), 'LineWidth', 1.5);
        leg{k} = sprintf('%d Preventative + %d Corrective',x2data(i-1), x3data(i-1));
        start = i;
        hold on;
        k = k + 1;
    elseif i == length(x2data)
        d = polyfit(b1(start:i), b2(start:i), 3);
        % d = polyfit(log(b1(start:i)), b2(start:i), 1);
        b1_interm = sort(unique(b1(start:i)));
        b3 = polyval(d, b1_interm);
        % b3 = polyval(d, log(b1_interm));
        FigNum(k) = plot(ax4, b1_interm, b3, 'Color',cm(k,:), 'LineWidth', 1.5);
        leg{k} = sprintf('%d Preventative + %d Corrective',x2data(i), x3data(i));
    else
        continue;
    end
end

lgd = legend(FigNum, leg, 'Location', 'bestoutside');
lgd.FontSize = 8;

% 3D visualisation data extraction from 3D plot
q = get(g5, 'XData');
q = reshape(q, 1, MaxIt);
w = get(g5, 'YData');
w = reshape(w, 1, MaxIt);
e = get(g5, 'ZData');
e = reshape(e, 1, MaxIt);
q = cell2mat(q);
w = cell2mat(w);
e = cell2mat(e);
q = reshape(q,[],1);
w = reshape(w,[],1);
e = reshape(e,[],1);

% Surface regression using curve fitting plug-in function (App in MATLAB),
% the regression model used is 'poly23'.
sf = fit([q, w], e,'poly23');
figure;
plot(sf,[q, w],e);
xlim([min(q), max(q)]);
ylim([min(w), max(w)]);
zlim([min(e), max(e)]);
xlabel('1^{st} Objective: Service life', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
ylabel('2^{nd} Objective: Cost', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
zlabel('3^{rd} Objective: Efficiency', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14)
title('Non-dominated solutions', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 16);
grid on;