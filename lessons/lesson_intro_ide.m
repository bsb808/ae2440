%% MATLAB IDE Tour
% =========================================================================
%  KEYBOARD SHORTCUTS  (show these on screen before running anything)
% =========================================================================
%
%   Action                  Windows/Linux       macOS
%   ----------------------  ----------------    ----------------
%   Run script (F5)         F5                  F5
%   Run section             Ctrl+Enter          Cmd+Enter
%   Run selected code       F9                  F9  (or Fn+F9)
%   Comment selection       Ctrl+R              Cmd+R
%   Uncomment selection     Ctrl+T              Cmd+T
%   Interrupt running code  Ctrl+C              Ctrl+C
%
% =========================================================================

%% Display
% -------------------------------------------------------------------------
% Run just a section

disp('Hello AE2440 World')          
disp("Hello AE2440 World")

% The semicolon (;) SUPPRESSES output to the Command Window.
x = 42;          % suppressed — nothing printed
y = 3.14         % no semicolon — value echoes in Command Window

%% Variables and Basic Arithmetic
% -------------------------------------------------------------------------

a = 10;
b = 3;

addition       = a + b      
subtraction    = a - b     
multiplication = a * b      
division       = a / b      
power          = a ^ b      

% Variable names are case-sensitive!
Voltage = 120;    % capital V
voltage = 12;     % lower-case v — completely different variable
disp(Voltage)
disp(voltage)

%% The Workspace (variable scope demo)
% -------------------------------------------------------------------------
% Every variable created here lives in the "base workspace."

radius   = 5;            % meters
area     = pi * radius^2 % pi is a built-in constant
diameter = 2 * radius;


%% Strings 
% -------------------------------------------------------------------------

material1 = 'Aluminum';
material2 = "Steel"

disp(material1)
material2

