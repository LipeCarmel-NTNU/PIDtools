classdef PID_obj < handle & matlab.mixin.Copyable
    % PID_obj  Discrete PID with actuator-model antiwindup.
    %
    % Forms:
    %   Parallel:  u = bias + sat{ Kp*e + I + D }
    %   Series  :  c(s) = Kc * (tauI*s + 1)/(tauI*s) * (tauD*s + 1)/((tauD/N)*s + 1)
    %              then converted to parallel: Kp=Kc, Ki=Kc/tauI, Kd=Kc*tauD, tauF=tauD/N
    %
    % Method:
    %   u = K(y, update)   % update=true by default

    properties
        % Parallel parameters
        Kp  (1,1) double = NaN
        Ki  (1,1) double = NaN                  % s^-1
        Kd  (1,1) double = NaN                  % s

        % Optional series params (kept for traceability)
        Kc  (1,1) double = NaN
        Ti  (1,1) double = NaN
        Td  (1,1) double = NaN

        % Operation
        sat  (1,2) double = [-Inf Inf]        % absolute saturation [umin umax]
        bias (1,1) double = 0                 % constant bias (nominal input)
        r    (1,1) double = 0                 % setpoint

        % States
        I_state (1,1) double = 0
        y_prev  (1,1) double = 0

        % Available parameters
        has_series = false
        has_parallel = false
    end

    methods
        function obj = PID_obj(opts)
            % Accepts tuning paramters in a struct

            % opts is optional struct with fields matching properties
            if nargin==1 && ~isempty(opts)
                fns = fieldnames(opts);
                for k = 1:numel(fns)
                    if isprop(obj, fns{k})
                        obj.(fns{k}) = opts.(fns{k});
                    end
                end
            end

            if strcmpi(opts.form, 'series')
                obj.has_series = true;
                obj = obj.toParallel();  % convert immediately
            else
                obj.has_parallel = true;
                obj = obj.toSeries();  % convert immediately
            end
        end

        function obj = toParallel(obj)
            % Map series gains to parallel gains
            obj.Kp = obj.Kc;
            obj.Ki = obj.Kc/obj.Ti;
            obj.Kd   = obj.Kc*obj.Td;

            obj.has_parallel = true;
        end

        function obj = toSeries(obj)
            if isnan(obj.Kp)
                warning('No series form.')
                return
            end

            % Controller gain
            obj.Kc = obj.Kp;
            obj.Ti = obj.Kp / obj.Ki;
            obj.Td = obj.Kd / obj.Kp;
            obj.has_series = true;
        end


        function u = control(obj, y, delta_t)
            arguments
                obj
                y
                delta_t = 0
            end

            % Error
            e = obj.r - y;

            % Proportional
            P = obj.Kp * e;

            % Derivative on y
            dy = (y - obj.y_prev)/delta_t;
            D = obj.Kd*dy;

            % Integrator update, actuator-model antiwindup
            I = obj.I_state;

            v = P + I + D + obj.bias;              % pre-saturation signal (absolute)

            % Saturation
            u = min(max(v, obj.sat(1)), obj.sat(2));


            % Integral action && Antiwindup via actuator model
            obj.I_state = obj.I_state + obj.Ki*e*delta_t;
            if not(obj.Ki == 0)
                tau_aw = obj.Kp/obj.Ki;
                es = u - v;
                obj.I_state = obj.I_state + (es/tau_aw)*delta_t;
            end

            obj.y_prev = y;
        end
    end
end
