function [bf_number, sea_state] = beaufort_classify(wind_speed_kts)
% BEAUFORT_CLASSIFY  Beaufort force number and sea state for a wind speed.
%   [BF_NUMBER, SEA_STATE] = BEAUFORT_CLASSIFY(WIND_SPEED_KTS) 
% returns the Beaufort force number BF_NUMBER (0 to 9) 
% and a string SEA_STATE for a wind speed WIND_SPEED_KTS in knots. 

% Round first
wind = round(wind_speed_kts);

% Test the upper limit of each band in increasing order. 
% Reaching an elseif means every earlier test was false, 
% so the lower limit of the band already holds and does 
% not need to be tested again.
if wind < 1
    bf_number = 0;
    sea_state = "Calm";
elseif wind <= 3
    bf_number = 1;
    sea_state = "Light Air";
elseif wind <= 6
    bf_number = 2;
    sea_state = "Light Breeze";
elseif wind <= 10
    bf_number = 3;
    sea_state = "Gentle Breeze";
elseif wind <= 16
    bf_number = 4;
    sea_state = "Moderate Breeze";
elseif wind <= 21
    bf_number = 5;
    sea_state = "Fresh Breeze";
elseif wind <= 27
    bf_number = 6;
    sea_state = "Strong Breeze";
elseif wind <= 33
    bf_number = 7;
    sea_state = "Near Gale";
elseif wind <= 40
    bf_number = 8;
    sea_state = "Gale";
else
    bf_number = 9;
    sea_state = "Severe Gale";
end

end
