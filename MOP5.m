%% Wood cladding and maintenance intervnetion
% This file is to apply maintenance effect on wood cladding degradation
% function.

% Input x: Maintenance intervention schedules (first row: preventative maintenance; second row: corrective maintenance)
% Output n: Service life after applying maintenance
% Output C: Annual cost of applying maintenance intervnetions
% Output Resilienceloss: Maintenance efficiency

function f = MOP5(x)

    PM = round(x(1, :));
    EM = round(x(2, :));
    
    % Maintenance intervention rules
    paint_delay = 4;
    a3 = 0.035;
    
    % Maintenance intervals for preventative and corrective maintenance
    a1 = 3;
    a2 = 5;
    
    correct = 0;
    threshold_1 = 0.01;
    
    % End of service service life threshold (20% degradation severity)
    threshold_2 = 0.2;
    
    % Schedule preparation (e.g. solving schedule conflict)
    PM_Year = zeros(1, 20);
    EM_Year = zeros(1, 20);
    for i = 1:length(PM)
        PM_Year(i) = PM(i);
        EM_Year(i) = EM(i);
    end
    PM_Year = nonzeros(sort(PM_Year));
    EM_Year = nonzeros(sort(EM_Year));
   
    for i = 2:length(PM_Year)
        if PM_Year(i) < PM_Year(i-1) + paint_delay + a1
            PM_Year(i) = PM_Year(i-1);
        else
            continue
        end
        
    end
    PM_Year = nonzeros(unique(sort(PM_Year)));
    
    for i = 2:length(EM_Year)
        if EM_Year(i) < EM_Year(i-1) + a2
            EM_Year(i) = EM_Year(i-1);
        else
            continue
        end
        
    end
    EM_Year = nonzeros(unique(sort(EM_Year)));
    
    for i = 1:length(EM_Year)
        for j = 1:length(PM_Year)
            if EM_Year(i) >= PM_Year(j) & EM_Year(i) <= PM_Year(j) + paint_delay + a1
                EM_Year(i) = 0;
            else
                continue
            end
        end
        
    end
    
    EM_Year = nonzeros(sort(EM_Year));
    y = zeros(1, 200);
    i = 1;
    x = 1:200;
    repair = 0;
   
    % Main loop: Applying maintenance intervention on degradation
    while i < 200
        % Identify 1) No maintenance; 2) Preventative maintenance 3)
        % Corrective maintenance
        if ismember(i, PM_Year)
            coating = find(i == PM_Year, 1);
        else
            coating = 0;
        end
        
        if ismember(i, EM_Year)
            repair = find(i == EM_Year, 1);
        else

        end
        
        % Apply corrective method
        if coating == 0
            
            switch repair
                case 0
                    y(i) = WoodCladding(x(i));
                case 0.5
                    y(i) = WoodCladding(x(i)) - correct;
                otherwise
                    y(i) = WoodCladding(x(i));
            end
            
            
            if y(i) >= threshold_2 & (repair == 0.5 | repair == 0)
                break
            elseif repair ~= 0 & repair ~= 0.5
                correct = correct + a3;
                if correct > y(i)
                    correct = y(i);
                else
                    
                end
                y(i) = y(i) - correct;
                repair = 0.5;
                i = i + 1;

            else
                i = i + 1;
            end
            
        % Apply preventative method
        elseif coating ~= 0 & y(i - 1) >= threshold_1
            y(i:i + paint_delay - 2) = y(i - 1);
            x_inter = x(i);
            i = i + paint_delay - 1;
            x(i:end) = x_inter:x_inter - 1 + length(x(i:end));
           
        elseif coating ~= 0 & y(i - 1) < threshold_1
            PM_Year(coating) = 0;
            
        end
    
    end
    
    % Service life and degradation change after applying maintenance
    n = length(nonzeros(y));
    y = y(1:n);
    y(y<0) = 0;
    PM_Year = nonzeros(sort(PM_Year));
    EM_Year = nonzeros(sort(EM_Year));
    % figure;
    % plot(y)
    
    % Maintenance efficiency indicated as resilience loss
    resilienceloss = trapz(y)/(n*threshold_2);
    
    % Annual cost estimation
    r = 0.03;
    C = 0;
    Cost_PM_Year = zeros(1, 20);
    Cost_EM_Year = zeros(1, 20);
    
    for i = 1:length(PM_Year)
        if PM_Year(i) > n
            continue;
        else
            Cost_PM_Year(i) = PM_Year(i) - 1;
            C = C + (8.75/(1 + r)^PM_Year(i))*(r*(1 + r)^n/((1+r)^n - 1));
        end
        
    end
    
    for i = 1:length(EM_Year)
        if EM_Year(i) > n
            continue;
        else
            Cost_EM_Year(i) = EM_Year(i);
            C = C + (8.75*1.5/(1 + r)^EM_Year(i))*(r*(1 + r)^n/((1+r)^n - 1));
        end
        
    end
    
    % Output summary: since the optimisation algorithm is designed to
    % minimise target objective, service life extension is thus indicated
    % as negative value. 
    f = [-n, C, resilienceloss]';
    
end