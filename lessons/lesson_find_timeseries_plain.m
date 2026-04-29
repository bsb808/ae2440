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

% Consider the question: "How long does it take for the response to exeed
% a value of 1.0?"

% This is a common question to ask about a time series, and we can use the `find` command to answer it. 
% We are being very verbose here to demonstrate the concepts, but we'll show a concise version at the end.

% We can first `find` where the values of our response values exceed some condition.  They key thing to keep in mind is that `find` returns the **index** of the values that meet the condition, not the values themselves, but we can use the index to find the corresponding time values.

index_vector = find(resp >= 1.0)

% The time series is short enough that we can see the values of the index vector, but in general it will be a vector of indices that meet the condition.  We can use the index vector to find the corresponding values in **both** time and response vectors.
time_values = time(index_vector)
resp_values = resp(index_vector)

hold on
plot(time_values, resp_values, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r', ...
    'DisplayName', 'All y(t) >= 1.0');

% So we have a new time series that fits our conditional, but what the questions asks for is the first time that the response exceeds 1.0, which is the value of the first element in the index vector.
time_to_exceed = time(index_vector(1))
response_at_exceed = resp(index_vector(1))

plot(time_to_exceed, response_at_exceed, 'ks', 'MarkerSize', 12, 'MarkerFaceColor', 'k', ...
    'DisplayName', 'First y(t) >= 1.0');
legend('location', 'southeast', 'Interpreter','latex')

% We can put this all together in a one-liner, but it can be hard to read.
respExceeds = time(find(resp >= 1.0, 1))
% Two lines is a bit easier to follow
indexExceeds = find(resp >= 1.0);
respExceeds = resp(indexExceeds(1))



