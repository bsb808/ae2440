% Fluid statics: force on an aquarium window (plain script, no text blocks)
a = 2; b = 3; w = 1.5;
rho = 1000; g = 9.81;
Pa = rho*g*a;
Pb = rho*g*(a+b);
F = (Pa + Pb)/2*(b*w)
