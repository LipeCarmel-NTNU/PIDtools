%% Test suite for SIMC_pid
% Assumes SIMC_pid.m and utils are on MATLAB path
s = tf('s');

tol = 1e-10; % tolerance for numerical comparisons

%% Case 1: First-order plus delay
% G(s) = e^{-θs} / (τ1 s + 1), with k = 1, τ1 = 5, θ = 2
G = exp(-2*s)*1.1/(5*s + 1);
tau_c = 3;
[Kc, Ti, Td, C] = SIMC_pid(G, tau_c);

% Analytical solution:
K_expected = 1.1; tau1 = 5; theta = 2;
Kc_ref = (1/K_expected)*tau1/(tau_c + theta);
Ti_ref = min(tau1, 4*(tau_c + theta));
Td_ref = 0;

assert(abs(Kc - Kc_ref) < tol, 'Case 1 Kc mismatch')
assert(abs(Ti - Ti_ref) < tol, 'Case 1 Ti mismatch')
assert(abs(Td - Td_ref) < tol, 'Case 1 Td mismatch')

disp('Case 1 (FOPDT) passed.')

%% Case 2: Second-order plus delay
% G(s) = e^{-θs} / ((τ1 s + 1)(τ2 s + 1)), with τ1 = 4, τ2 = 2, θ = 1
G = exp(-1*s)*1.1/((4*s+1)*(2*s+1));
tau_c = 2;
[Kc, Ti, Td, C] = SIMC_pid(G, tau_c);

K_expected = 1.1; tau1 = 4; tau2 = 2; theta = 1;
Kc_ref = (1/K_expected)*tau1/(tau_c + theta);
Ti_ref = min(tau1, 4*(tau_c + theta));
Td_ref = tau2;

assert(abs(Kc - Kc_ref) < tol, 'Case 2 Kc mismatch')
assert(abs(Ti - Ti_ref) < tol, 'Case 2 Ti mismatch')
assert(abs(Td - Td_ref) < tol, 'Case 2 Td mismatch')

disp('Case 2 (SOPDT) passed.')

%% Case 3: Pure time delay
% G(s) = e^{-θs}, with k = 2, θ = 3
G = 2*exp(-3*s);
tau_c = 4;
[Kc, Ti, Td, C] = SIMC_pid(G, tau_c);

% Analytical: Pure delay → Kc = 0, Ti = 0, Td = 0
assert(Kc == 0, 'Case 3 Kc mismatch')
assert(Ti == 0, 'Case 3 Ti mismatch')
assert(Td == 0, 'Case 3 Td mismatch')

disp('Case 3 (Pure delay) passed.')

%% Case 4: Integrating process
% G(s) = e^{-θs} / s, with k' = 1, θ = 2
G = exp(-2*s)*1.1/s;
tau_c = 5;
[Kc, Ti, Td, C] = SIMC_pid(G, tau_c);

Kp = 1.1; theta = 2;
Kc_ref = (1/Kp)*1/(tau_c + theta);
Ti_ref = 4*(tau_c + theta);
Td_ref = 0;

assert(abs(Kc - Kc_ref) < tol, 'Case 4 Kc mismatch')
assert(abs(Ti - Ti_ref) < tol, 'Case 4 Ti mismatch')
assert(abs(Td - Td_ref) < tol, 'Case 4 Td mismatch')

disp('Case 4 (Integrating) passed.')

%% Case 5: Double integrating process
% G(s) = 1/s^2, with k'' = 1, θ = 0
G = 1/s^2;
tau_c = 2;
[Kc, Ti, Td, C] = SIMC_pid(G, tau_c);

Kpp = 1; theta = 0;
Kc_ref = (1/Kpp)*1/(4*(tau_c + theta)^2);
Ti_ref = 4*(tau_c + theta);
Td_ref = 4*(tau_c + theta);

assert(abs(Kc - Kc_ref) < tol, 'Case 5 Kc mismatch')
assert(abs(Ti - Ti_ref) < tol, 'Case 5 Ti mismatch')
assert(abs(Td - Td_ref) < tol, 'Case 5 Td mismatch')

disp('Case 5 (Double integrating) passed.')
