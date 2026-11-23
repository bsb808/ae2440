%[text] # Systems of First-Order ODEs
%[text] Many models have more than one quantity changing at once, and the rate of each one depends on the others. In this lesson we take the recipe we already know and generalize it by replacing the scalar $y$ with a *state vector* $\\mathbf{x}$. The solver does not change; only the shapes of its inputs and outputs do.
%%
%[text] ## Recap: One First-Order ODE
%[text] Newton's law of cooling from last week:
%[text]{"align":"center"} $\\frac{dy}{dt} = -k\\,(y - \\theta\_e), \\qquad y(0) = 90$
%[text] Solving it took four pieces: a rate function, an initial condition, a time span and a call to the solver.
function dydt = cooling_rate(t, y)
    % Parameters of the model
    k       = 0.01;   % Cooling constant [1/min]
    theta_e = 20;     % Room temperature [deg C]
    dydt = -k * (y - theta_e);
end
%[text] The initial condition and time span are scalars and a pair of times:
y0    = 90;         % Initial temperature [deg C]
tspan = [0, 200];   % [min]
[tt, yy] = ode45(@cooling_rate, tspan, y0);
size(yy)
%[text] The output `yy` is a column with one row for each time in `tt`.
%%
%[text] ## Generalize: Replace the Scalar with a Vector
%[text] For a system of $n$ coupled first-order ODEs, we collect the unknowns into a state vector $\\mathbf{x}(t)$ and write the whole model as one vector ODE:
%[text]{"align":"center"} $\\frac{d\\mathbf{x}}{dt} = \\mathbf{f}(t, \\mathbf{x}), \\qquad \\mathbf{x}(0) = \\mathbf{x}\_0$
%[text] This has the same form as the single ODE. Each piece of the recipe carries over, with a vector in place of a scalar:
%[text:table]
%[text] | Piece | Single ODE | System of $n$ ODEs |
%[text] | --- | --- | --- |
%[text] | Unknown | $y(t)$, a scalar | $\\mathbf{x}(t)$, an $n \\times 1$ **column** |
%[text] | Rate function | `dydt = f(t, y)` returns a scalar | `dxdt = f(t, x)` returns an $n \\times 1$ **column** |
%[text] | Initial condition | `y0`, a scalar | `x0`, an $n \\times 1$ column |
%[text] | Solver call | `[tt, yy] = ode45(@f, tspan, y0)` | `[tt, xx] = ode45(@f, tspan, x0)` |
%[text] | Output | `yy` is $N \\times 1$ | `xx` is $N \\times n$, **one column per state** |
%[text:table]
%[text] The one new decision is the *state vector convention*: which state goes in which position of $\\mathbf{x}$. 
%[text] The key is to define a state vector convention and be consistent throughout.  
%[text] 1. in the initial condition vector,
%[text] 2. inside the rate function, when unpacking the state and when packing the rates,
%[text] 3. when interpreting the columns of the solver output. \
%%
%[text] ## Example: Lotka-Volterra Predator-Prey Model
%[text] The Lotka-Volterra model from Chapter 11 describes a population of rabbits (prey) and foxes (predators):
%[text]{"align":"center"} $\\frac{dx}{dt} = a\\,x - b\\,x\\,y$
%[text]{"align":"center"} $\\frac{dy}{dt} = -c\\,y + d\\,x\\,y$
%[text] where $x(t)$ is the number of rabbits, $y(t)$ is the number of foxes, and the parameters are $a = 0.1$, $b = 0.01$, $c = 0.1$ and $d = 0.002$, with time in weeks. We start with 80 rabbits and 20 foxes and simulate 200 weeks.
%[text] The model is already given as first-order ODEs, and each rate depends only on time and the current populations. That is everything `ode45` needs.
%[text] ### Step 1: Define the state vector convention
%[text]{"align":"center"} $\\mathbf{x}(t) = \\left\\{ \\matrix{x(t) \\cr y(t)} \\right\\} = \\left\\{ \\matrix{\\mathrm{rabbits} \\cr \\mathrm{foxes}} \\right\\}$
%[text] ### Step 2: Write the model in vector form
%[text]{"align":"center"} $\\frac{d\\mathbf{x}}{dt} = \\left\\{ \\matrix{\\dot{x} \\cr \\dot{y}} \\right\\} = \\left\\{ \\matrix{a\\,x - b\\,x\\,y \\cr -c\\,y + d\\,x\\,y} \\right\\} = \\mathbf{f}(t, \\mathbf{x})$
%[text] ### Step 3: Implement the rate function
%[text] The rate function has the same signature as `cooling_rate`. The new work is to *unpack* the state vector into named variables and then *pack* the rates back into a column vector, both in the order set by our convention.
function dxdt = lotka_rate(t, xx)
    % Parameters of the model [1/week]
    a = 0.1;
    b = 0.01;
    c = 0.1;
    d = 0.002;
    % Unpack the state vector, following our convention
    rabbits = xx(1);   % x
    foxes   = xx(2);   % y
    % Rate of change of each state
    drabbits_dt = a*rabbits - b*rabbits*foxes;
    dfoxes_dt   = -c*foxes + d*rabbits*foxes;
    % Pack the rates into a column vector, in the same order
    dxdt = [drabbits_dt; dfoxes_dt];
