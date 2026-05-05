%[text] # Contact Data Generator
%[text] This script creates a set of simulated radar contacts and saves them as `contactdata.mat`.
%[text] Read through it to see how a **struct** is created in MATLAB.
%[text] A struct groups related data under named **fields**, accessed with dot notation: `variable.field`
%%
%[text] ## Creating the Contacts
%[text] Each contact is one element of a **struct array**.
%[text] Fields are assigned one at a time using dot notation — MATLAB builds the struct as you go.
contact(1).id      = 'C-01';
contact(1).bearing = 45;
contact(1).range = 12.5;

contact(2).id      = 'C-02';
contact(2).bearing = 135;
contact(2).range = 8.2;

contact(3).id      = 'C-03';
contact(3).bearing = 270;
contact(3).range = 20.0;
%[text] Inspect `contact` in the **Workspace** panel.
%[text] Notice it shows as a **1×3 struct array** with three fields: `id`, `bearing`, `range`.
%[text] Click the arrow next to `contact` to expand and see each element's values.
%%
%[text] ## Save to File
save('contactdata.mat', 'contact');
disp('contactdata.mat saved.') %[output:19718c34]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:19718c34]
%   data: {"dataType":"text","outputData":{"text":"contactdata.mat saved.\n","truncated":false}}
%---
