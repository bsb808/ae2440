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
%[text] 3. Code: `cd('path/to/your/folder')` \
%%
%[text] ### Where Are We Right Now?
%[text] Run this section with Ctrl+Enter (Win) or Cmd+Enter (Mac)
pwd %[output:14e2a370]
current_folder = pwd     %[output:038f336b]
dir %[output:5c3e191f]
ls -lhrt %[output:7aa162e7]
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
x = 15 + 5 %[output:5354299e]

%[text] This is human text
%[text] 
code = 1
%[text] This text
%[text] 
%[text] 
%[text] 
% Let's build a small workspace representing a simple material measurement. Watch the Workspace panel fill up as you run this section.
sample_name = 'Steel_Rod_A';
length_m    = 0.500;          % metres
diameter_m  = 0.012;          % metres
mass_kg     = 0.444;          % kilograms

cross_area = pi/4 * diameter_m^2     % m^2 %[output:672d9c9b]
volume_m3  = cross_area * length_m    % m^3 %[output:267e389b]
density    = mass_kg / volume_m3      % kg/m^3 %[output:07c96a47]

%%
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
disp('Workspace cleared — check the Workspace panel, it is empty.') %[output:093c0a92]
whos            % whos lists variables with size & type — should be empty now

%%
%[text] **Reload** from the `.mat` file:
load('week01_results.mat')
whos             %[output:188d028d]
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
%   data: {"layout":"onright"}
%---
%[output:14e2a370]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'\/Users\/brian.bingham\/WorkingCopies\/ae2440\/lessons'"}}
%---
%[output:038f336b]
%   data: {"dataType":"textualVariable","outputData":{"name":"current_folder","value":"'\/Users\/brian.bingham\/WorkingCopies\/ae2440\/lessons'"}}
%---
%[output:5c3e191f]
%   data: {"dataType":"text","outputData":{"text":"\n.                                    ..                                   Heron.mlx                            batt_fit.mat                         euler.m                              euler_rats.mlx                       heron.png                            heron_villages.png                   heron_villages.xcf                   lesson_anonymous.mlx                 lesson_anonymous_lorenz.mlx          lesson_anonymous_pendulum.mlx        lesson_beam_ex.mlx                   lesson_beam_ex_soln.mlx              lesson_conditionals.mlx              lesson_cooling.mlx                   lesson_cooling_soln.mlx              lesson_curvefit_regression.mlx       lesson_datatype.mlx                  lesson_datatype_verbosedivision.mlx  lesson_dictionaries.mlx              lesson_fhandles_fzero.mlx            lesson_find.mlx                      lesson_find_cmd.mlx                  lesson_functions.mlx                 lesson_interpolation.mlx             lesson_intro_ide.m                   lesson_intro_workspace_path.m        lesson_loops.mlx                     lesson_matrices.mlx                  lesson_ode_intro.mlx                 lesson_optimization_intro.mlx        lesson_regression.mlx                lesson_secondorder.mlx               lesson_system_of_odes.mlx            lesson_vectors.mlx                   massspringdamper.m                   plot_stress_strain.mlx               rat_rate.m                           rate_rate.m                          rr2dd.m                              \n\n","truncated":false}}
%---
%[output:7aa162e7]
%   data: {"dataType":"text","outputData":{"text":"total 14728\n-rw-r--r--  1 brian.bingham  staff   148K Mar 30 17:55 Heron.mlx\n-rw-r--r--  1 brian.bingham  staff   8.6K Mar 30 17:55 batt_fit.mat\n-rw-r--r--  1 brian.bingham  staff   1.0K Mar 30 17:55 euler.m\n-rw-r--r--  1 brian.bingham  staff    45K Mar 30 17:55 euler_rats.mlx\n-rw-r--r--  1 brian.bingham  staff   107K Mar 30 17:55 heron.png\n-rw-r--r--  1 brian.bingham  staff    98K Mar 30 17:55 heron_villages.png\n-rw-r--r--  1 brian.bingham  staff   174K Mar 30 17:55 heron_villages.xcf\n-rw-r--r--  1 brian.bingham  staff   817K Mar 30 17:55 lesson_anonymous.mlx\n-rw-r--r--  1 brian.bingham  staff    69K Mar 30 17:55 lesson_anonymous_lorenz.mlx\n-rw-r--r--  1 brian.bingham  staff   114K Mar 30 17:55 lesson_anonymous_pendulum.mlx\n-rw-r--r--  1 brian.bingham  staff   118K Mar 30 17:55 lesson_beam_ex.mlx\n-rw-r--r--  1 brian.bingham  staff   107K Mar 30 17:55 lesson_beam_ex_soln.mlx\n-rw-r--r--  1 brian.bingham  staff    74K Mar 30 17:55 lesson_conditionals.mlx\n-rw-r--r--  1 brian.bingham  staff    60K Mar 30 17:55 lesson_cooling.mlx\n-rw-r--r--  1 brian.bingham  staff    86K Mar 30 17:55 lesson_cooling_soln.mlx\n-rw-r--r--  1 brian.bingham  staff   429K Mar 30 17:55 lesson_curvefit_regression.mlx\n-rw-r--r--  1 brian.bingham  staff    11K Mar 30 17:55 lesson_datatype.mlx\n-rw-r--r--  1 brian.bingham  staff   3.5K Mar 30 17:55 lesson_datatype_verbosedivision.mlx\n-rw-r--r--  1 brian.bingham  staff    52K Mar 30 17:55 lesson_dictionaries.mlx\n-rw-r--r--  1 brian.bingham  staff   295K Mar 30 17:55 lesson_fhandles_fzero.mlx\n-rw-r--r--  1 brian.bingham  staff   148K Mar 30 17:55 lesson_find.mlx\n-rw-r--r--  1 brian.bingham  staff   3.6K Mar 30 17:55 lesson_find_cmd.mlx\n-rw-r--r--  1 brian.bingham  staff   250K Mar 30 17:55 lesson_functions.mlx\n-rw-r--r--  1 brian.bingham  staff   322K Mar 30 17:55 lesson_interpolation.mlx\n-rw-r--r--  1 brian.bingham  staff   4.6K Mar 30 17:55 lesson_loops.mlx\n-rw-r--r--  1 brian.bingham  staff    24K Mar 30 17:55 lesson_matrices.mlx\n-rw-r--r--  1 brian.bingham  staff   2.8M Mar 30 17:55 lesson_ode_intro.mlx\n-rw-r--r--  1 brian.bingham  staff   165K Mar 30 17:55 lesson_optimization_intro.mlx\n-rw-r--r--  1 brian.bingham  staff   467K Mar 30 17:55 lesson_regression.mlx\n-rw-r--r--  1 brian.bingham  staff    40K Mar 30 17:55 lesson_secondorder.mlx\n-rw-r--r--  1 brian.bingham  staff    87K Mar 30 17:55 lesson_system_of_odes.mlx\n-rw-r--r--  1 brian.bingham  staff    88K Mar 30 17:55 lesson_vectors.mlx\n-rw-r--r--  1 brian.bingham  staff   325B Mar 30 17:55 massspringdamper.m\n-rw-r--r--  1 brian.bingham  staff   4.8K Mar 30 17:55 plot_stress_strain.mlx\n-rw-r--r--  1 brian.bingham  staff   191B Mar 30 17:55 rat_rate.m\n-rw-r--r--  1 brian.bingham  staff   191B Mar 30 17:55 rate_rate.m\n-rw-r--r--  1 brian.bingham  staff   233B Mar 30 17:55 rr2dd.m\n-rw-r--r--@ 1 brian.bingham  staff   3.0K Mar 30 19:48 lesson_intro_workspace_path.m\n-rw-r--r--@ 1 brian.bingham  staff   2.0K Mar 31 09:20 lesson_intro_ide.m\n\n","truncated":false}}
%---
%[output:5354299e]
%   data: {"dataType":"textualVariable","outputData":{"name":"x","value":"20"}}
%---
%[output:672d9c9b]
%   data: {"dataType":"textualVariable","outputData":{"name":"cross_area","value":"1.1310e-04"}}
%---
%[output:267e389b]
%   data: {"dataType":"textualVariable","outputData":{"name":"volume_m3","value":"5.6549e-05"}}
%---
%[output:07c96a47]
%   data: {"dataType":"textualVariable","outputData":{"name":"density","value":"7.8516e+03"}}
%---
%[output:093c0a92]
%   data: {"dataType":"text","outputData":{"text":"Workspace cleared — check the Workspace panel, it is empty.\n","truncated":false}}
%---
%[output:188d028d]
%   data: {"dataType":"text","outputData":{"text":"  Name             Size            Bytes  Class     Attributes\n\n  cross_area       1x1                 8  double              \n  density          1x1                 8  double              \n  diameter_m       1x1                 8  double              \n  length_m         1x1                 8  double              \n  mass_kg          1x1                 8  double              \n  sample_name      1x11               22  char                \n  volume_m3        1x1                 8  double              \n\n","truncated":false}}
%---
