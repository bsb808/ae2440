%[text] # Assignment 1: What We Saw
%[text] Short excerpts from this quarter's Assignment 1 submissions, anonymized and lightly edited, to illustrate the themes in the class summary. Some sections stop with an error on purpose; use **Run Section** (not Run All) to step through them one at a time.
%%
%[text] ## 1. File names are part of the interface
%[text] Five submissions missed full credit because of a file name alone. A few of the names we received, and the names the assignment asked for:
%[text:table]
%[text] | Submitted | Required |
%[text] | --- | --- |
%[text] | `Penny.m` | `penny.m` |
%[text] | `Pennywithair.m` | `pennywithair.m` |
%[text] | `pennywithhair.m` | `pennywithair.m` |
%[text] | `Bike_update.m` | `bike_update.m` |
%[text] | `pennydemo1.m` | `penny.m` |
%[text:table]
%[text] MATLAB treats `penny` and `Penny` as different names, and so does any script that calls your file. The Sakai preview step (download what you attached, open it) catches all of these.
%%
%[text] ## 2. Run from a clean workspace
%[text] This `aquarium.m` ran on the author's machine because `a` and `b` were already in the workspace from earlier work. From a clean workspace it stops on the second line. Run this section to see the error.
clear
w = 1.5
t = a       % depth of the top of the window, but a was never defined in this script
b = b       % b is "defined" as itself
%[text] The fix is to define every input in the script itself, near the top, with units:
a = 2;      % depth of the top of the window [m]
b = 3;      % height of the window [m]
w = 1.5;    % width of the window [m]
%[text] Habit: before submitting, type `clear` and then run the script.
%%
%[text] ## 3. Output is not code
%[text] One `pennywithair.m` ended with the output line copied back into the code. The saved file already showed the error under that line. Run this section to see it.
g = 9.8;
v_term = 18;
h = 381;
t1 = v_term/g;
t2 = (h - g*t1^2/2)/v_term;
totalTime = t1 + t2;
fprintf('Total fall time: %.2f seconds\n', totalTime)
Total fall time: 22.09 seconds
%[text] MATLAB reads the last line as a call to a function named `Total` with the text arguments `fall`, `time:`, and so on. The same file also repeated its whole calculation twice, a sign of pasting rather than editing.
%[text] A `bike_update.m` showed the same pattern at a larger scale: the update ran once, and then the results for each day were typed into the file by hand, where MATLAB would try to run them:
%[text] `leaving_m = round(0.05*m)`
%[text] `5`
%[text] `Day 1:`
%[text] `M=98`
%[text] `PG=102`
%[text] `Day 2:`
%[text] `...`
%[text] Live scripts already keep the output next to the code that made it, so there is no need to copy it anywhere. When you want to record a result, put it in a text block or a `%` comment.
%%
%[text] ## 4. Comments versus text blocks
%[text] Two `aquarium.m` files were live scripts that held only code and `%` comments. This one is clear and correct, and every value has units:
% Variables
w = 1.5;    % Width of aquarium window in m
a = 2;      % Distance from water's surface to top of window in m
b = 3;      % Height of window in m
p = 1000;   % Water density in kg/m^3
g = 9.81;   % Gravitational acceleration in m/s^2
% Math
Pa = p * g * a;                    % Pressure at top of window (N/m^2)
Pb = p * g * (a + b);              % Pressure at bottom of window (N/m^2)
P_avg = (Pa + Pb) / 2;             % Average pressure acting on window (N/m^2)
F = P_avg * (b * w) / 1000         % Total force acting on window (kN)
%[text] The assignment asked for the solution as alternating text and code, so a reader can follow the reasoning step by step. The same calculation as a live script:
%[text] The pressure at the top and bottom of the window grows linearly with depth:
%[text] $P\_A = \\rho g a, \\quad P\_B = \\rho g (a + b)$
rho = 1000;
Pa = rho*g*a;
Pb = rho*g*(a + b);
%[text] Because the load is linear, the resultant force is the average pressure times the window area:
%[text] $F = \\frac{P\_A + P\_B}{2}\\, b\\, w$
F = (Pa + Pb)/2 * b * w / 1e3    % [kN]
%[text] Text blocks hold the model (what and why), code holds the calculation (how). Comments are still the right place for units and short notes on a line.
%%
%[text] ## 5. Descriptive names and units
%[text] The assignment's example output shows `t` and `v`, but several of you chose clearer names: `time` and `velocity`, `v_impact`, `impactSpeed`. That is a good habit. One example, with units on each line and the equation in a text block:
%[text] $t = \\sqrt{\\frac{2h}{g}}$
h = 381;                 % [m], height of the building
g = 9.81;                % [m/s^2]
t = sqrt(2 * h / g);     % [s], free-fall time
impactSpeed = g * t      % [m/s], impact speed
%%
%[text] ## 6. g = 9.8 or 9.81?
%[text] Twelve of you used $g = 9.8$ m/s$^2$ and seven used $9.81$. How much does it matter here?
h = 381;
t98  = sqrt(2*h/9.8)
t981 = sqrt(2*h/9.81)
percent_difference = 100*(t98 - t981)/t981
%[text] About 0.05%, far smaller than the error in the model itself (no air resistance). The grading checks accept answers within 1% of the reference.
%%
%[text] ## 7. A model worth copying
%[text] From a `pennywithair.m` that wrote the model in two parts before computing anything (abridged):
%[text] Part 1: constant acceleration until terminal velocity. Time to reach terminal velocity and height at that time:
%[text] $t\_{\\mathrm{term}} = \\frac{v\_{\\mathrm{term}}}{g}, \\quad y\_1 = h - \\frac{1}{2} g\\, t\_{\\mathrm{term}}^2$
h = 381;          % [m]
g = 9.81;         % [m/s^2]
v_term = 18;      % [m/s]
t_term = v_term/g;
y_1 = h - g/2*t_term^2
%[text] Part 2: constant speed $v\_{\\mathrm{term}}$ from $y\_1$ to the ground:
%[text] $t = \\frac{y\_1}{v\_{\\mathrm{term}}}$
t = y_1/v_term;
t_total = t + t_term       % [s]
%%
%[text] ## 8. An update step versus a standalone script
%[text] The assignment's `bike_update.m` updates `m` and `pg` that already exist, so it can be called once per day from another script. Three submissions set the starting values inside the file instead:
m = 100;
pg = 100;
m_to_pg = round(0.05*m) - round(0.03*pg);
m = m - m_to_pg
pg = pg + m_to_pg
%[text] With the first two lines inside the file, every call starts over at 100 and 100, so calling it in a loop would never get past day 1. Keeping the initial values in the calling script is what lets the update step be reused, which we will build on with loops in Week 2.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
