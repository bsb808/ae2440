% Simulate a penny falling from the Empire State Building.

% Initial conditions as state vector: position and velocity
xx_init = [381; 0];

% Test the rate function
rate_func(0, xx_init)

tspan = [0, 10];
[tout, Xout] = ode45(@rate_func, tspan, xx_init);

figure(1)
clf;
plot(tout,Xout(:,1))
xlabel('Time [s]')
ylabel('Position [m]')

function xx_dot = rate_func(t, xx)
    % Rate function using state space format
    A = [0, 1; 0, 0];
    B = [0; 1];
    uu = -9.81;
    
    xx_dot = A*xx+B*uu;
end
