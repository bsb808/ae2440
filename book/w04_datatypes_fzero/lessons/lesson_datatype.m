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
a = 3.14;           class(a)   % double %[output:0a31151b]
b = "hello";        class(b)   % string %[output:868bc579]
c = 'hello';        class(c)   % char %[output:9b035014]
d = true;           class(d)   % logical %[output:8b093706]
%%
%[text] This lesson covers the three you will need most for Assignment 4: special numeric values, logical arrays, and structures.
%%
%[text] ## Arrays and Vectors
%[text] In MATLAB every value is an array — even a single number is a 1×1 array. A **vector** is a 1-D array. Square brackets build a vector; elements are separated by spaces or commas.
%[text] **Numeric vector** — all elements must be the same numeric type:
speeds = [12.5  8.3  15.0  9.7] %[output:26db3e43]
class(speeds) %[output:69883b89]
%[text] **String array** — a vector of strings, one per element:
labels = ["Alpha"  "Bravo"  "Charlie"  "Delta"] %[output:48f7e2c9]
labels(3) %[output:9e35b58b]
class(labels) %[output:2aa0f0b3]
%[text] **Logical vector** — a vector of `true`/`false` values, produced by comparisons:
speeds %[output:9b1ae5f0]
fast = speeds > 10 %[output:88721073]
class(fast) %[output:2ee340bf]
%[text] Logical indexing uses a logical vector to select elements from another vector of the same length:
speeds(fast) %[output:397d93bd]
speeds(speeds>10) %[output:54121c4a]
%%
%[text] ### `char` vs `string`
%[text] Single-quoted `'hello'` is a **`char`** **array** — a vector of characters. Double-quoted `"hello"` is a **`string`**. They print identically but behave differently in two common situations:
%[text] **Comparison**: `==` on two `char` arrays compares character by character and returns a logical array, not a single `true`/`false`. Use `strcmp` to test whether two `char` values are equal. `string` values can use `==` directly.
a_char = 'hello';
a_str  = "hello";
a_char == 'hello'        % [1 1 1 1 1] — element-wise, not a scalar %[output:1744b9eb]
strcmp(a_char, 'hello')  % true — correct way to compare char %[output:022ea67d]
a_str  == "hello"        % true — string == works as expected %[output:03a7c2e2]
%[text] **Indexing**: `(k)` on a `char` array gives the *k*-th character; `(k)` on a `string` gives the *k*-th element of the string array. For a scalar string, any index beyond 1 errors.
a_char(2)   % 'e' — second character %[output:4622212f]
a_str(2)    % error — "hello" is a 1×1 string array; no element at index 2 %[output:8161fcb6]
%%
%[text] ### Arrays of strings vs arrays of characters
%[text] Square brackets behave differently for `string` and `char`:
%[text] - `["Alpha" "Bravo"]` builds a **1×2 string array** — two separate words, indexed by position.
%[text] - `['Alpha' 'Bravo']` **concatenates** the characters into one long `char` vector `'AlphaBravo'` — not two words. \
words_str  = ["Alpha" "Bravo" "Charlie"]  % 1×3 string array
words_char = ['Alpha' 'Bravo' 'Charlie']  % 'AlphaBravoCharlie' — one long char vector
words_str(2)   % "Bravo" — second string element
words_char(2)  % 'l' — second character of the concatenated vector
%[text] To collect `char` words into an array, use `char(...)` — it pads each word to equal length with trailing spaces:
words_c2 = char('Alpha', 'Bravo', 'Charlie')  % 3×7 char array
words_c2(2,:)   % 'Bravo  ' — second row, with padding
%[text] String arrays are almost always more convenient for collections of text. Use `char` arrays only when an older function requires them.
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
y = x(~isnan(x))
%%
%[text] ## Logical Arrays
%[text] `isnan` and `isinf` return a **logical array** — one `true` or `false` per element. This is sometimes called a **mask** because it marks specific positions of interest.
%[text] `sum` counts the `true` entries — MATLAB treats `true` as 1 and `false` as 0:
bad_mask = isnan(x) | isinf(x)
x(bad_mask)
n_bad = sum(bad_mask)
%[text] `find` converts a mask into the **indices** where it is `true`:
bad_idx = find(bad_mask)
%[text] A mask can also be used directly as an index to select elements. The `~` operator **flips** a mask — every `true` becomes `false` and vice versa:
x_clean = x(~bad_mask)
%%
%[text] ## Formatted Output with fprintf
%[text] `fprintf` prints a formatted string to the Command Window. The format string uses [format specifiers ](https://cplusplus.com/reference/cstdio/printf/)to insert values:
%[text] - `%d` — integer
%[text] - `%.2f` — floating-point, 2 decimal places
%[text] - `%s` — string \
id = "S-01";
value = 23.456;
count = 12;
fprintf("Sensor %s  |  Value: %.2f C  |  Readings: %d", id, value, count) %[output:2d483b13]
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
sensor(1).type %[output:19557191]
sensor(2).value %[output:7b2c3e8b]
%%
%[text] Loop over a struct array to process all elements the same way:
for k = 1:length(sensor)
    fprintf('Sensor %s  |  Type: %s  |  Value: %.1f\n', ...
        sensor(k).id, sensor(k).type, sensor(k).value)
end
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
sensor(1).id(2)              % '-' — char indexing gives the second character

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:0a31151b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'double'"}}
%---
%[output:868bc579]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'string'"}}
%---
%[output:9b035014]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'char'"}}
%---
%[output:8b093706]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'logical'"}}
%---
%[output:26db3e43]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"speeds","rows":1,"type":"double","value":[["12.5000","8.3000","15.0000","9.7000"]]}}
%---
%[output:69883b89]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'double'"}}
%---
%[output:48f7e2c9]
%   data: {"dataType":"matrix","outputData":{"columns":4,"header":"1×4 string array","name":"labels","rows":1,"type":"string","value":[["Alpha","Bravo","Charlie","Delta"]]}}
%---
%[output:9e35b58b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"\"Charlie\""}}
%---
%[output:2aa0f0b3]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'string'"}}
%---
%[output:9b1ae5f0]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"speeds","rows":1,"type":"double","value":[["12.5000","8.3000","15.0000","9.7000"]]}}
%---
%[output:88721073]
%   data: {"dataType":"matrix","outputData":{"columns":4,"header":"1×4 logical array","name":"fast","rows":1,"type":"logical","value":[["1","0","1","0"]]}}
%---
%[output:2ee340bf]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'logical'"}}
%---
%[output:397d93bd]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"ans","rows":1,"type":"double","value":[["12.5000","15.0000"]]}}
%---
%[output:54121c4a]
%   data: {"dataType":"matrix","outputData":{"columns":2,"name":"ans","rows":1,"type":"double","value":[["12.5000","15.0000"]]}}
%---
%[output:1744b9eb]
%   data: {"dataType":"matrix","outputData":{"columns":5,"header":"1×5 logical array","name":"ans","rows":1,"type":"logical","value":[["1","1","1","1","1"]]}}
%---
%[output:022ea67d]
%   data: {"dataType":"textualVariable","outputData":{"header":"logical","name":"ans","value":"   1\n"}}
%---
%[output:03a7c2e2]
%   data: {"dataType":"textualVariable","outputData":{"header":"logical","name":"ans","value":"   1\n"}}
%---
%[output:4622212f]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'e'"}}
%---
%[output:8161fcb6]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Index exceeds the number of array elements. Index must not exceed 1."}}
%---
%[output:2d483b13]
%   data: {"dataType":"text","outputData":{"text":"Sensor S-01  |  Value: 23.46 C  |  Readings: 12","truncated":false}}
%---
%[output:19557191]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"\"Temperature\""}}
%---
%[output:7b2c3e8b]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"35.1000"}}
%---
