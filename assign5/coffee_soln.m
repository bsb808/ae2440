%[text] # Assignment 5 — Newton's Law of Cooling
%[text] ## Scenario
%[text] You receive a cup of coffee at **90 °C**. From experience you know the hottest you can drink comfortably is **50 °C**.
%[text] During the first minute the coffee drops **0.7 °C**. A quick estimate: you need to lose 40 °C, and at 0.7 °C/min that would take 40 ÷ 0.7 ≈ **57 minutes**. But this estimate assumes the cooling rate stays constant — it does not. The coffee cools fastest when it is far above room temperature and slows as it approaches room temperature. This assignment builds a physics-based model to get a better answer.
%%
%[text] ## The Model — Newton's Law of Cooling
%[text] **Newton's Law of Cooling** says the rate of temperature change is proportional to the difference between the object's temperature and the surrounding environment:
%[text] $\\frac{dy}{dt} = -k\\,(y - \\theta\_e)$$$
%[text] where
%[text] - $y(t)$ — coffee temperature (°C) at time $t$ (min)
%[text] - $\\theta\_e = 20$ °C — room temperature (constant; the room is large)
%[text] - $k$ — heat-transfer coefficient (min⁻¹) \
%%
%[text] ## Part 1 — Estimate k
%[text] At $t = 0$ the coffee is at 90 °C and cooling at 0.7 °C/min. Substituting into the ODE:
%[text] $$$-0.7 = -k\\,(90 - 20) \\quad \\Longrightarrow \\quad k = \\frac{0.7}{70} = 0.01\\ \\mathrm{min}^{-1}$
%[text] Define the initial condition:
y0 = 90;   % initial coffee temperature (deg C)
%%
%[text] ## Part 2 — Define the Rate Function
%[text] Write a **local function** named `coffee_rate` at the bottom of this file (after the `%[appendix]` line). The function must accept `(t, y)` in that order — `ode45` always passes time as the first argument even when the ODE does not depend on it. Define `k` and `theta_e` inside the function body.
function dydt = coffee_rate(t, y)
    k       = 0.01;   % heat-transfer coefficient (min^-1)
    theta_e = 20;     % room temperature (deg C)
    dydt    = -k * (y - theta_e);
end
%[text] Test the function by calling it directly with the initial conditions:
rate_check = coffee_rate(0, y0)
%[text] The result should be approximately **−0.70 °C/min**.
%%
%[text] ## Part 3 — Solve with ode45
%[text] Pass a handle to `coffee_rate` to `ode45` to solve the ODE from $t = 0$ to $t = 100$ minutes.
tspan = [0, 100];
[t, y] = ode45(@coffee_rate, tspan, y0);
%%
%[text] ## Part 4 — Plot the Results
%[text] Plot coffee temperature vs. time. Notice that the curve drops steeply at first and flattens out — the cooling rate at any moment is proportional to how far the coffee is above room temperature.
%[text] Add a horizontal reference line at 50 °C so you can visually estimate the wait time. Include axis labels with units.
figure(1)
clf()
plot(t, y, 'b-', 'LineWidth', 1.5)
hold on
yline(50, 'r--', '50 °C threshold')
xlabel('Time (min)')
ylabel('Temperature (°C)')
title('Coffee Cooling — Newton''s Law of Cooling')
grid on
hold off
%%
%[text] ## Part 5 — Find and Report the Wait Time
%[text] Use `find` to locate the first time step where the temperature reaches 50 °C or below, then report the result with `fprintf`.
idx = find(y <= 50, 1);
fprintf('Coffee reaches %.1f deg C at t = %.1f min\n', y(idx), t(idx))
%[text] **Reflect:** the constant-rate estimate predicted about **57 minutes**. Is the ODE answer shorter or longer? Explain why that result makes physical sense given how Newton's Law of Cooling works.
%[text] Once everything works and all cells show successful output, save the live script and submit **coffee.m** via Sakai.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
