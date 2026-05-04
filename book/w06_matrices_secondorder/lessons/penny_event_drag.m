% Simulate a penny falling from the Empire State Building.

% Initial conditions as state vector: position and velocity
xx_init = [381; 0];

% Test the rate function
rate_func(0, xx_init)

tspan = [0, 10];
options = odeset('Events', @event_func);
[tout, Xout] = ode45(@rate_func, tspan, xx_init, options);

figure(1)
clf;
plot(tout,Xout(:,1))
xlabel('Time [s]')
ylabel('Position [m]')

function xx_dot = rate_func(t, xx)
    % Rate function using state space format
    A = [0, 1; 0, 0];
    B = [0; 1];
    % Intput is total acceleration
    uu = acceleration(t, xx);
    
    xx_dot = A*xx+B*uu;
end

function accel = acceleration(t, xx)
    % Return total acceleration due to gravity and drag.
    
    % Drag constant in kg/m
    b = 75e-6; 
    % Velocity from state, in m/s
    v = xx(2);
    % Drag force in N    
    f_d = -sign(v) * b * v^2;
    % Mass in kg
    m = 2.5e-3;
    % Drag acceleration in m/s^2
    a_d = f_d / m;
    % Gravity
    a_g = -9.8;
    % Return total drag
    accel = a_g + a_d;
end

function [value, isterminal, direction] = event_func(t,xx)
    % Local event function for ode45 options
    value = xx(1);
    isterminal = 1;
    direction = -1;
end
