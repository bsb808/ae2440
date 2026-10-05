%[text] # MATLAB Live Script Tour
%[text] A live script mixes **text** and **code** in one file. Text lines are formatted prose (headings, bold, lists, equations, images); code lines run exactly like a plain `.m` script. Output appears in the document instead of in the Command Window.
%[text] ## Keyboard Shortcuts
%[text:table]{"ignoreHeader":true}
%[text] | Action | Windows/Linux | macOS |
%[text] | --- | --- | --- |
%[text] | Run whole script | F5 | F5 |
%[text] | Run section | Ctrl+Enter | Cmd+Enter |
%[text] | Run section and advance | Ctrl+Shift+Enter | Cmd+Shift+Enter |
%[text] | Run selected code | F9 | F9 (or Fn+F9) |
%[text] | Toggle line between code and text | Alt+Enter | Option+Enter |
%[text] | Insert section break | Ctrl+Alt+Enter | Cmd+Option+Enter |
%[text:table]
%%
%[text] ## Display
%[text] Click anywhere in this section and press Ctrl+Enter (Cmd+Enter on macOS) to run **just this section**. The section is highlighted; the bar on the$F=\\mathrm{ma}${"editStyle":"visual"} left shows which section is current.
disp('Hello AE2440 World') %[output:9ccb7456]
disp("Hello AE2440 World") %[output:90ebd406]
%[text] The semicolon (`;`) suppresses output. Without it, the value is echoed in the live script, right below the line that produced it, not in the Command Window.
x = 42;          % suppressed: nothing printed
y = 3.14         % no semicolon: value echoes below this line %[output:87aeb22e]
%[text] Use the **View** tab to choose where output goes: **Output Inline** (below each line) or **Output on Right** (in a panel beside the code). Both show the same results.
%%
%[text] ## Variables and Basic Arithmetic
%[text] Text lines can hold real math. The operators below are $+$, $-$, $\\times$, $\\div$ and $a^b$; type a dollar sign in a text line to start an inline equation, or use **Insert \> Equation** for a display equation.
a = 10;
b = 3;

addition       = a + b %[output:3a4792e5]
subtraction    = a - b %[output:75099725]
multiplication = a * b %[output:4afc94e7]
division       = a / b %[output:038d6a26]
power          = a ^ b %[output:2efcd8f3]
%[text] Variable names are **case-sensitive**.
Voltage = 120;    % capital V
voltage = 12;     % lower-case v: a completely different variable
disp(Voltage) %[output:5718f839]
disp(voltage) %[output:6a280eef]
%%
%[text] ## The Workspace (variable scope demo)
%[text] Every variable created here lives in the **base workspace**, the same one used by the Command Window and by plain scripts. Watch the **Workspace** panel as you run this section.
radius   = 5;            % meters
area     = pi * radius^2 % pi is a built-in constant %[output:1cc1d22d]
diameter = 2 * radius;
%[text] The formula above, written as an equation instead of code: $A = \\pi r^2$.
%%
%[text] ## Strings
%[text] Single quotes make a character array; double quotes make a string. Both display inline.
material1 = 'Aluminum';
material2 = "Steel" %[output:1ac3f62c]

disp(material1) %[output:5b750206]
material2 %[output:331b883f]
%%
%[text] ## Managing Output
%[text] - Save with or without output?
%[text] - Clear output \
%%
%[text] 
%[text] ## What Only a Live Script Can Do
%[text] - Formatted text: **bold**, *italic*, `monospace`, headings, bulleted and numbered lists
%[text] - Equations: inline like $F = ma$ or on their own line
%[text] - Images and hyperlinks, for example [MATLAB Live Editor documentation](https://www.mathworks.com/help/matlab/live-scripts-and-functions.html)
%[text] - Output saved in the document, including figures
%[text] - Export to PDF, HTML, or Word from the **Live Editor** tab, **Export** menu \

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:9ccb7456]
%   data: {"dataType":"text","outputData":{"text":"Hello AE2440 World\n","truncated":false}}
%---
%[output:90ebd406]
%   data: {"dataType":"text","outputData":{"text":"Hello AE2440 World\n","truncated":false}}
%---
%[output:87aeb22e]
%   data: {"dataType":"textualVariable","outputData":{"name":"y","value":"3.1400"}}
%---
%[output:3a4792e5]
%   data: {"dataType":"textualVariable","outputData":{"name":"addition","value":"13"}}
%---
%[output:75099725]
%   data: {"dataType":"textualVariable","outputData":{"name":"subtraction","value":"7"}}
%---
%[output:4afc94e7]
%   data: {"dataType":"textualVariable","outputData":{"name":"multiplication","value":"30"}}
%---
%[output:038d6a26]
%   data: {"dataType":"textualVariable","outputData":{"name":"division","value":"3.3333"}}
%---
%[output:2efcd8f3]
%   data: {"dataType":"textualVariable","outputData":{"name":"power","value":"1000"}}
%---
%[output:5718f839]
%   data: {"dataType":"text","outputData":{"text":"   120\n\n","truncated":false}}
%---
%[output:6a280eef]
%   data: {"dataType":"text","outputData":{"text":"    12\n\n","truncated":false}}
%---
%[output:1cc1d22d]
%   data: {"dataType":"textualVariable","outputData":{"name":"area","value":"78.5398"}}
%---
%[output:1ac3f62c]
%   data: {"dataType":"textualVariable","outputData":{"name":"material2","value":"\"Steel\""}}
%---
%[output:5b750206]
%   data: {"dataType":"text","outputData":{"text":"Aluminum\n","truncated":false}}
%---
%[output:331b883f]
%   data: {"dataType":"textualVariable","outputData":{"name":"material2","value":"\"Steel\""}}
%---
