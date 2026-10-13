function Gid = SIMC_half_rule(G, order)
    % Simplified SIMC_half_rule using utilities
    s = tf('s');
    
    % Extract data
    [K, tau0, theta, T0] = get_tf_data(G);
    
    % Approximate dominant time constants
    tau = tau0(1:order);
    if length(tau0) > order
        tau(order) = tau(order) + tau0(order+1)/2;
    end
    
    % Effective delay
    if length(tau0) > order+1
        theta = theta + tau0(order+1)/2 + sum(tau0(order+2:end));
    elseif length(tau0) == order+1
        theta = theta + tau0(order+1)/2;
    end
    theta = theta + sum(T0);
    
    % Transfer Function
    den = 1;
    for i = 1:length(tau)
        den = den*(tau(i)*s + 1);
    end
    Gid = zpk(K*exp(-theta*s)/den);
    set(Gid,'DisplayFormat','time constant')
end
