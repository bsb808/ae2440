%[text] # Draft by interp1 and fzero: model repeated
R = 0.213;
L = 5;
m = 200;
rho = 1000;
dd = 0:0.001:2*R;
%%
%[text] ## interp1
mass = 2*rho*L*(R^2*acos(1 - dd/R) - (R - dd).*sqrt(R^2 - (R - dd).^2));
d_interp = interp1(mass, dd, m)
%%
%[text] ## fzero
f = @(d) 2*rho*L*(R^2*acos(1 - d/R) - (R - d).*sqrt(R^2 - (R - d).^2)) - m;
d_fzero = fzero(f, R)
%%
%[text] ## Check
ff = 2*rho*L*(R^2*acos(1 - dd/R) - (R - dd).*sqrt(R^2 - (R - dd).^2)) - m;
d_check = interp1(ff, dd, 0)
plot(dd, ff)
grid on

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
