function [xvec, zvec] = RSSIinput_3D_simple(st_observer, st_obstacle, noise)    
Pn = -63;
gamma_l = 2.0;

range     = get_range (st_observer(:,2:3), st_obstacle(:,2:3));
vrelative = GetRelativeVel (st_observer(:,4:6),     st_obstacle(:,4:6));
prelative = GetRelativePos (st_observer(:,[2:3,6]), st_obstacle(:,[2:3,6]));

% State Vector -- Calculated for reference
xvec = [prelative(:,1), ...  % x relative position of j wrt i body frame
        prelative(:,2), ...  % y relative position of j wrt i body frame
        st_observer(:,4),... % x velocity of i wrt i body frame
        st_observer(:,5),... % y velocity of i wrt i body frame
        vrelative(:,1),...   % x velocity of j wrt i body frame
        vrelative(:,2),...   % y velocity of j wrt i body frame
        st_observer(:,6),... % orientation of i wrt north
        st_obstacle(:,6),... % orientation of j wrt north
        st_obstacle(:,7)     % height
        ];

% Measurement vector (with simulated noise terms)
zvec = [ logdistdB( Pn, gamma_l, range ) + noise(1) * randn(size(range)),...  % range
        st_observer(:,[4 5]) + noise(2) * randn(size(st_observer(:,4:5))),... % x,y velocity of i wrt i
        st_observer(:,6)     + noise(3) * randn(size(st_observer(:,6))),...   % orientation of i wrt i
        st_obstacle(:,[4 5]) + noise(2) * randn(size(st_obstacle(:,4:5))),... % x,y velocity of j wrt j
        st_obstacle(:,6)     + noise(3) * randn(size(st_obstacle(:,6))),...   % orientation of j wrt j
        st_obstacle(:,7)     + noise(3) * randn(size(st_obstacle(:,7))),...   % relative height
        ];   

end