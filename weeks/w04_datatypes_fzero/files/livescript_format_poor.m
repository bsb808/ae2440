%[text] usv draft
%[text] the volume is V = L(R^2 acos(1-d/R) - (R-d)sqrt(R^2-(R-d)^2))
R = 0.213;
dd = linspace(0, 2*R, 200);
% this is the illustrative POORLY formatted example for class, not a student submission
% it is the same code as the well formatted example
% find the draft of the usv, the function is below
% the mass of water for 2 hulls = mass of vessel so 2*rho*V - m = 0
usv_balance(0)
usv_balance(2*R)

% Call fzero
d_guess = 0.1;
d_draft = fzero(@usv_balance, d_guess)

% Plot the buoyancy balance and mark the computed draft
figure()
clf()
plot(dd, usv_balance(dd), 'b-')
hold on
yline(0, 'k--')
plot(d_draft, 0, 'ro', 'MarkerFaceColor', 'r')
hold off

function f = usv_balance(d)
R = 0.213;          % Hull radius (m)
L = 5;              % Hull length (m)
m = 200;            % Vessel mass (kg)
rho = 1000;         % Density of water (kg/m^3)
V = L .* (R.^2 .* acos(1 - d./R) - (R - d) .* sqrt(R.^2 - (R - d).^2));
f = 2 .* rho .* V - m;
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
