function valid = is_valid_triangle(a, b, c)
% IS_VALID_TRIANGLE  Check whether three side lengths form a valid triangle.
%   VALID = IS_VALID_TRIANGLE(A, B, C) returns 1 if the three side lengths A, B, C satisfy the triangle inequality, and 0 otherwise.

% All three combinations must hold,
if (a + b > c) && (a + c > b) && (b + c > a)
    valid = 1;
else
    valid = 0;
end

% The single compound expression valid = (a + b > c) && (a + c > b) && (b + c > a) gives the same answer as a logical true or false, which MATLAB displays as true/false but compares equal to 1/0.

end
