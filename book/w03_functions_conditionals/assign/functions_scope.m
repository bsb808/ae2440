%[text] # Variable Scope and MATLAB Workspaces
%[text] When MATLAB runs a function — whether in a separate file or defined locally at the bottom of a live script — that function runs in its own private workspace. Variables in the script are not visible inside the function, and variables created inside the function are not visible in the script. This is called *variable scope*.
%[text] This exercise walks you through three common scoping mistakes. For each one you will run the broken code, read the error message, fix the code, and answer a short question.
%[text] ## Section 1 — Script variables are not visible inside a function
%[text] The code below defines a radius in the script and then calls a local function to compute the area of a circle. Run it and read the error message carefully.
radius = 7;
area = circle_area();
disp("Circle area: " + area)

function a = circle_area()
    a = pi * radius^2;   
end
%[text] MATLAB cannot find `radius` inside `circle_area` because the function has its own private workspace — it has no access to variables defined in the script above it.
%[text] **Your task:** Fix `circle_area` so that it accepts `radius` as an input argument. Update the call in the script to pass the value in. Re-run and confirm the output is approximately 153.94.
%%
%[text] ## Section 2 — Function variables are not visible in the script
%[text] The code below calls a local function that computes the perimeter of a rectangle. The function does its work correctly, but the script tries to use the result in the wrong way. Run it and read the error message.
compute_perimeter(5, 12);
disp("Rectangle perimeter: " + perimeter)   

function compute_perimeter(w, h)
    perimeter = 2 * (w + h);
end
%[text] The variable `perimeter` was created inside `compute_perimeter` and exists only there. Once the function returns, that workspace is discarded. The script has no idea `perimeter` ever existed.
%[text] **Your task:** Modify `compute_perimeter` to return `perimeter` as an output argument. Update the call in the script to capture the returned value. Re-run and confirm the output is 34.
%%
%[text] ## **Section 3 — Functions do not modify the caller's variables**
%[text] The code below passes a temperature value to a local function that is supposed to convert it from Celsius to Fahrenheit in place. The function runs without error, but the result in the script is not what you expect. Run it and inspect the output.
temp = 100;
convert_to_fahrenheit(temp);
disp("Temperature: " + temp)   

function convert_to_fahrenheit(t)
    t = t * 9/5 + 32;
end
%[text] This one does not produce an error message — it silently gives the wrong answer, which makes it the most dangerous kind of bug. MATLAB passes variables *by value*, meaning the function receives its own private copy of `temp`. Modifying `t` inside the function has no effect on `temp` in the script.
%[text] **Your task:** Modify `convert_to_fahrenheit` to return the converted value as an output argument. Update the script to capture it into a variable called `temp_f` and display that instead. Re-run and confirm the output is 212.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
