%[text] # Indexing Idioms for Manipulating Time Series Information by Index
%%
%[text] This is a demonstration to do in class and provided for students to review. The objective is to demonstrate using the `find` command to process time series vectors (and similarly organized data) by index.
%[text] ## A Small Time Series
%[text] For demonstration purposes we'll create a time series: two coordinated vectors of the same length, one holding time values (the independent variable) and one containing the function values (states of the system).
%[text] (MATLAB also has a built-in `timeseries` object that bundles time and data together — useful for larger projects, but we'll stick with plain vectors here.)
%[text] We are familiar with time series resulting from using array operations (element-wise arithmetic) to evaluate a function over a vector of time values.
clear;

time = linspace(0, 10, 25);
resp = 1 - exp(-0.6*time)./sqrt(1-0.3^2) .* sin(2*sqrt(1-0.3^2)*time + atan(sqrt(1-0.3^2)/0.3));
%[text] We visualize the function by plotting the discrete points.
figure(1);
clf()
plot(time, resp, '-o', ...
    'LineWidth', 1.5, ...
    'DisplayName', '$y(t)$')
xlabel('Time (s)')
ylabel('Response y(t)')
title('Time Response')
grid on
legend('location', 'southeast', 'Interpreter','latex')
%%
%[text] ## Using `find` to Locate Element Values by Conditional
%[text] Consider the question: 
%[text]{"align":"center"} ***How long does it take for the response to exceed a value of 1.0?***
%[text] A common question to ask about a time series. We use `find` verbosely here to show each step; a concise version follows at the end.
%[text] `find` returns the **indices** of elements meeting the condition, not the values themselves — but we can use those indices to look up values in any parallel vector.
index_vector = find(resp >= 1.0)
%[text] With those indices we can retrieve the corresponding values from **both** parallel vectors.
time_values = time(index_vector)
resp_values = resp(index_vector)

hold on
plot(time_values, resp_values, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', ...
    'DisplayName', 'All y(t) >= 1.0');

%[text] That gives all crossing points. The question asks for the *first* — that's `index_vector(1)`.
time_to_exceed = time(index_vector(1))
response_at_exceed = resp(index_vector(1))

plot(time_to_exceed, response_at_exceed, 'ks', 'MarkerSize', 12, 'MarkerFaceColor', 'k', ...
    'DisplayName', 'First y(t) >= 1.0');
legend('location', 'southeast', 'Interpreter','latex')

%[text] We can put this all together in a one-liner, but it can be hard to read.
timeExceeds = time(find(resp >= 1.0, 1))
%[text] Two lines is a bit easier to follow.
indexExceeds = find(resp >= 1.0);
timeExceeds = time(indexExceeds(1))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
