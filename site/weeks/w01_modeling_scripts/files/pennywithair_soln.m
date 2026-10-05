%[text] # Penny With Air
%[text] PMM Exercise 1.2: the penny falls from the top of the Empire State Building, but now with air resistance. As a simple model, assume the penny accelerates at $g$ until it reaches its terminal velocity, then falls at that constant speed for the rest of the way down. How long does it take to reach the sidewalk?
%[text] ## What We Know
% Height of Empire State Building [m]
h = 381;

% Acceleration of gravity [m/s^2]
g = 9.81;

% Terminal velocity of a penny [m/s]
v_term = 18;
%[text] ## Phase 1: Accelerating to Terminal Velocity
%[text] Under constant acceleration $v = g\\,t$, so the time to reach terminal velocity is
%[text] $t\_1 = \\frac{v\_{term}}{g}$
%[text] and the distance fallen in that time is
%[text] $d\_1 = \\frac{1}{2} g\\, t\_1^2$
% Time to reach terminal velocity [s]
t1 = v_term/g

% Distance fallen while accelerating [m]
d1 = 0.5*g*t1^2
%[text] ## Phase 2: Falling at Terminal Velocity
%[text] The rest of the distance, $d\_2 = h - d\_1$, is covered at constant speed, which takes
%[text] $t\_2 = \\frac{d\_2}{v\_{term}}$
% Distance remaining [m]
d2 = h - d1

% Time to fall the remaining distance [s]
t2 = d2/v_term
%[text] ## Total Time
%[text] $t = t\_1 + t\_2$
% Total time to reach the sidewalk [s]
t = t1 + t2

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
