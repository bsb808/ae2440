function res = myfunc(x)
%MYFUNC Manhattan distance from the origin to a point on the unit circle.
%   d = MYFUNC(d) is the distance from the origin to a point on the unit
%   circle with (x) as the angle in radians.

    s = sin(x);
    c = cos(x);
    res = abs(s) + abs(c);

end
