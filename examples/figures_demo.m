%[text] # Figures in Live Scripts: Best Practices
%[text] This demo walks through common patterns and pitfalls when creating 2D plots inside MATLAB live scripts.  Live scripts display output *inline*, which changes how figures behave compared to traditional `.m` scripts.
%%
%[text] ## Start Every Script with `clear` and `close all`
%[text] `clear` removes all variables from the workspace.  `close all` closes any figure windows that may be open from a previous run.  Without these, leftover state from a prior run can contaminate your results — a plot from the last run may still be "live" and accept new data unintentionally.
clear
close all
%[text] **Rule:** Put `clear` and `close all` at the very top of every script.
%%
%[text] ## A Basic 2D Plot
%[text] Always:
%[text] 1. Open a numbered figure with `figure(N)`.
%[text] 2. Clear it with `clf()` before drawing.
%[text] 3. Add axis labels and a title. \
%[text] `figure(1)` creates or raises Figure 1. `clf()` wipes any existing content so you start with a blank canvas.  Without `clf()`, re-running the section appends to whatever is already there.
x = linspace(0, 2*pi, 200);
y_sin = sin(x);

figure(1);
clf();
plot(x, y_sin)
xlabel('x [rad]')
ylabel('y')
title('Sine Wave')
grid('on')

%%
%[text] ## Overlaying Plots with `hold on`
%[text] To draw multiple curves on one set of axes, call `hold on` *after* the first `plot`.  Every subsequent `plot` call then adds to the same axes instead of replacing them.  Call `hold off` when you are done overlaying (or let `clf()` reset it on the next run).
%[text] 
%[text] **Important for live scripts:** Keep all the code that builds a single figure *within one section*.  If you split a `hold on` sequence across a `%%` section break, the inline output area is split too and the figure may render in pieces or appear duplicated.
y_cos = cos(x);
y_tan_clip = max(min(tan(x), 3), -3);   

figure(2);
clf();
plot(x, y_sin, 'b-',  'LineWidth', 1.5, 'DisplayName', 'sin(x)')
hold on
plot(x, y_cos, 'r--', 'LineWidth', 1.5, 'DisplayName', 'cos(x)')
plot(x, y_tan_clip, 'g:', 'LineWidth', 1.5, 'DisplayName', 'tan(x) [clipped]')
hold off

xlabel('x [rad]')
ylabel('y')
title('Trig Functions')
legend('Location', 'northeast')
grid('on')

%%
%[text] ## What Goes Wrong Without `clf()`
%[text] Run the cell below *twice* in a row and watch what happens to Figure 3.  The second run adds another sine wave on top of the first one instead of replacing it because `hold on` is still active from the previous run.
%[text] This is one of the most common sources of confusion in live scripts.
figure(3);
% clf() intentionally omitted to demonstrate the problem
plot(x, sin(2*x), 'm-', 'LineWidth', 1.5)
hold on
xlabel('x [rad]')
ylabel('y')
title('Figure 3: re-run me without clf — watch the plot accumulate')
%%
%[text] ## Fix: Always Pair `figure(N)` with `clf()`
%[text] Replacing the section above with `clf()` makes it idempotent — it looks the same no matter how many times you re-run it.
figure(3);
clf();                              % <-- this makes re-runs safe
plot(x, sin(2*x), 'm-', 'LineWidth', 1.5)
xlabel('x [rad]')
ylabel('y')
title('Figure 3: now safe to re-run')
grid('on')
%%
%[text] ## Multiple Independent Figures in One Script
%[text] Use a different figure number for each independent plot.  Keep each figure's complete setup (from `figure(N); clf()` through the last formatting call) together in one section.
figure(4);
clf();
t = linspace(0, 10, 300);
plot(t, exp(-0.3*t) .* sin(5*t), 'k-', 'LineWidth', 1.5)
xlabel('Time [s]')
ylabel('Amplitude')
title('Damped Oscillation')
grid('on')

figure(5);
clf();
theta = linspace(0, 2*pi, 300);
plot(cos(theta), sin(theta), 'b-', 'LineWidth', 2)
axis('equal')
xlabel('x')
ylabel('y')
title('Unit Circle')
grid('on')
%%
%[text] ## Section Breaks to Control Rendering
%[text] A section break forces any pending figure output to render inline at that point.  This is useful when debugging or when you want to see an intermediate state of a plot before more data is added.
%[text] ### Example: All in one section
figure(4); clf;
% Plot the data - discrete points
tt = linspace(0, 10, 11);
plot(tt, exp(-0.3*tt) .* sin(5*tt)+0.1*randn(1,length(tt)), 'rs', ...
    "DisplayName", "Data")
hold on

%[text] **Note - no figure is created here!**
% Plot the model - continuous curve (approximated)
plot(t, exp(-0.3*t) .* sin(5*t), 'b-', 'DisplayName', 'Model')
legend('Location', 'northeast')
xlabel('Time [s]')
ylabel('Amplitude')
title('Damped Oscillation')
grid('on')
%%
%[text] ### Example: Section break to force rendering
figure(4); clf;
% Plot the data - discrete points
tt = linspace(0, 10, 11);
plot(tt, exp(-0.3*tt) .* sin(5*tt)+0.1*randn(1,length(tt)), 'rs', ...
    "DisplayName", "Data")
hold on
%[text] **Section break forces rendering**
%%
%[text] 
% Plot the model - continuous curve (approximated)
plot(t, exp(-0.3*t) .* sin(5*t), 'b-', 'DisplayName', 'Model')
legend('Location', 'northeast')
xlabel('Time [s]')
ylabel('Amplitude')
title('Damped Oscillation')
grid('on')
%%
%[text] ## Summary: Figure Best Practices
%[text:table]{"ignoreHeader":true}
%[text] | **Practice** | **Why** |
%[text] | --- | --- |
%[text] | `clear` + `close all` at top | Prevents leftover state from prior runs |
%[text] | `figure(N)` with a fixed number | Targets the same window consistently |
%[text] | `clf()` right after `figure(N)` | Guarantees a clean canvas every run |
%[text] | `hold on` / `hold off` within one section | Keeps the inline output together |
%[text] | All figure code in one section | Avoids split or duplicated inline output |
%[text] | Section breaks force rendering | Helpful in debugging to see the individual steps |
%[text] | Labels, title, legend, grid | Required for any figure you turn in |
%[text:table]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
