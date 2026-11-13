%[text] # Assignment 4 — USV Draft
%[text] Estimate the draft $d$ of the WAM-V 16 USV, modeling each of its two hulls as a cylinder of radius $R = 0.213$ m and length $L = 5$ m. The vessel mass is $m = 200$ kg and the density of water is $\\rho = 1000$ kg/m$^3$.
%%
%[text] ## Buoyancy Equilibrium
%[text] At equilibrium the mass of the water displaced by both hulls equals the mass of the vessel. Each hull displaces the submerged volume $V$ given in the assignment, so
%[text]{"align":"center"} $m = 2 \\rho L \\left( R^2 \\arccos\\left(1 - \\frac{d}{R}\\right) - (R - d)\\sqrt{R^2 - (R - d)^2} \\right)$
%%
%[text] ## Rearrange - pose as root finding
%[text] Move everything to the left side so that the expression is equal to zero. The draft we want is the value of $d$ that makes this expression zero, i.e., the root of the left hand side:
%[text]{"align":"center"} $f(d) = m - 2 \\rho L \\left( R^2 \\arccos\\left(1 - \\frac{d}{R}\\right) - (R - d)\\sqrt{R^2 - (R - d)^2} \\right) = 0$
%[text] $f(d)$ is the vessel mass minus the displaced mass, so it is positive when the USV sits too high (not enough water displaced) and negative when it sits too deep. Defining it the other way round, displaced mass minus vessel mass, flips the sign but has the same zero.
%%
%[text] ## Local Function
%[text] The local function implements $f(d)$, with the parameters defined inside it. It uses element-wise operators (`.*`, `./`, `.^`) so that it also works when `d` is a vector.
function f = usv_balance(d)
    % Parameters
    R = 0.213;          % Hull radius [m]
    L = 5;              % Hull length [m]
    m = 200;            % Vessel mass [kg]
    rho = 1000;         % Density of water [kg/m^3]

    % Submerged volume of one hull [m^3]
    V = L .* (R.^2 .* acos(1 - d./R) - (R - d) .* sqrt(R.^2 - (R - d).^2));

    % Vessel mass minus the mass of water displaced by both hulls [kg]
    f = m - 2 .* rho .* V;
end
%%
%[text] ## Test the Function
%[text] With no draft, nothing is displaced, so $f(0)$ should equal the vessel mass, 200 kg.
usv_balance(0)
%[text] As the draft increases, more water is displaced and $f(d)$ decreases. The model applies for $0 \\le d \\le 2R = 0.426$ m.
usv_balance(0.05)
usv_balance(0.1)
usv_balance(0.2)
usv_balance(2*0.213)
%[text] The sign changes from positive to negative between $d = 0.05$ m and $d = 0.1$ m, so there is a root in that interval. At $d = 2R$ both hulls are fully submerged, and $f$ is the vessel mass minus the mass of water that both full cylinders would displace.
%[text] Outside $0 \\le d \\le 2R$ the square root and the arccosine have no real value, and the function returns a complex number:
usv_balance(0.5)
%%
%[text] ## Solve with fzero
%[text] Pass a function handle to `usv_balance` and an initial estimate. The tests above suggest a guess of 0.1 m.  Later we will verify that the solution is not affected by the specific choice of initial estimate.
d_init = 0.1;
d_equil = fzero(@usv_balance, d_init)
%[text] A second check is to give `fzero` an interval that brackets the root. The whole valid range works, because $f$ changes sign across it:
d_bracket = fzero(@usv_balance, [0, 2*0.213])
%[text] Both calls give the same draft, which builds confidence in the answer:
fprintf('Estimated draft of the WAM-V 16: %.3f m (%.1f cm)\n', d_equil, 100*d_equil);
%[text] At this draft $f$ should be essentially zero:
usv_balance(d_equil)
%%
%[text] ## Verify: Graphical, with a Plot
%[text] Plot $f(d)$ over the valid range $0 \\le d \\le 2R$. The `fzero` solution should be where the curve crosses the horizontal axis. As a bonus, markers show the initial guess and the solution.
R = 0.213;                          % Hull radius [m]
dd = linspace(0, 2*R, 200);
ff = usv_balance(dd);

figure
plot(dd, ff, 'b-')
hold on
yline(0, 'k--')
plot(d_init, usv_balance(d_init), 'ks', 'MarkerFaceColor', 'y')
plot(d_equil, usv_balance(d_equil), 'ro', 'MarkerFaceColor', 'r')
hold off
grid on
xlabel('Draft, d [m]')
ylabel('Vessel mass - displaced mass, f(d) [kg]')
title('WAM-V 16 buoyancy balance')
legend('f(d)', 'Equilibrium, f = 0', 'Initial guess', 'fzero solution')
%[text] The curve crosses zero at the `fzero` solution, so the estimated draft is consistent with the model.
%[text] 
%%
%[text] ## Verify: Solution invariant to initial estimate
%[text] **Note:** The following goes beyond what was asked for in the solution.   The intent is to show how human engineering judgement and context is necessary to be able to guide the computational solver.
%[text] 
%[text] `fzero` is naive, it only knows the math we give it.  It has no context or meaning to the values.   That physical context has to come from the human user, and we use it to choose where the solver starts. This is engineering judgement.
%[text] What do we know before solving? The draft must lie between $0$ and $2R$. A quick check narrows that further: if both hulls were submerged to their centerline ($d = R$), would the USV float?
usv_balance(R)
%[text] The result is strongly negative: half-submerged hulls displace far more water than the 200 kg vessel needs. 
%[text] If the solution is trustworthy, every reasonable initial estimate should lead `fzero` to the same draft. Try several:
d_guesses = [0.05, 0.075, 0.1, 0.15, 0.2];
for k = 1:length(d_guesses) %[output:group:6ca32739]
    d_k = fzero(@usv_balance, d_guesses(k));
    fprintf('Initial estimate %.3f m  ->  draft %.4f m\n', d_guesses(k), d_k);
end %[output:group:6ca32739]
%[text] Every reasonable initial estimate gives the same draft, so the answer does not depend on where the solver starts. That is good evidence that we found the one physical root.
%[text] Now see what happens with estimates that ignore the physics: a draft of almost zero, and one with the hulls nearly fully submerged.
d_low = fzero(@usv_balance, 0.01)
d_high = fzero(@usv_balance, 0.4)
%[text] Both return `NaN`. Starting from a single estimate, `fzero` first searches outward on both sides of the initial value for a sign change. From an estimate near either end of the valid range, that search soon steps below $d = 0$ or above $d = 2R$, where the model returns complex numbers, and `fzero` gives up. 
%[text] The lesson is that a numerical solver does not replace understanding the problem - good news for engineers! Physical context told us the range of possible drafts, gave us a sensible initial estimate, and lets us judge the answer. When physics lets us bracket the root, as with the interval $\[0, 2R\]$ above, the solver is the most reliable. The answer is also plausible: a draft of about 8 cm for a 200 kg vessel on two 5 m pontoons.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
