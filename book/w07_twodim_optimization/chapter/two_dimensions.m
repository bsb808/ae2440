%[text] # Two Dimensions
%[text] In the previous chapter, we solved a one-dimensional problem—a penny falling from the Empire State Building. Now we'll solve a two-dimensional problem—finding the trajectory of a baseball.
%[text] To do that, we'll use spatial vectors to represent quantities in two and three dimensions, including force, acceleration, velocity, and position.
%%
%[text] ## Spatial Vectors
%[text] The word *vector* means different things to different people. In MATLAB, a vector is a matrix that has either one row or one column. So far, we've used MATLAB vectors to represent the following:
%[text] - **Sequences** — A mathematical sequence, like the Fibonacci numbers, is a set of values identified by integer indices; in Chapter §vecseq, we used a MATLAB vector to store the elements of a sequence.
%[text] - **State vectors** — A state vector is a set of values that describes the state of a physical system. When you call `ode45`, you give it initial conditions in a state vector. Then, when `ode45` calls your rate function, it gives you a state vector.
%[text] - **Time series** — One of the results from `ode45` is a vector that represents a sequence of time values.
%[text] In this chapter, we'll see another use of MATLAB vectors: representing *spatial vectors*. A spatial vector represents a multidimensional physical quantity like position, velocity, acceleration, or force.
%[text] For example, to represent a position in two-dimensional space, we can use a vector with two elements:
P = [3 4]
%[text] To interpret this vector, we have to know the coordinate system it is defined in. Most commonly, we use a Cartesian system where the x-axis points east and the y-axis points north. This is one of many typical conventions, referred to in three dimensions and East-North-Up (ENU). In that case `P` represents a point 3 units east and 4 units north of the origin.
%[text] When a spatial vector is represented in this way, we can use it to compute the magnitude and direction of a physical quantity. For example, the *magnitude* of `P` is the distance from the origin to `P`, which is the hypotenuse of the triangle with sides `P(1)` and `P(2)`. We can compute it using the Pythagorean theorem:
sqrt(P(1)^2 + P(2)^2)
%[text] Or we can do the same thing using the function `norm`, which computes the *Euclidean norm* of a vector, which is its magnitude:
norm(P)
%[text] There are two ways to get the *direction* of a vector. One convention is to compute the angle between the vector and the x-axis:
atan2(P(2), P(1))
%[text] In this example, the angle is about 0.9 rad. The same function gives the angle from one point to another by taking `atan2` of the differences in coordinates—for example, `atan2(y2-y1, x2-x1)` returns the bearing from point 1 to point 2.
%[text] But for computational purposes, we often represent direction with a *unit vector*, which is a vector with length 1. To get a unit vector we can divide a vector by its length:
function res = hat(V)
    res = V / norm(V)
