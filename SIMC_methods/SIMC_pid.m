function [Kc, Ti, Td, C] = SIMC_pid(G, tauc, theta)
    % SIMC PID tuning based on Table 5.1, page 158
    arguments
        G
        tauc
        theta = 0;
    end
    
    %% Extract process data
    if theta == 0
        [K, tau, theta, T] = get_tf_data(G);
    else
        [K, tau, ~, T] = get_tf_data(G);
    end

    %% Number of poles
    nuns = sum(pole(G) > 0);
    if nuns > 0
        error('No tuning for unstable plants')
    end

    ns = length(tau);   % number of stable poles
    nz = length(T);     % number of zeros
    ni = sum(pole(G) == 0); % number of integrating poles
    
    %% Detect process type
    if ns == 1 && nz == 0 && ni == 0
        % First-order
        tau1 = tau(1);
        Kc = (1/K) * tau1/(tauc + theta);
        Ti = min(tau1, 4*(tauc + theta));
        Td = 0;
        
    elseif ns == 2 && nz == 0 && ni == 0
        % Second-order
        tau1 = tau(1); tau2 = tau(2);
        Kc = (1/K) * tau1/(tauc + theta);
        Ti = min(tau1, 4*(tauc + theta));
        Td = tau2;
        
    elseif ns == 0 && nz == 0 && ni == 0 && theta > 0
        % Pure time delay (special case, see at the end)
        Kc = 0;
        Ti = 0; Td = 0;
        
    elseif ns == 0 && nz == 0 && ni == 1
        % Integrating process (G(s) ~ k'/s)
        Kc = (1/K) * 1/(tauc + theta);
        Ti = 4*(tauc + theta);
        Td = 0;

    elseif ns == 1 && nz == 0 && ni == 1
        % Integrating with lag (G(s) ~ k'/s/(τ2 s + 1))
        tau2 = tau(1);
        Kc = (1/K) * 1/(tauc + theta);
        Ti = 4*(tauc + theta);
        Td = tau2;
              
    elseif ns == 0 && nz == 0 && ni == 2
        % Double integrating process
        Kc = (1/K) * 1/(4*(tauc + theta)^2);
        Ti = 4*(tauc + theta);
        Td = 4*(tauc + theta);
        
    elseif ns == 1 && nz == 1 && ni == 1
        % IPZ process, assume form: k' e^{-θs}/s * (Ts+1)/(τ2 s + 1)
        tau2 = tau(1); % smallest time constant
        Kc = (1/K/T) * tau2/(tauc + theta);
        Ti = min(tau2, 4*(tauc + theta));
        Td = 0;
        
    else
        error('Unknown process type.');
    end
    
    %% Construct controller transfer function
    s = tf('s');
    if Ti == 0
        % pure integral controller
        C = (Kc/Ti)/s;
    else
        C = Kc * (1 + 1/(Ti*s) + Td*s);
    end
end
