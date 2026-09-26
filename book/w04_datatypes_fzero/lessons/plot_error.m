% Generate vectors for x and y
x = linspace(-2, 5, 100);
y = error_func(x);

% Plot the result
figure(1);
clf;
plot(x, y)
xlabel('Independent variable - x [n/a]')
ylabel('Error function - y [n/a]')
grid on;

