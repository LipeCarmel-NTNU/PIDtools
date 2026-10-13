function PID = parallel_PID(Kp, Ki, Kd)
    arguments
        Kp  (1,1) double = 0
        Ki  (1,1) double = 0                  % s^-1
        Kd  (1,1) double = 0                  % s
    end
    PID.form = 'parallel';
    PID.Kp = Kp;
    PID.Ki = Ki;
    PID.Kd = Kd;

    PID = PID_obj(PID);
end