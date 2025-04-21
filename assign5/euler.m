function [tt, yy] = euler(odefun, tspan, y0)
    %EULER  Solve differential equations with Euler integration.
    %   [TOUT,YOUT] = EULER(ODEFUN,TSPAN,Y0) integrates the system of
    %   differential equations y' = f(t,y) from time TSPAN(1) to TSPAN(end)
    %   with initial conditions Y0. Each row in the solution array YOUT
    %   corresponds to a time in the column vector TOUT. 
    %     * ODEFUN is a function handle. For a scalar T and a vector Y,
    %       ODEFUN(T,Y) must return a column vector corresponding to f(t,y).
    %     * TSPAN is a two-element vector [T0 TFINAL] 
    %     * YO is a column vector of initial conditions, one for each equation.

    % Time step is fixed at 100 points within the tspan
    n = 100;
    dt = (tspan(2) - tspan(1)) / n;
    tt = linspace(tspan(1), tspan(2), n);
    dt = tt(2)-tt(1);
    % Create vectors to store the solutions
    tt = zeros(1, n);
    tt(1) = tspan(1);
    yy = zeros(1, n);
    yy(1) = y0;
    % Euler
    for ii = 2:n
        rate = odefun(tt(ii-1), yy(ii-1));
        tt(ii) = tt(ii-1) + dt;
        yy(ii) = yy(ii-1) + rate*dt;
    end

end
