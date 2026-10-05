%[text] # Penny
%[text] PMM Exercise 1.1: a penny dropped from the top of the Empire State Building, ignoring air resistance. How long does it take to reach the sidewalk, and how fast is it going when it gets there?
% Acceleration of gravity [m/s^2]
g = 9.81;

% Height of Empire State Building [m]
h = 381;

% Time to fall [s]
t = sqrt(h/g)

% Velocity at time t [m/s]
v = g*t

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
