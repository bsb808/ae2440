function [tt, yy] = euler(odefun, tspan, y0)
    %EULER  Solve differntial equations with Euler integration.
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
    tt = linspace(tspan(1), tspan(2), n);
    dt = tt(2)-tt(1);
    % Create vector to store the solutions
    yy = zeros(n, 1);
    yy(1) = y0;

    % Euler
    for ii = 2:n
        rate = odefun(tt(ii-1), yy(ii-1));
        yy(ii) = yy(ii-1) + rate*dt;
    end

end
