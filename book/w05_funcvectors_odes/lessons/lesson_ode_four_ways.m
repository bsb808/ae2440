%[text] # One ODE, Four Ways
%[text] In `lesson_ode_intro.m` we modeled a cooling cup of coffee with Newton's law of cooling and solved it with Euler's method and `ode45`. Here we solve the same equation four different ways and compare what each one gives us:
%[text] 1. Analytical: solve with pen and paper, then use MATLAB to evaluate and plot the formula
%[text] 2. Symbolic: let the Symbolic Math Toolbox (`dsolve`) do the pen-and-paper work
%[text] 3. Numerical: cast the problem in state-space form and hand it to `ode45`
%[text] 4. Chebfun: write the equation almost as you would on paper, and let Chebfun solve it numerically to near machine precision \
%%
%[text] ## The Problem
%[text] A cup of coffee starts at 90 °C in a 20 °C room. The rate of cooling is proportional to the temperature difference:
%[text] $\\frac{dy}{dt} = -k\\,(y - \\theta\_e), \\quad y(0) = y\_0$
%[text] with $k = 0.01$ min$^{-1}$, $\\theta\_e = 20$ °C and $y\_0 = 90$ °C. We look at the first 200 minutes.
k       = 0.01;     % Cooling constant [1/min]
theta_e = 20;       % Room temperature [deg C]
y0      = 90;       % Initial temperature [deg C]
tspan   = [0, 200]; % Time interval [min]
%%
%[text] ## 1. Analytical Solution (Pen and Paper)
%[text] The equation is separable. Substitute $u = y - \\theta\_e$, so that $du/dt = dy/dt$ and the ODE becomes
%[text] $\\frac{du}{dt} = -k\\,u$
%[text] Separate the variables and integrate both sides:
%[text] $\\int \\frac{du}{u} = -k \\int dt \\quad \\Rightarrow \\quad \\ln|u| = -kt + C \\quad \\Rightarrow \\quad u(t) = A\\,e^{-kt}$
%[text] The initial condition fixes the constant: $u(0) = y\_0 - \\theta\_e = A$. Substituting back for $y$:
%[text] $y(t) = \\theta\_e + (y\_0 - \\theta\_e)\\,e^{-kt}$
%[text] MATLAB's job here is only arithmetic: evaluate the formula at many time samples and plot. A function handle keeps the formula in one place so we can reuse it as the reference solution later.
y_exact = @(t) theta_e + (y0 - theta_e)*exp(-k*t);
tt = linspace(tspan(1), tspan(2), 500);
figure(1)
clf()
plot(tt, y_exact(tt), 'k-', 'LineWidth', 2)
xlabel('Time (min)')
ylabel('Temperature (deg C)')
title('Analytical solution')
grid on
%[text] What you get: a formula. It is exact, and it shows structure (an exponential decay toward $\\theta\_e$ with time constant $1/k = 100$ min) that no table of numbers shows as plainly. The catch is that you must be able to solve the equation by hand, which most real models do not allow.
%%
%[text] ## 2. Symbolic Math Toolbox
%[text] Yes, the Symbolic Math Toolbox can solve simple ODEs. `dsolve` does the separation and integration for us. Declare $y$ as a symbolic function of $t$, write the equation with `==`, and pass the initial condition as a second equation:
syms y(t)
ode  = diff(y, t) == -k*(y - theta_e);
cond = y(0) == y0;
y_sym = dsolve(ode, cond)
%[text] The result is a symbolic expression, the same formula we found by hand (MATLAB may write it in a different but equivalent form). To plot it, either use `fplot`, which understands symbolic expressions, or convert it to an ordinary numeric function handle with `matlabFunction`:
y_sym_func = matlabFunction(y_sym);
figure(2)
clf()
fplot(y_sym, tspan, 'b-', 'LineWidth', 2)
xlabel('Time (min)')
ylabel('Temperature (deg C)')
title('Symbolic solution (dsolve)')
grid on
%[text] Symbolic parameters work too, which reproduces the general pen-and-paper result rather than one numeric case:
syms kk th yy0 real
y_general = dsolve(diff(y, t) == -kk*(y - th), y(0) == yy0)
%[text] What you get: a formula, without the algebra. The limits are the same as for pen and paper. `dsolve` handles linear and textbook nonlinear equations; for most nonlinear models it returns an empty result or a warning that no explicit solution was found.
%%
%[text] ## 3. Numerical Solver: State-Space Form and ode45
%[text] This is the approach we focus on in this course, because it works for nearly any model. Every MATLAB ODE solver expects the problem in first-order state-space form:
%[text] $\\dot{\\mathbf{x}} = \\mathbf{f}(t, \\mathbf{x}), \\quad \\mathbf{x}(0) = \\mathbf{x}\_0$
%[text] The state $\\mathbf{x}$ is the smallest set of variables that, together with the inputs, determines the future of the system. For the coffee cup the state is a single number, the temperature, so $\\mathbf{x} = y$ and
%[text] $f(t, x) = -k\\,(x - \\theta\_e)$
%[text] Casting the problem means writing $f$ as a function with the signature `dxdt = f(t, x)`. Here an anonymous function captures the parameters `k` and `theta_e` from the workspace:
f = @(t, x) -k*(x - theta_e);
[t_ode, y_ode] = ode45(f, tspan, y0);
figure(3)
clf()
plot(tt, y_exact(tt), 'k--', 'LineWidth', 2, 'DisplayName', 'Exact')
hold on
plot(t_ode, y_ode, 'bo-', 'DisplayName', 'ode45')
xlabel('Time (min)')
ylabel('Temperature (deg C)')
title('Numerical solution (ode45)')
legend()
grid on
%[text] What you get: vectors of numbers, `t_ode` and `y_ode`, at time steps the solver chose for itself. There is no formula, and the answer is accurate only to the solver's tolerance (the default relative tolerance is $10^{-3}$). In exchange, the same three lines solve models with many states, nonlinearities, and inputs measured from data, where options 1 and 2 have nothing to offer. A higher-order model, such as a mass on a spring, is handled by making $\\mathbf{x}$ a vector (position and velocity); nothing else about the call changes.
%%
%[text] ## 4. Chebfun
%[text] Chebfun is an open-source MATLAB package that works with *functions* the way MATLAB works with vectors. It overloads familiar commands (`plot`, `diff`, `sum`, `max`, `roots`, `\`) so that they act on functions, which makes the code read like symbolic math. Under the hood each function is a Chebyshev polynomial approximation accurate to about 15 digits, so the computation is numerical and fast.
%[text] Chebfun is not part of MATLAB. Download it from chebfun.org (or clone it from GitHub) and add the folder to your path, for example `addpath('~/chebfun')`.
assert(~isempty(which('chebfun')), 'Chebfun is not on the MATLAB path. Use addpath to add the chebfun folder.')
%[text] ### Chebfun as a symbolic-looking calculator
%[text] First, use Chebfun on the analytical answer from option 1. The variable `tc` is not a vector of samples; it is the function $t$ on the interval $[0, 200]$. Ordinary MATLAB expressions in `tc` produce new functions:
tc = chebfun('t', tspan);
y_cheb_formula = theta_e + (y0 - theta_e)*exp(-k*tc);
%[text] Calculus works on the result directly. Here we check that the formula really satisfies the ODE: the residual $y' + k(y - \\theta\_e)$ should be zero everywhere on the interval.
residual = diff(y_cheb_formula) + k*(y_cheb_formula - theta_e);
max_residual = norm(residual, inf)
%[text] ### Solving the ODE with a chebop
%[text] To solve the ODE without knowing the answer, Chebfun uses a `chebop`, an operator on functions. Write the equation in the form $\\mathcal{N}(y) = 0$, give the domain and the initial condition, and solve with backslash, just as you would solve a linear system `A\b`:
N = chebop(tspan(1), tspan(2));
N.op  = @(t, y) diff(y) + k*(y - theta_e);
N.lbc = y0;     % left boundary condition: y(0) = y0
y_cheb = N\0
%[text] The result `y_cheb` is again a chebfun, a function you can evaluate anywhere, differentiate or integrate, not a list of samples. For example, when does the coffee reach 50 °C? Chebfun finds the root of $y(t) - 50$ directly:
t_50 = roots(y_cheb - 50)
%[text] Compare with the analytical answer, $t = \\frac{1}{k}\\ln\\frac{y\_0 - \\theta\_e}{50 - \\theta\_e}$:
t_50_exact = log((y0 - theta_e)/(50 - theta_e))/k
figure(4)
clf()
plot(y_cheb, 'm-', 'LineWidth', 2)
hold on
plot(t_50, 50, 'ko', 'MarkerFaceColor', 'k')
xlabel('Time (min)')
ylabel('Temperature (deg C)')
title('Chebfun solution (chebop)')
grid on
%[text] What you get: a function, computed numerically, that you can treat almost like a formula. Note that `plot(y_cheb)` needed no time vector. Chebfun's ODE solvers handle nonlinear equations and boundary-value problems as well; for initial-value problems it calls MATLAB's own solvers internally and then converts the result to a chebfun.
%%
%[text] ## Comparing the Four
%[text] All four solutions on one plot are indistinguishable by eye:
figure(5)
clf()
plot(tt, y_exact(tt), 'k-', 'LineWidth', 4, 'DisplayName', 'Analytical')
hold on
plot(tt, y_sym_func(tt), 'y--', 'LineWidth', 2, 'DisplayName', 'Symbolic (dsolve)')
plot(t_ode, y_ode, 'bo', 'DisplayName', 'ode45')
plot(y_cheb, 'm:', 'LineWidth', 2, 'DisplayName', 'Chebfun (chebop)')
xlabel('Time (min)')
ylabel('Temperature (deg C)')
legend()
grid on
%[text] The differences show up in the error against the analytical solution. The symbolic solution is the same formula, so its error is exactly zero and cannot appear on a log axis. For the two numerical methods a logarithmic axis is needed because their errors differ by many orders of magnitude:
err_ode  = abs(y_ode - y_exact(t_ode));
err_cheb = abs(y_cheb(tt) - y_exact(tt));
figure(6)
clf()
semilogy(t_ode, err_ode, 'bo-', 'DisplayName', 'ode45')
hold on
semilogy(tt, err_cheb, 'm-', 'DisplayName', 'Chebfun')
xlabel('Time (min)')
ylabel('|error| (deg C)')
title('Error relative to the analytical solution')
legend('Location', 'best')
grid on
%[text] With default tolerances `ode45` is off by about $10^{-5}$ °C, which is plenty for coffee and can be tightened with `odeset('RelTol', ...)`. Chebfun is off by about $10^{-12}$ °C: it asks MATLAB's solver for much tighter tolerances and then represents the answer as a smooth polynomial.
%[text:table]
%[text] |  | Analytical | Symbolic | ode45 | Chebfun |
%[text] | --- | --- | --- | --- | --- |
%[text] | Who solves it | You | MATLAB, symbolically | MATLAB, numerically | MATLAB, numerically |
%[text] | Result | Formula | Formula | Vectors `t`, `y` | Function object |
%[text] | Accuracy | Exact | Exact | Set by tolerances ($10^{-5}$ here) | About 12 places ($10^{-12}$ here) |
%[text] | Works for | Simple ODEs | Simple ODEs | Nearly any ODE | Most ODEs on an interval |
%[text] | Needs | Pen, paper, practice | Symbolic Math Toolbox | Core MATLAB | Chebfun package |
%[text:table]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
