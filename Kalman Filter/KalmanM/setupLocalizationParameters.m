function [ x, f, h, Pmod, xvec, zvec ] = ...
    setupLocalizationParameters(filter, st_observer, st_obstacle, initialstateknown, noise, dt)
%setupEKF Sets up the Localization EKF variables

filterfunc = [filter,'_filter'];

[xvec, zvec] = feval(filter,st_observer, st_obstacle, noise);
[f, h, Pmod] = feval(filterfunc, dt);

% Initial state
if ~initialstateknown
    disp('Initial state is NOT known!');
    x = zeros(size(xvec,2),1); % Just zeros -- no knowledge
    
    x(1) = 1; % Or else log10(0) = Inf!
    x(2) = 1;

elseif initialstateknown
    disp('Initial state is known!');
    x = xvec(1,:); % Actual initial values
end

check_samesize(f(x), xvec, 1, 2)
check_samesize(h(x), zvec, 1, 2)

end