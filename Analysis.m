%% Three maintenance scenarios selected for all material choices
Wood(1:2, :) = [18, 26, 34, 44, 44; 14, 14, 14, 14, 14];
Wood(3:4, :) = [5, 29, 38, 38, 38; 13, 19, 26, 26, 26];
Wood(5:6, :) = [21, 31, 39, 39, 39; 13, 18, 30, 30, 30];
Stone(1:2, :) = [43, 67, 80, 80, 80; 57, 64, 64, 64, 64];
Stone(3:4, :) = [13, 26, 26, 26, 26; 34, 41, 53, 61, 67];
Stone(5:6, :) = [51, 62, 86, 86, 86; 38, 48, 59, 76, 76];
Concrete(1:2, :) = [27, 35, 45, 53, 53; 0, 0, 0, 0, 0];
Concrete(3:4, :) = [40, 48, 48, 48, 48; 12, 20, 27, 32, 38];
Concrete(5:6, :) = [30, 40, 47, 47, 47; 16, 28, 39, 39, 39];
Cementitious(1:2, :) = [14, 23, 30, 30, 30;	22, 22, 22, 22, 22];
Cementitious(3:4, :) = [6, 15, 22, 22, 22; 5, 14, 14, 14, 14];
Cementitious(5:6, :) = [7, 22, 29, 29, 29; 5, 15, 21, 21, 21];
Cementitious(7:8, :) = [7, 17, 17, 17, 17; 5, 16, 16, 16, 16];

%% Plot three maintenace scenarios
% Reference time-based replacement maintenance scheme
figure;
x = 1:100;
y_reference = WoodCladding(x);
y_reference = y_reference(1: find(y_reference >= 0.2, 1));
plot(y_reference);

% Scenario plotting
for i = 1:3
    hold on;
    ReverseMOP5(Wood((2*i-1):(2*i), :))
    legend('Without maintenance', 'Scenario 1', 'Scenario 2', 'Scenario 3', 'Location', 'northwest', 'Fontsize', 11);
    ylim([0, 0.2]);
end

% Reference time-based replacement maintenance scheme
figure;
x = 1:100;
y_reference = NaturalStoneCladding(x);
y_reference = y_reference(1: find(y_reference >= 0.2, 1));
plot(y_reference);

% Scenario plotting
for i = 1:3
    hold on;
    ReverseMOP8(Stone((2*i-1):(2*i), :))
    legend('Without maintenance', 'Scenario 1', 'Scenario 2', 'Scenario 3', 'Location', 'northwest', 'Fontsize', 11);
    ylim([0, 0.2]);
end

% Reference time-based replacement maintenance scheme
figure;
x = 1:100;
y_reference = ConcreteCladding(x);
y_reference = y_reference(1: find(y_reference >= 0.2, 1));
plot(y_reference);

% Scenario plotting
for i = 1:3
    hold on;
    ReverseMOP6(Concrete((2*i-1):(2*i), :))
    legend('Without maintenance', 'Scenario 1', 'Scenario 2', 'Scenario 3', 'Location', 'northwest', 'Fontsize', 11);
    ylim([0, 0.2]);
end

% Reference time-based replacement maintenance scheme
figure;
x = 1:100;
y_reference = CementitiousCladding(x);
y_reference = y_reference(1: find(y_reference >= 0.2, 1));
plot(y_reference);

% Scenario plotting
for i = 1:3
    hold on;
    ReverseMOP7(Cementitious((2*i-1):(2*i), :))
    legend('Without maintenance', 'Scenario 1', 'Scenario 2', 'Scenario 3', 'Location', 'northwest', 'Fontsize', 11);
    ylim([0.01, 0.2]);
end

%% Reliability calculation
% The file path read by the csvread function needs to be re-defined for
% other users
t5 = csvread('D:\\Optimisation\\WoodResult.csv',1,0);
R5 = zeros(1, 100);
for i = 1:100
    R5(i) = Reliability5([t5(i, 1:5); t5(i, 6: 10)]);
    E5(i) = t5(i, 16);
    % 86
end

