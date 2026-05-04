% Implement Euler's method. and show results
function res = euler()
    % Initial conditions
    tt(1) = 0;
    yy(1) = 5;
    % Time step
    dt = 0.1;
    
    % Loop for each time step
    for i=1:40
        r = rate_func(tt(i), yy(i));
        tt(i+1) = tt(i) + dt;
        yy(i+1) = yy(i) + r * dt;
    end
    plot(tt, yy)
    xlabel('Time [hours]')
    ylabel('Population [cells]')
end

function res = rate_func(t, y)
    %RATE_FUNC  Rate of growth at time (t) for population (y).
    a = 0.2;
    res = a * y;
end
