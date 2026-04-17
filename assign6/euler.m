function [tt, yy] = euler(odefun, tspan, y0)
% euler  Solve a differential equation using Euler's method.
%   [TT, YY] = euler(ODEFUN, TSPAN, Y0) integrates y' = f(t,y) from
%   TSPAN(1) to TSPAN(2) with initial condition Y0, using a fixed
%   step size of (TSPAN(2) - TSPAN(1)) / 100.
dt    = (tspan(2) - tspan(1)) / 100;
tt    = (tspan(1):dt:tspan(2))';
yy    = zeros(size(tt));
yy(1) = y0;
for k = 1:length(tt)-1
    yy(k+1) = yy(k) + dt * odefun(tt(k), yy(k));
end
end
