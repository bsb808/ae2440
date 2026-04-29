%[text] # From Prototype to Function
%%
%[text] ## The Approach
%[text] Writing new logic as a flat script first puts every intermediate variable in the workspace where you can inspect it directly — double-click an array in the Variables panel, plot results on the fly, catch mistakes in individual steps before they compound. Once the logic is confirmed, wrapping it in a function takes a minute.
%%
%[text] ## Dead Reckoning
%[text] Dead reckoning navigation: 
%[text] 1. start where you are
%[text] 2. apply a sequence of headings, speeds, and elapsed times to estimate where you will be
%[text] 3. repeat \
%[text] Each leg contributes a displacement in easting and northing:
%[text] $\\Delta x = v\\,\\Delta t\\,\\sin\\theta, \\qquad \\Delta y = v\\,\\Delta t\\,\\cos\\theta$
%[text] where $\\theta$ is compass bearing from north (north = 0°, east = 90°), $v$ is speed in knots, and $\\Delta t$ is time in hours. 
%%
%[text] ## Prototype: One Leg
%[text] Work through a single leg first. Choose heading due east (easy to know "truth") so the workspace values serve as a built-in sanity check.

clear

hdg_deg = 90;    % heading, degrees clockwise from north
spd_kts = 10;    % speed, knots
time_hr = 2;     % elapsed time, hours

hdg_rad = hdg_deg * pi/180
dist    = spd_kts * time_hr       % leg distance, nautical miles
dx      = dist * sin(hdg_rad)     % easting displacement, nm
dy      = dist * cos(hdg_rad)     % northing displacement, nm
%[text] - Are the results what we expect? \
%%
%[text] ## Generalizing 
%[text] With the single-leg logic working, avoid repeating ourselves with a for-loop; each iteration appends the next waypoint.

headings_deg = [  0,  90, 180, 270];   % N, E, S, W
speeds_kts   = [ 10,   8,  10,   8];   % knots
times_hr     = [  2,   2, 1.5,   2];   % hours

% Initial conditions
x(1) = 0;
y(1) = 0; 

for k = 1:length(headings_deg);
    hdg_rad  = headings_deg(k) * pi/180;
    dist     = speeds_kts(k) * times_hr(k);
    x(k+1)  = x(k) + dist * sin(hdg_rad);
    y(k+1)  = y(k) + dist * cos(hdg_rad);
end

figure(1); clf; hold on
plot(x, y, 'b-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b', 'DisplayName', 'Track')
plot(x(1),   y(1),   'gs', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'DisplayName', 'Departure')
plot(x(end), y(end), 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Arrival')
xlabel('Easting (nm)'); ylabel('Northing (nm)')
title('Dead Reckoning Track'); axis equal; grid on; legend
%[text] - The inputs are still small enough we can verify with some quick geometry. \
%%
%[text] ## Wrapping in a Function
%[text] Now we have all the logic. Package it as a function — the documentation header defines the interface:

function [x, y] = dead_reckoning(headings_deg, speeds_kts, times_hr)
    % dead_reckoning  Dead reckoning track from a sequence of legs.
    %
    %   Inputs:
    %     headings_deg  heading for each leg, degrees clockwise from north  (1 x n)
    %     speeds_kts    speed for each leg, knots                           (1 x n)
    %     times_hr      elapsed time for each leg, hours                    (1 x n)
    %
    %   Outputs:
    %     x   easting  at each waypoint, nautical miles  (1 x n+1);  x(1) = 0
    %     y   northing at each waypoint, nautical miles  (1 x n+1);  y(1) = 0
    n = length(headings_deg);
    x = zeros(1, n+1);
    y = zeros(1, n+1);
    for k = 1:n
        hdg_rad  = headings_deg(k) * pi/180;
        dist     = speeds_kts(k) * times_hr(k);
        x(k+1)  = x(k) + dist * sin(hdg_rad);
        y(k+1)  = y(k) + dist * cos(hdg_rad);
    end
end

%[text] **Test** 
%[text] call the function on the single-leg prototype case and confirm the endpoint matches:
[x_fn, y_fn] = dead_reckoning(90, 10, 2);
x_fn(end)    % expect 20 nm east
y_fn(end)    % expect  0 nm north
%%
%[text] ## Reuse: Two Voyages

figure(2); clf; hold on
[xa, ya] = dead_reckoning([  0,  90, 180, 270], [10,  8, 10,  8], [2, 2, 1.5, 2]);
[xb, yb] = dead_reckoning([ 45, 135, 225, 315], [12, 12, 12, 12], [2, 2, 2,   2]);
plot(xa, ya, 'b-o', 'LineWidth', 1.5, 'DisplayName', 'Voyage A')
plot(xb, yb, 'r-o', 'LineWidth', 1.5, 'DisplayName', 'Voyage B')
plot(0, 0, 'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'k', 'HandleVisibility', 'off')
xlabel('Easting (nm)'); ylabel('Northing (nm)')
title('Dead Reckoning — Two Voyages'); axis equal; grid on; legend

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
