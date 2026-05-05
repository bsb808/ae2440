%[text] # Unicycle Model — Plan-View Vehicle Kinematics
%[text] ## Scenario
%[text] Many vehicles seen from above — a small surface craft, a wheeled robot, an aircraft in level flight — can be approximated by the **unicycle model**. The vehicle has a position $(x, y)$ in the plane and a heading angle $\\theta$ measured from east. It always moves in the direction it points, with forward speed $v$ and turn rate $\\omega$.
%[text] In this assignment you will build the model, simulate it open-loop to confirm the behavior, and then close a feedback loop that steers the vehicle toward a fixed waypoint.
%%
%[text] ## The Model
%[text] The state vector has three components:
%[text] $\\mathbf{x}(t) = \\left\\{ \\begin{array}{c} x \\\\ y \\\\ \\theta \\end{array} \\right\\}$
%[text] The equations of motion are
%[text] $\\dot{x} = v\\cos\\theta, \\quad \\dot{y} = v\\sin\\theta, \\quad \\dot{\\theta} = \\omega.$
%[text] The velocity vector $\\dot{\\mathbf{p}} = [\\dot{x}, \\dot{y}]$ has magnitude $v$ and direction $[\\cos\\theta, \\sin\\theta]$ — a unit vector in the heading direction. The chapter's `hat(V)` function builds a unit vector by dividing out the magnitude; here we already know the unit vector directly from $\\theta$.
%[text] Unlike the baseball model, the unicycle is **kinematic**: the inputs are velocities, not forces. There is no $F = ma$ here. Spatial vectors still carry the 2D geometry — they just describe motion instead of force.
%%
%[text] ## Part 1 — Rate Function (Open Loop)
%[text] Write a local function `unicycle(t, xx, params)` that returns $\\dot{\\mathbf{x}}$ as a column vector. The third argument `params = [v; omega]` lets you change the inputs without rewriting the function.
%[text] Test it at the initial state $\\mathbf{x}\_0 = [0;\\ 0;\\ 0]$ with $v = 2$ m/s and $\\omega = 0$. Heading is east and turn rate is zero, so the result should be $[2;\\ 0;\\ 0]$ — moving east at 2 m/s, not turning.
function dxxdt = unicycle(t, xx, params)
    % Your code here.
end
xx0 = [0; 0; 0];
rate_check = unicycle(0, xx0, [2; 0])
%%
%[text] ## Part 2 — Open-Loop Trajectories
%[text] Wrap the rate function in an anonymous handle so `ode45` sees the standard `(t, xx)` interface. Solve over $t \\in [0, 30]$ s for two cases.
%[text] **Straight line** ($v = 2$, $\\omega = 0$): expected to travel $v \\cdot t\_f = 60$ m due east. Plot $y$ vs $x$ on equal axes with labels.
%
%[text] **Circle** ($v = 2$, $\\omega = 0.5$): from the equations of motion the radius is $R = v / \\omega$. With these values $R = 4$ m. Plot and verify visually.
%
%%
%[text] ## Part 3 — Steer Toward a Waypoint
%[text] Now the vehicle drives itself toward a fixed goal at $(x\_g,\\, y\_g) = (20,\\, 15)$ m. Forward speed stays $v = 2$ m/s, but $\\omega$ is no longer constant — at every instant it is computed from the **bearing error** between the current heading and the direction to the goal.
%[text] **Bearing to goal** — the angle from the vehicle to the goal, measured from east:
%[text] $\\lambda = \\mathrm{atan2}(y\_g - y,\\; x\_g - x)$
%[text] Use `atan2`, not `atan` — `atan2` returns the correct quadrant over the full $[-\\pi, \\pi]$.
%[text] **Bearing error** — how far off the current heading is from the bearing to the goal. Angles wrap at $\\pm\\pi$, so a naive subtraction can produce a value larger than $\\pi$. The trick `atan2(sin(d), cos(d))` wraps any angle $d$ back into $[-\\pi, \\pi]$.
%[text] **Steering law** — turn rate proportional to bearing error:
%[text] $\\omega = K \\cdot \\mathrm{atan2}(\\sin(\\lambda - \\theta),\\; \\cos(\\lambda - \\theta))$
%[text] Write a new rate function `unicycle_goal(t, xx, K)` that uses this law with a fixed goal and forward speed inside the function body.
function dxxdt = unicycle_goal(t, xx, K)
    % Your code here.
end
%[text] Wrap it for `ode45` and run with $K = 1.5$ over $t \\in [0, 25]$ s. Plot the trajectory on equal axes and mark the goal with a red filled circle.
%
%[text] You should see the vehicle curve smoothly toward $(20, 15)$ and then **circle around it** — the model has no "stop" condition, so once on top of the goal it keeps moving at speed $v$ and orbits.
%[text] **Reflect:**
%[text] - Try $K = 0.3$ and $K = 5$. What changes? Which is more like how a person would steer?
%[text] - The bearing $\\lambda$ and the heading direction $[\\cos\\theta, \\sin\\theta]$ both describe direction in the plane — one as an angle, one as a unit vector. Where does each form appear in your code, and why each one in that place?
%[text] ADD A FEW SENTENCES OF REFLECTION HERE
%[text] Once everything runs successfully, submit **unicycle.m** via Sakai.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
