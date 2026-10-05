function run_checks(jobfile, outfile)
% RUN_CHECKS  Run student scripts for grading; called by grade.py via matlab -batch.
%   jobfile: JSON array of {key, name, path}. Each script is copied to a fresh
%   temp folder as <name> and run in its own function workspace. One JSON line
%   per script is appended to outfile as soon as it finishes, so a hang loses
%   only the script that hung: {key, name, ran, error, scalars}.
jobs = jsondecode(fileread(jobfile));
set(groot, 'DefaultFigureVisible', 'off');
for k = 1:numel(jobs)
    job = jobs(k);
    r = run_one(job.path, job.name);
    r.key = job.key;
    r.name = job.name;
    fid = fopen(outfile, 'a');
    fprintf(fid, '%s\n', jsonencode(r));
    fclose(fid);
end
end

function r = run_one(src, name)
r = struct('ran', false, 'error', '', 'scalars', struct());
tmp = tempname;
mkdir(tmp);
copyfile(src, fullfile(tmp, name));
old = cd(tmp);
try
    r.scalars = exec_script__(name);
    r.ran = true;
catch e
    r.error = e.message;
end
cd(old);
close all force
rmdir(tmp, 's');
end

function out__ = exec_script__(name__)
% Runs the script in this function's workspace, then returns its real numeric
% scalars (including ans).
evalc('run(name__)');
vars__ = setdiff(who, {'name__', 'out__'});
out__ = struct();
for i__ = 1:numel(vars__)
    v__ = eval(vars__{i__});
    if isnumeric(v__) && isscalar(v__) && isreal(v__)
        out__.(vars__{i__}) = double(v__);
    end
end
end
