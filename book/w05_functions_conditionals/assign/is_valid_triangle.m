function valid = is_valid_triangle(a, b, c)

% IS_VALID_TRIANGLE  Check whether three side lengths form a valid triangle.
%   VALID = IS_VALID_TRIANGLE(A, B, C) returns true if the three side
%   lengths A, B, C satisfy the triangle inequality, and false otherwise.

valid = (a + b > c) && (a + c > b) && (b + c > a);

end