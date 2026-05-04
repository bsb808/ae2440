% Geometry of one dead reckoning leg.
% Heading theta (clockwise from north) decomposes a displacement v*dt
% into east and north components via sin and cos.

figure(1); clf
hold on; axis equal; axis off

theta_deg = 40;
theta_rad = theta_deg * pi / 180;
dist      = 1;
dx        = dist * sin(theta_rad);
dy        = dist * cos(theta_rad);

blue = [0.15 0.35 0.75];
red  = [0.80 0.15 0.15];
gray = [0.40 0.40 0.40];

% --- compass arrows
al = 1.15;
quiver(0, 0,  0, al, 0, 'Color',gray, 'LineWidth',1.5, 'MaxHeadSize',0.10)
quiver(0, 0, al,  0, 0, 'Color',gray, 'LineWidth',1.5, 'MaxHeadSize',0.10)
text(-0.04, al+0.05, 'N', 'FontSize',14, 'FontWeight','bold', ...
    'HorizontalAlignment','center')
text(al+0.05, 0, 'E', 'FontSize',14, 'FontWeight','bold', ...
    'VerticalAlignment','middle')

% --- dashed component lines (right triangle)
plot([0,  dx], [0,  0],  '--', 'Color',red, 'LineWidth',1.5)   % base  (Δx)
plot([dx, dx], [0, dy],  '--', 'Color',red, 'LineWidth',1.5)   % height (Δy)

% --- right-angle marker at (dx, 0)
sq = 0.038;
plot([dx-sq, dx-sq, dx], [0, sq, sq], 'Color',gray, 'LineWidth',0.9)

% --- angle arc from north to vector
r_arc = 0.22;
arc   = linspace(pi/2, pi/2 - theta_rad, 80);
plot(r_arc*cos(arc), r_arc*sin(arc), 'k-', 'LineWidth',1.5)

% --- displacement vector (drawn last so arrowhead sits on top)
quiver(0, 0, dx, dy, 0, 'Color',blue, 'LineWidth',2.5, 'MaxHeadSize',0.14)

% --- departure point
plot(0, 0, 'ko', 'MarkerSize',8, 'MarkerFaceColor','k')

% --- labels
% theta — at midpoint of arc
mid_arc  = pi/2 - theta_rad/2;
text(0.30*cos(mid_arc), 0.30*sin(mid_arc), '$\theta$', ...
    'Interpreter','latex', 'FontSize',16, 'HorizontalAlignment','center')

% v*dt — alongside the vector, offset to its left
rot      = 90 - theta_deg;                          % degrees CCW from horizontal
left_off = 0.09 * [-cos(theta_rad), sin(theta_rad)];
text(dx/2 + left_off(1), dy/2 + left_off(2), '$v \,\Delta t$', ...
    'Interpreter','latex', 'FontSize',13, 'Color',blue, ...
    'HorizontalAlignment','center', 'Rotation',rot)

% Δx — below the base
text(dx/2, -0.10, '$\Delta x = v\,\Delta t\,\sin\theta$', ...
    'Interpreter','latex', 'FontSize',12, 'Color',red, ...
    'HorizontalAlignment','center')

% Δy — to the right of the height
text(dx+0.07, dy/2, '$\Delta y = v\,\Delta t\,\cos\theta$', ...
    'Interpreter','latex', 'FontSize',12, 'Color',red, ...
    'VerticalAlignment','middle')

axis([-0.12, 1.55, -0.22, 1.28])
