%[text] # Illustration: Two Ways to Make a Legend
%[text] MATLAB offers two ways to label lines in a legend: 
%[text] 1. List in `legend` call afterwards, or 
%[text] 2. Label when plotted  with `'DisplayName'`. \
%[text] Both draw the same legend.
x = linspace(0, 2, 50);
%%
%[text] ## Method 1: List in `legend` call 
figure();
hold on
plot(x, x)
plot(x, x.^2)
plot(x, x.^3)
legend('x', 'x^2', 'x^3')
hold off
%[text] The curves (plots) and their labels are disconnected. 
%%
%[text] ### Common error - change the plotting, but forget to update the legend list. 
%[text] Add a plot line at the start, and keep the same `legend` call:
figure();
hold on
plot([0 2], [1 1], 'k--')
plot(x, x)
plot(x, x.^2)
plot(x, x.^3)
legend('x', 'x^2', 'x^3')
hold off
%[text] No syntax error, but a sematic one!
%%
%[text] ## Method 2: Label when plotted  with `'DisplayName'`.
figure();
hold on
plot([0 2], [1 1], 'k--', 'DisplayName', 'Reference')
plot(x, x, 'DisplayName', 'x')
plot(x, x.^2, 'DisplayName', 'x^2')
plot(x, x.^3, 'DisplayName', 'x^3')
legend()
hold off
%[text] Each label belongs to its own line, so the legend stays correct when lines are added or reordered.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
