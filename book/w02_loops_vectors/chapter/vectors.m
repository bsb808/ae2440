%[text] # Vectors
%[text] In the previous chapter we used a loop to compute the elements (scalars) of a sequence, but we were only able to store the last element. In this chapter, we'll use a vector to store all the elements in an array. We'll also learn how to select elements from a vector, and how to perform vector arithmetic and common vector operations like *reduce* and *apply*.
%%
%[text] ## Creating Vectors
%[text] A *vector* in MATLAB is a sequence of numbers, stored as an array. There are several ways to create vectors; one of the most common is to put a sequence of numbers in square brackets:
[1 2 3]
%[text] The `size` function tells you the number of elements in each dimension.
size(xx)
%[text] This indicates that `xx` is a 1-by-3 array. We will learn later that this is a *row* vector.
%[text] Another way to create a vector is the colon operator, which we have already used to create a range of values in a `for` loop.
1:3
%[text] In general, anything you can do with a number, you can also do with a vector. For example, you can assign a vector value to a variable:
xx = [1 2 3]
%[text] Note that variables that contain vectors are often double letters (`xx`) or capital letters (`X`). These are just conventions; MATLAB doesn't require it, but it's a useful way to remember which variables are vectors.
%[text] Here are the syntax for some typical ways to create a vector:
     % Some ways to initialize vectors
     % As an list with step size = 1
     1:5
     ans =
          1     2     3     4     5

     % As a list with step size ~= 1
     1:3:10
     ans =
          1     4     7    10

     % As an N-by-1 column of zeros
     zeros(5,1)
     ans =
          0
          0
          0
          0
          0

     % As a 1-by-N row of ones
     ones(1,5)
     ans =
          1     1     1     1     1

     % A vector of psuedorandom numbers
     rand(1,5)
     ans =
         0.1576    0.9706    0.9572    0.4854    0.8003

     % Manually, as a row vector
     [5 3.1 9.8 -2]
     ans =
         5.0000    3.1000    9.8000   -2.0000

     % Manually as a column vector
     [5; 3.1; 9.8; -2;]
     ans =
         5.0000
         3.1000
         9.8000
        -2.0000

     % As a column using transpose
     [5 3.1 9.8 -2]'
     ans =
         5.0000
         3.1000
         9.8000
        -2.0000

     % Linear spacing from A to B with N elements
     linspace(0, 1, 5)
     ans =
            0    0.2500    0.5000    0.7500    1.0000

     % Logrithmic spacing from A to B with N elements
     logspace(0, 1, 5)
     ans =
       1.0000    1.7783    3.1623    5.6234   10.0000
