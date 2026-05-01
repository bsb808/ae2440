# Email Response — Student, Assignment 5 (Euler / Ballistics)

## Draft Reply

Student,

You're closer than you think. I appreciate you taking the time to understand this.  It isn't a race and getting the concepts solidified is the key.

Your understanding of the algorithm is correct — the issue is that the body of your loop assumes `tt` and `yy` already exist, but nothing in your function creates them yet. Once you add the three lines of setup before the `for` loop, the rest sould fall together.

**Walk through what `euler` needs to do, in order:**

1. Compute the step size `dt` from `tspan` (you have this).
2. **Build the time vector** `tt` from `tspan(1)` to `tspan(2)` in steps of `dt`. This is what's missing — the error "Unrecognized function or variable 'tt'" on line 7 is MATLAB telling you that `tt` doesn't exist yet when the `for` loop tries to use `length(tt)`.  % CLAUDE: explain this more.  The student is struggling with the concept of variable naming in the main script (MATLAB Workspace) and the function (local Workspace)
3. **Pre-allocate `yy`** as a vector the same size as `tt`, and set the first entry: `yy(1) = y0`.  % CLAUDE: For our purposes in the class, we don't discuss preallocation.  There is an underlying reason with the theme of the class.  I'd like you to capture this in the repo as a theme for your memory.  My philosophy is that the conceptual undersanding of how to formulate an engineering problem into a form where we can apply computation is the foundational, persistent knowledge and skill we are trying to strengthen in the course.   From that prespective, the syntax of matlab, and the details can often be ignored - especially for these students that will not be "programming" after they leave graduate school.   This is also important as we think of how AI will change things --- it will still be the key skill to figure out how to translate between engineering and AI computational tools.   Finally, I encourage matlab as a good language for quick and dirty prototyping.  Full detail and efficient execution are not the advantage of matlab.   Along the same lines, we demonstrate a make it work, make it right, make it fast mantra - and making it fast is outside the scope of this short class.
4. Loop from `k = 1` to `length(tt)-1` and apply the update rule.

**Three small bugs to fix in your update line:**

```matlab
yy(k+1) = y(k) + ydot(dt)
```

- `y(k)` should be `yy(k)` (you defined the output as `yy`, not `y`).
- `ydot(dt)` calls `ydot` as if it were a function — but `ydot` is already a number (the slope you computed on the line above). You want to **multiply**: `ydot * dt`.
- End the line with a semicolon so the loop doesn't print 100 lines of output.

**One bug on the ballistic.m side:**

Your call is `[yy, tt] = euler(@drop_rate, tspan, v0)` but the function signature should be `function [tt, yy] = euler(...)` (just like the `ode45` interface ) - wiith outputs in the opposite order. Swap them to `[tt, yy] = euler(...)`. 

Also: your `ode45` line `vterm = ode45(@drop_rate, 0:100, v0)` overwrites your terminal-velocity scalar `v_term` with the solver's output struct. Use a different name and capture both outputs, e.g. `[t_ode, v_ode] = ode45(@drop_rate, tspan, v0)`.

Let me know if that gets you unstuck.

All the best,
Brian
