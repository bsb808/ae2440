%[text] # Assignment 2 — Simple Statistics
%[text] ## Scenario
%[text] The ANSUR II survey measured the arm span of thousands of US Army soldiers. The file `ansur_span.mat` holds one of those measurements, the arm span of each male participant in meters, as a single vector named `span`. The task is to compute the sample mean and standard deviation by iterating over the elements with `for` loops, rather than calling MATLAB's `mean` and `std`, and then to check the results against the published table.
%[text] $\\mu = \\frac{\\sum\_{i=1}^{n} x\_i}{n}, \\qquad \\sigma = \\sqrt{\\frac{\\sum\_{i=1}^{n} (x\_i - \\mu)^2}{n - 1}}$
%%
%[text] ## Load the data
%[text] The MAT-file must be in MATLAB's current folder. After loading, `span` should be a column vector with 4082 elements.
load("ansur_span.mat");
sz = size(span)    % Rows x columns
%%
%[text] ## Mean
%[text] Walk through the vector once, accumulating the sum and counting the elements. The variable names avoid `sum` and `mean`, which are MATLAB functions.
total = 0;                  
N = length(span);           
for ii = 1:N
    total = total + span(ii);
end
mu = total / N              
%%
%[text] ## Standard deviation
%[text] A second pass accumulates the squared deviations from the mean. Dividing by $n - 1$ gives the sample variance; its square root is the sample standard deviation.
sq_dev = 0;                 % Running sum of squared deviations (m^2)
for ii = 1:N
    sq_dev = sq_dev + (span(ii) - mu)^2;
end
variance = sq_dev / (N - 1) % Sample variance (m^2)
sigma = sqrt(variance)      % Sample standard deviation (m)
%%
%[text] ## Check against the built-in functions and the Army table
%[text] MATLAB's `mean` and `std` use the same definitions, so they should agree with `mu` and `sigma` above to every displayed digit. The ANSUR II report lists the male arm span (called *span* in the table) with a mean of 1814 mm and a standard deviation of 85 mm, which matches these results to the precision of the table.
mu_builtin = mean(span)     % Built-in sample mean (m)
sigma_builtin = std(span)   % Built-in sample standard deviation (m)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
