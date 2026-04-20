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
clear;
a = 3.14;           class(a)   % double %[output:447d94fc]
b = "hello";        class(b)   % string %[output:989857fd]
c = 'hello';        class(c)   % char %[output:4486053b]
d = true;           class(d)   % logical %[output:66d1dab0]
%%
%[text] This lesson covers the three you will need most for Assignment 4: special numeric values, logical arrays, and structures.
%%
%[text] ## Arrays and Vectors
%[text] In MATLAB every value is an array — even a single number is a 1×1 array. A **vector** is a 1-D array. Square brackets build a vector; elements are separated by spaces or commas.
%[text] **Numeric vector** — all elements must be the same numeric type:
speeds = [12.5  8.3  15.0  9.7] %[output:1d480918]
class(speeds) %[output:93fd9081]
%[text] **String array** — a vector of strings, one per element:
labels = ["Alpha"  "Bravo"  "Charlie"  "Delta"] %[output:4ce891fe]
class(labels) %[output:5650524b]
%[text] **Logical vector** — a vector of `true`/`false` values, produced by comparisons:
fast = speeds > 10 %[output:0a946845]
class(fast) %[output:74643887]
%[text] Logical indexing uses a logical vector to select elements from another vector of the same length:
speeds(fast) %[output:9630e28c]
%%
%[text] ### `char` vs `string`
%[text] Single-quoted `'hello'` is a **`char`** **array** — a vector of characters. Double-quoted `"hello"` is a **`string`**. They print identically but behave differently in two common situations:
%[text] **Comparison**: `==` on two `char` arrays compares character by character and returns a logical array, not a single `true`/`false`. Use `strcmp` to test whether two `char` values are equal. `string` values can use `==` directly.
a_char = 'hello';
a_str  = "hello";
a_char == 'hello'        % [1 1 1 1 1] — element-wise, not a scalar
strcmp(a_char, 'hello')  % true — correct way to compare char
a_str  == "hello"        % true — string == works as expected
%[text] **Indexing**: `(k)` on a `char` array gives the *k*-th character; `(k)` on a `string` gives the *k*-th element of the string array. For a scalar string, any index beyond 1 errors.
a_char(2)   % 'e' — second character
a_str(2)    % error — "hello" is a 1×1 string array; no element at index 2
%%
%[text] ### Arrays of strings vs arrays of characters
%[text] Square brackets behave differently for `string` and `char`:
%[text] - `["Alpha" "Bravo"]` builds a **1×2 string array** — two separate words, indexed by position.
%[text] - `['Alpha' 'Bravo']` **concatenates** the characters into one long `char` vector `'AlphaBravo'` — not two words. \
words_str  = ["Alpha" "Bravo" "Charlie"]  % 1×3 string array %[output:5c1fe464]
words_char = ['Alpha' 'Bravo' 'Charlie']  % 'AlphaBravoCharlie' — one long char vector %[output:7435241d]
words_str(2)   % "Bravo" — second string element %[output:77548e10]
words_char(2)  % 'l' — second character of the concatenated vector %[output:3bc169e3]
%[text] To collect `char` words into an array, use `char(...)` — it pads each word to equal length with trailing spaces:
words_c2 = char('Alpha', 'Bravo', 'Charlie')  % 3×7 char array %[output:26167411]
words_c2(2,:)   % 'Bravo  ' — second row, with padding %[output:6afa6ed0]
%[text] String arrays are almost always more convenient for collections of text. Use `char` arrays only when an older function requires them.
%%
%[text] ### Aside — Cell Arrays
%[text] A regular vector requires all elements to be the same type. A **cell array** lifts that restriction — each cell can hold any type. Cells are created with curly braces `{}` and accessed the same way.
mixed = {42,  "hello",  [1 2 3],  true} %[output:7d02af84]
mixed{1}    % number %[output:2bd4402d]
mixed{2}    % string %[output:355293d8]
mixed{3}    % vector %[output:7288f8c1]
%%
%[text] ## Special Numeric Values: NaN and Inf
%[text] Two reserved values appear frequently in real sensor data:
%[text] - **NaN** (Not a Number) — marks a missing or invalid reading, e.g., a sensor dropout
%[text] - **Inf** (Infinity) — result of dividing by zero, or a sensor saturation error \
%[text] Standard comparison operators do not work on NaN — `NaN == NaN` is always `false`. Use `isnan` and `isinf` instead.
x = [3.1  NaN  2.8  Inf  3.5];
isnan(x) %[output:7892b93d]
isinf(x) %[output:54cb5602]
y = x(~isnan(x)) %[output:0562ee1b]
%%
%[text] ## Logical Arrays
%[text] `isnan` and `isinf` return a **logical array** — one `true` or `false` per element. This is sometimes called a **mask** because it marks specific positions of interest.
%[text] `sum` counts the `true` entries — MATLAB treats `true` as 1 and `false` as 0:
bad_mask = isnan(x) | isinf(x) %[output:22e9e07e]
x(bad_mask) %[output:8191db59]
n_bad = sum(bad_mask) %[output:05956fc5]
%[text] `find` converts a mask into the **indices** where it is `true`:
bad_idx = find(bad_mask) %[output:27c6a110]
%[text] A mask can also be used directly as an index to select elements. The `~` operator **flips** a mask — every `true` becomes `false` and vice versa:
x_clean = x(~bad_mask) %[output:96961741]
%%
%[text] ## Formatted Output with fprintf
%[text] `fprintf` prints a formatted string to the Command Window. The format string uses [**format specifiers** ](https://cplusplus.com/reference/cstdio/printf/)to insert values:
%[text] - `%d` — integer
%[text] - `%.2f` — floating-point, 2 decimal places
%[text] - `%s` — string \
id = "S-01";
value = 23.456;
count = 12;
fprintf("Sensor %s  |  Value: %.2f C  |  Readings: %d", id, value, count) %[output:8c3eef48]
%[text] The `\n` moves the cursor to a new line. The separators and spacing are layout choices — use whatever format your report requires.
%%
%[text] ## Structures
%[text] A **struct** groups related data under named **fields**, accessed with dot notation: `variable.field`
%[text] Build a single struct by assigning fields one at a time:
clear;
sensor.id    = "S-01";
sensor.type  = "Temperature";
sensor.value = 23.4;
%[text] Inspect `sensor` in the **Workspace** panel — notice it shows as a `1×1 struct`.
%%
%[text] Extend it into a **struct array** by assigning a second element:
sensor(2).id    = "S-02";
sensor(2).type  = "Salinity";
sensor(2).value = 35.1;
%[text] Now `sensor` is a `1×2 struct array`. Access any element and field with index + dot notation:
sensor(1).type %[output:221fcdc7]
sensor(2).value %[output:707c569b]
%%
%[text] Loop over a struct array to process all elements the same way:
for k = 1:length(sensor) %[output:group:3168fdf9]
    fprintf('Sensor %s  |  Type: %s  |  Value: %.1f\n', ... %[output:93c6c2ff]
        sensor(k).id, sensor(k).type, sensor(k).value) %[output:93c6c2ff]
end %[output:group:3168fdf9]
%%
%[text] New fields can be added at any time — MATLAB extends the struct for all elements:
sensor(1).units = "deg C";
sensor(2).units = "ppt";
%%
%[text] ### Gotchas
%[text] **Struct element vs. field** — `sensor(1)` returns the whole first struct; `sensor(1).value` returns just that field. A common mistake is writing `sensor.value(1)` expecting the first element's value — but `sensor.value` without an index produces a comma-separated list, not a vector. Collect all values into a vector with `[sensor.value]`:
sensor(1)           % whole struct element — a 1×1 struct
sensor(1).value     % field from element 1 — a scalar
sensor.value        % comma-separated list — NOT a vector, cannot plot this
[sensor.value]      % collect into a numeric vector — this is what you usually want
%[text] The order of indexing matters: 
%[text] - `sensor(2).value` first selects the second struct element then reads its field — correct.
%[text] - `sensor.value(2)` accesses the field across all elements first, then tries to take index 2 of the *first* result — almost always a mistake: \
sensor(2).value     % 35.1 — correct: element 2, then its field
sensor.value(2)     % error: takes sensor(1).value (23.4), then index 2 of a scalar
%%
%[text] **`char`** **vs** **`string`** — single quotes make a `char` array; double quotes make a `string`. They print identically but behave differently:
%[text] - **Character indexing on a field**: `sensor(1).id(2)` means different things depending on the type of `id`. For a `string` field, `(2)` is *array* indexing — it looks for a second string in the 1×1 array and errors. For a `char` field, `(2)` gets the second *character*. To extract a character from a `string` field, convert first. \

sensor(1).id(2)         % error — id is a 1×1 string; no element at index 2
sensor(1).id = 'S-01';  % as charray
sensor(1).id(2)              % '-' — char indexing gives the second character %[output:546fc0b3]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:447d94fc]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'double'"}}
%---
%[output:989857fd]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'string'"}}
%---
%[output:4486053b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'char'"}}
%---
%[output:66d1dab0]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'logical'"}}
%---
%[output:1d480918]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"speeds","rows":1,"type":"double","value":[["12.5000","8.3000","15.0000","9.7000"]]}}
%---
%[output:93fd9081]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'double'"}}
%---
%[output:4ce891fe]
%   data: {"dataType":"matrix","outputData":{"columns":4,"header":"1×4 string array","name":"labels","rows":1,"type":"string","value":[["Alpha","Bravo","Charlie","Delta"]]}}
%---
%[output:5650524b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'string'"}}
%---
%[output:0a946845]
%   data: {"dataType":"matrix","outputData":{"columns":4,"header":"1×4 logical array","name":"fast","rows":1,"type":"logical","value":[["1","0","1","0"]]}}
%---
%[output:74643887]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'logical'"}}
%---
%[output:9630e28c]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"ans","rows":1,"type":"double","value":[["12.5000","15.0000"]]}}
%---
%[output:5c1fe464]
%   data: {"dataType":"matrix","outputData":{"columns":3,"header":"1×3 string array","name":"words_str","rows":1,"type":"string","value":[["Alpha","Bravo","Charlie"]]}}
%---
%[output:7435241d]
%   data: {"dataType":"textualVariable","outputData":{"name":"words_char","value":"'AlphaBravoCharlie'"}}
%---
%[output:77548e10]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"\"Bravo\""}}
%---
%[output:3bc169e3]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'l'"}}
%---
%[output:26167411]
%   data: {"dataType":"textualVariable","outputData":{"header":"3×7 char array","name":"words_c2","value":"    'Alpha  '\n    'Bravo  '\n    'Charlie'\n"}}
%---
%[output:6afa6ed0]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'Bravo  '"}}
%---
%[output:7d02af84]
%   data: {"dataType":"tabular","outputData":{"columns":4,"header":"1×4 cell array","name":"mixed","rows":1,"type":"cell","value":[["42","\"hello\"","[1,2,3]","1"]]}}
%---
%[output:2bd4402d]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"42"}}
%---
%[output:355293d8]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"\"hello\""}}
%---
%[output:7288f8c1]
%   data: {"dataType":"matrix","outputData":{"columns":3,"name":"ans","rows":1,"type":"double","value":[["1","2","3"]]}}
%---
%[output:7892b93d]
%   data: {"dataType":"matrix","outputData":{"columns":5,"header":"1×5 logical array","name":"ans","rows":1,"type":"logical","value":[["0","1","0","0","0"]]}}
%---
%[output:54cb5602]
%   data: {"dataType":"matrix","outputData":{"columns":5,"header":"1×5 logical array","name":"ans","rows":1,"type":"logical","value":[["0","0","0","1","0"]]}}
%---
%[output:0562ee1b]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"y","rows":1,"type":"double","value":[["3.1000","2.8000","Inf","3.5000"]]}}
%---
%[output:22e9e07e]
%   data: {"dataType":"matrix","outputData":{"columns":5,"header":"1×5 logical array","name":"bad_mask","rows":1,"type":"logical","value":[["0","1","0","1","0"]]}}
%---
%[output:8191db59]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"ans","rows":1,"type":"double","value":[["NaN","Inf"]]}}
%---
%[output:05956fc5]
%   data: {"dataType":"textualVariable","outputData":{"name":"n_bad","value":"2"}}
%---
%[output:27c6a110]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"bad_idx","rows":1,"type":"double","value":[["2","4"]]}}
%---
%[output:96961741]
%   data: {"dataType":"matrix","outputData":{"columns":3,"name":"x_clean","rows":1,"type":"double","value":[["3.1000","2.8000","3.5000"]]}}
%---
%[output:8c3eef48]
%   data: {"dataType":"text","outputData":{"text":"Sensor S-01  |  Value: 23.46 C  |  Readings: 12","truncated":false}}
%---
%[output:221fcdc7]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'Temperature'"}}
%---
%[output:707c569b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"35.1000"}}
%---
%[output:93c6c2ff]
%   data: {"dataType":"text","outputData":{"text":"Sensor S-01  |  Type: Temperature  |  Value: 23.4\nSensor S-02  |  Type: Salinity  |  Value: 35.1\n","truncated":false}}
%---
%[output:546fc0b3]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'-'"}}
%---
