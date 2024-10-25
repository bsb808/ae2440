% Multi-scale forced oscillator system
% y' + 20y = slow_oscillation + fast_oscillation
% The large coefficient of y makes the homogeneous part stiff
% while the forcing combines slow and fast dynamics

function demo_forced_oscillator()
    % Parameters for the system
    tspan = [0 10];  % Show several periods of slow oscillation
    y0 = 0;         % Initial condition
    
    % Solve using ode45
    [t_ode45, y_ode45] = ode45(@forced_system, tspan, y0);
    
    % Solve using Euler method
    dt = 0.001;     % Try different step sizes to show stability issues
    t_euler = tspan(1):dt:tspan(2);
    y_euler = zeros(size(t_euler));
    y_euler(1) = y0;
    
    for i = 1:length(t_euler)-1
        dydt = forced_system(t_euler(i), y_euler(i));
        y_euler(i+1) = y_euler(i) + dt * dydt;
    end
    
    % Plot results
    figure;
    subplot(3,1,1);
    plot(t_ode45, y_ode45, 'b-', 'LineWidth', 1.5);
    title('ode45 Solution');
    xlabel('Time');
    ylabel('y(t)');
    grid on;
    
    subplot(3,1,2);
    plot(t_euler, y_euler, 'r-', 'LineWidth', 1.5);
    title('Euler Solution');
    xlabel('Time');
    ylabel('y(t)');
    grid on;
    
    % Plot forcing function separately for comparison
    t_dense = linspace(tspan(1), tspan(2), 1000);
    f_t = forcing(t_dense);
    subplot(3,1,3);
    plot(t_dense, f_t, 'g-', 'LineWidth', 1.5);
    title('Forcing Function');
    xlabel('Time');
    ylabel('f(t)');
    grid on;
end

function dydt = forced_system(t, y)
    % System: y' + 20y = f(t)
    % Rearranged as y' = -20y + f(t)
    dydt = -20*y + forcing(t);
end

function f = forcing(t)
    % Combine slow and fast oscillations
    slow_freq = 1;     % 1 rad/s
    fast_freq = 20;    % 20 rad/s
    
    % Slow oscillation with amplitude 1
    slow_term = sin(slow_freq * t);
    
    % Fast oscillation with smaller amplitude
    fast_term = 0.2 * sin(fast_freq * t);
    
    f = slow_term + fast_term;
end

% Optional function to analyze stability regions
function plot_stability_regions()
    % Compare stability regions for Euler and ode45 (RK4)
    z = linspace(-4, 1, 200);
    w = linspace(-4, 4, 200);
    [Z, W] = meshgrid(z, w);
    
    % Euler stability region: |1 + h*lambda| <= 1
    euler_region = abs(1 + (Z + 1i*W)) <= 1;
    
    % RK4 stability region
    zeta = 1 + (Z + 1i*W) + (Z + 1i*W).^2/2 + ...
           (Z + 1i*W).^3/6 + (Z + 1i*W).^4/24;
    rk4_region = abs(zeta) <= 1;
    
    figure;
    subplot(1,2,1);
    contourf(Z, W, euler_region);
    title('Euler Stability Region');
    xlabel('Re(h\lambda)');
    ylabel('Im(h\lambda)');
    colorbar;
    
    subplot(1,2,2);
    contourf(Z, W, rk4_region);
    title('RK4 Stability Region');
    xlabel('Re(h\lambda)');
    ylabel('Im(h\lambda)');
    colorbar;
end