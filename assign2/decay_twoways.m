%[text] # Approximating a Continuous Model and Simulating a Discrete Model
%[text] A general-purpose model of many phenomena is **first-order decay**. This model arises from a first-order ordinary differential equation (ODE):
%[text] $\\frac{dy}{dt} = -k \\, y(t)$
%[text] where \\$y(t)\\$ is the quantity that decays over time (e.g.\\ temperature), and \\$k\\$ is the constant decay rate. For example, this model can predict the cooling of a hot object over time.
%[text] We will generate and display the response of this model in two different ways --- both are useful in different contexts.
%[text] ## Part 1: Visualizing the Analytical Solution
%[text] %---------------------------------------------------------------
%[text] \\section\*{Part 1: Visualizing the Analytical Solution}
%[text] %---------------------------------------------------------------
%[text] 
%[text] The analytical solution to this ODE is:
%[text] 
%[text] \\begin{equation}
%[text]     y(t) = y\_0 \\, e^{-kt}
%[text] \\end{equation}
%[text] 
%[text] where \\$y\_0 = 20\\$~\\textdegree C is the starting temperature above room temperature, and \\$k = 2~\\text{s}^{-1}\\$ controls how fast it cools.
%[text] 
%[text] This equation is a \\textbf{continuous-time function} --- it is defined for every value of \\$t\\$. To visualize it, we evaluate \\$y(t)\\$ at a large number of discrete time points and plot the results.
%[text] 
%[text] \\textbf{Instructions:}
%[text] \\begin{enumerate}
%[text]     \\item Use \\texttt{linspace} to create a time vector \\texttt{t} of 100 points from \\$t = 0\\$ to \\$t = 4\\$ seconds.
%[text]     \\item Compute the vector \\texttt{y} using the formula above. MATLAB will evaluate the formula at every point in \\texttt{t} automatically.
%[text]     \\item Plot \\texttt{y} vs \\texttt{t}. Label the axes and add a title.
%[text] \\end{enumerate}
%[text] 
%[text] \\begin{lstlisting}\[style=matlab\]
%[text] % Define parameters
%[text] 
%[text] 
%[text] % Create time vector
%[text] 
%[text] 
%[text] % Compute analytical solution
%[text] 
%[text] 
%[text] % Plot
%[text] 
%[text] 
%[text] \\end{lstlisting}
%[text] 
%[text] %---------------------------------------------------------------
%[text] \\section\*{Part 2: Solution via Discrete-Time Approximation}
%[text] %---------------------------------------------------------------
%[text] 
%[text] In Part~1 we could solve the ODE analytically, but for many real engineering problems an analytical solution does not exist. In those cases, we approximate the solution by stepping forward in time using only the value from the \\textbf{previous} time step.
%[text] 
%[text] This is called a \\textbf{discrete-time approximation}, and it is described by the following difference equation:
%[text] 
%[text] \\begin{equation}
%[text]     y\[n\] = y\[n-1\] \\cdot \\left(1 - k \\,\\Delta t\\right)
%[text] \\end{equation}
%[text] 
%[text] where \\$y\[n\]\\$ is the value at the \\$n\\$-th time step, \\$y\[n-1\]\\$ is the value at the previous time step, and \\$\\Delta t\\$ is the time between steps.
%[text] 
%[text] \\textbf{Instructions:}
%[text] \\begin{enumerate}
%[text]     \\item Set the parameters: \\$y\_0 = 20\\$, \\$k = 2\\$, \\$\\Delta t = 0.04\\$~s, and \\$N = 100\\$ steps.
%[text]     \\item Pre-allocate a vector \\texttt{y} of length \\$N\\$ using \\texttt{zeros}.
%[text]     \\item Set \\texttt{y(1) = y0} as the initial condition.
%[text]     \\item Write a \\texttt{for} loop from \\texttt{n = 2} to \\texttt{N} that computes each element using the difference equation above.
%[text]     \\item Create a time vector \\texttt{t} using \\texttt{linspace}, starting at \\$0\\$ and ending at \\$(N-1)\\cdot\\Delta t\\$.
%[text]     \\item Plot \\texttt{y} vs \\texttt{t} using circle markers (\\texttt{'o'}). Label the axes and add a title.
%[text] \\end{enumerate}
%[text] 
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
