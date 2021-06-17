function R = Reliability7(z)
    % Cementitious Cladding
    PM = round(z(1, :));
    EM = round(z(2, :));
    paint_delay = 4;
    a1 = 3;
    a2 = 5;
    a3 = 0.035;
    correct = 0;
    threshold_1 = 0.01;
    threshold_2 = 0.2;
    PM_Year = zeros(1, 20);
    EM_Year = zeros(1, 20);
    for i = 1:length(PM)
        PM_Year(i) = PM(i);
        EM_Year(i) = EM(i);
    end
    PM_Year = nonzeros(sort(PM_Year));
    EM_Year = nonzeros(sort(EM_Year));
    % Objective function 1: Reliability:
   
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
   
    while i < 200
        if ismember(i, PM_Year)
            coating = find(i == PM_Year, 1);
        else
            coating = 0;
        end
        
        if ismember(i, EM_Year)
            repair = find(i == EM_Year, 1);
        else

        end
    
        if coating == 0
            
            switch repair
                case 0
                    y(i) = CementitiousCladding(x(i));
                case 0.5
                    y(i) = CementitiousCladding(x(i)) - correct;
                otherwise
                    y(i) = CementitiousCladding(x(i));
            end
            
            if y(i) >= threshold_2 & (repair == 0.5 | repair == 0)
                break
            elseif repair ~= 0 & repair ~= 0.5
                % i
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
        
        elseif coating ~= 0 & y(i - 1) >= threshold_1
            y(i:i + paint_delay - 2) = y(i - 1);
            x_inter = x(i);
            i = i + paint_delay - 1;
            x(i:end) = x_inter:x_inter - 1 + length(x(i:end));
           
        elseif coating ~= 0 & y(i - 1) < threshold_1
            PM_Year(coating) = 0;
            
        end
    
    end
   m = 0;
    n = length(nonzeros(y));
    for i = 1:n
        if y(i) == 0
        m = m + 1;
        else
        end
    end
    n = n + m - 1;
    y = y(1:n);
    y(y<0) = 0;
    replacement = fix(150/n) + 1;
    lifespan = zeros(1, n*replacement);
    j = 1;
    for i = 1:replacement
        lifespan(j:j + n - 1) = y;
        j = n*i + 1;
    end
    lifespan = lifespan(1:150);

    x = 1:100;
    y_reference = CementitiousCladding(x);
    k = find(y_reference >= 0.2, 1) - 1;
    y_reference = y_reference(1:k);
    
    replacement = fix(150/k) + 1;
    lifespan_reference = zeros(1, k*replacement);
    j = 1;
    for i = 1:replacement
        lifespan_reference(j:j + k - 1) = y_reference;
        j = k*i + 1;
    end
    lifespan_reference = lifespan_reference(1:150);
        
    count = 1;
    reliability = zeros(1, 150);
    reliability_reference = zeros(1, 150);
    reliability(1) = 4.75;
    reliability_reference(1) = 4.75;
    
    for i = 2:150
        if lifespan(i) <= 0.10
            reliability(i) = reliability(i - 1);
        else
            reliability(i) = Relisis_2(5*10^-3, 4.5*10^-3, 34, count);
            count = count + 1;
        end
        
    end
    count_reference = 1;
    for i = 2:150
        if lifespan_reference(i) <= 0.10
            reliability_reference(i) = reliability_reference(i - 1);
        else
            reliability_reference(i) = Relisis_2(5*10^-3, 4.5*10^-3, 34, count_reference);
            count_reference = count_reference + 1;
        end
        
    end
    
    R = reliability(end);
    
%     figure;
%     subplot(2, 1, 1);
%     plot(lifespan);
%     hold on;
%     plot(lifespan_reference);
%     grid on;
%     ylim([0.01, 0.2]);
%     xlabel('Year', 'fontname', 'times', 'Fontsize', 12);
%     ylabel('Degredation Severity', 'fontname', 'times', 'Fontsize', 12);
%     title('Exterior cladding service life', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
%     legend('Condition-based optimal maintenance', 'Time-based replacement', 'Location', 'bestoutside', 'Fontsize', 10);
%     
%     subplot(2, 1, 2);
%     plot(reliability);
%     hold on;
%     plot(reliability_reference);
%     y1 = ones(1, 150).* 3.8;
%     plot(y1, 'k', 'Linewidth', 1);
%     text(5,3.65,'Eurocode 50-year threshold: 3.8', 'fontname', 'times', 'Fontsize', 12)
%     grid on;
%     xlabel('Year', 'fontname', 'times', 'Fontsize', 12);
%     ylabel('Reliability Index', 'fontname', 'times', 'Fontsize', 12);
%     title('Reliability analysis and comparison', 'fontname', 'times', 'fontweight','bold', 'Fontsize', 14);
%     legend('Condition-based optimal maintenance', 'Time-based replacement', 'Location', 'bestoutside', 'Fontsize', 10);

end