end
%[text] This function takes a vector, `V`, and returns a unit vector with the same direction as `V`. It's called `hat` because in mathematical notation, unit vectors are written with a “hat” symbol. For example, the unit vector with the same direction as $\\vec{P}$ would be written $\\hat{P}$.
%[text] The two representations of direction are interchangeable. Given an angle $\\theta$, the corresponding unit vector is $[\\cos\\theta, \\sin\\theta]$. Given a unit vector $\\hat{P}$, the corresponding angle is `atan2(P(2), P(1))`. Which form is easier to work with depends on the problem: forces and additions favor the vector form, while a vehicle's heading is often more natural as a single angle.
%%
%[text] ## Adding Vectors
%[text] Vectors are useful for representing quantities like force and acceleration because we can add them up without having to think explicitly about direction.
%[text] As an example, suppose we have two vectors representing forces:
A = [2, 4];
B = [2, -2];
%[text] `A` represents a force pulling northeast; `B` represents a force pulling southeast, as shown in Figure §fig:vector2:
%[text] ![The sum of two forces represented by vectors](../../images/figure12_01_new.pdf)
%[text] *Figure: The sum of two forces represented by vectors*
%[text] To compute the sum of these forces, all we have to do is add the vectors:
A + B
%[text] Later in the chapter, we'll use vector addition to add accelerations due to different forces acting on a baseball.
%%
%[text] ## ODEs in Two Dimensions
%[text] So far we've used `ode45` to solve a system of first-order equations and a single second-order equation. Now we'll take one more step, solving a system of second-order equations.
%[text] The recipe is the same regardless of where the physics comes from: assemble a state vector, write a rate function that returns $\\dot{\\mathbf{x}}$, and hand it to `ode45`. In this chapter the rate function comes from Newton's laws—forces produce accelerations. Other 2D models are *kinematic*: the inputs are velocities, and there is no $F=ma$ step. Many vehicle models in robotics and naval architecture take this form. Either way, the structure of the program is identical.
%[text] As an example, we'll simulate the flight of a baseball. If there is no wind and no spin on the ball, the ball travels in a vertical plane, so we can think of the system as two-dimensional, with $x$ representing the horizontal distance traveled from the starting place and $y$ representing height or altitude.
%[text] Using Newtonian mechanics ($F=ma$), our simple model of the dynamics of a baseball are the following equations of motion:
%[text] $\\begin{array}{rcl} \\ddot{x}(t) &=& 0 \\\\ \\ddot{y}(t) &=& -g \\end{array}$
%[text] There are no forces (yet) in the horizontal $x$ direction and only gravity in the vertical $y$ direction.
%[text] Using the same process from Section §s:newton we can introduce state variable for the velocity of the baseball in the horizontal and vertical direction, $v\_x$ and $v\_y$. This process of introducing new variables is confusing at first, but hopefully it makes some intuitive sense that the *state* of our baseball system is described by position and velocity. The state vector of the system is then these four states. They can be in any order. The order is important to keep in mind for book keeping in implementation, but the physics don't change. We'll choose to define the state vector as
%[text] $ \\mathbf{x}(t) = \\left\\{ \\begin{array}{c} x \\\\ v\_x \\\\ y \\\\ v\_y \\end{array}\\right\\}.$
%[text] The model, now in state-space from, becomes
%[text] $ \\left\\{ \\begin{array}{c} \\dot{x}(t) \\\\ \\dot{v\_x}(t) \\\\ \\dot{y}(t) \\\\ \\dot{v\_y}(t) \\end{array}\\right\\} = \\left[ \\begin{array}{cccc} 0 & 1 & 0 & 0\\\\ 0 & 0 & 0 & 0\\\\ 0 & 0 & 0 & 1\\\\ 0 & 0 & 0 & 0\\\\ \\end{array} \\right] \\left\\{ \\begin{array}{c} x \\\\ v\_x \\\\ y \\\\ v\_y \\end{array}\\right\\} + \\left\\{\\begin{array}{c} 0 \\\\ 0 \\\\ 0 \\\\ -g \\end{array} \\right\\} .$
%[text] Listing §lst:baseball_rate_func shows a rate function, named `state_transition`, we can use to simulate this system with `ode45`:
%[text] **Listing.** A rate function we can use to model the flight of a baseball
function xx_dot = state_transition(t, xx)
    % Unpack state into components
    x = xx(1);
    vx = xx(2);
    y = xx(3);
    vy = xx(4);

    % Acceleration in x and y from subroutine
    aa = acceleration(t, xx);

    % Equations of motion
    x_dot = vx;
    vx_dot = aa(1);
    y_dot = vy;
    vy_dot = aa(2);

    % Pack the result into a column vector
    xx_dot = [x_dot vx_dot y_dot vy_dot]';
end

function accel = acceleration(t, xx)
    % Acceleration for time (t) and state (xx)
    % Gravity
    g = 9.81;
    % Return 1x2 vector of acceleration in x and y directions
    accel = [0, -g];
