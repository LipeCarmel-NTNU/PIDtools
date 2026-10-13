%% Test SIMC_half_rule against book examples
s = tf('s');
tol = 1e-3;

%% Example E1
G1 = 1/((s+1)*(0.2*s+1));
Gid1 = SIMC_half_rule(G1, 1);

[K1, tau1, theta1, ~] = get_tf_data(Gid1);

% Expected values
K1_ref = 1;
tau1_ref = 1.1;
theta1_ref = 0.1;

assert(abs(K1 - K1_ref) < tol, 'E1: Gain mismatch')
assert(abs(tau1(1) - tau1_ref) < tol, 'E1: Tau1 mismatch')
assert(abs(theta1 - theta1_ref) < tol, 'E1: Delay mismatch')
disp('Example E1 passed.')

%% Example E2 (First-order half rule)
G2 = ( (-0.3*s+1)*(0.08*s+1) ) / ...
     ( (2*s+1)*(1*s+1)*(0.4*s+1)*(0.2*s+1)*(0.05*s+1)^3 );

Gid2a = SIMC_half_rule(G2, 1);
[K2a, tau2a, theta2a, ~] = get_tf_data(Gid2a);

assert(abs(K2a - 1) < tol, 'E2a: Gain mismatch')
assert(abs(tau2a(1) - 2.5) < tol, 'E2a: Tau1 mismatch')
assert(abs(theta2a - 1.47) < 0.05, 'E2a: Delay mismatch') % small tolerance
disp('Example E2 (1st order) passed.')

%% Example E2 (Second-order half rule)
Gid2b = SIMC_half_rule(G2, 2);
[K2b, tau2b, theta2b, ~] = get_tf_data(Gid2b);

assert(abs(K2b - 1) < tol, 'E2b: Gain mismatch')
assert(abs(tau2b(1) - 2) < tol, 'E2b: Tau1 mismatch')
assert(abs(tau2b(2) - 1.2) < tol, 'E2b: Tau2 mismatch')
assert(abs(theta2b - 0.77) < 0.05, 'E2b: Delay mismatch')
disp('Example E2 (2nd order) passed.')
