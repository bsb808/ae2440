%[text] # Function Handles and Zero-Finding
%%
%[text] ## Function Handles
%[text] A **function handle** is a reference to a function stored in a variable. It lets you pass a function as an argument to another function — the foundation of MATLAB's solver-based workflow.
func_handle = @sin;
class(func_handle)
result = func_handle(pi/2)
%%
%[text] ## Plotting with fplot
%[text] `fplot(f, [xmin xmax])` plots `y = f(x)` over an interval — a natural first payoff for function handles.
figure
clf()
fplot(@sin, [-2*pi, 2*pi], 'r')
hold on
fplot(@cos, [-2*pi, 2*pi], 'b')
legend('sin', 'cos')
hold off
%%
%[text] ## The Solver-Based Workflow
%[text] MATLAB solvers separate **what to do** (the algorithm) from **what to do it to** (your model). You define the engineering model as a function, pass a handle to the solver, and the solver takes it from there.
%[text] The same pattern appears across many MATLAB tools:
%[text:table]
%[text] | Task | Solver | Call |
%[text] | --- | --- | --- |
%[text] | Find a zero | `fzero` | `fzero(@model, x0)` |
%[text] | Minimize a function | `fminbnd` | `fminbnd(@model, a, b)` |
%[text] | Solve an ODE | `ode45` | `ode45(@model, tspan, y0)` |
%[text:table]
%%
%[text] ## Engineering Example — Newton's Law of Cooling
%[text] The exact solution to Newton's Law of Cooling gives temperature as a function of time:
%[text] $y(t) = \\theta\_e + (y\_0 - \\theta\_e)\\,e^{-kt}$
%[text] A cup of coffee starts at 90 °C with $k = 0.01$ min$^{-1}$ and $\\theta\_e = 20$ °C. **When does it reach 50 °C?**
%[text] Define a local function for the model. The **zero** of this function is the answer:

function f = coffee_cooling(t)
    k       = 0.01;
    theta_e = 20;
    y0      = 90;
    f = theta_e + (y0 - theta_e)*exp(-k*t) - 50;
end

%[text] Visualize the function first — a good habit before calling any solver. The zero crossing shows roughly where the answer lies.
figure
clf()
fplot(@coffee_cooling, [0 150])
yline(0, 'r--')
xlabel('Time (min)')
ylabel('y(t) - 50  (deg C)')
title('Newton''s Law of Cooling — offset from 50 °C')
grid on
%%
%[text] Pick an initial guess from the plot, then pass the model to `fzero`:
x0   = 50;
%[text] Check to see how close the initial solution is to yielding a zero?
initialsoln = coffee_cooling(50)
%%
%[text] Now apply solver.
root = fzero(@coffee_cooling, x0)
fprintf('Coffee reaches 50 deg C at t = %.1f min\n', root)
%%
%[text] Check to verify that the solution is a root of the function:
check = coffee_cooling(root)
%%
%[text] ### Verbose Output
%[text] `fzero` can return additional information — exit status, function value at the root, and solver diagnostics — as output arguments:
[x, fval, exitflag, output] = fzero(@coffee_cooling, x0)
%%
%[text] ### Controlling the Algorithm
%[text] An `options` structure (built with `optimset`) lets you tune solver behavior. Setting `Display` to `'iter'` prints each iteration so you can watch the algorithm converge:
options = optimset('Display', 'iter')
root = fzero(@coffee_cooling, x0, options)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
