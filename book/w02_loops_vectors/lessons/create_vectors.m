echo on;
% Some ways to initialize vectors
% As an list with step size = 1
1:5
% As a list with step size ~= 1
1:3:10
% As an N-by-1 column of zeros
zeros(5,1)
% As a 1-by-N row of ones
ones(1,5)
% A vector of psuedorandom numbers
rand(1,5)
% Manually, as a row vector
[5 3.1 9.8 -2]
% Manually as a column vector
[5; 3.1; 9.8; -2;]
% As a column using transpose
[5 3.1 9.8 -2]'

% Linear spacing from A to B with N elements
linspace(0, 1, 5)

% Logrithmic spacing from 10^A to 10^B with N elements
logspace(0, 1, 5)

echo off;