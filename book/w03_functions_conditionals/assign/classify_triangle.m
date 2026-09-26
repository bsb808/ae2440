function triangle_type = classify_triangle(a, b, c)

% CLASSIFY_TRIANGLE  Classify a valid triangle by its side lengths.

%
%   TRIANGLE_TYPE = CLASSIFY_TRIANGLE(A, B, C) returns "Equilateral",

%   "Isosceles", or "Scalene" based on the side lengths A, B, C.


% Equilateral must be tested before isosceles: a triangle with all three

% sides equal would also satisfy the two-sides-equal condition, so testing

% isosceles first would misclassify it.

if a == b && b == c

    triangle_type = "Equilateral";

elseif a == b || a == c || b == c

    triangle_type = "Isosceles";

else

    triangle_type = "Scalene";

end


end