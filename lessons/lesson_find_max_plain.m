%% Indexing idioms for manipulating time series information by index.
%
% This is a demonstration to do in class and provided for students to
% review.  The objective is to demonstrate using the find command to
% process time series vectors (and similarly organized data) by index.

%% The time series
% For demonstration purposes we'll create a time series, two coordinated
% vectors of the same length, one holding time values (the independent
% variable) and one containing the function values (states of the system).
% (MATLAB also has a built-in `timeseries` object that bundles time and data
% together — useful for larger projects, but we'll stick with plain vectors here.)

% We are familiar with time series resulting from using array operations
% (element-wise arithmetic) to evaluate a function over a vector of time
% values.

tt = linspace(0, 10, 25);
yy = 1 - exp(-0.6*tt)./sqrt(1-0.3^2) .* sin(2*sqrt(1-0.3^2)*tt + atan(sqrt(1-0.3^2)/0.3));

% We visualize the function by plotting the discrete points.
figure(1);
clf()
plot(tt, yy, '-o', ...
    'LineWidth', 1.5, ...
    'DisplayName', '$y(t)$')
xlabel('Time (s)')
ylabel('Response y(t)')
title('Time Response')
grid on
legend('location', 'southeast', 'Interpreter','latex')

%% Using `find` to locate values by conditional

% Consider the question: "How long does it take for the response to exeed
% a value of 1.0?"

% The following is a common idiom to find the first index where the condition is met, and then use that index to find the corresponding time value.  
indx = find(yy > 1.0)
timeToExceed = tt(indx(1));
% Equivalently, could ask find to return only the **first** index where the condition is met, which is more efficient.
indxFirst = find(yy > 1.0, 1);


hold on
plot(tt(indx), yy(indx), 'rs', 'MarkerSize', 12, 'MarkerFaceColor', 'r',...
    'DisplayName',"$All y(t) > 1.0$")
plot(tt(indxFirst), yy(indxFirst), 'ks', 'MarkerSize', 12, 'MarkerFaceColor', 'k',...
    'DisplayName',"$First y(t) > 1.0$")
legend('location', 'southeast', 'Interpreter','latex')


