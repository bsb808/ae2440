%[text] # **Triangle Classifier**
%[text] A triangle is one of the most fundamental geometric shapes, and determining whether three lengths can even form a triangle — and what kind — requires careful use of conditional logic and boolean expressions. In this exercise you will write two functions: one that validates a proposed triangle, and one that classifies it. Together they illustrate how compound boolean conditions and if-else logic combine to solve a practical classification problem.
%[text] **Learning objectives**
%[text] - Write and call multiple external function files
%[text] - Construct compound boolean expressions using `&&` and `||`
%[text] - Use an if-else ladder where the order of testing matters \
%[text] **Set the side lengths**
%[text] To support development, we arbitrarily define a triangle by defining three sides as separate variables.
a = 3;
b = 4;
c = 5;
%[text] ## **Input validation and Single Test**
%[text] Before calling either function we check that all three sides are positive numbers. If any side is zero or negative the script displays a message and does not proceed. 
%[text] Note - you will need to write the two function files before the next code block will run.
if a <= 0 || b <= 0 || c <= 0
    disp("Invalid input. All side lengths must be positive.")    
else  
    valid = is_valid_triangle(a, b, c);   
    if valid       
        triangle_type = classify_triangle(a, b, c);  
        disp("Side lengths   : " + a + ", " + b + ", " + c)
        disp("Valid triangle : Yes")
        disp("Type           : " + triangle_type)
    else   
        disp("Side lengths   : " + a + ", " + b + ", " + c) 
        disp("Valid triangle : No")   
    end
end
%[text] ## **Your task: write** **`is_valid_triangle.m`**
%[text] Create a new file named `is_valid_triangle.m` in the same folder as this live script. The file must contain a function satisfying the following specification.
%[text] **Name:** `is_valid_triangle`
%[text] **Inputs:** `a`, `b`, `c` — three side lengths (positive numbers)
%[text] **Output:** `valid` — a logical value (`true` or `false`)
%[text] **Behavior:** A set of three lengths forms a valid triangle if and only if the sum of any two sides is strictly greater than the third side. This condition must hold for all three combinations. If all three combinations are satisfied the function returns `true`; otherwise it returns `false`. Express this as a single compound boolean expression.
%[text] **Hint:** Think carefully about whether you need `&&`, `||`, or both, and how they combine here.
%[text] ## **Your task: write** **`classify_triangle.m`**
%[text] Create a new file named `classify_triangle.m` in the same folder as this live script. The file must contain a function satisfying the following specification.
%[text] **Name:** `classify_triangle`
%[text] **Inputs:** `a`, `b`, `c` — three side lengths of a known valid triangle
%[text] **Output:** `triangle_type` — a string: `"Equilateral"`, `"Isosceles"`, or `"Scalene"`
%[text] **Behavior:** Classify the triangle according to the following rules. An equilateral triangle has all three sides equal. An isosceles triangle has exactly two sides equal. A scalene triangle has no sides equal. Use an if-else ladder to test these conditions in order.
%[text] **Important:** The order in which you test the conditions matters. Think about why equilateral must be tested before isosceles, and write a one-sentence comment in your code explaining your reasoning.
%[text] **Summary**
%[text] This exercise introduced two related but distinct uses of boolean logic. In `is_valid_triangle` a single compound expression combines multiple conditions that must all be true simultaneously. In `classify_triangle` an if-else ladder tests conditions in a deliberate order where getting the sequence wrong produces incorrect results even when no error is thrown (i.e., a *semantic error*). Both patterns appear frequently in engineering software — recognizing which one a problem calls for is an important design skill.
%[text] ## Verification Testing
%[text] Test your functions with at least four cases: one equilateral, one isosceles, one scalene, and one invalid set of lengths. Confirm that each produces the expected output before moving on.
% Your Code Goes Here

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
