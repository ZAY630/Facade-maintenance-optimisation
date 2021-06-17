%% Reliability assessment
% This function calculates reliability index based on load model,
% resistance model and decay model. This function is used in Reliability
% files.

% Input: Load model (dead load DL, live load LL)
% Input: Resistance model (grading strength RE)
% Input: simulated year x
% Output: Reliability index at year x

function R = Relisis_2(DL, LL, RE, x)
    
    % Dimension of the glulam beam
    L = 5835;
    h = 360;
    b = 266;
    
    % decay parameter (k1: climate factor, k2: wood species factor)
    k1 = 0.165;
    k2 = 2.5;
    
    % Load combination based on Eurocode 1990
    Reduction = 0.3;
    MeanForce = DL * 1.35 * L/2 + LL * 1.5 * Reduction * L/2;
    MeanLoad = (1/8) * MeanForce * L^2;
    StdDead = 5 * 10^-4 * 1.35 * L/2;
    StdLive = 5 * 10^-4 * 1.5 * L/2 * Reduction;
    StdForce = sqrt(StdDead^2 + StdLive^2);
    StdLoad = (1/8) * StdForce * L^2;
    
    % initiate decay on cross section
    r = 0.4;
    h = h - x * r;
    b = b - x * r;
    kmod = 0.8;
    
    % Resistance calculation based on Eurocode 1995
    MeanResistance = (1/6) * b * h^2 * RE * kmod;
    StdResistance = 5 * 10^-4 * (1/6) * b * h^2 * kmod;
    
    % Reliability index derivation
    R = (MeanResistance - MeanLoad)/sqrt(StdLoad^2 + StdResistance^2);
    
    if R > 4.75
        R = 4.75;
    end
    
end