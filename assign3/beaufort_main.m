%[text] # Beaufort Scale Wind Classifier
%[text] We often classify sea conditions using the Beaufort scale, which maps wind speed (in knots) to a force number and a descriptive sea state. In this exercise you will write a MATLAB function that performs this classification, then call it from this live script.
%[text] **Learning objectives**
%[text] - Write a simple function in a separate .m file
%[text] - Use an if-else ladder to implement multi-way branching
%[text] - Return multiple output values from a function \
%[text] ## Set Wind Speed
%[text] Change this single value of `wind_speed_kts` below and re-run the script to test different conditions.
wind_speed_kts = 25;   % knots — edit this value
%[text] ## Validation, Function Call and Output
%[text] Before calling any function it is good practice to check that inputs are sensible. The code below performs a simple range check and displays a message if the value is out of bounds. Notice that the entire classification and display logic sits inside the `else` block — if the input is invalid, nothing further executes.
if wind_speed_kts < 0 || wind_speed_kts > 200
    disp("Invalid wind speed. Please enter a value between 0 and 200 knots.")
else
    [bf_number, sea_state] = beaufort_classify(wind_speed_kts);
    disp("Wind speed : " + wind_speed_kts + " knots")
    disp("Beaufort   : Force " + bf_number)
    disp("Sea state  : " + sea_state)
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
