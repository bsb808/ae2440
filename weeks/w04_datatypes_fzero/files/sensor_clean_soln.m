%[text] # Assignment 4 — Sensor Data Cleaning
%[text] A coastal buoy has been logging ocean surface temperature (°C) every hour for 72 hours.
%[text] Due to hardware issues the raw data contains two types of bad readings:
%[text] - **Sensor dropout** — the sensor failed to record a value, stored as `NaN`
%[text] - **Saturation error** — the sensor maxed out its measurement range, stored as `Inf` \
%[text] Work through each part below to identify, locate, and clean the bad readings, then summarize the valid data.
%%
%[text] ## Part 1 — Meet the Data
%[text] Download the file "sensordata.mat" and put it in the same directory as this script.
%[text] Run this cell to load the raw sensor dataset. Then inspect `temp_raw` and `tt` in the **Workspace** panel — note the data type, size, and value range shown there.
%[text] - The `temp_raw` vector is the temperature values in °C.  The vector includes both `NaN` and `Inf` elements.
%[text] - The `tt` vector is the corresponding time values in hours. \
clear;
load sensordata.mat
%[text] Plot the timeseries data.  You will see gaps in the plot where there are `Inf` or `NaN` values.  It should look something like this...
figure(1);
clf()
plot(tt, temp_raw)
xlabel("Time (Hours)")
ylabel("Raw Temp (C)")
title("Raw buoy data")
grid on
%%
%[text] ## Part 2 — Spot the Bad Readings
%[text] `isnan()` and `isinf()` each return a **logical array** — one `true` or `false` per element.
%[text] This logical array is sometimes called a **mask** because it marks specific elements of interest, like a stencil over the data.
%[text] Inspect `nan_mask` and `inf_mask` in the Workspace to see this data type.
%[text] Then use `sum()` to count the bad readings of each type. This works because MATLAB treats `true` as 1 and `false` as 0.
nan_mask = isnan(temp_raw);
inf_mask = isinf(temp_raw);
n_nan = sum(nan_mask)
n_inf = sum(inf_mask)
%%
%[text] ## Part 3 — Find Where They Are
%[text] `find()` converts a mask into the **indices** where it is `true` — giving you the position of each bad reading in the vector.
nan_idx = find(nan_mask)
inf_idx = find(inf_mask)
%[text] Add markers to the plot from Part 1 to distinguish the two types of bad readings.
hold on;
plot(tt(nan_idx), 24*ones(length(nan_idx),1), 'rv', 'MarkerSize', 10, 'DisplayName', 'NaN — dropout');
plot(tt(inf_idx), 24*ones(length(inf_idx),1), 'g^', 'MarkerSize', 10, 'DisplayName', 'Inf — saturation');
legend('Raw data', 'NaN — dropout', 'Inf — saturation', 'Location', 'best');
hold off;
%%
%[text] ## Part 4 — Remove Bad Readings
%[text] A mask can do more than just count or locate elements — it can also **select** elements directly.
%[text] When you use a logical array as an index, MATLAB keeps only the elements where the mask is `true`.
%[text] Here is a small example to illustrate:
x_demo = [10 20 30 40 50];
keep_demo = logical([1 0 1 0 1]);
x_demo(keep_demo)
%[text] The `~` operator **flips** a mask — every `true` becomes `false` and vice versa.
%[text] So if `bad_mask` marks the bad elements, then `~bad_mask` marks all the **good** ones.
%[text] Create a combined bad-value mask, then use it to extract only the valid readings into new vectors:
%[text] - `temp_clean` — temperature values with the bad readings removed
%[text] - `tt_clean` — the corresponding times (must remove the same positions) \
bad_mask   = nan_mask | inf_mask;
temp_clean = temp_raw(~bad_mask);
tt_clean   = tt(~bad_mask);
%%
%[text] ## Part 5 — Compute Statistics and Report
%[text] Compute the mean and standard deviation of `temp_clean`, then display a formatted summary.
mu = mean(temp_clean);
sd = std(temp_clean);
n  = numel(temp_clean);
fprintf('Valid readings : %d of %d\n', n, numel(temp_raw));
fprintf('Mean temp      : %.2f deg C\n', mu);
fprintf('Std dev        : %.2f deg C\n', sd);
%[text] Plot the cleaned data alongside the original to confirm the bad readings have been removed.
figure(2);
clf()
plot(tt, temp_raw, 'bo-', 'DisplayName', 'Raw (gaps = bad data)')
hold on;
plot(tt_clean, temp_clean, 'r--', 'DisplayName', 'Cleaned')
xlabel("Time (Hours)")
ylabel("Temperature (C)")
title("Buoy Temperature — Raw vs Cleaned")
legend('Location', 'best')
grid on
hold off;

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
