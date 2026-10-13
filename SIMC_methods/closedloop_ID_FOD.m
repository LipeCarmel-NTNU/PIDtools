function [G, k, theta, tau1] = skogeFOD(Kc0, dys, tp, dyp, dyu)  
    % Closed loop FOD identification and tuning (page 151)

    dyinf = 0.45 * (dyp + dyu);
    D = (dyp - dyinf) / dyinf;
    if abs(D - 0.3) > 0.5
        warning(['Warning in skogeFOD: Overshoot percentage should be close to 0.3, current value is D = ', num2str(D)]);
    end
    B = (dys - dyinf) / dyinf;
    A = 1.152 * D^2 - 1.607 * D + 1;
    r = 2 * A / B;
    k = 1 / (Kc0 * B);
    s = tf('s'); % Laplace variable
    theta = tp * (0.309 + 0.209 * exp(-0.61 * r));
    tau1 = r * theta;


    % For better FOD estimation (page 174)
    theta = tp * (0.309 + 0.209 * exp(-0.61 * tau1 / theta));


    G = k * exp(-theta * s) / (tau1 * s + 1);
end
