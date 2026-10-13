function [y_overshoot, I_overshoot, t_overshoot, y_undershoot, I_undershoot, t_undershoot] = find_over_undershoot(t,y)
%% Finding the overshoot
[y_overshoot, I_overshoot] = max(y);
t_overshoot = t(I_overshoot);


%% Finding the undershoot
not_found = true;
k = I_overshoot;
while k < length(y) - 1 && not_found
    if y(k) < y(k+1)
        not_found = false;
        y_undershoot = y(k);
        I_undershoot = k;
        t_undershoot = t(k);
    end
    k = k + 1;
end

end