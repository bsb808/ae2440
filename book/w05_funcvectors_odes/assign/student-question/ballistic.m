%[text] # Ballistic Drop with Drag
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
%[text] - $b$ — drag coefficient (N·s/m) \
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
v_term = m*g/b     % terminal velocity (m/s) %[output:44135632]

%%
%[text] ## Part 2 — Rate Function
%[text] Write a local function `drop_rate` that evaluates the right-hand side of the ODE. The solver always passes time as the first argument, so the function must accept `(t, v)` even though this model does not depend on $t$ explicitly.
%[text] Test the function at $v = 0$: with no drag, the initial acceleration should equal $g = 9.81$ m/s$^2$.

function dvdt = drop_rate(t, v)
    % Your code here.
    b      = 10;
    m      = 50;
    g=9.81;
    dvdt = g - (b/m) * v;
    
end

rate_check = drop_rate(0, v0) %[output:908c5944]
%%
%[text] ## Part 3 — ode45 Solution
%[text] Use `ode45` to solve the ODE. The velocity should rise from zero and level off near the terminal velocity computed in Part 1.
% velocity does level out to 49.050 m/s after 88.187seconds
vterm=ode45(@drop_rate,0:100,v0) %[output:240ef3d9]
%%
%[text] ## Part 4 — Euler Solver
%[text] Create a new file named `euler.m` in the same directory as this script. This file contains a **primary function** — a standalone, reusable solver with the same interface as `ode45`:
%[text] `[tt, yy] = euler(odefun, tspan, y0)`
%[text] The Euler algorithm steps the solution forward using the slope at each point:
%[text] $y\_{k+1} = y\_k + dt \\cdot f(t\_k,\\, y\_k)$
%[text] Use a fixed step size $dt = (tspan(2) - tspan(1)) / 100$.
%[text] Once `euler.m` is saved and in the same directory, call it here with the same inputs used for `ode45`:
% Super lost here how do I build euler function and how do I call it here?
%[tt, yy] = euler(odefun, tspan, y0) call the function??
%euler=e_1(tt,yy)
%ye= euler_fun(tt,yy) %tried calling my function
%[tt, yy] = euler(rate_drop(t,y), tspan, y0) %Tspan is a start and stop time

%v=dvdt/(g-(b/m)) %solved for v to have MATLAB recognize it. but now does not understand dv on 2nd functioin.
%[tt, yy] = euler(drop_rate(t,v), tt, yy,t, y) % how do I get v term %recognized? It comes from a function.2nd function attempt
% function [tt, yy] = euler(odefun, tspan, y0)
% tspan=[0:30]
% dt=(tspan(2)-tspan(1))/100 %[tt,yy] is the solution as a vector
% tt=tspan(1); % I dont understand these do I need them?
% yy=y0; % Are they the initial values??
% for k=1:length(tt)-1
%     tnow=tt(k)
%     ynow=yy(k)
% tt    = tspan(end); 
% yy    = yy(end);
% ydot=odefun(tnow,ynow)
% %odefun=y0+dt*f(t,y);
% 
% yy(k+1)=yy(k)+ydot*dt
% end
[yy,tt]=euler(@drop_rate,tspan,v0) %[output:38783ab8] %[output:6c9e9852] %[output:0b5837bf] %[output:94c4b29f] %[output:56963c11]
%%
%[text] ## Part 5 — Compare Solutions
%[text] Plot both solutions on the same axes and add a horizontal reference line at $v\_t$. Both solvers should approach terminal velocity by the end of the time span.
%

%[text] Report the final velocity from each solver and compare to the terminal velocity.
%
%[text] **Reflect:** Do the two solvers agree? Does Euler lead or lag the ode45 solution during the transient phase — and why?
%[text] ADD A FEW WORDS OF TEXT HERE
%[text] Once everything runs successfully, submit both **ballistic.m** and **euler.m** via Sakai.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:44135632]
%   data: {"dataType":"textualVariable","outputData":{"name":"v_term","value":"49.0500"}}
%---
%[output:908c5944]
%   data: {"dataType":"textualVariable","outputData":{"name":"rate_check","value":"9.8100"}}
%---
%[output:240ef3d9]
%   data: {"dataType":"textualVariable","outputData":{"header":"struct with fields:","name":"vterm","value":"     solver: 'ode45'\n    extdata: [1×1 struct]\n          x: [0 2.0484e-05 1.2291e-04 6.3501e-04 0.0032 0.0160 0.0800 0.4001 2.0004 5.3133 9.2616 13.9602 19.5224 26.2109 34.4607 44.4607 54.4607 64.4607 74.4607 84.4607 94.4607 100]\n          y: [0 2.0095e-04 0.0012 0.0062 0.0313 0.1567 0.7787 3.7719 16.1735 32.1003 41.3532 46.0402 48.0578 48.7867 48.9965 49.0407 49.0484 49.0497 49.0500 49.0500 49.0500 49.0500]\n      stats: [1×1 struct]\n      idata: [1×1 struct]\n"}}
%---
%[output:38783ab8]
%   data: {"dataType":"textualVariable","outputData":{"name":"t0","value":"0"}}
%---
%[output:6c9e9852]
%   data: {"dataType":"textualVariable","outputData":{"name":"tf","value":"30"}}
%---
%[output:0b5837bf]
%   data: {"dataType":"textualVariable","outputData":{"name":"dt","value":"0.3000"}}
%---
%[output:94c4b29f]
%   data: {"dataType":"textualVariable","outputData":{"name":"t","value":"0"}}
%---
%[output:56963c11]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Unrecognized function or variable 'tt'.\n\nError in <a href=\"matlab:matlab.lang.internal.introspective.errorDocCallback('euler', 'E:\\Navy\\NPS\\MATLAB\\Assignments\\Assignment5\\euler.m', 7)\" style=\"font-weight:bold\">euler<\/a> (<a href=\"matlab: opentoline('E:\\Navy\\NPS\\MATLAB\\Assignments\\Assignment5\\euler.m',7,0)\">line 7<\/a>)\nfor k=1: length(tt)-1\n^^^^^^^^^^^^^^^^^^^^^"}}
%---
