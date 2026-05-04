function [tt, yy] = euler(odefun, tspan, v0)%[tt,yy] is the solution as a vector
t0=tspan(1) % Initial time value in my time matrix
tf=tspan(2) % Final time value in my time matrix
dt=(tf-t0)/100 %delta t/ number of steps
t=t0

for k=1: length(tt)-1
    tnow=tt(k)
    ynow=yy(k)
    ydot=odefun(tnow,ynow) 
    yy(k+1)=y(k)+ydot(dt)%output

end
end
% function [tt, yy] = euler(odefun, tspan, y0) 
% tspan=[0:30]
% tt(1)=tspan(1); 
% yy(1)=y0; 
% tt    = tspan(end); 
% yy    = yy(end);
% tt=tspan(1):dt:tspan(2)
% ydot=odefun(tt(k),yy(k))
% %[tt, yy] = euler(odefun, tspan, y0) 
% odefun=y0+dt*f(t,y); % tk and yk???
% dt=(tspan(2)-tspan(1))/100
% yy(k+1)=y(k)+ydot(dt)

%attatch below to function above
%tt=tspan(1):dt:tspan(2) time space 
%yy(1)=y0
%for k=1:length(tt)-1
%tnow=tt(k)
%ynow=yy(k)
%ydot=odefun(tnow,ynow)
%yy(k+1)=yy(k)+ydot*dt
%end

% function [tt, yy] = euler(odefun, tspan, y0) %[tt,yy] is the solution as a vector
% tt(1)=tspan(1); % I dont understand these do I need them?
% yy(1)=y0; % Are they the initial values??
% tt    = tt_euler(end); % What is this doing?
% yy    = yy_euler(end);
% %[tt, yy] = euler(odefun, tspan, y0) % all from ballistics
% odefun=y0+dt*f(t,y); % tk and yk???
% dt=(tspan(2)-tspan(1))/100
% end

%function [tt, yy] = euler(f, tt, yy,t, y) % do I need a step variable?
%dt=(tspan(2)-tspan(1))/100
%tt_euler = [0];
%yy_euler = [0];
%t=tt_euler(end)
%y=yy_euler(end)
%tt_euler(end+1) = t + dt; %from lesson find timeseries step
%yy_euler(end+1) = y + dydt * dt;
%end

%[text] $y\_{k+1} = y\_k + dt \\cdot f(t\_k,\\, y\_k)$

%[appendix]{"version":"1.0"}
%---
