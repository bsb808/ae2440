% Demonstrate using a local function definition in a script 
function res = local_error_func(x)
    % Local error function
    res = x^2 - 2*x -3;
end

% Calling fzero and passing handle local function
fzero(@local_error_func, [2,4])

