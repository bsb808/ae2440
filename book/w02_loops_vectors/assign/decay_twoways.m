%[text] # Approximating a Continuous Model and Simulating a Discrete Model
%[text] A general-purpose model of many phenomena is **first-order decay**. This model arises from a first-order ordinary differential equation (ODE):
%[text]{"align":"center"} $\\frac{dy}{dt} = -k \\, y(t)$
%[text] where$y(t)$ is the quantity that decays over time (e.g. temperature), and $k$ is the constant decay rate. For example, this model can predict the cooling of a hot object over time.
%[text] We will generate and display the response of this model in two different ways --- both are useful in different contexts.
%[text] ## Part 1: Visualizing the Analytical Solution
%[text] The analytical solution to this ODE is:
%[text] $y(t) = y\_0 \\, e^{-kt}$
%[text] where $y\_0 = 20$ C is the starting temperature above room temperature, and $k = 2\~\\text{s}^{-1}$ controls how fast it cools (the time constant is $\\tau = 1/k = 0.5 \\, \\text{s}$.
%[text] This equation is a *continuous-time function* --- it is defined for every value of $t$. To visualize it, we evaluate $y(t)$ at a large number of discrete time points and plot the results.
%[text] In the code block below, complete the following:
%[text] 1. Use `linspace` to create a time vector variable named `tt` of 100 points from t = 0 to t = 4 seconds.
%[text] 2. Compute the vector `yy` using the formula above. MATLAB will evaluate the formula at every point using element-wise or array operations (see [array vs matrix operations](https://www.mathworks.com/help/matlab/matlab_prog/array-vs-matrix-operations.html))
%[text] 3. Plot the `yy` vector vs the `tt` vector. Label the axes and add a title. \
% Define parameters


% Create time vector


% Compute analytical solution vector


% Plot
%[text] 
%[text] ### Part 2: Solution via Discrete-Time Approximation
%[text] In Part 1 we could solve the ODE analytically, but for many real engineering problems an analytical solution does not exist. In those cases, we approximate the solution by stepping forward in time using only the value from the previous time step.
%[text] This is called a *discrete-time approximation*, and it is described by the following difference equation:
%[text] $    y\[n\] = y\[n-1\] \\cdot \\left(1 - k \\,\\Delta t\\right)\n$
%[text] where $y\[n\]$ is the value at the N-th time step, $y\[n-1\]$is the value at the previous time step, and $\\Delta t$ is the time between steps.
%[text] Instructions:
%[text] 1. Set the parameters: `y0 = 20,` `k = 2`, `dt = 0.04`, and `N = 100` steps.
%[text] 2. Set the first element of a new vector, `yyy` as the initial condition:  `yyy(1) = y0` as the initial condition.
%[text] 3. Write a `for` loop from `n = 2` to `N` that computes each element using the difference equation above.
%[text] 4. Create a time vector `ttt` using `linspace`, starting at `0` and ending at `N-1*dt.`
%[text] 5. On the same axes as Part 1, plot `yyy` vs `ttt` using circle markers ('o'). Add a legend to label the continuous (analytical) and the discrete (numerical) solutions. \
% Your code goes here.
%[text] 
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
