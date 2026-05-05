%[text] # Optimization
%[text] In §cannon in the previous chapter you were asked to find the best launch angle for a human cannonball, meaning the angle that maximizes the distance traveled before landing. This kind of problem, finding minimums and maximums, is called *optimization*.
%[text] In this chapter, we'll solve a similar problem, finding the best launch angle for a baseball. We'll solve the problem two ways, first running simulations with a range of values and plotting the results, then using a MATLAB function that automates the process, `fminsearch`.
%%
%[text] ## Optimal Baseball
%[text] In the previous chapter we wrote functions to simulate the flight of a baseball with a known initial velocity. Now we'll use that code to find the launch angle that maximizes *range*, that is, the distance the ball travels before landing.
%[text] First, we need an event function to stop the simulation when the ball lands.
function [value, isterminal, direction] = event_landing(t, xx)
    % Event function for ode solver to trigger when vertical position
    % is zero
    value = xx(3);
    isterminal = 1;
    direction = -1;
end
%[text] This is similar to the event function we saw in Chapter §events, except that it uses `xx(3)` as the event value, which is the element of the state vector corresponding to the y-position. This event function stops the simulation when the altitude of the ball is 0 and falling.
%[text] Now we can call `ode45` like this:
% Initial conditions
xx_init = [0 30 1 40]';

% Solve with ode45
tspan = [0 10];
options = odeset('Events', @event_landing);
[tout, Xout] = ode45(@state_transition, tspan, xx_init, options);
%[text] The initial position of the ball is 1 m above home plate. The ball's initial velocity is 40 m/s in the $x$-direction and 30 m/s in the $y$-direction.
%[text] The maximum duration of the simulation is 10 s, but we expect an event to stop the simulation first. We can get the final values of the simulation like this:
tout(end)
Xout(end,:)
%[text] The final time is 5.9 s. The final $x$-position is 112 m; the final $y$-position is 0 m, as expected.
%[text] As we saw in Chapter §projectile, we can plot the *trajectory* the baseball from launch, on the left, to landing, on the right. This plot is repeated in Figure §f:baseball3
%[text] ![Simulated flight of a baseball plotted as a trajectory](../lessons/baseball2_xy.png)
%[text] *Figure: Simulated flight of a baseball plotted as a trajectory*
%%
%[text] ## Exhaustive Search: Range Versus Angle
%[text] Now we'll simulate the trajectory of the baseball with a range of launch angles. First, we'll take the code we have and wrap it in a function that takes the launch angle as an input variable, runs the simulation, and returns the distance the ball travels (Listing §lst:baseball_range).
%[text] **Listing.** A function that takes the launch angle of a baseball and returns the distance it travels
%[text] ```matlab
%[text] function res = baseball_range(theta)
%[text]     P = [0; 1];
%[text]     v = 50;
%[text]     [vx, vy] = pol2cart(theta, v);
%[text]
%[text]     V = [vx; vy];     % initial velocity in m/s
%[text]     W = [P; V];       % initial condition
%[text]
%[text]     tspan = [0 10];
%[text]     options = odeset('Events', @event_func);
%[text]     [T, M] = ode45(@rate_func, tspan, W, options);
%[text]
%[text]     res = M(end, 1);
%[text] end
%[text] ```
%[text] The launch angle, `theta`, is in radians. The magnitude of velocity, `v`, is always 50 m/s. We use `pol2cart` to convert the angle and magnitude (*polar* coordinates) to Cartesian components, `vx` and `vy`.
%[text] After running the simulation we extract the final $x$-position and return it as an output variable.
%[text] We can run this function for a range of angles like this:
    thetas = linspace(0, pi/2);
    for i = 1:length(thetas)
        ranges(i) = baseball_range(thetas(i));
    end
%[text] And then plot `ranges` as a function of `thetas`:
    plot(thetas, ranges)
