%[text] # MATLAB Data Types
%[text] Why use different data types?
%[text] ## Interfaces
%[text] Accessing MATLAB capabilities requires fluency with a variety of data types.
%[text] - *Function handles* allow use to access optimzation tools
%[text] - *Structures* enable customizing those tools
%[text] ## Operator Overloading
%[text] - You can multiply numbers but not strings
%[text] - Adding strings concatenates them ("hello" + "world" = "helloworld")
%[text] - Adding numbers performs mathematical addition (2 + 2 = 4)
%[text] [datetime](https://www.mathworks.com/help/matlab/ref/datetime.html) as an example of when operators have different meaning.
now = datetime("today")
class(now)
day = days(1)
tomorrow = now + day
yesterday = now - day
next_week = now + 7*day
%%
%[text] ## Numbers
%[text] ### Numeric Types:
%[text] Double (default)
%[text] - 64-bit floating-point numbers, 15-17 significant figures
x = 1/3;
class(x)
fprintf("%.25f",x)
%[text] Due to rounding and limitations of floating-point arithmitic, MATLAB shows the requested significant figures, but those beyond 16 are essentially random.
%%
%[text] Single
%[text] - 32-bit floating-point numbers, 6-7 significant figures
%[text] - Rare, but can be used large arrays where extreme precision isn't needed, e.g., image processing
x = single(x);
class(x)
fprintf('%.25f',x)
%%
%[text] Integer types:
%[text] - int8: 8-bit signed (-128 to 127)
%[text] - uint8: 8-bit unsigned (0 to 255)
%[text] - int16: 16-bit signed (-32,768 to 32,767)
%[text] - uint16: 16-bit unsigned (0 to 65,535)
%[text] - int32: 32-bit signed
%[text] - uint32: 32-bit unsigned
%[text] - int64: 64-bit signed
%[text] - uint64: 64-bit unsigned
x = int8(125)       % signed 8-bit integer
%%
%[text] **Questions:** What do you expect for the output?
x = x + 10
%%
y = uint16(1000)    % unsigned 16-bit integer
%%
y = -y
%[text] Floating-point comparisons
0.1 + 0.2 == 0.3
%%
%[text] **Memory usage:**
clear
% Creates a 1000x1000 matrix
d = rand(1000);            % double: 8MB
s = single(rand(1000));    % single: 4MB
ii = int8(rand(1000)*100);  % int8: 1MB
whos
%%
%[text] **Complex numbers:**
z = 3 + 4i;
%or
z = complex(3, 4)
mag = abs(z) 
phase = angle(z) % radians
%%
%[text] **Special numbers:**
%[text] - **NaN:** Not a number
%[text] - **Inf:** Infinity
%[text] Dividing by zero is Inf, but zero divided by zero is NaN.
n = 10;
bb = round(rand(1,n))
cc = round(rand(1,n))
dd = bb./cc
isnan(dd)
isinf(dd)
%%
%[text] ### Arrays of Numbers
%[text] All numbers are arrays.
%[text] - **Empty:** An array with no elements
%[text] - **Scalar:** An array with a single element.
%[text] - **Vector:** A two-dimensional array that has either 1-by-N (a row vector) or N-by-1 (a column vector) dimensions.
%[text] - **Matrix:** A two-dimensional array with more than one element in both dimensions.
%[text] - **Array:** A general term in MATLAB that can refer to data with more than two dimensions.
%[text] If our search is unsuccessful, MATLAB returns and empty array
aa = [1 2 3 4];
ind = find(aa <= 0)
if isempty(ind)
    disp("All values greater than zero");
end
%%
%[text] ## Character Arrays, Strings, and String Arrays
%[text] Text is represented with two different data types: *character arrays* and and *strings.*
%[text] ## Character Arrays
%[text] 1-D array of `char`s, created with single-quotes
clear
charray = 'The quick brown fox';
class(charray)
length(charray)
whos
%%
%[text] **Question:** How could we extract `quick` from the character array?
%[text] Character arrays can be sliced be accessed by index.
charray(5:9)
%[text] How about extracting `fox`?
charray(end-3:end)
%%
%[text] Concatenate as you would a vector
phrase = [charray ' jumps over the lazy dog']
phrase(3)+1
%%
%[text] ## Strings and String Arrays
%[text] (Introduced in  R2016b)
%[text] 1x1 array of type `string,` created with doubel-quotes
%"The five boxing wizards jump quickly"
str = "The five boxing wizards"
length(str)
strlength(str)
whos
%%
%[text] sliced with a function
extractBetween(str, 5, 9)
extractAfter(str, strlength(str)-7)
%%
%[text] concatenate with addition
phrase = str + " jump quickly"
%[text] But this throws an error:
%%
yell = upper(phrase)
whisper = lower(yell)
%%
%[text] ### String Operations: split and join
%[text] Break a string into parts by delimiter and return an array of strings.
%[text] Delimiter: character or sequnce to mark boundaries in text data, e.g, comma, space, tab, etc.
str = "apple,banana,orange";
fruits = split(str, ",") 
%%
%[text] Join an array of strings with a  delimiter?
join(fruits, " : ")
%%
path = "C:\home\ae2440\assignment3\takeoff.mlx";
folders = split(path, "\")
%[text] **Question:** How could we modify the `folders` array to generate a new path string: ``"C:\home\ae2440\assignment4\ship_struct.mlx"?`
folders(4) = "assignment4"
folders(5) = 'ship_struct.mlx'
join(folders,"\")
str = char(string('abc'))
whos("str")
%%
%[text] ### String Operations: find and replace
%[text] strfind to search a character array or string for a pattern and return the locations of matchs.
phrase = 'The Quick Brown Fox Jumps Over the Lazy Dog'
ii = strfind(phrase, "Fox")
fox = phrase(ii:ii+2)
strfind(phrase, 'o')
%%
%[text] **Question:** How could we find all upper and lower case o's with a single `strfind` call?
strfind(upper(phrase), "O")
%%
%[text] Use `contains` to search a string for a pattern and return a logical (true/false)
phrase = "The five boxing wizards jump quickly";
contains(phrase, "wizards")
contains(phrase, "t")
contains(phrase, "t", 'IgnoreCase', true)
%%
%[text] replace to find a pattern and replace with a new one
new_phrase = replace(phrase, "wizards", "foxes")
%%
%[text] ## Formatting Strings
%[text] - sprintf: creates a formatted string based on the *format specifier* and intputs (numbers, strings, arrays)
%[text] - fprintf: writes a formatted string to the Command Window or a file based on format specifier and inputs.
%[text] format specifier: `%[identifier][flags][width][.precision][subtype]specifier`
% Integer
x = 42;
fprintf("The answer is %% %d\n", x);  
fprintf("%d is the answer", 42);
%[text] Note  the special newline character `\n` at the end.  For live scripts, we can omit, but it is necessary for scipts and the intepreter.
%%
% Float with decimal precision
pi_val = pi;
fprintf("Pi is approximately %.2f    \n", pi_val)  
%%
% String
name = "Alice";
fprintf("Hello, %s!\n", name) 
%%
% Mixed types
name = "Bob";
age = 25;
height = 1.75;
fprintf("%s is %d years old and %.2f meters tall\n", name, age, height)
%%
% Sample data
names = ["Amy", "Ben", "Chris", "Dana"];
scores = [92.5, 88.7, 95.2, 91.8];
grades = ["A-", "B+", "A", "A-"];

% Store the result as a single string
% Header
tstr = sprintf( "+---------------+---------------+---------------+\n" + ...
                "| Name\t\t| Score\t\t| Grade\t\t|\n" + ...
                "+---------------+---------------+---------------+\n");

% Add each row, using tabs for alignment
for ii = 1:length(names)
    tstr = tstr + sprintf("| %s\t\t| %.1f%%\t\t| %s\t\t|\n", names(ii), scores(ii), grades(ii));
end

% Add bottom
tstr = tstr + sprintf("+---------------+---------------+---------------+\n");

disp(tstr)
%[text] **Question:** Given this data
robotID = 7;
battery = 87.4567;
status = "Active";
%[text] How could we print the state like in this format?
%[text]     Robot ID: 7 | Battery: 87.46% | Status: Active
% ?
%%
%[text] ## Structures
%[text] A data type for organizing related information using *fields*. Each field has a name and a value.  
%[text] - Fields can contain any type of data
%[text] - Dot notation (.) accesses fields
%[text] - Common in accessing MATLAB capabilities, GUI programming, data management
%[text] A single structure element:
clear sensors
sensors.ID = 101;
sensors.type = "Conductivity";
sensors.data = [55433       55816       55048       55055]  % [uS/cm]
whos("sensors")
class(sensors)
sensors.ID(2) = 102
sensors(2).ID(2) = 103
%%
%[text] Add elements to the array of structures
sensors(2).ID = 102;
sensors(2).type = "Temperature";
sensors(2).data = [17.2, 17.1, 16.9, 16.2];  % [C]

sensors(3) = struct("ID", 103, ...
                    "type", "Depth", ...
                    "data", [0, 102, 205, 502]) % [m]
whos("sensors")
%%
%[text] Accessing structures by index and dot-notation.
fprintf("The data for the %s sensor has %d elements", ...
    sensors(2).type, ...
    length(sensors(2).data))
%%
%[text] We can access all the values from a specific field name
sensors.type
%%
%[text] and put them into their own array
types = [sensors.type]
join(types, " , ")
%%
%[text] **Question:** How could we plot temperature as a function of depth?
figure

% ??

xlabel("Depth [m]")
ylabel("Temperature [C]")

%[appendix]{"version":"1.0"}