%%
%[text] ## Vector Arithmetic
%[text] As with numbers, you can do arithmetic with vectors. However, operations with vectors can be done in more than one way, so to avoid logical errors, we need to be more intentional with the instructions we provide. In general, MATLAB executes both *array operations* and *matrix operations*. Matrix operations follow the rules of linear algebra, while array operations execute element by element. The syntax for each can be closely related.
%[text] If you add a scalar to a vector, MATLAB does the array operation increments each element of the vector:
Y = X + 5
%[text] The result is a new vector; the original value of `X` has not changed.
%[text] If you add two vectors, MATLAB adds the corresponding elements of each vector and creates a new vector that contains the sums:
Z = X + Y
%[text] But adding vectors only works if the operands are the same size. Otherwise, you get an error:
W = [1 2]
X+W
%[text] The \lstinline(size()) function can be helpful in debugging runtime errors of vector/matrix sizing, e.g.,
size(X)
size(W)
%[text] might help us investigate whey we received the `Matrix dimensions must agree' error.
%[text] If you divide two vectors, you might be surprised by the result:
X / Y
%[text] MATLAB is performing a matrix operation called right-matrix division, which is not what we expected. (See the `mrdivid()` function documentation for more details.) If, instead, we wanted MATLAB to do the array operation o divide the elements of `X` by the elements of `Y`, you have to use `./`, which is element-wise division:
X ./ Y
%[text] Multiplication has the same problem. If you use `*`, MATLAB does matrix multiplication following the rules of linear algebra. With these two vectors, matrix multiplication is not defined, so you get an error:
X * Y
%[text] In this case, the error message is pretty helpful. As it suggests, you can use `.*` to perform element-wise multiplication:
X .* Y
%[text] As an exercise, see what happens if you use the exponentiation operator (`^`) with a vector.
%%
%[text] ## Indexing and Slicing
%[text] In MATLAB, array *indexing* refers to accessing specific elements of an array using their position, while *slicing* allows selecting multiple elements, such as a range of rows, columns, or both. MATLAB uses 1-based indexing, meaning the first element is at position 1. To access an element, you specify its index in parentheses. For example, for vector `Y`:
Y = [6 7 8 9]
Y(1)
Y(4)
%[text] This means that the first element of `Y` is `6` and the fourth element is~`9`. The number in parentheses is called the *index* because it indicates which element of the vector you want.
%[text] The index can be a variable name or a mathematical expression:
i = 1;
Y(i)
Y(i+1)
%[text] We can use a loop to display the elements of `Y`:
for i=1:4
     Y(i)
end
%[text] Each time through the loop we use a different value of `i` as an index into~`Y`.
%[text] In the previous example we had to know the number of elements in `Y`. We can make it more general by using the `length` function, which returns the number of elements in a vector:
for i=1:length(Y)
     Y(i)
end
%[text] This version works for a vector of any length.
%[text] When slicing a vector, you can extract a subset of the array using colon notation `:` to indicate ranges.
B = [1, 2, 3, 4, 5]
C = B(2:4)
%[text] You can also slice a vector to extract the elements described by another vector:
D = B([2 5])
%%
%[text] ## Indexing Errors
%[text] An index can be any kind of expression, but the value of the expression has to be a positive integer, and it has to be less than or equal to the length of the vector. If it's zero or negative, you'll get an error:
Y(0)
%[text] If it's not an integer, you get an error:
Y(1.5)
%[text] If the index is too big, you also get an error:
Y(5)
%[text] The `end` keyword can help with indexing and slicing. It refers to the maximum index value, so that
Y(end)
%[text] will index the last element in the vector no matter how many elements are included. This is particularly helpful when slicing the last N elements of a vector:
G = 1:10
N = 5
H = G(end-N:end)
%%
%[text] ## Vectors and Sequences
%[text] Vectors and sequences go together nicely. For example, another way to evaluate the Fibonacci sequence from Chapter~2 is to store successive values in a vector. Remember that the definition of the Fibonacci sequence is $F\_1 = 1$, $F\_2 = 1$, and $F\_{i} = F\_{i-1} + F\_{i-2}$ for $i > 2$.
%[text] Listing~§lst:fib_vec shows how we can compute the elements of this sequence and store them in a vector, using a capital letter for the vector `F` and lower-case letters for the integers `i` and `n`.
%[text] **Listing.** Calculating the Fibonacci sequence using a vector
%[text] ```matlab
%[text] F(1) = 1
%[text] F(2) = 1
%[text] for i=3:n
%[text]     F(i) = F(i-1) + F(i-2)
%[text] end
%[text] ```
%[text] If you had any trouble with §fib2, you have to appreciate the simplicity of this script. The MATLAB syntax is similar to the math notation, which makes it easier to check for correctness.
%[text] If you only want the $n$th Fibonacci number, storing the whole sequence wastes some space. But if wasting space makes your code easier to write and debug, that's probably okay.
%%
%[text] ## Plotting Vectors
%[text] If you call `plot` with a vector as an argument, MATLAB plots the indices on the x-axis and the elements on the y-axis. To plot the Fibonacci numbers we computed in Listing~§lst:fib_vec, we'd use
plot(F)
xlabel('Index [n/a]')
ylabel('Fibonacci number [n/a]')
%[text] Figure~§fig:fibonacci shows the result.
%[text] ![The first 10 elements of the Fibonacci sequence](../../images/figure04_fib.png)
%[text] *Figure: The first 10 elements of the Fibonacci sequence*
%[text] This way of looking at a vector is often useful for debugging, especially if it is big enough that displaying the elements on the screen is unwieldy.
%%
%[text] ## Common Vector Operations
%[text] We've covered some basic features of vectors. Let's now look at some common patterns we use to work with data stored in vectors.
%[text] ### Reduce
%[text] We frequently use loops to run through the elements of a vector and add them up, multiply them together, compute the sum of their squares, and so on. This kind of operation is called *reduce*, because it reduces a vector with multiple elements down to a single number.
%[text] For example, the loop in Listing~§lst:vec_reduce adds up the elements of a vector named `X` (which we assume has been defined).
%[text] **Listing.** Reducing a vector to a single scalar value (the sum)
%[text] ```matlab
%[text] total = 0
%[text] for i=1:length(X)
%[text]     total = total + X(i)
%[text] end
%[text] ans = total
%[text] ```
%[text] The use of `total` as an accumulator is similar to what we saw in Chapter~3. Again, we use the `length` function to find the upper bound of the range, so this loop will work regardless of the length of `X`. Each time through the loop, we add in the `i`th element of `X`, so at the end of the loop `total` contains the sum of the elements.
%[text] MATLAB provides functions that perform some reduce operations. For example, the `sum` function computes the sum of the elements in a vector, and `prod` computes the product.
%[text] ### Apply
%[text] Another common use of a loop is to run through the elements of a vector, perform some operation on the elements, and create a new vector with the results. This operation is called *apply*, because you apply the operation to each element in the vector.
%[text] For example, the loop in Listing~§lst:vec_apply creates a vector `Y` that contains the squares of the elements of `X` (assuming, again, that `X` is already defined).
%[text] **Listing.** Making a new vector Y by squaring the elements in X
%[text] ```matlab
%[text] for i=1:length(X)
%[text]     Y(i) = X(i)^2
%[text] end
%[text] ```
%[text] Many apply operations can be done with element-wise operators. The following statement is more concise than the loop in Listing~§lst:vec_apply.
Y = X .^ 2
%[text] It also runs faster!
%%
%[text] ## Chapter Review
%[text] In this chapter, we used a vector to store the elements of a sequence. We learned how to select elements from a vector and perform vector arithmetic. We performed reduce and apply operations using `for` loops, MATLAB functions, and element-wise operations.
%[text] Here are some terms from this chapter you might want to remember.
%[text] A *vector* is a sequence of values, which is a kind of *matrix*, also called an *array* in some MATLAB documentation.
%[text] An *index* is an integer value used to indicate one of the elements in a vector or matrix (also called a *subscript* in some MATLAB documentation).
%[text] An operation is *element-wise* if it acts on the individual elements of a vector or matrix (unlike some linear algebra operations).
%[text] You can *apply* an operation to all elements of a vector, and you can *reduce* a vector to a single value, for example by computing the sum of the elements.
%[text] In the next chapter, we'll meet the most important idea in computer programming: functions!
%%
%[text] ## Exercises
%[text] Before you go on, you might want to work on the following exercises.
%[text] **Exercise.**
%[text] (From [18.S997 OCW.](https://ocw.mit.edu/courses/18-s997-introduction-to-matlab-programming-fall-2011/pages/the-basics/lists-vectors-and-matrices/))
%[text] Practice creating vectors in various ways.  B2 
%[text] **Exercise.**
%[text] Write a loop that computes the first $n$ elements of the geometric sequence $A\_{i+1} = A\_i/2$ with $A\_1 = 1$. Notice that math notation puts $A\_{i+1}$ on the left side of the equality. When you translate to MATLAB, you might want to rewrite it with $A\_{i}$ on the left side.
%[text] **Exercise.**
%[text] Write an expression that computes the square root of the sum of the squares of the elements of a vector, without using a loop.
%[text] **Exercise.**
%[text] The ratio of consecutive Fibonacci numbers, $F\_{n+1}/F\_{n}$, converges to a constant value as $n$ increases. Write a script that computes a vector with the first $n$ elements of a Fibonacci sequence (assuming that the variable `n` is defined) and then computes a new vector that contains the ratios of consecutive Fibonacci numbers. Plot this vector to see if it seems to converge. What value does it converge on?
%[text] **Exercise.**
%[text] The following set of equations is based on a famous example of a chaotic system, the Lorenz attractor (see <https://greenteapress.com/matlab/lorenz>):
%[text] $\\begin{array}{rcl} x\_{i+1} &=& x\_i + \\sigma \\left( y\_i - x\_i \\right) dt \\\\ y\_{i+1} &=& y\_i + \\left[ x\_i (r - z\_i) - y\_i \\right] dt \\\\ z\_{i+1} &=& z\_i + \\left( x\_i y\_i - b z\_i \\right) dt \\end{array}$
%[text]  B0 
%[text] **Exercise.**
%[text] The logistic map (see <https://greenteapress.com/matlab/logistic>) is described by the following equation:
%[text] $X\_{i+1} = r X\_i (1-X\_i)$
%[text] where $X\_i$ is a number between 0 and 1, and $r$ is a positive number.
%[text]  B1 
%[text] **Exercise.**
%[text] For this exercise write a live script named *firstorder.mlx* to examine the connection between a geometric series (progression) and the time response of a first-order system.
%[text] A first-order, linear ordinary differential equation (ODE) is a common mathematical model useful to predict the behavior of many engineering systems. A typical form for a system undergoing decay is
%[text] $\\frac{dy}{dt} = -k \\, y(t)$
%[text] where $y(t)$ is the quantity that decays over time, $k$ is the constant decay rate and $t$ is time. The solution to this ODE is
%[text] $y(t) = y\_0 \\, e^{-kt}$
%[text] where $y\_0$ is the initial condition.
%[text] Computers, and computer programs, don't have a way to handle such this continuous time function directly. One thing we can do is to sample the function at discrete points and plot the results.
%[text]  B3 
%[text] In computational solutions, we often approximate continuous processes using discrete time steps because computers operate with finite, step-by-step calculations. They cannot directly handle continuous, infinitely varying data. We can approximate the above ODE with the following *difference equation*:
%[text] $y[n] = y[n-1] (1- k \\Delta t)$
%[text] where $y[n]$ is the value at the $n$-th time step, $y[n-1]$ is the value at the previous time step and $\\Delta t$ is the time step between consecutive points in the discrete-time system. This is the interval over which we are updating the system's state from one step to the next.
%[text]  B4 
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
