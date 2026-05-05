%[text] # Matrices and Systems of ODEs
%[text] In the previous chapter we used Euler's method and `ode45` to solve a single first-order differential equation. In this chapter, we'll move on to systems of first-order ODEs and implement a model of a predator-prey system. But first, we have to learn more about matrices.
%%
%[text] ## Matrices
%[text] Recall from the introduction to Chapter §vectors that the MATLAB's fundamental datatype is an array. Scalars, in MATLAB, are actually 1-by-1 arrays with a single element and vectors are 1-by-N (or N-by-1) arrays with N elements. We can even have empty arrays that have zero elements. We can demonstrate this by creating a few variables and interrogating the workspace using `whos` to see how they are stored:
clear;
%[text] A *matrix* is a two-dimensional array. Like a vector, it contains elements that are identified by indices. The difference is that the elements are arranged in rows and columns, so it takes *two* indices to identify an element. Matrices are a powerful datatype because we can use tools from linear algebra to operate on matrices (and vectors).
%[text] ### Creating a Matrix
%[text] A common way to create a matrix is the `zeros` function, which returns a matrix with the given size filled with zeros. This example creates a matrix with two rows and three columns.
M = zeros(2, 3)
%[text] If you don't know the size of a matrix, you can display it by using `whos`:
whos M
%[text] or the `size` function, which returns a vector:
V = size(M)
%[text] The first element is the number of rows; the second is the number of columns.
%[text] To read an element of a matrix, you specify the row and column numbers:
M(1,2)
M(2,3)
%[text] When you're working with matrices, it takes some effort to remember which index comes first, row or column. I find it useful to repeat “row, column” to myself, like a mantra. You might also find it helpful to remember “down, across” or the abbreviation RC as in “radio control” or RC Cola.
%[text] Another way to create a matrix is to enclose the elements in brackets, with semicolons between rows:
D = [1,2,3 ; 4,5,6]
size(D)
%[text] ### Row and Column Vectors
%[text] Although it's useful to think in terms of numbers, vectors, and matrices, from MATLAB's point of view everything is an array and MATLAB is particularly good and dealing with 2D arrays, matrices. A number is just a matrix that happens to have one row and one column:
x = 5;
size(x)
%[text] And a vector is a matrix with only one row:
R = 1:5;
size(R)
%[text] Well, some vectors have only one row, anyway. Actually, there are two kinds of vectors. The ones we've seen so far are called *row vectors*, because the elements are arranged in a row; the other kind are *column vectors*, where the elements are in a single column.
%[text] One way to create a column vector is to create a matrix with only one element per row:
C = [1;2;3]
size(C)
%[text] The difference between row and column vectors is important in linear algebra, but for most basic vector operations, it doesn't matter. For example, when you index the elements of a vector, you don't have to know what kind it is:
R(2)
C(2)
%[text] ### The Transpose Operator
%[text] The transpose operator, which looks remarkably like an apostrophe, computes the *transpose* of a matrix, which is a new matrix that has all the elements of the original, but with each row transformed into a column (or you can think of it the other way around).
%[text] In this example `D` has two rows:
D = [1,2,3 ; 4,5,6]
%[text] so its transpose has two columns:
Dt = D'
%[text] **Exercise.**
%[text] What effect does the transpose operator have on row vectors, column vectors, and numbers?
%%
%[text] ## Solving Systems of ODEs
%[text] Now that we've seen the basics of matrices, let's see how we can use them to solve systems of differential equations.
%[text] A generic form for a system of first-order, non-linear ODEs is the non-linear *state-space* equation typically wrtiten as
%[text] $ \\dot{\\mathbf{x}}(t) = \\mathbf{f}(\\mathbf{x}(t), \\mathbf{u}(t))$
%[text] where $\\mathbf{x}(t)$ is the state vector, $\\mathbf{f}$ is a non-linear function of the state vector and $\\mathbf{u}(t)$ is the input vector. We've used the notation convention where scalar variables are expressed in regular font (e.g., $t$), vectors are in bold font (e.g., $\\mathbf{x}$) and matrices are capitalized (e.g., $A$). If we can get our problem into this form, we can then apply a variety of MATLAB numerical tools to solve the system of equations.
%[text] ### Lotka-Volterra
%[text] The Lotka-Volterra model describes the interactions between two species in an ecosystem, a predator and its prey. As an example, we'll consider foxes and rabbits.
%[text] The model is governed by the following system of first-order, non-linear differential equations:
%[text] $\\begin{array}{rcl} \\frac{dx}{dt} &=& a x - b x y \\\\ \\frac{dy}{dt} &=& -c y + d x y \\end{array}$
%[text] where $x$ and $y$ are the populations of rabbits and foxes, and $a$, $b$, $c$, and $d$ are parameters that quantify the interactions between the two species (see <https://greenteapress.com/matlab/lotka>).
%[text] We can put this model into the state-space form of Equation §e:nonlinearstatespace. The first step is to define the state as the vector of rabbits and foxes,
%[text] $\\dot{\\mathbf{x}}(t) = \\left\\{ \\begin{array}{c} x(t) \\\\ y(t) \\end{array}\\right\\}.$
%[text] Using this state, the right side of our model is only a function of those state values—there is no external input. So there is no input vector $\\mathbf{u}(t)$. So in standard state-space form our model is
%[text] $\\left\\{ \\begin{array}{c} \\dot{x}(t) \\\\ \\dot{y}(t) \\end{array}\\right\\} = \\left[ \\begin{array}{c} ax - bxy \\\\ -cy + dxy \\end{array}\\right].$
%[text] At first glance, you might think you could solve these equations by calling `ode45` once to solve for $x$ and once to solve for $y$. The problem is that each equation involves both variables, which is what makes this a *system of equations* and not just a list of unrelated equations. To solve a system, you have to solve the equations simultaneously.
%[text] Fortunately, `ode45` can handle systems of equations. The difference is that the initial condition is a vector that contains the initial values $x(0)$ and $y(0)$, and the output is a matrix that contains one column for $x$ and one for $y$.
%[text] Listing §lst:lotka_volterra shows the rate function with the parameters $a = 0.1$, $b = 0.01$, $c = 0.1$, and $d = 0.002$:
%[text] **Listing.** A rate function for Lotka-Volterra
%[text] ```matlab
%[text] function res = rate_func(t, V)
%[text]     % unpack the elements of V
%[text]     x = V(1);
%[text]     y = V(2);
%[text]
%[text]     % set the parameters
%[text]     a = 0.1;
%[text]     b = 0.01;
%[text]     c = 0.1;
%[text]     d = 0.002;
%[text]
%[text]     % compute the derivatives
%[text]     dxdt = a*x - b*x*y;
%[text]     dydt = -c*y + d*x*y;
%[text]
%[text]     % pack the derivatives into a column vector
%[text]     res = [dxdt; dydt];
%[text] end
%[text] ```
%[text] The first input variable, `t`, is time. Even though the time variable is not used in this rate function, it has to be there in order for this function to work with `ode45`. The second input variable, `V`, is a vector with two elements, $x(t)$ and $y(t)$. The body of the function includes four sections, each explained by a comment.
%[text] The first section *unpacks* the vector by copying the elements into variables. This isn't necessary, but giving names to these values will help you to remember what's what. It also makes the third section, where we compute the derivatives, resemble the mathematical equations we were given, which helps prevent errors.
%[text] The second section sets the parameters that describe the reproductive rates of rabbits and foxes, and the characteristics of their interactions. If we were studying a real system, these values would come from observations of real animals, but for this example I chose values that yield interesting results.
%[text] The third section computes the derivatives of $x$ and $y$, using the equations we were given.
%[text] The last section *packs* the computed derivatives back into a vector. When `ode45` calls this function, it provides a vector as input and expects to get a vector as output.
%[text] Sharp-eyed readers will notice something different about this line:
    res = [drdt; dfdt];
%[text] The semicolon between the elements of the vector is not an error. It is necessary in this case because `ode45` requires the result of this function to be a column vector.
%[text] As always, it's a good idea to test your rate function before you call `ode45`. Create a file named *lotka.m* with the following main function:
function res = lotka()
    t = 0;
    V_init = [80, 20];
    rate_func(t, V_init)
end
%[text] `V_init` is a vector that represents the initial condition, 80 rabbits and 20 foxes. The result from `rate_func` is
-8.0000
 1.2000
%[text] which means that with these initial conditions, we expect the rabbit population to decline initially at a rate of 8 per week and the fox population to increase by 1.2 per week.
%[text] Now we can run `ode45` like this:
tspan = [0, 200]
[T, M] = ode45(@rate_func, tspan, V_init)
%[text] The first argument is the function handle for the rate function. The second argument is the time span, from 0 to 200 weeks. The third argument is the initial condition.
%[text] ### Output Matrices
%[text] The `ode45` function returns two values: `T`, a vector, and `M`, a matrix.
size(T)
size(M)
%[text] `T` has 101 rows and 1 column, so it is a column vector with one row for each time step.
%[text] `M` has 101 rows, one for each time step, and 2 columns, one for each variable, $x$ and $y$.
%[text] This structure—one column per variable—is a common way to use matrices. And `plot` understands this structure, so if you do the following:
plot(T, M)
%[text] MATLAB understands that it should plot each column from `M` versus `T`.
%[text] You can copy the columns of `M` into other variables like this:
R = M(:, 1);
F = M(:, 2);
%[text] In this context, the colon represents the range from `1` to `end`, so `M(:, 1)` means “all the rows, column 1” and `M(:, 2)` means “all the rows, column 2.”
size(R)
size(F)
%[text] So `R` and `F` are column vectors.
%[text] Now we can plot these vectors separately, which makes it easier to give them different style strings:
plot(T, R, '-')
plot(T, F, '--')
%[text] Figure §fig:lotka shows the results. The x-axis is time in weeks; the y-axis is population. The top curve shows the population of rabbits; the bottom curve shows foxes.
%[text] ![Solution for the Lotka-Volterra model](../lessons/lotka_time.png)
%[text] *Figure: Solution for the Lotka-Volterra model*
%[text] Initially, there are too many foxes, so the rabbit population declines. Then there are not enough rabbits, and the fox population declines. That allows the rabbit population to recover, and the pattern repeats.
%[text] This cycle of “boom and bust” is typical of the Lotka-Volterra model.
%[text] ### Phase Plot
%[text] Instead of plotting the two populations over time, it is sometimes useful to plot them against each other:
plot(R, F)
%[text] Figure §fig:phase shows the result, which is called a *phase plot*. Each point on this plot represents a certain number of rabbits (on the x-axis) and a certain number of foxes (on the y-axis). Since these are the only two variables in the system, each point in this plane describes the complete *state* of the system, that is, the values of the variables we're solving for.
%[text] ![Phase plot from the Lotka-Volterra model](../lessons/lotka_state.png)
%[text] *Figure: Phase plot from the Lotka-Volterra model*
%[text] Over time, the state moves around the plane. Figure §fig:phase shows the path traced by the state over time; this path is called a *trajectory*.
%[text] Since the behavior of this system is periodic, the trajectory is a loop.
%[text] If there are three variables in the system, we need three dimensions to show the state of the system, so the trajectory is a 3D curve. You can use `plot3` to trace trajectories in three dimensions, but for four or more variables, you're on your own.
%[text] ### What Could Go Wrong?
%[text] The output vector from the rate function has to be a column vector, otherwise you get an error:
Error using odearguments (line 93)
RATE_FUNC must return a column vector.
%[text] which is a pretty good error message. It's not clear *why* it needs to be a column vector, but that's not our problem.
%[text] Another possible error is reversing the order of the elements in the initial conditions or the vectors inside `lotka`. MATLAB doesn't know what the elements are supposed to mean, so it can't catch errors like this; it will just produce incorrect results.
%[text] The order of the elements (rabbits and foxes) is up to you, but you have to be consistent. That is, the order of the initial conditions you provide when you call `ode45` has to be the same as the order inside `rate_func` where you unpack the input vector and the same as the order of the derivatives in the output vector.
%%
%[text] ## Chapter Review
%[text] In this chapter, we used `ode45` to solve a system of first-order differential equations. As an exercise, you'll have a chance to solve the famous Lorenz equations, one of the first examples of a chaotic system.
%[text] Here are the terms from this chapter you might want to remember.
%[text] A *row vector* is a matrix that has only one row, and a *column vector* is a matrix that has only one column. The *transpose operation* transforms the rows of a matrix into columns (or the other way around, if you prefer).
%[text] A *system of equations* is a collection of equations written in terms of the same set of variables.
%[text] In a rate function, we often have to *unpack* the input variable, copying the elements of a vector into a set of variables. Then we have to *pack* the results into a vector as an output variable.
%[text] The *state* of a system is a set of variables that quantify the condition of the system as it changes over time.
%[text] When we solve a system of differential equations, we can visualize the results with a *phase plot*, which shows the state of a system as a point in the space of possible states. A *trajectory* is a path in a phase plot that shows how the state of a system changes over time.
%[text] In the next chapter, we'll move on to second-order systems, which we use to describe systems with objects moving in space, governed by Newton's laws of motion.
%%
%[text] ## Exercises
%[text] Before you go on, you might want to work on the following exercise.
%[text] **Exercise.**
%[text] Based on the examples we've seen so far, you'd think that all ODEs describe population as a function of time, but that's not true.
%[text] For example, the Lorenz system is a system of differential equations based on a model of fluid dynamics in the atmosphere (see <https://greenteapress.com/matlab/lorenz>). It turns out to be interesting in part because its solutions are chaotic; that is, small changes in the initial conditions yield big differences in the solutions.
%[text] The system is described by these differential equations:
%[text] $\\begin{array}{rcl} x\_t &=& \\sigma (y - x) \\\\ y\_t &=& x (r - z) - y \\\\ z\_t &=& xy - b z \\end{array}$
%[text] Common values for the parameters are $\\sigma = 10$, $b = 8/3$, and $r=28$.
%[text] Use `ode45` to estimate a solution to this system of equations.
%[text]  B0 
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
