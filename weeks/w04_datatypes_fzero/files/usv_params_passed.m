%[text] # Parameters passed to the function
R = 0.213;
L = 5;
m = 200;
rho = 1000;

d0 = 0.1;
d = fzero(@(d) usv_balance(d, R, L, m, rho), d0)

function f = usv_balance(d, R, L, m, rho)
    V = L*(R^2*acos(1 - d/R) - (R - d)*sqrt(R^2 - (R - d)^2));
    f = 2*rho*V - m;
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
