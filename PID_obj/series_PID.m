function PID = series_PID(Kc, Ti, Td)
    arguments
        Kc  (1,1) double = 0
        Ti  (1,1) double = inf
        Td  (1,1) double = 0
    end
    PID.form = 'series';
    PID.Kc = Kc;
    PID.Ti = Ti;
    PID.Td = Td;

    PID = PID_obj(PID);
end