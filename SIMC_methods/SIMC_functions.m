%% Parameters
Kc0 = -2.8;
dyp = 0.72;     % maximum peak
tp = 7;         % time of maximum
dyu = 0.47;     % first undershoot
dys = 0.58;        % setpoint

dyinf = 0.45 * (dyp + dyu);

disp('overshoot percentage:')
disp(abs(100*dyp/dyinf - 100))

%% Function Calls
% Modeling
[k, theta, tau1, model] = FOD_model(Kc0, dyp, dyinf, dys, tp);
tau2 = 0;


% Tunnig parameter
theta = better_tau1_theta(tp, tau1, theta);
tauc = theta;


% PID
[PID_SIMC] = SIMC(k, theta, tau1, tau2);
[PID_Improved_SIMC] = Improved_SIMC(k, theta, tau1, tau2);

% Possible adjustments
theta = better_tau1_theta(tp, tau1, theta);

P0 = 1;
F = integrator_adjustment(tp, P0);


%% Functions
function [k, theta, tau1, model] = FOD_model(Kc0, dyp, dyinf, dys, tp)
    D = (dyp - dyinf) / dyinf;
    B = (dys - dyinf) / dyinf;
    A = 1.152 * D^2 - 1.607 * D + 1;
    r = 2 * A / B;
    k = 1 / (Kc0 * B);
    s = tf('s'); % Laplace variable
    theta = tp * (0.309 + 0.209 * exp(-0.61 * r));
    tau1 = r * theta;
    model = k * exp(-theta * s) / (tau1 * s + 1);
end

function [PID, Kc, taui, taud] = Improved_SIMC(k, theta, tau1, tau2)
    % Improved SIMC PI-rule for first-order with delay process (page 170)
    % can be used for second order with care (page 173)
    tau1 = tau1 + theta / 3;
    taui = min(tau1, 4 * (tauc + theta));
    taud = tau2;
    s = tf('s'); % Laplace variable
    Kc = (tau1 / k) / (tauc + theta);
    PID = Kc * (1 + 1 / (s * taui)) * (taud * s + 1);
end

function [PID, Kc, taui, taud] = SIMC(k, theta, tau1, tau2)
    tauc = theta;
    taui = min(tau1, 4 * (tauc + theta));
    taud = tau2;
    s = tf('s'); % Laplace variable
    Kc = (tau1 / k) / (tauc + theta);
    PID = Kc * (1 + 1 / (s * taui)) * (taud * s + 1);
end



function theta = better_tau1_theta(tp, tau1, theta)
    % For better FOD estimation (page 174)
    theta = tp * (0.309 + 0.209 * exp(-0.61 * tau1 / theta));
end

