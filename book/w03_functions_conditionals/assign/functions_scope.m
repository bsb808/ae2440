%[text] # Variable Scope and MATLAB Workspaces
%[text] When MATLAB runs a function (both plain and local functions) that function runs in its own private workspace. Variables in the script are not visible inside the function, and variables created inside the function are not visible in the script. 
%[text] This exercise walks you through three common scoping mistakes. For each...
%[text] 1. run the broken code
%[text] 2. read the error message
%[text] 3. fix the code. \
%[text] ## Section 1 — Script variables are not visible to a local function
%[text] The code below defines a radius in the script and then calls a local function to compute the area of a circle. 
radius = 7;
area = circle_area();
disp("Circle area: " + area)

function a = circle_area()
    a = pi * radius^2;   
end
%[text] MATLAB cannot find `radius` inside `circle_area` because the function has its own private workspace.
%[text] - Fix `circle_area` so that it accepts `radius` as an input argument. 
%[text] - Update the function call in the script to pass the radius value as an input to `circle_area`
%[text] - Re-run and confirm the output is approximately 153.94. \
%%
%[text] ## Section 2 — Function variables are not visible in the script
%[text] The code below calls a local function that computes the perimeter of a rectangle. The function does its work correctly, but the script tries to use the result in the wrong way. 
compute_perimeter(5, 12);
disp("Rectangle perimeter: " + perimeter)   

function compute_perimeter(w, h)
    perimeter = 2 * (w + h);
end
%[text] The variable `perimeter` was created inside `compute_perimeter` and exists only there. The script has no idea `perimeter` ever existed.
%[text] - Modify `compute_perimeter` to return `perimeter` as an output argument. 
%[text] - Update the call in the script to capture the returned value. 
%[text] - Re-run and confirm the output is 34. \
%%
%[text] ## Section 3 — Functions do not modify the caller's variables
%[text] The code below passes a temperature value to a local function that is intended to convert it from Celsius to Fahrenheit in place. 
%[text] The function runs without error, but the result in the script is not as intended - the `temp` values is still in Celsius.
temp = 100;
convert_to_fahrenheit(temp);
disp("Temperature: " + temp)   

function convert_to_fahrenheit(temp)
    temp = temp * 9/5 + 32;
end
%[text] This is a semantic error that does not generate an error message, but silently gives an unintended result. MATLAB passes variables *by value*, meaning the function receives a **copy** of `temp`. Modifying the copied `temp` inside the function has no effect on  `temp` in the live script.
%[text] - Modify `convert_to_fahrenheit` to return the converted value as an output argument. 
%[text] - Update the script to capture it into a variable called `temp_f` and display that instead. 
%[text] - Re-run and confirm the output is 212. \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
