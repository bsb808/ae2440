% Use ode45 to predict rat population growth.


% Initial condition
rats_init = 1000; 
% Time span
t_span = [0, 365];

[tt, rats] = ode45(@rate_func, t_span, rats_init);
plot(tt, rats)
xlabel('Time (days)')
ylabel('Population (rats)')

% Return the final poplution number
res = rats(end);

function res = rate_func(t, rats)
    %RATE_FUNC returns the growth rate at time (t) for population (rats)
    a = 0.002;
    omega = 2*pi / 365;
    res = a * rats * (1 - cos(omega * t));
end
