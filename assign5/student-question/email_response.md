# Email Response — Student, Assignment 5 (Euler / Ballistics)

## Draft Reply

Student,

You're closer than you think. I appreciate you taking the time to understand this.  It isn't a race and getting the concepts solidified is the key.

Your understanding of the algorithm is correct — the issue is that the body of your loop assumes `tt` and `yy` already exist, but nothing in your function creates them yet. Once you add a couple lines of setup before the `for` loop, the rest should fall together.

**A note on workspaces — this is the heart of the confusion:**

When you call `[tt, yy] = euler(@drop_rate, tspan, v0)` from `ballistic.m`, MATLAB has *two separate workspaces* in play:

- The **base workspace** (your script) — has variables like `tspan`, `v0`, `g`, `m`, `b`.
- The **local workspace** of `euler` — only sees what gets passed in as arguments (`odefun`, `tspan`, `y0`). The names `tt` and `yy` on the *outside* (in your script) have nothing to do with `tt` and `yy` on the *inside* of the function.

So inside `euler.m`, `tt` and `yy` don't exist until *you create them*. The error "Unrecognized function or variable 'tt'" on line 7 is MATLAB telling you exactly that — you wrote `length(tt)` before any line in the function ever assigned a value to `tt`. The function only "knows" what its arguments are and what it builds itself.

Using the debugger and the step-into function is a good way to "see" what variables are available in each workspace as the procedural steps are done.

**Walk through what `euler` needs to do, in order:**

1. Compute the step size `dt` from `tspan` (you have this).
2. **Build the time vector** `tt` from `tspan(1)` to `tspan(2)` in steps of `dt`. This is the missing piece — once you create `tt` here, the `length(tt)` on the next line works.
3. Set the initial condition: `yy(1) = y0`.
4. Loop from `k = 1` to `length(tt)-1` and apply the update rule.

**Three small bugs to fix in your update line:**

```matlab
yy(k+1) = y(k) + ydot(dt)
```

- `y(k)` should be `yy(k)` (you defined the output as `yy`, not `y`).
- `ydot(dt)` calls `ydot` as if it were a function — but `ydot` is already a number (the slope you computed on the line above). You want to **multiply**: `ydot * dt`.
- End the line with a semicolon so the loop doesn't print 100 lines of output.

**One bug on the ballistic.m side:**

Your call is `[yy, tt] = euler(@drop_rate, tspan, v0)` but the function signature should be `function [tt, yy] = euler(...)` (just like the `ode45` interface) — outputs in the opposite order. Swap them to `[tt, yy] = euler(...)`.

Also: your `ode45` line `vterm = ode45(@drop_rate, 0:100, v0)` overwrites your terminal-velocity scalar `v_term` with the solver's output struct. Use a different name and capture both outputs, e.g. `[t_ode, v_ode] = ode45(@drop_rate, tspan, v0)`.

Let me know if that gets you unstuck.

All the best,
Brian

(I use Claude Code to make this process more efficient, but all the concepts in this  are mine and I've reviewed this in detail.)