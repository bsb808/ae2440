# Email Thread — Student, Assignment 5 (Euler / Ballistics)

## Re: Assignment Assistance Request

**From:** Student (LT)
**To:** Bingham, Brian (CIV)

Good Afternoon Sir,

I am still very lost when it comes to Euler. I still don't seem to grasp what we went over in class.

My current understanding:

- Write an Euler function of the form `[yy,tt]=euler(odefun,tspan,y0)`
- My ode function will be called later on the ballistics problem
- Tspan is just delta t where `tspan(1)` is my first value and `tspan(2)` is the next value and that is divided by 100 for the step size
- Then I put `ydot=odefun(tnow,ynow)` inside a for loop but I don't understand the how to implement `yy(k+1)=yy(k)+ydot*dt`
- On my ballistics.m side I keep getting that `tt` is an unrecognized variable.

Please see attached `euler.m` and `ballistics.m` files. I apologize I have a lot of things commented out as I am attempting to understand the problem and attempting different solutions.

Standing by for guidance.

Very Respectfully,
LT Student, USN

---

**From:** Bingham, Brian (CIV)
**Sent:** Friday, April 24, 2026 4:21 PM
**To:** Student (LT)

Student,

Here is **a** solution to the problem. Please compare this to your implementation as that might shed some light on the confusion.

All the best,
Brian

---

**From:** Student (LT)
**Sent:** Friday, April 24, 2026 15:40
**To:** Bingham, Brian (CIV)

Sir,

After a lot of back and forth with MATLAB, I think I finally got it. I would like to discuss it with you more on Monday if possible, but I was not getting a plot because I had a vector vs. scalar plot, so I needed to vectorize my function's equation with periods throughout. Thank you for your assistance.

Very Respectfully,
LT Student, USN

---

**From:** Bingham, Brian (CIV)
**Sent:** Friday, April 24, 2026 10:45 AM
**To:** Student (LT)

Student,

Attached is the live code script with my comments. I can certainly see why you are lost.

I'd recommend reviewing my comments first, then start simple, do just this:

- Write out your math equation as an equation in the live code so it is clear what model you are implementing, BEFORE writing the matlab implementation.
- Implement the model as a simple function.
- To check, graph the value of your function (RHS) for a vector of draft values from 0.01 to 0.4 m. This will verify that there is a zero crossing somewhere within that range of draft values. From that figure you will be able to estimate the value of d for which the function value is approximately zero. Use this as your initial value for fzero.
- Then, once you've validated your function, pass the function to the fzero solver using a function handle and an initial value from the previous step.
- Verify that the output of fzero is consistent with the plot.

Please give that a try and send the code back if you are stuck.

All the best,
Brian

---

**From:** Student (LT)
**Sent:** Thursday, April 23, 2026 23:18
**To:** Bingham, Brian (CIV)
**Subject:** Assignment Assistance Request

Good Evening Sir,

I have been working on the `usv_draft.m` assignment but feel lost. I have tried multiple things to get a valid output but to no avail. I did get it to provide a plot once, however only with one output value. My thought process was to list the variables, then solve the right-hand side of the equation (RHS). The thing I don't understand is how to incorporate draft into the function. I need to name `draft(d)= something`, otherwise my function does not know how to handle it. However, I don't know what d will be as we want to test for it using the fzero function. Also, I don't seem to grasp how to limit the domain of d to `2*R`.

In short here is what I have done so far:

- Listed variables
- Started with a value of `d=1` outside my function
- Wrote a function `RHS=wstab(d)`
- Brought all variables inside function
- Attempted for loop to limit domain of d to `2*R` inside the function on my equation `RHS=...`
- Called my function `RHS=wstab(d)` to the workspace
- Attempted to perform fzero function on wstab (commented out)
- Lastly, attempted a for loop on the plot as I only returned 1 value (possibly because d was assigned a value). I was expecting many values with one crossing the x axis.

Please see attached `.m` file. I am free after 1100 tomorrow if you are available for office hours.

- `usv_draft.m`
- `usv_draft.asv`

Standing by for guidance.

Very Respectfully,
LT Student, USN
