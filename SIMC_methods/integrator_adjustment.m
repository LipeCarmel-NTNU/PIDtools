function F = integrator_adjustment(P0, taui0)
    % Use in case of oscillations (page 172)
    %
    % P0 is the period of oscillations

    ratio = P0 / taui0;
    if ratio < 3
        disp('The adjustment is not necessary. Setting F = 1.')
        F = 1;
    else
        F = (1/pi^2) * (ratio)^2; % Kc * taui = F * Kc0 * taui0, adjust the controller accordingly
    end
end