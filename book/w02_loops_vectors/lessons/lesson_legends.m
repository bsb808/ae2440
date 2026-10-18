%[text] # Two Ways to Make a Legend
%[text] A family of curves needs a legend that says which curve is which. MATLAB offers two ways to build one: list the labels in the `legend` call afterwards (the classic method), or give each line its label at the moment it is plotted with the `'DisplayName'` option. Both draw the same legend. They differ in what happens when the plot changes.
%[text] The example is the water-jet nozzle from Assignment 2 (`lcs_flow.m`): fluid velocity along the nozzle at several times.
xx = linspace(0, 4, 100);    % Distance along the nozzle (m)
%%
%[text] ## Method 1: labels listed in the legend call
%[text] Plot every curve, then pass one label per curve to `legend`, in the order the curves were plotted.
figure();
hold on
for tt = [0 10 20 30]
    vv = (10 + 0.2*tt)*pi ./ ((pi/4)*(4 - 0.25*xx).^2);    % Velocity (m/s)
    plot(xx, vv)
end
xlabel('Distance along nozzle (m)')
ylabel('Fluid velocity (m/s)')
title('Method 1: labels in the legend call')
legend('t = 0 s', 't = 10 s', 't = 20 s', 't = 30 s', 'Location', 'northwest')
grid on
hold off
%[text] This works, and it is what the reference solution does. The catch: `legend` matches labels to lines purely by order. The labels live in one place and the lines in another, and nothing checks that they agree.
%%
%[text] ## What goes wrong with Method 1
%[text] Suppose we add a design limit to the plot, a horizontal line at 20 m/s, and also look at one more time, 40 s. The loop changes, but the `legend` call is copied unchanged:
figure();
hold on
plot([0 4], [20 20], 'k--')    % Design limit (m/s), plotted first
for tt = [0 10 20 30 40]
    vv = (10 + 0.2*tt)*pi ./ ((pi/4)*(4 - 0.25*xx).^2);    % Velocity (m/s)
    plot(xx, vv)
end
xlabel('Distance along nozzle (m)')
ylabel('Fluid velocity (m/s)')
title('Method 1 after a change: labels no longer match')
legend('t = 0 s', 't = 10 s', 't = 20 s', 't = 30 s', 'Location', 'northwest')
grid on
hold off
%[text] MATLAB raises no error. The dashed limit line takes the label `t = 0 s`, every curve after it is labelled one time step too early, and the 40 s curve gets no label at all. The plot looks finished and is wrong, which is the worst kind of bug.
%%
%[text] ## Method 2: label each line when it is plotted
%[text] Add the name-value pair `'DisplayName', label` to each `plot` call. The label becomes a property of that line, and a bare `legend` call (no labels) collects whatever names the lines carry.
%[text] Inside the loop the label has to change with `tt`. The expression `"t = " + tt + " s"` joins text and a number into one label, so for `tt = 10` it gives `t = 10 s`. (Strings, the double-quoted kind of text, are covered properly in week 4; for now read `+` here as "glue together".)
figure();
hold on
plot([0 4], [20 20], 'k--', 'DisplayName', 'Design limit')
for tt = [0 10 20 30 40]
    vv = (10 + 0.2*tt)*pi ./ ((pi/4)*(4 - 0.25*xx).^2);    % Velocity (m/s)
    plot(xx, vv, 'DisplayName', "t = " + tt + " s")
end
xlabel('Distance along nozzle (m)')
ylabel('Fluid velocity (m/s)')
title('Method 2: DisplayName on each line')
legend('Location', 'northwest')
grid on
hold off
%[text] Same changes as before, and the legend is right: the limit line is labelled as the limit, and the 40 s curve appears with its own label. Change the list of times in the `for` line and the legend follows automatically, because each label is created by the same line of code that draws its curve.
%%
%[text] ## Summary
%[text] - **Classic method**, `legend('a', 'b', ...)`: short and fine for a fixed plot with a few lines. Labels are matched by order, so any change to the plotting code means editing the legend by hand, and a mismatch fails silently.
%[text] - **DisplayName**, `plot(..., 'DisplayName', label)` then `legend`: each label is attached to its own line. Works naturally inside loops, survives added or reordered lines, and is the better habit for any plot that might change.
%[text] Either way, look at the finished plot and check one or two curves against their labels. The legend is part of the result.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
