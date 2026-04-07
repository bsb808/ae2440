%[text] # Example: Array Math and Vector Iteration
%[text] ## Context
%[text] Newton's Law of cooling is a physical model that has proven to be useful to predict the dynamics of an object's temperature, $T$, as the object cools or warms toward and ambient temperature $T\_{\\text{env}}$.
%[text] The model is a first-order differential equation:
%[text]{"align":"center"} $\\frac{dT}{dt}=-k \\, (T-T\_{\\text{env}})$    (1)
%[text] where $k$ is the constant, positive cooling rate.
%[text] The solution to this ODE is
%[text]{"align":"center"} $T(t) = T\_{\\text{env}} + (T\_0 - T\_{\\text{env}})\\,e^{-kt}$      (2)
%[text] To make this example specific, let's image the following example:
%[text] - A strong HVAC system for a classroom would have a heating constant of $k = 0.10 \\, \\text{min}^{-1$
%[text] - The classroom starts at $T\_0 =$10 $^o \\text{C}$ and his heated to $T\_{\\text{env}} = 20 \\, ^o \\text{C$ \
Tenv = 20;
T0 = 10;
k = 0.1;
%%
%[text] ## Exercise: Incrementally evaluate solution
%[text] Evaluate the solution, $T(t)$, for a set of time values by iterating through each time value, solving the equation (2) and adding a point to a plot.
%[text] Create a vector of time values from 0 -- 60 minutes where each element is 0.1 min larger than the previous.
tt = 0:0.1:60
%[text] Create a `for` loop that iterates through each element in the `tt` vector.  For each iteration, calculate the value of $T(t)$ and add the new value to a 2d plot of time vs temperature.
figure(1);
clf()
for ii = 1:length(tt)
    time = tt(ii);
    temp = 
    plot...


end
xlabel("Time [min]")
ylabel("Temperature [C]")
%%
%[text] ## Exercise: Array arithmetic to evaluate solution
%[text] Use Array Operations to operate element-wise over the entire time vector, $tt$, with a single line that yields a new vector, $TT$, that his the same size as $tt$ and stores the value for $T(t) $ for each element of the time vector
%[text] $T(t) = T\_{\\text{env}} + (T\_0 - T\_{\\text{env}})\\,e^{-kt}$ 
tt = linspace(0, 60, 1000);
TT = Tenv + (T0 - Tenv)*exp(-k*tt)
%[text] And then plot both time and temperature vectors with a single plot command
figure(2)
plot(tt,TT, 'o--')
xlabel("Time [min]")
ylabel("Temperature [C]")
%%
%[text] ## Exercise: Numerical approximation
%[text] So far, we have used the close-form solution provided in equation (2).   Another method is to approximate this solution with a *difference equation*, which is equivalent to defining a *sequence*: 
%[text] $T\_{n+1} = T\_n - k \\,(T\_n - T\_{\\text{env}})\\,\\Delta t$
%[text] $t\_{n+1} = t\_n + \\Delta t$
%[text] Start with our initial values for time and temperature
t = 0;
T = T0;
%[text] Create a `for` loop to iterate 600 times.  Each time recalculate values for `t` and `T` using $\\Delta t = 0.1$min.
figure(3)
clf();
Dt = 0.1;
N = 600;
t_vec = zeros(1,N);
temp_vec = [];
for ii = 1:N
    % Storage
    t_vec(ii) = t;
    temp_vec(ii) = T;
    % Sequence
    t = t + Dt;
    T = T - k * (T - Tenv)*Dt;
    
end

plot(t_vec, temp_vec)
xlabel("Time [min]")
ylabel("Temperature [C]")

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":19.6}
%---