t6 = csvread('D:\\Optimisation\\ConcreteResult.csv',1,0);
R6 = zeros(1, 100);
for i = 1:100
    R6(i) = Reliability6([t6(i, 1:5); t6(i, 6: 10)]);
    E6(i) = t6(i, 16);
    % 82
end

t7 = csvread('D:\\Optimisation\\CementitiousResult.csv',1,0);
R7 = zeros(1, 100);
for i = 1:100
    R7(i) = Reliability7([t7(i, 1:5); t7(i, 6: 10)]);
    E7(i) = t7(i, 16);
    % 85
end

t8 = csvread('D:\\Optimisation\\StoneResult.csv',1,0);
R8 = zeros(1, 100);
for i = 1:100
    R8(i) = Reliability8([t8(i, 1:5); t8(i, 6: 10)]);
    E8(i) = t8(i, 16);
    % 81
end

% Plot reliability indices and maintenace efficiency
figure;
plot(E5, R5, 'k.', 'MarkerSize', 14);
hold on;
plot(E6, R6, 'b.', 'MarkerSize', 14);
plot(E7, R7, 'g.', 'MarkerSize', 14);
plot(E8, R8, 'r.', 'MarkerSize', 14);
grid on;
xlabel('Efficiency', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 12);
ylabel('Reliability index', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 12);
title('Reliability indices vs Efficiency indices', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
legend({'Wood', 'Concrete', 'Cementitious', 'Stone'}, 'Location', 'northwest', 'fontname', 'times', 'Fontsize', 12);

%% Maintenace total cost calculation (150 years)
r = 0.03;

% Maintenance intervention cost ratio
f1 = 1.5;
f2 = 4;
% f2 = 4.2   % 5% inflation
% f2 = 4.4   % 10% inflation

% Maintenance schedules for different scenarios
WoodPM_Year = [20, 30, 38, 73, 83, 91, 126, 136];
WoodEM_Year = [13, 18, 30, 66, 71, 83, 119, 124, 136];
Wood2PM_Year = [17, 25, 33, 43, 66, 74, 82, 92, 115, 123, 131, 141];
Wood2EM_Year = [14, 63, 112];
Wood3PM_Year = [4, 28, 37, 56, 80, 89, 108, 132, 148];
Wood3EM_Year = [13, 19, 26, 65, 71, 78, 117, 123, 130];
WoodReplacement = [54, 107];
Wood2Replacement = [50, 99];
Wood3Replacement = [53, 105];
WoodReplacement_reference = [35, 69, 103, 137];
WoodC = 0;
WoodC2 = 0;
WoodC3 = 0;
WoodC_reference = 0;

% Total cost accumulation
for i = 1:length(WoodPM_Year)
    WoodC = WoodC + (8.75/(1 + r)^WoodPM_Year(i));  
end

for i = 1:length(Wood2PM_Year)
    WoodC2 = WoodC2 + (8.75/(1 + r)^Wood2PM_Year(i));
end

for i = 1:length(Wood3PM_Year)
    WoodC3 = WoodC3 + (8.75/(1 + r)^Wood3PM_Year(i));
end

for i = 1:length(WoodEM_Year)
    WoodC = WoodC + (8.75*f1/(1 + r)^WoodEM_Year(i));        
end

for i = 1:length(Wood2EM_Year)
    WoodC2 = WoodC2 + (8.75*f1/(1 + r)^Wood2EM_Year(i));        
end

for i = 1:length(Wood3EM_Year)
    WoodC3 = WoodC3 + (8.75*f1/(1 + r)^Wood3EM_Year(i));        
end

for i = 1:length(WoodReplacement)
    WoodC = WoodC + (8.75*f2/(1 + r)^WoodReplacement(i));  
end

for i = 1:length(Wood2Replacement)
    WoodC2 = WoodC2 + (8.75*f2/(1 + r)^Wood2Replacement(i));  
end

for i = 1:length(Wood3Replacement)
    WoodC3 = WoodC3 + (8.75*f2/(1 + r)^Wood3Replacement(i));  
end

for i = 1:length(WoodReplacement_reference)
    WoodC_reference = WoodC_reference + (8.75*f2/(1 + r)^WoodReplacement_reference(i));
end

% Maintenance schedules for different scenarios
ConcretePM_Year = [29, 39, 46, 88, 98, 105];
Concrete2PM_Year = [26, 34, 44, 52, 52, 81, 89, 99, 107, 136];
Concrete3PM_Year = [39, 47, 97, 105];
ConcreteEM_Year = [16, 28, 39, 75, 87, 98, 134];
Concrete2EM_Year = [];
Concrete3EM_Year = [12, 20, 27, 32, 38, 70, 78, 85, 90, 96, 128, 136, 143];
ConcreteReplacement = [60, 119];
Concrete2Replacement = [56, 111];
Concrete3Replacement = [59, 117];
ConcreteReplacement_reference = [44, 87, 130];
ConcreteC = 0;
ConcreteC2 = 0;
ConcreteC3 = 0;
ConcreteC_reference = 0;

% Total cost accumulation
for i = 1:length(ConcretePM_Year)
    ConcreteC = ConcreteC + (12.75/(1 + r)^ConcretePM_Year(i));  
end

for i = 1:length(Concrete2PM_Year)
    ConcreteC2 = ConcreteC2 + (12.75/(1 + r)^Concrete2PM_Year(i));  
end

for i = 1:length(Concrete3PM_Year)
    ConcreteC3 = ConcreteC3 + (12.75/(1 + r)^Concrete3PM_Year(i));  
end

for i = 1:length(ConcreteEM_Year)
    ConcreteC = ConcreteC + (12.75*f1/(1 + r)^ConcreteEM_Year(i));        
end

for i = 1:length(Concrete2EM_Year)
    ConcreteC2 = ConcreteC2 + (12.75*f1/(1 + r)^Concrete2EM_Year(i));        
end

for i = 1:length(Concrete3EM_Year)
    ConcreteC3 = ConcreteC3 + (12.75*f1/(1 + r)^Concrete3EM_Year(i));        
end

for i = 1:length(ConcreteReplacement)
    ConcreteC = ConcreteC + (12.75*f2/(1 + r)^ConcreteReplacement(i));  
end

for i = 1:length(Concrete2Replacement)
    ConcreteC2 = ConcreteC2 + (12.75*f2/(1 + r)^Concrete2Replacement(i));  
end

for i = 1:length(Concrete3Replacement)
    ConcreteC3 = ConcreteC3 + (12.75*f2/(1 + r)^Concrete3Replacement(i));  
end

for i = 1:length(ConcreteReplacement_reference)
    ConcreteC_reference = ConcreteC_reference + (12.75*f2/(1 + r)^ConcreteReplacement_reference(i));
end

% Maintenance schedules for different scenarios
CementitiousPM_Year = [6, 21, 28, 44, 59, 66, 82, 97, 104, 120, 135, 142];
Cementitious2PM_Year = [13, 22, 29, 45, 54, 61, 77, 86, 93, 109, 118, 125, 141];
Cementitious3PM_Year = [5, 14, 21, 40, 49, 56, 75, 84, 91, 110, 119, 126, 145];
CementitiousEM_Year = [5, 15, 21, 43, 53, 59, 81, 91, 97, 119, 129, 135];
Cementitious2EM_Year = [22, 54, 86, 118];
Cementitious3EM_Year = [5, 14, 40, 49, 75, 84, 110, 119, 145];
CementitiousReplacement = [39, 77, 115];
Cementitious2Replacement = [33, 65, 97, 129];
Cementitious3Replacement = [36, 71, 106];
CementitiousReplacement_reference = [21, 41, 81, 101, 121, 141];
CementitiousC = 0;
CementitiousC2 = 0;
CementitiousC3 = 0;
CementitiousC_reference = 0;

% Total cost accumulation
for i = 1:length(CementitiousPM_Year)
    CementitiousC = CementitiousC + (5.39/(1 + r)^CementitiousPM_Year(i));  
end

for i = 1:length(Cementitious2PM_Year)
    CementitiousC2 = CementitiousC2 + (5.39/(1 + r)^Cementitious2PM_Year(i));  
end

for i = 1:length(Cementitious3PM_Year)
    CementitiousC3 = CementitiousC3 + (5.39/(1 + r)^Cementitious3PM_Year(i));  
end

for i = 1:length(CementitiousEM_Year)
    CementitiousC = CementitiousC + (5.39*f1/(1 + r)^CementitiousEM_Year(i));        
end

for i = 1:length(Cementitious2EM_Year)
    CementitiousC2 = CementitiousC2 + (5.39*f1/(1 + r)^Cementitious2EM_Year(i));        
end

for i = 1:length(Cementitious3EM_Year)
    CementitiousC3 = CementitiousC3 + (5.39*f1/(1 + r)^Cementitious3EM_Year(i));        
end

for i = 1:length(CementitiousReplacement)
    CementitiousC = CementitiousC + (5.39*f2/(1 + r)^CementitiousReplacement(i));  
end

for i = 1:length(Cementitious2Replacement)
    CementitiousC2 = CementitiousC2 + (5.39*f2/(1 + r)^Cementitious2Replacement(i));  
end

for i = 1:length(Cementitious3Replacement)
    CementitiousC3 = CementitiousC3 + (5.39*f2/(1 + r)^Cementitious3Replacement(i));  
end

for i = 1:length(CementitiousReplacement_reference)
    CementitiousC_reference = CementitiousC_reference + (5.39*f2/(1 + r)^CementitiousReplacement_reference(i));
end

% Maintenance schedules for different scenarios
StonePM_Year = [50, 61, 85, 141];
Stone2PM_Year = [42, 66, 79, 127];
Stone3PM_Year = [12, 25, 101, 114]
StoneEM_Year = [38, 48, 59, 76, 129, 139];
Stone2EM_Year = [57, 64, 142];
Stone3EM_Year = [34, 41, 53, 61, 67, 123, 130, 142];
StoneReplacement = [92];
Stone2Replacement = [86];
Stone3Replacement = [90];
StoneReplacement_reference = [69, 137];
StoneC = 0;
StoneC2 = 0;
StoneC3 = 0;
StoneC_reference = 0;

% Total cost accumulation
for i = 1:length(StonePM_Year)
    StoneC = StoneC + (15.75/(1 + r)^StonePM_Year(i));  
end

for i = 1:length(Stone2PM_Year)
    StoneC2 = StoneC2 + (15.75/(1 + r)^Stone2PM_Year(i));  
end

for i = 1:length(Stone3PM_Year)
    StoneC3 = StoneC3 + (15.75/(1 + r)^Stone3PM_Year(i));  
end

for i = 1:length(StoneEM_Year)
    StoneC = StoneC + (15.75*f1/(1 + r)^StoneEM_Year(i));        
end

for i = 1:length(Stone2EM_Year)
    StoneC2 = StoneC2 + (15.75*f1/(1 + r)^Stone2EM_Year(i));        
end

for i = 1:length(Stone3EM_Year)
    StoneC3 = StoneC3 + (15.75*f1/(1 + r)^Stone3EM_Year(i));        
end

for i = 1:length(StoneReplacement)
    StoneC = StoneC + (15.75*f2/(1 + r)^StoneReplacement(i));  
end

for i = 1:length(Stone2Replacement)
    StoneC2 = StoneC2 + (15.75*f2/(1 + r)^Stone2Replacement(i));  
end

for i = 1:length(Stone3Replacement)
    StoneC3 = StoneC3 + (15.75*f2/(1 + r)^Stone3Replacement(i));  
end

for i = 1:length(StoneReplacement_reference)
    StoneC_reference = StoneC_reference + (15.75*f2/(1 + r)^StoneReplacement_reference(i));
end

% Cost summary for different scenarios 1: lowest cost; 2: Highest
% efficiency; 3: Optimal solution 4: Reference time-based replacement
Costsummary(1, 1:4) = [WoodC, StoneC, ConcreteC, CementitiousC];
Costsummary(2, 1:4) = [WoodC2, StoneC2, ConcreteC2, CementitiousC2];
Costsummary(3, 1:4) = [WoodC_reference, StoneC_reference, ConcreteC_reference, CementitiousC_reference];
Costsummary(4, 1:4) = [WoodC3, StoneC3, ConcreteC3, CementitiousC3];
