% Plot the first `n` elements of the Fibonacci series
% Precondition: `n` is a positive integer.

F(1) = 1
F(2) = 1
for i=3:n
    F(i) = F(i-1) + F(i-2)
end

plot(F)
xlabel('Index [n/a]')
ylabel('Fibonacci number [n/a]')
%saveas(gcf, '../../book/ figs/fibonacci.eps', 'epsc')
