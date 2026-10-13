Kp = 1;
Ki = 0.1;
parPID = parallel_PID(Kp, Ki, 0);
seriesPID = series_PID(Kp, Kp/Ki, 0);

I = 0;
for i = 1 : 100
    e = rand();
    dt = rand();
    uref = Kp*e + Ki*I;
    I = I + e*dt;

    u = parPID.K(-e, dt);
    assert(abs(u - uref) <= 1e-10, 'Failure')

    u = seriesPID.K(-e, dt);
    assert(abs(u - uref) <= 1e-10, 'Failure')

end
disp('Passed')