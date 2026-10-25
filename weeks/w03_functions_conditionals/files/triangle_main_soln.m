%[text] # Assignment 3 — Triangle Classifier
%[text] A triangle is one of the most fundamental geometric shapes, and determining whether three lengths can even form a triangle, and what kind,  requires careful use of conditional (if-elseif) logic and boolean expressions. In this exercise you will write two functions: 
%[text] 1. one that validates a proposed triangle, and
%[text] 2. one that classifies it. \
%[text] To get started, we define a 3-4-5 triangle so we have a clear idea of what to expect.
a = 3;
b = 4;
c = 5;
%[text] ## **Triangle Validator**
%[text] Create a new file named `is_valid_triangle.m` in the same folder as this live script. The function implements this  specification:
%[text] - **Name:** `is_valid_triangle`
%[text] - **Inputs:** `a`, `b`, `c` — three side lengths as positive, scalar numbers.
%[text] - **Output:** `valid` — a validity flag as a scalar number, `1` for true and `0` for false. \
%[text] **Behavior:** A set of three lengths forms a valid triangle if and only if the sum of any two sides is strictly greater than the third side. This condition must hold for all three combinations. If all three combinations are satisfied the function returns `1`; otherwise it returns `0`.  The logic of this behavior can be accomplished in a variety of ways.   If you want a challenge, see if you can express this as a single compound boolean expression. (Think carefully about whether you need `&&`, `||`, or both, and how they combine.)
%[text] ### Verify
%[text] The cases below cover each way the validator function can be right or wrong. 
%[text:table]
%[text] | Category | Expected |
%[text] | --- | --- |
%[text] | Valid, scalene | `1` |
%[text] | Valid, isosceles | `1` |
%[text] | Valid, equilateral | `1` |
%[text] | Invalid, long side in `c` | `0` |
%[text] | Invalid, long side in `b` | `0` |
%[text] | Invalid, long side in `a` | `0` |
%[text] | Degenerate (sum equals the third side) | `0` |
%[text] | Non-integer lengths | `1` |
%[text:table]
%[text] To verify your function, choose at least three of the cases from table above, and demonstrate that your function provides the expected result.
%[text] Each row of `sides` is one case from the table, in the same order, and `valid_expected` holds the expected flag. The degenerate case 1, 2, 3 lies on a line (1 + 2 equals 3), so the strict inequality rejects it.
sides = [3    4    5       % Valid, scalene
         5    5    8       % Valid, isosceles
         2    2    2       % Valid, equilateral
         1    2    10      % Invalid, long side in c
         1    10   2       % Invalid, long side in b
         10   1    2       % Invalid, long side in a
         1    2    3       % Degenerate
         0.5  0.5  0.9];   % Non-integer lengths
valid_expected = [1 1 1 0 0 0 0 1];
for k = 1:size(sides, 1)
    valid = is_valid_triangle(sides(k, 1), sides(k, 2), sides(k, 3));
    disp(sides(k, 1) + ", " + sides(k, 2) + ", " + sides(k, 3) + " : valid = " + valid + " (expected " + valid_expected(k) + ")")
end
%[text] ## **Triangle Classifier**
%[text] Create a new file named `classify_triangle.m` in the same folder as this live script. The file must contain a function satisfying the following specification.
%[text] - **Name:** `classify_triangle`
%[text] - **Inputs:** `a`, `b`, `c` — three side lengths of a known valid triangle
%[text] - **Output:** `triangle_type` — a string message: `"Equilateral"`, `"Isosceles"`, or `"Scalene"` \
%[text] **Behavior:** Classify the triangle according to the following rules. An equilateral triangle has all three sides equal. An isosceles triangle has exactly two sides equal. A scalene triangle has no sides equal. Use an if-else ladder to test these conditions. 
%[text] ### Verify
%[text] The cases below cover the possible categories to verify.
%[text:table]{"ignoreHeader":true}
%[text] | Category | Expected |
%[text] | --- | --- |
%[text] | Equilateral | `"Equilateral"` |
%[text] | Isosceles, `a` equals `b` | `"Isosceles"` |
%[text] | Isosceles, `a` equals `c` | `"Isosceles"` |
%[text] | Isosceles, `b` equals `c` | `"Isosceles"` |
%[text] | Scalene | `"Scalene"` |
%[text] | Nearly isosceles | `"Scalene"` |
%[text] | Non-integer lengths | `"Equilateral"` |
%[text:table]
%[text] To verify your function, choose at least three of the cases from table above, and demonstrate that your function provides the expected result.
%[text] The same pattern for the classifier. Every case here is a valid triangle, since the function assumes one.
sides = [2    2     2      % Equilateral
         5    5     8      % Isosceles, a equals b
         5    8     5      % Isosceles, a equals c
         8    5     5      % Isosceles, b equals c
         3    4     5      % Scalene
         5    5.01  8      % Nearly isosceles
         0.5  0.5   0.5];  % Non-integer lengths
type_expected = ["Equilateral" "Isosceles" "Isosceles" "Isosceles" "Scalene" "Scalene" "Equilateral"];
for k = 1:size(sides, 1)
    triangle_type = classify_triangle(sides(k, 1), sides(k, 2), sides(k, 3));
    disp(sides(k, 1) + ", " + sides(k, 2) + ", " + sides(k, 3) + " : " + triangle_type + " (expected " + type_expected(k) + ")")
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
