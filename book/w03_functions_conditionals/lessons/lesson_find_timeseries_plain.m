%% Indexing idioms for manipulating time series information by index.
%
% This is a demonstration to do in class and provided for students to
% review.  The objective is to demonstrate using the find command to
% process time series vectors (and similarly organized data) by index.

%% A small time series
% For demonstration purposes we'll create a time series, two coordinated
% vectors of the same length, one holding time values (the independent
% variable) and one containing the function values (states of the system).
% (MATLAB also has a built-in `timeseries` object that bundles time and data
% together — useful for larger projects, but we'll stick with plain vectors here.)

% We are familiar with time series resulting from using array operations
% (element-wise arithmetic) to evaluate a function over a vector of time
% values.

clear;

time = linspace(0, 10, 25);
resp = 1 - exp(-0.6*time)./sqrt(1-0.3^2) .* sin(2*sqrt(1-0.3^2)*time + atan(sqrt(1-0.3^2)/0.3));

% We visualize the function by plotting the discrete points.
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

%% Using `find` to locate element values by conditional

% Consider the question: "How long does it take for the response to exceed
% a value of 1.0?"

% A common question to ask about a time series. We use `find` verbosely here
% to show each step; a concise version follows at the end.

% `find` returns the **indices** of elements meeting the condition, not the
% values themselves — but we can use those indices to look up values in any parallel vector.

index_vector = find(resp >= 1.0)

% With those indices we can retrieve the corresponding values from **both** parallel vectors.
time_values = time(index_vector)
resp_values = resp(index_vector)

hold on
plot(time_values, resp_values, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', ...
    'DisplayName', 'All y(t) >= 1.0');

% That gives all crossing points. The question asks for the *first* — that's `index_vector(1)`.
time_to_exceed = time(index_vector(1))
response_at_exceed = resp(index_vector(1))

plot(time_to_exceed, response_at_exceed, 'ks', 'MarkerSize', 12, 'MarkerFaceColor', 'k', ...
    'DisplayName', 'First y(t) >= 1.0');
legend('location', 'southeast', 'Interpreter','latex')

% We can put this all together in a one-liner, but it can be hard to read.
timeExceeds = time(find(resp >= 1.0, 1))
% Two lines is a bit easier to follow.
indexExceeds = find(resp >= 1.0);
timeExceeds = time(indexExceeds(1))



