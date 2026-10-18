%[text] # Assignment 2 — LCS Nozzle Flow
%[text] ## Scenario
%[text] The water-jet nozzle on the LCS contracts from the transom to the outlet, so the fluid accelerates along it. With $x$ the distance along the nozzle (0 to 4 m) and $t$ the time since the throttle began increasing (0 to 30 s), the velocity and acceleration are
%[text] $v(x,t) = \\frac{(10 + 0.2t)\\,\\pi}{\\frac{\\pi}{4}\\,(4 - 0.25x)^2}, \\qquad a(x,t) = \\frac{0.5}{(4 - 0.25x)^2} + \\frac{0.5\\,(24 + 0.5t)^2}{(2 - 0.125x)^5}$
%[text] The script produces two figures, velocity and acceleration against $x$, each with one curve for $t = 0, 10, 20, 30$ s.
%%
%[text] ## Set up  x vector
%[text] `x` is a vector, so each formula is evaluated for all 100 points at once with element-wise operators (`./` and `.^`). 
xx = linspace(0, 4, 100);    
%%
%[text] ## Loop over the four times and use array arithmetic at each time.
%[text] The model is written once for velocity and once for acceleration. Because of the way live scripts handle figure windows, we want to build the figure for velocity first, then move on to acceleration
%[text] ### Velocity
figure(); 
clf();
hold on;
for tt = [0 10 20 30]      
    vv = (10 + 0.2*tt)*pi ./ ((pi/4)*(4 - 0.25*xx).^2);  
    plot(xx, vv)
end
%%
xlabel('Distance along nozzle (m)')
ylabel('Fluid velocity (m/s)')
title('Water-jet nozzle: velocity')
legend('t = 0 s', 't = 10 s', 't = 20 s', 't = 30 s', 'Location', 'northwest')
grid on
%%
%[text] ### Acceleration
figure();
clf();
hold on;
for tt = [0 10 20 30]
    aa = 0.5 ./ (4 - 0.25*xx).^2 + 0.5*(24 + 0.5*tt)^2 ./ (2 - 0.125*xx).^5;  
    plot(xx, aa)
end
%%
xlabel('Distance along nozzle (m)')
ylabel('Fluid acceleration (m/s^2)')
title('Water-jet nozzle: acceleration')
legend('t = 0 s', 't = 10 s', 't = 20 s', 't = 30 s', 'Location', 'northwest')
grid on

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
