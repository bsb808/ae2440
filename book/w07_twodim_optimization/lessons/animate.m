tspan = [0 10];
W = [0 1 30 40];
[T, M] = ode45(@rate_func, tspan, W);


figure(3);
clf();
x = Xout(:,1);
y = Xout(:,2);
minmax = [min([x]), max([x]), min([y]), max([y])];
for ii=1:length(tout)
    clf; hold on
    axis(minmax)
    plot(x(ii), y(ii), 'o')
    drawnow;
    if ii < length(tout)
        dt = tout(ii+1) - tout(ii);
        pause(dt);
    end
end

