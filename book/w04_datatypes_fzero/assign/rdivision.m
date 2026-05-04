% PMM Exercise 7.1: rdivision.m

% Write local function called robust_division(a,b) that prints the quotient
% of two numbers a/b to the screen with three signicant gures. If the result is a NaN, print
% Not a Number. If the result is Inf, print Infinity. If either of the input variables is an integer
% type, convert to a oating-point type before execution the division. Include the local function
% in an M-le that tests the various cases.

% The exercises asks for a function that does the printing, so the function
% does not need to have any return variables.
function [] = robust_division(a, b )
    
    % Convert the inputs to floating point doubles
    a = double(a);
    b = double(b);

    % Find the quotent
    q = a/b;
    if isnan(q)
        fprintf("Not a Number\n");
    elseif isinf(q)
        fprintf("Infinity\n");
    else
        fprintf("%.3f\n", q);
    end
end

% Testing - make sure to exercise all the functionality.
robust_division(3.1, 2);
robust_division(0, 3.1);
robust_division(int8(3), int8(2));
robust_division(3.1, 0);
robust_division(0, 0);
