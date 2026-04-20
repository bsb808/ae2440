%[text] # Assignment 6 — Ballistic Drop with Drag
%[text] ## Scenario
%[text] A munition is released from rest by an aircraft. Gravity pulls it downward while air drag resists the motion. As velocity increases the drag force grows until it exactly balances gravity — the munition then falls at a constant **terminal velocity**.
%[text] This assignment models the fall, solves it two ways, and compares the results.
%%
%[text] ## The Model
%[text] Applying Newton's second law and dividing by mass $m$:
%[text] $\\frac{dv}{dt} = g - \\frac{b}{m}v$
%[text] where
%[text] - $v(t)$ — downward velocity (m/s)
%[text] - $g = 9.81$ m/s$^2$ — gravitational acceleration
%[text] - $m$ — munition mass (kg)
%[text] - $b$ — drag coefficient (N·s/m)
%[text] Setting $dv/dt = 0$ gives the **terminal velocity**:
%[text] $v\_t = \\frac{mg}{b}$
%%
%[text] ## Part 1 — Parameters
%[text] Define the model parameters and compute terminal velocity as a first sanity check.
g      = 9.81;     % gravitational acceleration (m/s^2)
m      = 50;       % munition mass (kg)
b      = 10;       % drag coefficient (N*s/m)
v0     = 0;        % initial velocity (m/s, released from rest)
tspan  = [0, 30];  % time span (s)
v_term = m*g/b     % terminal velocity (m/s)
%%
%[text] ## Part 2 — Rate Function
%[text] Write a local function `drop_rate` that evaluates the right-hand side of the ODE. The solver always passes time as the first argument, so the function must accept `(t, v)` even though this model does not depend on $t$ explicitly.
%[text] Test the function at $v = 0$: with no drag, the initial acceleration should equal $g = 9.81$ m/s$^2$.

function dvdt = drop_rate(t, v)
g = 9.81;
m = 50;
b = 10;
dvdt = g - (b/m) * v;
end

rate_check = drop_rate(0, v0)
%%
%[text] ## Part 3 — ode45 Solution
%[text] Use `ode45` to solve the ODE. The velocity should rise from zero and level off near the terminal velocity computed in Part 1.
[t_ode, v_ode] = ode45(@drop_rate, tspan, v0);
%%
%[text] ## Part 4 — Euler Solver
%[text] Create a new file named `euler.m` in the same directory as this script. This file contains a **primary function** — a standalone, reusable solver with the same interface as `ode45`:
%[text] `[tt, yy] = euler(odefun, tspan, y0)`
%[text] The Euler algorithm steps the solution forward using the slope at each point:
%[text] $y\_{k+1} = y\_k + dt \\cdot f(t\_k,\\, y\_k)$
%[text] Use a fixed step size $dt = (tspan(2) - tspan(1)) / 100$.
%[text] Once `euler.m` is saved and in the same directory, call it here with the same inputs used for `ode45`:
[t_euler, v_euler] = euler(@drop_rate, tspan, v0);
%%
%[text] ## Part 5 — Compare Solutions
%[text] Plot both solutions on the same axes and add a horizontal reference line at $v\_t$. Both solvers should approach terminal velocity by the end of the time span.
figure(1)
clf()
plot(t_ode, v_ode, 'b-', 'LineWidth', 1.5)
hold on
plot(t_euler, v_euler, 'r--', 'LineWidth', 1.5)
yline(v_term, 'k:', 'Terminal velocity')
xlabel('Time (s)')
ylabel('Velocity (m/s)')
title('Ballistic Drop — ode45 vs Euler')
legend('ode45', 'Euler', 'Location', 'southeast')
grid on
hold off
%[text] Report the final velocity from each solver and compare to the terminal velocity.
fprintf('ode45 final velocity: %.2f m/s\n', v_ode(end))
fprintf('Euler final velocity: %.2f m/s\n', v_euler(end))
%[text] **Reflect:** Do the two solvers agree? Does Euler lead or lag the ode45 solution during the transient phase — and why?
%[text] Once everything runs successfully, submit both **ballistic.m** and **euler.m** via Sakai.
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
