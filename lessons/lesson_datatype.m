%[text] # MATLAB Data Types
%[text] Every variable in MATLAB has a **type** that determines what operations make sense on it. The five types you will encounter most are:
%[text:table]
%[text] | Type | Created with | Good for |
%[text] | --- | --- | --- |
%[text] | `double` | `x = 3.14` | Numbers — the default for all math |
%[text] | `string` | `s = "hello"` | Text you search, format, or compare |
%[text] | `char` | `c = 'hello'` | Single-quoted text; compatible with older MATLAB functions and `fprintf` |
%[text] | `logical` | `isnan(x)`, `x > 0` | True/false masks for selecting or filtering data |
%[text] | `struct` | `s.field = val` | Grouping related variables (id, bearing, range) under one name |
%[text:table]
a = 3.14;           class(a)   % double
b = "hello";        class(b)   % string
c = 'hello';        class(c)   % char
d = true;           class(d)   % logical
%%
%[text] This lesson covers the three you will need most for Assignment 4: special numeric values, logical arrays, and structures.
%%
%[text] ## Arrays and Vectors
%[text] In MATLAB every value is an array — even a single number is a 1×1 array. A **vector** is a 1-D array. Square brackets build a vector; elements are separated by spaces or commas.
%[text] **Numeric vector** — all elements must be the same numeric type:
speeds = [12.5  8.3  15.0  9.7]
class(speeds)
%[text] **String array** — a vector of strings, one per element:
labels = ["Alpha"  "Bravo"  "Charlie"  "Delta"]
class(labels)
%[text] **Logical vector** — a vector of `true`/`false` values, produced by comparisons:
fast = speeds > 10
class(fast)
%[text] Logical indexing uses a logical vector to select elements from another vector of the same length:
speeds(fast)
%%
%[text] ### Aside — Cell Arrays
%[text] A regular vector requires all elements to be the same type. A **cell array** lifts that restriction — each cell can hold any type. Cells are created with curly braces `{}` and accessed the same way.
mixed = {42,  "hello",  [1 2 3],  true}
mixed{1}    % number
mixed{2}    % string
mixed{3}    % vector
%%
%[text] ## Special Numeric Values: NaN and Inf
%[text] Two reserved values appear frequently in real sensor data:
%[text] - **NaN** (Not a Number) — marks a missing or invalid reading, e.g., a sensor dropout
%[text] - **Inf** (Infinity) — result of dividing by zero, or a sensor saturation error \
%[text] Standard comparison operators do not work on NaN — `NaN == NaN` is always `false`. Use `isnan` and `isinf` instead.
x = [3.1  NaN  2.8  Inf  3.5];
isnan(x)
isinf(x)
%%
%[text] ## Logical Arrays
%[text] `isnan` and `isinf` return a **logical array** — one `true` or `false` per element. This is sometimes called a **mask** because it marks specific positions of interest.
%[text] `sum` counts the `true` entries — MATLAB treats `true` as 1 and `false` as 0:
bad_mask = isnan(x) | isinf(x);
n_bad = sum(bad_mask)
%[text] `find` converts a mask into the **indices** where it is `true`:
bad_idx = find(bad_mask)
%[text] A mask can also be used directly as an index to select elements. The `~` operator **flips** a mask — every `true` becomes `false` and vice versa:
x_clean = x(~bad_mask)
%%
%[text] ## Formatted Output with fprintf
%[text] `fprintf` prints a formatted string to the Command Window. The format string uses **specifiers** to insert values:
%[text] - `%d` — integer
%[text] - `%.2f` — floating-point, 2 decimal places
%[text] - `%s` — string \
id = 'S-01';
value = 23.456;
count = 12;
fprintf('Sensor %s  |  Value: %.2f C  |  Readings: %d\n', id, value, count)
%[text] The `\n` moves the cursor to a new line. The separators and spacing are layout choices — use whatever format your report requires.
%%
%[text] ## Structures
%[text] A **struct** groups related data under named **fields**, accessed with dot notation: `variable.field`
%[text] Build a single struct by assigning fields one at a time:
sensor.id    = 'S-01';
sensor.type  = 'Temperature';
sensor.value = 23.4;
%[text] Inspect `sensor` in the **Workspace** panel — notice it shows as a `1×1 struct`.
%%
%[text] Extend it into a **struct array** by assigning a second element:
sensor(2).id    = 'S-02';
sensor(2).type  = 'Salinity';
sensor(2).value = 35.1;
%[text] Now `sensor` is a `1×2 struct array`. Access any element and field with index + dot notation:
sensor(1).type
sensor(2).value
%%
%[text] Loop over a struct array to process all elements the same way:
for k = 1:length(sensor)
    fprintf('Sensor %s  |  Type: %-15s  |  Value: %.1f\n', ...
        sensor(k).id, sensor(k).type, sensor(k).value)
end
%[text] New fields can be added at any time — MATLAB extends the struct for all elements:
sensor(1).units = 'deg C';
sensor(2).units = 'ppt';

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
