# Archived exercise: Ballistics Table (.50 BMG)

Archived 27 Nov 2026. This was Exercise 2 of Assignment 7 (Fall 2026) until it was replaced, before release, by the 16-inch range table exercise. It was set aside because it repeats much of NPS MA2121 Project 3, which some students take in the same quarter. It is kept here for possible later use.

The text below is the exercise as it appeared on the assignment page (`site/weeks/w07_twodim_optimization/assignment.qmd`), in Quarto Markdown. The instructor solution is in the private repo at `solutions/w07_twodim_optimization/archive/ballistics_soln.m`. Students would submit a live script named `ballistics.m`.

## Exercise: Ballistics Table

Adapted from NPS MA2121, Project 3.

A ballistics table tells a shooter how far a bullet drops, how long it is in the air and how much energy it carries at each range. In this exercise you build one for the .50 BMG round (a 750-grain bullet) by simulating its flight in two dimensions, as in Chapter 13. The model is deliberately simple: it ignores changes in air density, wind, spin drift and the rotation of the Earth.

### Model

Let $x$ be the downrange distance and $y$ the height of the bullet, both in feet, with time in seconds. Drag acts opposite to the velocity and grows with the square of the speed, so the equations of motion are

$$
\begin{aligned}
\ddot{x} &= -d_p \, \dot{x} \sqrt{\dot{x}^2 + \dot{y}^2} \\
\ddot{y} &= -g - d_p \, \dot{y} \sqrt{\dot{x}^2 + \dot{y}^2}
\end{aligned}
$$

where $g = 32$ ft/s² and the drag parameter is $d_p = 0.00008$ 1/ft. The value of $d_p$ already includes the bullet's mass and shape, and it is valid only in feet and seconds, so do the simulation in those units.

The shot is fired level from the origin at the muzzle velocity $v_0 = 2820$ ft/s:

$$
x(0) = 0, \quad y(0) = 0, \quad \dot{x}(0) = v_0, \quad \dot{y}(0) = 0.
$$

### Exercise

For this exercise, submit a live script named `ballistics.m`.

1. Before writing any code, convert the two second-order equations into a system of four first-order equations. In your live script, define the four-element state vector and write the model in state-space form. As with the pendulum, the order of the elements is your choice, but be consistent.
2. Write a local rate function `bullet_rate(t, s, dp)` that takes the drag parameter as a third input argument. Test it at the initial condition. Does the horizontal deceleration at the muzzle, $d_p v_0^2$, match what your function returns?
3. `ode45` expects a rate function with exactly two inputs, `(t, s)`. Use an anonymous function to wrap `bullet_rate` with a fixed value of `dp`, as in the Wednesday lesson, and solve for the first few seconds of flight. Use a finely spaced `tspan` (for example, a step of 0.0005 s) so the solution is dense enough to read values from directly.
4. Use the same rate function and a second anonymous wrapper to solve the case with no drag ($d_p = 0$). Plot both trajectories on the same axes, with height in inches against downrange distance in yards out to 2500 yd.
5. Check your no-drag solution: without drag, the time to reach 500 yd is $t = 1500/v_0$ and the drop is $\frac{1}{2} g t^2$. Does your simulation agree?
6. Build the ballistics table for the case with drag. For each range of 500, 1000, 1500, 2000 and 2500 yd, use `find` to locate the first sample at or beyond that range, and report:
    a. the bullet drop, in inches,
    b. the time of flight, in seconds,
    c. the kinetic energy, $\frac{1}{2} m v^2$, in joules.

   Print the table with `fprintf`, one row per range, with units in the column headings.

Units are the hard part of this problem, on purpose: the model is in feet and seconds, the ranges are in yards, the drop is in inches, the bullet's mass is in grains and the energy is in joules. Real engineering models look like this. Convert at the boundaries (once when you set up the problem, once when you report results) and label every quantity with its unit in a comment. You will need 1 grain = 64.79891 mg and 1 ft = 0.3048 m.

7. Optional: the longest confirmed sniper shot (2017) was at 3871 yd. According to this model, how far did the bullet drop?
