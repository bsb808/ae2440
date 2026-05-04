% Use ode45 to predict rat population growth.


% Initial condition
rats_init = 1000; 
% Time span
t_span = [0, 365];

opts = odeset(Stats="on");
[tt, rats] = ode45(@rate_func, t_span, rats_init, opts);

[tte, rats_euler] = euler(@rate_func, t_span, rats_init);

figure(1);
clf()
plot(tt, rats, 'b--')
hold on;
plot(tte, rats_euler, "r:")
xlabel('Time (days)')
ylabel('Population (rats)')

legend('ode45','euler','location','southeast')
title(sprintf("Final rate population: %.1f (ode45), %.1f (euler)", ...
    rats(end), rats_euler(end)));

function res = rate_func(t, rats)
    %RATE_FUNC returns the growth rate at time (t) for population (rats)
    a = 0.002;
    omega = 2*pi / 365;
    res = a * rats * (1 - cos(omega * t));
end
