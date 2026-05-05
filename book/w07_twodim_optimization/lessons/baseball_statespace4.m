
% Exhaustive search.  Evaluate range for a set of launch angles
thetas = linspace(0, pi/2);
for ii = 1:length(thetas)
    ranges(ii) = baseball_range(thetas(ii));
end

figure(1);
clf;
plot(thetas, ranges)
xlabel('Initial angle [rad]')
ylabel('Range [m]')
grid('on')

% Inital estimate of solution
theta0 = 0;
% Optimization
[x, fval] = fminsearch(@negative_range, theta0)

% Optimization options
options = optimset('Display','iter', ...
    'PlotFcns', {@optimplotx, @optimplotfval,@optimplotfunccount});
% Call optimization
[x, fval, exitflag,output] = fminsearch(@negative_range, theta0, options)

% Animate
% Solve with ode45
tspan = [0 10];
xx_init = [0 30 1 40];
options = odeset('Events', @event_landing);
[tout, Xout] = ode45(@state_transition, tspan, xx_init, options);

% Setup figure
figure(4);
clf();
x = Xout(:,1);
y = Xout(:,3);
minmax = [min([x]), max([x]), min([y]), max([y])];
% Plot each element in the solution
for ii=1:round(length(tout)*4/5)
    clf; 
    hold on;
    plot(x(1:ii), y(1:ii), 'b:')
    plot(x(ii), y(ii), 'ro')
    axis(minmax)
    xlabel('x position [m]')
    ylabel('y position [m]')
    drawnow;
    if ii < length(tout)
        dt = tout(ii+1) - tout(ii);
        pause(dt);
    end
end

function nrange = negative_range(theta)
    % Return -1*range for use with function minimization
    nrange = -1.0*baseball_range(theta);
end

function range = baseball_range(theta)
    % Simulate baseball trajectory based on initial angle (theta)
    % and return the horizontal distance travelled (range)
    
    % Initial speed is constant [m/s]
    v_init = 50;
    
    % Polar-to-Cartesian for initial velocities in x andy directions
    [vx, vy] = pol2cart(theta, v_init);

    % Initial conditions
    xx_init = [0 vx 1 vy]';

    % Solve with ode45
    tspan = [0 10];
    options = odeset('Events', @event_landing);
    [tout, Xout] = ode45(@state_transition, tspan, xx_init, options);

    % Return final x position
    range = Xout(end, 1);
end

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

function [value, isterminal, direction] = event_landing(t, xx)
    % Event function for ode solver to trigger when vertical position
    % is zero
    value = xx(3);
    isterminal = 1;
    direction = -1;
end