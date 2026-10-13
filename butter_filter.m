classdef butter_filter < handle & matlab.mixin.Copyable
    % To prevent duplication use copy(butter_filter) instead of assignment
    properties
        Ts
        order
        cuttoff_frequency
    end
    properties (Hidden)
        A
        B
        C
        D
        x

        init = false
    end

    methods (Static)
        function fc = fc_from_tau(tauF)
            wc = 1/tauF;    % rad/time units
            fc = wc/(2*pi); % 1/time units
        end
    end
    methods
        function obj = butter_filter(Ts, order, cuttoff_frequency)
            % cuttoff_frequency in Hz
            obj.Ts = Ts;
            obj.order = order;
            obj.cuttoff_frequency = cuttoff_frequency;

            obj.init = true;
            obj = constructor(obj);
        end

        function obj = constructor(obj)
            if not(obj.init)
                return
            end

            sample_frequency = 1/obj.Ts;

            wn = obj.cuttoff_frequency/(sample_frequency/2);
            [obj.A, obj.B, obj.C, obj.D] = butter(obj.order, wn);

            obj.x = zeros(length(obj.A), 1);
        end

        function y = sample(obj, u)
            % yk = y(xk)

            y = obj.C*obj.x + obj.D*u;
            obj.x = obj.A*obj.x + obj.B*u;
        end

        function set_y0(obj, y0)
            % steady-state for xk
            obj.x = (eye(size(obj.A)) - obj.A)\obj.B*y0;
        end

        function set.Ts(obj, val)
            obj.Ts = val;
            constructor(obj);
        end
        function set.order(obj, val)
            obj.order = val;
            constructor(obj);
        end
        function set.cuttoff_frequency(obj, val)
            obj.cuttoff_frequency = val;
            constructor(obj);
        end

    end

end