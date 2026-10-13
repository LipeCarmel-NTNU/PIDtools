function [K, tau, theta, T] = get_tf_data(G)
G = zpk(G);

% Removing integrators
ns = sum(pole(G) == 0);
G = G * tf('s')^ns;

% Gain
K = dcgain(G);

% Time constants
[wn,~] = damp(G);
tau = 1./wn;
tau = tau(tau < inf);

% Numerator Time constants
T = sort(1./G.Z{1});
T = T(T < inf);

% Delay
theta = get_tf_delay(G);
end