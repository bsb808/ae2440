echo on

table_str = sprintf(" cats \t dogs \n salt \t pepper")
disp(table_str);

fprintf(" yin \t yang \n fish \t chips \n")


% Fixed-point 
fprintf("pi = %f\n", pi);

fprintf("pi also equals %4.2f\n", pi)

fprintf("There are %d %s and %d %s\n", ...
    3, "apples", 5, "oranges");

fprintf("Random numbers: %5.3f\n", rand(1,3))
fprintf("Random numbers: %5.3f, %5.3E, %.3f \n", rand(1,3))

echo off