%[text] Figure §fig:baseball4 shows the result. As expected, the ball does not travel far if it's hit nearly horizontal or vertical. The peak is apparently near 0.7 rad. This is an example of the most basic optimization technique, *exhaustive search*. In this case, it is computationally feasible to generate (almost) the entire solutions space, the full set of possible launch angles, and then simply select the best one.
%[text] ![Exhaustive search for maximum range using the Data tips graphical tool to choose the near-optimal solution](../lessons/range_exhaustive.png)
%[text] *Figure: Exhaustive search for maximum range using the \emph{Data tips} graphical tool to choose the near-optimal solution*
%[text] Considering that our model is only approximate, this result might be good enough. But if we want to find the peak more precisely, we can use `fminsearch`.
%%
%[text] ## fminsearch
%[text] The [`fminsearch`](https://www.mathworks.com/help/matlab/ref/fminsearch.html) function is similar to `fzero`, which we saw in Chapter §fzero. Recall that `fzero` takes a function handle and an initial guess, and it returns a root of the function. The `fminsearch` function uses this same interface to implement a nonlinear optimization to search for a value that minimizes the user-supplied function.
%[text] If we want to find the maximum of a function, rather than the minimum, we can still use `fminsearch` by writing a short function that negates the function we want to maximize. In the baseball example, the function we want to maximize is `baseball_range`; we can wrap it in another function like this:
function nrange = negative_range(theta)
% Return -1*range for use with function minimization
nrange = -1.0*baseball_range(theta);
end
%[text] And then we call `fminsearch` like this:
    % Inital estimate of solution
    theta0 = 0;
    % Optimization
    [x, fval] = fminsearch(@negative_range, theta0)
%[text] which would return
    x =
    0.8403
fval =
 -113.9392
%[text] The optimal launch angle for the baseball is 0.84 rad; launched at that angle, the ball travels almost 114 m.
%[text] If you're curious about how `fminsearch` works, see “§howfminsearch” on page §howfminsearch.
%%
%[text] ## Logical Errors
%[text] The `fminsearch` algorithm often does a great job of finding a local minimum for a wide range of non-linear function, but there are lots of ways that things can go wrong. This is a common issue with black-box solutions where the process of finding the solution is not clear. The best way to avoid these logical bugs—where the program is doing exactly what we told it, but still doesn't give the result we intended—is to peer into the black-box. We can do this by setting some options available in the `fminsearch` interface and looking at more of the outputs. Here is an example:
    % Optimization options
    options = optimset('Display','iter', ...
        'PlotFcns', {@optimplotx, @optimplotfval, @optimplotfunccount});
    % Call optimization
    [x, fval, exitflag, output] = fminsearch(@negative_range, theta0, options)
%[text] In the snippet above we use the [`optimset`](https://www.mathworks.com/help/matlab/ref/optimset.html) function to set parameters to values. This is a common idiom in MATLAB where parameters are specified by *Name* and *Value*. Here we are setting the parameter named `Dispay` to the string value `'iter'`. Then we set the parameter named `PlotFcns` to a cell array value with three function handles. The eclipses, `...`, tell MATLAB to continue the same command on the next line. We have also added two additional output variables so that the algorithm is more verbose, giving us both the solution and some information about the solution.
%[text] And here is what we get in return. The `Dispay='iter'` option results in the following output to the Command Window
%[text] ```text
%[text]     Iteration   Func-count     min f(x)         Procedure
%[text]      0            1         -14.0976
%[text]      1            2         -14.1229         initial simplex
%[text]      2            4         -14.1736         expand
%[text]      3            6         -14.2755         expand
%[text]      4            8         -14.4816         expand
%[text]      5           10         -14.9023         expand
%[text]      6           12         -15.7779         expand
%[text]      7           14          -17.663         expand
%[text]      8           16         -21.9205         expand
%[text]      9           18         -31.8432         expand
%[text]     10           20         -53.6809         expand
%[text]     11           22         -92.3186         expand
%[text]     12           24         -112.788         reflect
%[text]     13           26         -113.243         contract outside
%[text]     14           28         -113.923         contract inside
%[text]     15           30         -113.923         contract inside
%[text]     16           32         -113.927         contract inside
%[text]     17           34         -113.939         contract inside
%[text]     18           36         -113.939         contract inside
%[text]     19           38         -113.939         contract inside
%[text]     20           40         -113.939         contract inside
%[text]     21           42         -113.939         contract inside
%[text]     22           44         -113.939         contract inside
%[text]     23           46         -113.939         contract inside
%[text]     24           48         -113.939         contract inside
%[text]
%[text] Optimization terminated:
%[text]  the current x satisfies the termination criteria using OPTIONS.TolX of 1.000000e-04
%[text]  and F(X) satisfies the convergence criteria using OPTIONS.TolFun of 1.000000e-04
%[text] ```
%[text] This gives us some diagnostic information about each step in the optimization and tells us that the solution converged, which is a good sign.
%[text] Setting the `PlotFcns` option to the three built-in plotting functions, results in a new figure window as shown in Figure §f:opt_plot. If you are quick, you might notice that this plot is generated incrementally as the optimization iterates. This can be helpful for more computationally demanding scenarios that might take minutes or hours. Having some incremental status information helps.
%[text] ![Figure resulting from setting \\ 'PlotFcns' = @optimplotx, @optimplotfval, @optimplotfunccount](../lessons/opt_plot.png)
%[text] *Figure: Figure resulting from setting \\ \lstinline{'PlotFcns' = {@optimplotx, @optimplotfval, @optimplotfunccount}}*
%[text] The two additional output variables also help us make sure the answer we received is what we intended.
exitflag =
     1
output =
  struct with fields:

    iterations: 24
     funcCount: 48
     algorithm: 'Nelder-Mead simplex direct search'
       message: 'Optimization terminated: the current x satisfies the
       termination criteria using OPTIONS.TolX of 1.000000e-04
        and F(X) satisfies the convergence criteria using
        OPTIONS.TolFun of 1.000000e-04 '
%[text] The `exitflag` will be `1` when the solution converged, `0` when it exceeds the allowed number of iterations and `-1` if the search ended do to a user-defined exit criteria—similar to the event function we used with `ode45`. The `output` variable is a structure with fields to characterize the process.
%%
%[text] ## How fminsearch Works
%[text] According to the MATLAB documentation, `fminsearch` uses the Nelder-Mead simplex algorithm. You can read about it at <https://greenteapress.com/matlab/nelder>, but you might find it overwhelming.
%[text] To give you a sense of how it works, I will present a simpler algorithm, the *golden-section search*. Suppose we're trying to find the minimum of a function of a single variable, $f(x)$.
%[text] As a starting place, assume that we have evaluated the function at three places, $x\_1$, $x\_2$, and $x\_3$, and found that $x\_2$ yields the lowest value. Figure §fig:golden1 shows this initial state.
%[text] ![Initial state of a golden-section search](../../images/figure15_04_new.pdf)
%[text] *Figure: Initial state of a golden-section search*
%[text] We will assume that $f(x)$ is continuous and *unimodal* in this range, which means that there is exactly one minimum between $x\_1$ and $x\_3$.
%[text] The next step is to choose a fourth point, $x\_4$, and evaluate $f(x\_4)$. There are two possible outcomes, depending on whether $f(x\_4)$ is greater than $f(x\_2)$ or not. Figure §fig:golden2 shows the two possible states.
%[text] ![Possible states of a golden-section search after evaluating](../../images/figure15_05_new.pdf)
%[text] *Figure: Possible states of a golden-section search after evaluating $f(x_4)$*
%[text] If $f(x\_4)$ is less than $f(x\_2)$ (shown on the left), the minimum must be between $x\_2$ and $x\_3$, so we would discard $x\_1$ and proceed with the new triple $(x\_2, x\_4, x\_3)$.
%[text] If $f(x\_4)$ is greater than $f(x\_2)$ (shown on the right), the local minimum must be between $x\_1$ and $x\_4$, so we would discard $x\_3$ and proceed with the new triple $(x\_1, x\_2, x\_4)$.
%[text] Either way, the range gets smaller and our estimate of the optimal value of $x$ gets better.
%[text] This method works for almost any value of $x\_4$, but some choices are better than others. You might be tempted to bisect the interval between $x\_2$ and $x\_3$, but that turns out not to be the best choice. You can read about a better option at <https://greenteapress.com/matlab/golden>.
%%
%[text] ## Animation
%[text] Animation is a useful tool for checking the results of a physical model. If something is wrong, animation can make it obvious. There are two ways to do animation in MATLAB. One is to use `getframe` to capture a series of images and then use `movie` to play them back. This method is a bit involved, but allows you to generate a standalone video file, for example, a MP4 file.
%[text] The more informal way is to draw a series of plots. You may have seen this when MATLAB incrementally generated the plots in Figure §f:opt_plot Listing §lst:animate is a snippet that animates the results of a baseball simulation:
%[text] **Listing.** A snippet that animates the results of a baseball simulation
%[text] ```matlab
%[text]     % Animate
%[text]     % Solve with ode45
%[text]     tspan = [0 10];
%[text]     xx_init = [0 30 1 40];
%[text]     options = odeset('Events', @event_landing);
%[text]     [tout, Xout] = ode45(@state_transition, tspan, xx_init, options);
%[text]
%[text]     % Setup figure
%[text]     figure(4);
%[text]     clf();
%[text]     x = Xout(:,1);
%[text]     y = Xout(:,3);
%[text]     minmax = [min([x]), max([x]), min([y]), max([y])];
%[text]     % Plot each element in the solution
%[text]     for ii=1:round(length(tout)*4/5)
%[text]         clf;
%[text]         hold on;
%[text]         plot(x(1:ii), y(1:ii), 'b:')
%[text]         plot(x(ii), y(ii), 'ro')
%[text]         axis(minmax)
%[text]         xlabel('x position [m]')
%[text]         ylabel('y position [m]')
%[text]         drawnow;
%[text]         if ii < length(tout)
%[text]             dt = tout(ii+1) - tout(ii);
%[text]             pause(dt);
%[text]         end
%[text]     end
%[text] ```
%[text] A vector of four elements, `minmax` is used inside the loop to set the axes of the figure. This is necessary because otherwise MATLAB scales the figure each time through the loop, so the axes keep changing, which makes the animation hard to watch.
%[text] Each time through the loop, `animate` uses `clf` to clear the figure and `axis` to reset the axes. Then it plots a circle to represent the position of the baseball.
%[text] We have to call `drawnow` after `plot` so that MATLAB actually displays each plot. Otherwise, it waits until you finish drawing all the figures and then updates the display.
%[text] One limitation of this kind of animation is that the speed of the animation depends on how fast your computer can generate the plots. Since the results from `ode45` are usually not equally spaced in time, your animation might slow down where `ode45` takes small time steps and speed up where the time steps are larger.
%[text] One way to fix this problem is to change the way we specify `tspan`. Here's an example:
    tspan = 0:0.1:10;
%[text] The result is a vector that goes from 0 to 10 with a step size of 0.1. Passing `tspan` to `ode45` in this form doesn't affect the accuracy of the results; `ode45` still uses variable time steps to generate the estimates, but then it interpolates them before returning the results.
%[text] With equal time steps, the animation should be smoother.
%[text] Another option is to use `pause` to play the animation in real time. After drawing each frame and calling `drawnow`, you can compute the time until the next frame and use `pause` to wait:
    dt = tout(ii+1) - tout(ii);
    pause(dt);
%[text] A limitation of this method is that it ignores the time required to draw the figure, so it tends to run slow, especially if the figure is complex or the time step is small.
%%
%[text] ## Chapter Review
%[text] This chapter presented two new tools, `fminsearch` and `animate`. The MATLAB function `fminsearch` searches efficiently for the minimum of a function and can be adapted to search for the maximum, too. The `animate` function is one I wrote to read results from `ode45` and generate an animation; the version in this chapter works with the results from the baseball simulation, but it can be adapted for other simulations.
%[text] In the exercises below, you have a chance to extend the example from this chapter and bring together many of the tools we have used so far.
%[text] In the next chapter, we move on to a new example, celestial mechanics, which describes the motion of planets and other bodies in outer space.
%%
%[text] ## Exercises
%[text] Before you go on, you might want to work on the following exercises.
%[text] **Exercise.**
%[text] Manny Ramirez is a former member of the Boston Red Sox who was famous for his relaxed attitude. The goal of this exercise is to solve the following Manny-inspired problem:
%[text]  B1 
%[text] Fenway Park is a baseball stadium in Boston, Massachusetts. One of its most famous features is the “Green Monster,” which is a wall in left field that is unusually close to home plate, only 310 feet away. To compensate for the short distance, the wall is unusually high, at 37 feet.
%[text] You can solve this problem in two steps:
%[text]  B0 
%[text] **Exercise.**
%[text] A golf ball hit with backspin generates lift, which might increase the distance it travels, but the energy that goes into generating spin probably comes at the cost of lower initial velocity.
%[text] Write a simulation of the flight of a golf ball and use it to find the launch angle and allocation of spin and initial velocity (for a fixed energy budget) that maximizes the horizontal range of the ball in the air.
%[text] The lift of a spinning ball is due to the Magnus force (see <https://greenteapress.com/matlab/magnus>), which is perpendicular to the axis of spin and the path of flight. The coefficient of lift is proportional to the spin rate; for a ball spinning at 3000 rpm it is about 0.1. The coefficient of drag of a golf ball is about 0.2 as long as the ball is moving faster than 20 m/s.
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
