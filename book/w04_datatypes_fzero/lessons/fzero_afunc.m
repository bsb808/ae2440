% Anonymous error function handle
error_afunc_handle = @(x) x.^2 - 2.*x -3;

% Calling fzero and passing anonymous function
fzero(error_afunc_handle, [2,4])