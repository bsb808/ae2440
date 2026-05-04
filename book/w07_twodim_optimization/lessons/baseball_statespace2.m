% Simulate the flight of a baseball with no drag.
% State vector is x, v_x, y, v_y

% Initial conditions
xx_init = [0 30 1 40]';

% Solve with ode45
tspan = [0 6];
[tout, Xout] = ode45(@state_transition, tspan, xx_init);

% Extract positions
x = Xout(:, 1);
y = Xout(:, 3);

% Plot
figure(1); 
clf;
plot(tout, x)
hold on;
plot(tout, y)
xlabel('Time (s)')
ylabel('Position (m)')
legend('x position', 'y position', 'Location', 'northwest')

figure(2); 
clf;
plot(x, y)
xlabel('X Position (m)')
ylabel('Y Position (m)')

function xx_dot = state_transition(t, xx)
    % Unpack state into components
    x = xx(1);
    vx = xx(2);
    y = xx(3);
    vy = xx(4);

    % Acceleration in x and y from subroutine
    aa = acceleration(t, xx);

    % Equations of motion
    x_dot = vx;
    vx_dot = aa(1);
    y_dot = vy;
    vy_dot = aa(2);
    
    % Pack the result into a column vector
    xx_dot = [x_dot vx_dot y_dot vy_dot]';
end

function accel = acceleration(t, xx)
    % Acceleration for time (t) and state (xx)
    
    % Gravity
    g = 9.81;

    % Drag subroutine
    ff_d = drag_force([xx(2), xx(4)]);
    % Mass [kg]
    m = 0.145;
    % Drag acceleration
    aa_d = ff_d/m;

    % Return 1x2 vector of acceleration in x and y directions
    accel = [0; -g] + aa_d;
end

function ff_d = drag_force(vv)
    % Drag force vector as a functio of velocity vector
    % Drag coefficient [dimensionless]
    C_d = 0.3;     
    % Density, air [kg/m^3]
    rho = 1.3;     
    % Area, cross-sectional [m^2]
    A = 0.0042; 
    % Magnitude of velocity vector [m/s]
    v = norm(vv);   
    % Drag force [N]
    ff_d = - 1/2 * C_d * rho * A * v * vv;
end
