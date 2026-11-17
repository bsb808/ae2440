%[text] usv draft
%[text] the volume is V = L(R^2 acos(1-d/R) - (R-d)sqrt(R^2-(R-d)^2))
clear;
close all;

% Call fzero
z = fzero(@find_z, 0.08)
t = linspace(0,0.4,100);
y = find_z(t);
hold on;
fplot(@find_z, [0 0.4]);
yline(0, 'r--');
ylim([-20 210]);
xlim([0 2*0.213]);
xlabel('Draft (m)');
ylabel('Mass not supported by water (kg)');
title('Buoyancy Equilibrium Solution');
x_target = 0.0843;
dx = x_target-0.15;
y_target = 0;
dy = y_target-45;
plot([x_target - dx, x_target], [y_target - dy, y_target], 'r-', 'LineWidth', 1.5);
plot(x_target, y_target, 'r*', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
q = [z 0];
tz = sprintf('(%.3g, %.3g)', q);
t = text(0.15, 50, "Zero "+tz);
t.Color = 'green';
t.FontSize = 10;
hold off;
function z = find_z(d)
m = 200; % kg
R = 0.213; % m
L = 5; % m
rho = 1000; % kg/m^3
z = m - 2*rho*L*((R^2)*(acos(1-d./R))-(R-d).*sqrt((R^2)-((R-d).^2)));
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