end
%[text] The second argument is understood to be a vector, `xx`, with four elements. To avoid a hard-to-find semantic bug, it is key that you use a consistent interpretation of the meaning of this vector — that it includes the variables in the order that we defined in Equation §e:bstate. Having a written mathematical model, Equation §e:baseballstate, is a good defense.
%[text] The goal of the rate function is to compute the derivative of the state vector `xx`, the left-hand side of Equation §e:baseballstate.
%[text] For now, we'll ignore air resistance, so the only force on the baseball is gravity. We represent acceleration due to gravity with a vector that has magnitude `g` and direction along the negative y-axis.
%[text] Let's assume that a ball is batted from an initial position 1 m above the home plate, with an initial velocity of 40 m/s in the horizontal and 30 m/s in the vertical direction.
%[text] Here's how we can call `ode45` with these initial conditions:
% Simulate the flight of a baseball with no drag.
% State vector is x, v_x, y, v_y

% Initial conditions
xx_init = [0 30 1 40]';

% Solve with ode45
tspan = [0 6];
[tout, Xout] = ode45(@state_transition, tspan, xx_init);

% Extract positions
x = Xout(:, 1);
y = Xout(:, 3);

% Plot
figure(1);
clf;
plot(tout, x)
hold on;
plot(tout, y)
xlabel('Time (s)')
ylabel('Position (m)')
legend('x position', 'y position', 'Location', 'northwest')

figure(2);
clf;
plot(x, y)
xlabel('X Position (m)')
ylabel('Y Position (m)')
%[text] The initial conditions are defined by `xx_init` as a column vector using the transpose operator `'`.
%[text] The output variables from `ode45` are a vector, `tout`, that contains time values and a matrix, `Xout`, with four columns. Each row of `Xout` is the state of the system at the corresponding time from `tout`. We can slice this matrix to access the position values based on our model's definition of state, Equation §e:bstate.
%[text] Figure §f:baseball1 shows what these coordinates look like as a function of time and in space. The x-coordinate increases linearly because the $x$ velocity is constant. The y-coordinate goes up and down, as we expect.
%[text] ![Baseball solution time series](../lessons/baseball_time.png)
%[text] ![Baseball solution in x and y](../lessons/baseball_xy.png)
%[text] *Figure: Two ways to visualize the solution*
%[text] The simulation ends just before the ball lands, having traveled almost 180 m. That's substantially farther than a real baseball would travel, because we have ignored air resistance, or “drag force.”
%%
%[text] ## Drag Force
%[text] A simple model for the drag force on a baseball is
%[text] $\\vec{F}\_\\mathrm{d} = - \\frac{1}{2} \\, \\rho v C\_\\mathrm{d} A \\hat{V}$
%[text] where $\\vec{F}\_\\mathrm{d}$ is a vector that represents the force on the baseball due to drag, $\\rho$ is the density of air, $C\_\\mathrm{d}$ is the drag coefficient, and $A$ is the cross-sectional area.
%[text] $\\vec{V}$ is the baseball's velocity vector, $v$ is the magnitude of $\\vec{V}$, and $\\hat{V}$ is a unit vector in the same direction as $\\vec{V}$. The minus sign at the beginning means that the result is in the opposite direction to $\\vec{V}$.
%[text] The function in Listing §lst:baseball_drag computes the drag force on a baseball:
function ff_d = drag_force(vv)
    % Drag force vector as a functio of velocity vector
    % Drag coefficient [dimensionless]
    C_d = 0.3;
    % Density, air [kg/m^3]
    rho = 1.3;
    % Area, cross-sectional [m^2]
    A = 0.0042;
    % Magnitude of velocity vector [m/s]
    v = norm(vv);
    % Drag force [N]
    ff_d = - 1/2 * C_d * rho * A * v * vv;
end
%[text] The drag coefficient for a baseball is about 0.3. The density of air at sea level is about 1.3 kg/m^3. The cross-sectional area of a baseball is 0.0042 m^2.
%[text] Now we have to update `acceleration` to take drag into account:
function accel = acceleration(t, xx)
    % Acceleration for time (t) and state (xx)

    % Gravity
    g = 9.81;

    % Drag subroutine
    ff_d = drag_force([xx(2), xx(4)]);
    % Mass [kg]
    m = 0.145;
    % Drag acceleration
    aa_d = ff_d/m;

    % Return 1x2 vector of acceleration in x and y directions
    accel = [0; -g] + aa_d;
