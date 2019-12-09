function [f, h, P_basic] = RSSIinput_3D_simple_filter(dt, P_basic, P_lobes)

if nargin < 2
    P_basic = [-63 2];
end

if nargin < 3
    P_lobes = [];
end

% Filter State Equation
f=@(x)[ x(1) - ( x(3) - x(5) ) * dt; % relative pos j wrt i in x (i body frame)
        x(2) - ( x(4) - x(6) ) * dt; % relative pos j wrt i in y (i body frame)
        x(3); % x velocity of i wrt i body frame
        x(4); % y velocity of i wrt i body frame
        x(5); % x velocity of j wrt i body frame
        x(6); % y velocity of j wrt i body frame
        x(7); % orientation of i wrt north
        x(8); % orientation of j wrt north
        x(9); % height difference
        ];

% Filter Measurement Equation
h=@(x)[ EstimateRSSI(P_basic, P_lobes, sqrt(x(1)^2 + x(2)^2 + x(9)^2)); % abs range between origin of i body frame and j body frame
        x(3); % x velocity of i wrt i body frame
        x(4); % y velocity of i wrt i body frame
        x(7); % x orientation of i wrt north
        cos( x(7) - x(8) ) * x(5) - sin( x(7) - x(8) ) * x(6); % x velocity of j wrt j body frame
        sin( x(7) - x(8) ) * x(5) + cos( x(7) - x(8) ) * x(6); % y velocity of j wrt j body frame
        x(8);  % orientation of j wrt north
        x(9) % height difference
        ];

end