end
%[text] ### Step 4: Set the initial condition and time span
%[text] The initial condition is now a column vector, ordered by our convention:
%[text]{"align":"center"} $\\mathbf{x}\_0 = \\left\\{ \\matrix{80 \\cr 20} \\right\\}$
xx0   = [80; 20];   % [rabbits; foxes]
tspan = [0, 200];   % [weeks]
%[text] Before handing the rate function to the solver, test it at the initial condition:
dxdt0 = lotka_rate(0, xx0)
%[text] Rabbits start falling by 8 per week and foxes start growing by 1.2 per week. Verify by a manual check:  $0.1(80) - 0.01(80)(20) = -8$ and $-0.1(20) + 0.002(80)(20) = 1.2$.
%[text] ### Step 5: Solve
%[text] The solver call is the same as for a single ODE:
[tt, xx] = ode45(@lotka_rate, tspan, xx0);
size(xx)
%[text] As before, each row of `xx` is one time in `tt`. Unpack the states the same way we did inside the rate function:
rabbits = xx(:,1);
foxes   = xx(:,2);
%%
%[text] ## Plot the Response
figure(1)
clf()
plot(tt, rabbits, 'LineWidth', 2, 'DisplayName', 'Rabbits')
hold on
plot(tt, foxes, '--', 'LineWidth', 2, 'DisplayName', 'Foxes')
xlabel('Time [weeks]')
ylabel('Population [animals]')
grid on
legend()
%[text] At first there are too many foxes for the rabbits to support, so the rabbit population falls. Then there are too few rabbits to feed the foxes, so the fox population falls, and the rabbits recover. The cycle of boom and bust repeats.
%[text] ### Phase plot
%[text] Since the two populations are the only states, each point in the rabbits–foxes plane is a complete description of the system at one instant. Plotting one column of `xx` against the other shows the path the state takes through that plane.
figure(2)
clf()
plot(rabbits, foxes, 'LineWidth', 2)
hold on
plot(xx0(1), xx0(2), 'ko', 'MarkerFaceColor', 'k')
xlabel('Rabbits [animals]')
ylabel('Foxes [animals]')
grid on
%[text] The closed loop says the system keeps returning to the same state, which is the repeating cycle we saw in the time series. The black dot is the initial condition.
%%
%[text] ## Verification
%[text] How do we know `ode45` is solving the model we wrote down, with the convention we chose?
%[text] - The first row of `xx` should equal `xx0`.
%[text] - The initial slopes of the time series should match `dxdt0`.
%[text] - Tightening the solver tolerance with `odeset('RelTol',1e-8,'AbsTol',1e-10)` should leave the solution essentially unchanged.
%[text] - A limiting case should match a result we know analytically. \
%[text] For the last check, remove the foxes. With $y = 0$ the rabbit equation becomes $\\dot{x} = a\\,x$, which has the exact solution $x(t) = x\_0\\,e^{a t}$ (exponential growth of pre), and the foxes should stay at zero.
[tt_check, xx_check] = ode45(@lotka_rate, [0, 20], [80; 0]);
rabbits_numerical = xx_check(end, 1)
rabbits_exact     = 80*exp(0.1*20)
max_foxes         = max(abs(xx_check(:, 2)))
%[text] Plot
figure();
clf()
plot(tt_check, xx_check(:,1), 'LineWidth', 2, 'DisplayName', 'Rabbits')
hold on
plot(tt_check, xx_check(:,2), '--', 'LineWidth', 2, 'DisplayName', 'Foxes')
xlabel('Time [weeks]')
ylabel('Population [animals]')
grid on
legend()
%%
%[text] ## Summary
%[text] - A system of first-order ODEs uses the same recipe as a single first-order ODE: rate function, initial condition, time span, solver call.
%[text] - The scalar $y$ becomes a column vector $\\mathbf{x}$. The rate function returns a column of the same length, and the solver returns one column per state.
%[text] - Write down the state vector convention first, then use it consistently in the initial condition, in the rate function and when reading the output.
%[text] - Next, in the higher-order ODEs lesson, the model is not handed to us as first-order ODEs. We build the first-order system ourselves, and the state vector convention is where that work starts. \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
