% System parameters
m = 10; c = 5; k = 20; 
% Forcing function
F = @(t) 10 * sin(5 * t); 
% Solve for displacement and velocity
ode = @(t, y) [y(2); (F(t) - c * y(2) - k * y(1)) / m];
[t, y] = ode45(ode, [0, 10], [0, 0]); 
% Visualize displacement vs time
plot(t, y(:, 1)); 

xlabel('Time [s]')
ylabel("x(t) [m]")
grid('on')
