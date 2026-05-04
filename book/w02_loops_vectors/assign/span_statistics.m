load("ansur_span.mat");

% Counter for number of elements
N = 0;
% Variable for the sum of all the elements
summ = 0;
% Loop through each element
for ii = 1:length(span)
    % Accumulate the sum
    summ = summ + span(ii);
    % Count the elements
    N = N+1;
end

% Mean (m)
mu = summ/N

% Variable for the variances
varr = 0;
for ii = 1:length(span)
    varr = varr + (span(ii)-mu)^2;
end

% Vairance (m^2)
varr = varr/(N-1)
% Standard deviation (m)
stdd = sqrt(varr)