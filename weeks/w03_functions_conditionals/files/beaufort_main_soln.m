%[text] # Assignment 3 — Beaufort Scale Wind Classifier
%[text] We often classify sea conditions using the Beaufort scale, which maps wind speed (in knots) to a force number and a descriptive sea state. In this exercise you will write a MATLAB function that performs this classification, then call it from this live script.
%[text] **Learning objectives**
%[text] - Write a simple function in a separate .m file
%[text] - Use an if-else ladder to implement multi-way branching
%[text] - Return multiple output values from a function \
%[text] ## Background (Not strictly necessary to complete the exercise)
%[text] The Beaufort scale is a standardized numerical system, ranging from Force 0 (calm) to Force 12 (hurricane), that classifies wind speed and sea conditions based on observable effects on the water surface. Many of you will already be familiar with this scale from time at sea, and you will encounter it frequently in Navy system performance specifications, where equipment and vehicle operational envelopes are often defined in terms of Beaufort force limits.
%[text] Photographs of each sea state are in `beaufort.png` in the assignment folder (omitted here to keep the solution file small).
%[text] 
%[text] ## Set Wind Speed
%[text] To start, set a nominal value for the wind speed to test your function.  Change this single value of `wind_speed_kts` below and re-run the script to test different conditions.
wind_speed_kts = 25;   % knots 
%%
%[text] ## Incremental Development: Make it Work
%[text] *Make it work; Make it right*
%[text] *- Kent Beck*
%[text] To start incrementally, write a standard MATLAB function with the function name `beaufort_classify` in a new file named `beaufort_classify.m`.  To "make it work" we want the function to return two static (for now) values just to test the function setup.  Your prototype function should return a number and a string.  For now, simply return a constant number (0) and a constant string ("Calm"), whatever the input. The first line of your function file should be the function signature `function [bf_number, sea_state] = beaufort_classify(wind_speed_kts)`.
%[text] The prototype ignores its input and returns the two constants, which is enough to confirm that the file name, function name, inputs and outputs are wired up correctly:
% function [bf_number, sea_state] = beaufort_classify(wind_speed_kts)
%     bf_number = 0;
%     sea_state = "Calm";
% end
%[text] The finished `beaufort_classify.m` replaces the two constants with the if/elseif ladder described in the next section.
%[text] Call the function to verify:
[bf_number, sea_state] = beaufort_classify(wind_speed_kts);
%%
%[text] ## Function Call and Output
%[text] Make it right:
%[text] Now that the basic structure of the function file is there, add the flow control logic so that the function returns the correct number and string based on the provided wind speed, corresponding to this table:
%[text:table]
%[text] | Beaufort Force | Wind Speed (knots) | Sea State |
%[text] | --- | --- | --- |
%[text] | 0 | \< 1 | Calm |
%[text] | 1 | 1 – 3 | Light Air |
%[text] | 2 | 4 – 6 | Light Breeze |
%[text] | 3 | 7 – 10 | Gentle Breeze |
%[text] | 4 | 11 – 16 | Moderate Breeze |
%[text] | 5 | 17 – 21 | Fresh Breeze |
%[text] | 6 | 22 – 27 | Strong Breeze |
%[text] | 7 | 28 – 33 | Near Gale |
%[text] | 8 | 34 – 40 | Gale |
%[text] | 9 | \> 40 | Severe Gale |
%[text:table]
%[text] The simplest arrangement rounds the speed to the nearest whole knot first, as the assignment page asks, and then tests only the upper limit of each band in increasing order (`wind < 1`, `wind <= 3`, `wind <= 6`, and so on). Each `elseif` is reached only when every earlier test was false, so the lower limit already holds and needs no second comparison. Force 9 is the final `else`.
%[text] The function will use a series of `if/elseif` blocks to classify the values and report the correct Beaufort Force number and Sea State message.   There are a number of ways to arrange the `if/elseif` steps - some are simpler than others, so consider how to approach the comparisons before writing the code.  
%[text] 
%[text] The snippet below is a single call to the classifier function to manually test values in the range above.  **Verify** that your program provides the expected outputs
wind_speed_kts = 25;   % knots
[bf_number, sea_state] = beaufort_classify(wind_speed_kts)
%%
%[text] ## Test
%[text] Now that we have the function working for a single nominal value, we want to test the function for a variety of input arguments.   For the purposes of this exercise, a test is simply giving a known input and comparing the provided bf\_number output to the expected results.
wind_in = 25;
bf_expected = 6;
[bf_number, sea_state] = beaufort_classify(wind_in);
if (~(bf_expected==bf_number))
    disp("Error")
end
%[text] Write at least three of your own tests that examine normal and edge case inputs, e.g., non-integer input, negative input, etc. 
%[text] Each test below gives a known input and compares `bf_number` with the expected force. The inputs include band edges (10 and 40 kts), non-integer speeds that round up or down (3.5, 10.6, 40.4 and 40.5 kts), zero, and a speed well above the table.
wind_in     = [0  0.4  3.5  10  10.6  25  40  40.4  40.5  60];   % knots
bf_expected = [0  0    2    3   4     6   8   8     9     9];
for k = 1:length(wind_in)
    [bf_number, sea_state] = beaufort_classify(wind_in(k));
    if bf_number == bf_expected(k)
        result = "pass";
    else
        result = "FAIL";
    end
    disp(wind_in(k) + " kts: Force " + bf_number + ", " + sea_state + " (" + result + ")")
end

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
