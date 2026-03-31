%[text] # Workspace & File Management
%[text] Paths, directories, saving and reloading the workspace
%[text] ## Recommended Folder Structure
%[text] Keep **one folder per week**. MATLAB always looks in the *Current Folder* first, so staying organised means you rarely need to touch the path manually.
%[text] ```
%[text] Documents/
%[text] └── AE2440/
%[text]     ├── week01/     ← put this file here
%[text]     ├── week02/
%[text]     ├── week03/
%[text]     └── data/       ← shared datasets (optional)
%[text] ```
%[text] ### Setting the Current Folder — three ways
%[text] 1. GUI — browser: Navigate in the **Current Folder** panel
%[text] 2. GUI — address bar: Type the path directly above the Current Folder panel
%[text] 3. Code: `cd('path/to/your/folder')`  \
%%
%[text] ### Where Are We Right Now?
%[text] Run this section with Ctrl+Enter (Win) or Cmd+Enter (Mac)
pwd
current_folder = pwd    
dir
ls -lhrt
%[text] To change folder from code, uncomment the line that matches your OS:
% cd('~/Documents/MATLAB_Course/week01')                        % macOS / Linux
% cd('C:\Users\YourName\Documents\MATLAB_Course\week01')        % Windows
%%
%[text] ### The MATLAB Path
%[text] MATLAB searches a list of folders (the *path*) to find functions and scripts. For this course you **do not** need to manage the path — just keep the Current Folder set to the week you are working on.
%[text] **MATLAB says "... not found,** you are almost certainly in the wrong folder.
%[text] 
which sqrt          
which lesson_intro_workspace_path 
%%
%[text] ### Creating Variables to Save
%[text] Let's build a small workspace representing a simple material measurement. Watch the **Workspace** panel fill up as you run this section.

sample_name = 'Steel_Rod_A';
length_m    = 0.500;          % metres
diameter_m  = 0.012;          % metres
mass_kg     = 0.444;          % kilograms

cross_area = pi/4 * diameter_m^2     % m^2
volume_m3  = cross_area * length_m    % m^3
density    = mass_kg / volume_m3      % kg/m^3

%[text] ### **Saving the Workspace**
%[text] **Why?** Long simulations, measured data, results you want to hand off to a colleague, or work you want to resume tomorrow.
%[text] `.mat` files are MATLAB's native binary format. 

% Save the entire workspace:
save('week01_results.mat')

% Save only specific variables:
save('sample_data.mat', 'sample_name', 'mass_kg', 'density')
%%
%[text] **Clear** the workspace 
%[text] Check with `whos` or "Workspace" panel.

clear
disp('Workspace cleared — check the Workspace panel, it is empty.')
whos            % whos lists variables with size & type — should be empty now

%%
%[text] **Reload** from the `.mat` file:
load('week01_results.mat')
whos            
%[text] Often these three lines at the top a script to guarantee a predictable starting state.
%[text] ```
%[text] clear       % remove all workspace variables
%[text] clc         % clear the Command Window
%[text] close all   % close all figure windows
%[text] ```
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
