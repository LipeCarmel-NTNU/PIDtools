close all
omega = 2*pi/5; % signal frequency

%% Filter
Ts = 0.01;      % Sampling rate

% time constant
tauF = 0.5;
fc = butter_filter.fc_from_tau(tauF);

% frequency
fc = omega/(2*pi) * (1);
bwf = butter_filter(Ts, 2, fc);

%%
t = 0 : Ts : 10;
y =  sin(t*omega);
y = y + 2*(rand(1,length(y)) - 0.5);

plot(t, y, 'b.')

yf = y;
for i = 1 : length(t)
    yf(i) = bwf.sample(y(i));
end

hold on
plot(t, yf, 'r-', 'LineWidth', 2)