end
%[text] As in Listing §lst:baseball_rate_func, `acceleration` represents acceleration due to gravity with a vector that has magnitude `g` and direction along the negative y-axis. But now it also computes drag force and divides by the mass of the baseball to get acceleration due to drag. Finally, it adds the two acceleration vectors, representing gravity and drag, to get the total acceleration of the baseball.
%[text] Figure §fig:vector3 shows the following quantities graphically: (1) acceleration due to drag, $\\vec{D}$, which is in the opposite direction to (2) velocity, $\\vec{V}$; (3) acceleration due to gravity, $\\vec{G}$, which is straight down; and (4) total acceleration, $\\vec{A}$, which is the sum of $\\vec{D}$ and $\\vec{G}$.
%[text] ![Diagram of velocity, ; acceleration due to drag force, ; acceleration due to gravity, ; and total acceleration,](../../images/figure12_03_new.pdf)
%[text] *Figure: Diagram of velocity, $\vec{V}$; acceleration due to drag force, $\vec{D}$; acceleration due to gravity, $\vec{G}$; and total acceleration, $\vec{A}$*
%[text] Figure §f:baseball2 shows the results from `ode45`. The ball lands after about 5 s, having traveled less than 120 m, substantially less than what we got without air resistance, about 180 m.
%[text] ![Baseball solution time series](../lessons/baseball2_time.png)
%[text] ![Baseball solution in x and y](../lessons/baseball2_xy.png)
%[text] *Figure: Simulated flight of a baseball including drag force including drag froce*
%[text] This result suggests that ignoring air resistance is not a good choice for modeling a baseball.
%%
%[text] ## Chapter Review
%[text] In this chapter, we simulated the flight of a baseball with and without air resistance and saw that the difference is substantial. We can conclude that it's important to model air resistance if we want to make accurate predictions about baseballs and similar projectiles.
%[text] Here are some terms from this chapter you might want to remember.
%[text] A *spatial vector* is a value that represents a multidimensional physical quantity like position, velocity, acceleration, or force. A spatial vector has a direction and a magnitude. The magnitude is also called the *norm* of the vector. A *unit vector* is a vector with norm 1, which is often used to represent a direction.
%[text] In the next chapter, we'll continue with the baseball example, using `fzero`, which we saw in Chapter §fzero, and a new tool for optimization, called `fminsearch`. We'll also see a simple way to animate the solution of a differential equation.
%%
%[text] ## Exercises
%[text] Before you go on, you might want to work on the following exercises.
%[text] **Exercise.**
%[text] When the Boston Red Sox won the World Series in 2007, they played the Colorado Rockies at their home field in Denver, Colorado. Find an estimate of the density of air in the Mile High City. What effect does this have on drag? What effect does it have on the distance the baseball travels?
%[text] **Exercise.**
%[text] The actual drag on a baseball is more complicated than what is captured by our simple model. In particular, the drag coefficient depends on velocity. You can get some details from Robert K. Adair's *The Physics of Baseball* (Harper Perennial, 2002); the figure you need is reproduced at <https://greenteapress.com/matlab/drag>.
%[text] Use this data to specify a more realistic model of drag and modify your program to implement it. How big is the effect on the distance the baseball travels?
%[text] **Exercise.**
%[text] According to Wikipedia, the record distance for a human cannonball is 59.05 m (see <https://greenteapress.com/matlab/cannon>).
%[text] Modify the example from this chapter to simulate the flight of a human cannonball. You might have to do some research to find the drag coefficient and cross-sectional area for a flying human.
%[text] Find the initial velocity (both magnitude and direction) you would need to break this record. You might have to experiment to find the optimal launch angle.
%[text] How much acceleration can a human withstand without injury? At this maximum acceleration, how long would the barrel of the cannon have to be to reach the initial velocity needed to break the record?
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
