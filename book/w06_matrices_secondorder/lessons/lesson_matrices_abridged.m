%[text] # Basics of Matrix Operations in MATLAB
%[text] This lesson covers fundamental matrix operations — creating, indexing, slicing, concatenation, transpose, and equivalence — with an emphasis on how each one is used when we solve **systems of ODEs**. 
%[text] ## Creating Matrices
%[text] A matrix with $m$ rows and $n$ columns is an element of $\\mathbb{R}^{m \\times n}$. In MATLAB we build one with brackets — commas (or spaces) separate columns, semicolons separate rows.
%[text]{"align":"center"} $A = \\left\[\\begin{array}{cc} 1 & 2 \\\\ 3 & 4 \\\\ 5 & 6 \\end{array}\\right\] \\in \\mathbb{R}^{3 \\times 2}$
A = [1, 2; 3, 4; 5, 6];
disp('Matrix A:');
disp(A);
%[text] The `size` function reports `[rows, cols]` — note the order:
size(A)
fprintf("A has %d rows and %d columns\n", size(A,1), size(A,2));
%[text] ### Special Matrices
%[text] The identity, ones, and zeros matrices come up constantly when assembling state-space models or preallocating arrays.
%[text]{"align":"center"} $I\_4 = \\left\[\\begin{array}{cccc} 1 & 0 & 0 & 0 \\\\ 0 & 1 & 0 & 0 \\\\ 0 & 0 & 1 & 0 \\\\ 0 & 0 & 0 & 1 \\end{array}\\right\], \\quad \\mathbf{1}\_{2 \\times 3} = \\left\[\\begin{array}{ccc} 1 & 1 & 1 \\\\ 1 & 1 & 1 \\end{array}\\right\], \\quad \\mathbf{0}\_{2 \\times 2} = \\left\[\\begin{array}{cc} 0 & 0 \\\\ 0 & 0 \\end{array}\\right\]$
I = eye(4);
disp('4x4 Identity matrix I:');
disp(I);
B = ones(2, 3);
disp('2x3 Matrix of ones B:');
disp(B);
Z = zeros(2, 2);
disp('2x2 Matrix of zeros Z:');
disp(Z);
%%
%[text] ## Indexing and Slicing
%[text] Use `A(i, j)` to extract a single element. The colon operator `:` selects all entries along that dimension, so `A(i, :)` is row $i$ and `A(:, j)` is column $j$. Range expressions like `A(2:3, 1:2)` carve out submatrices.
%[text]{"align":"center"} $A(i,j) = a\_{ij}, \\quad A(i,:) = \\left\[\\begin{array}{cccc} a\_{i1} & a\_{i2} & \\cdots & a\_{in} \\end{array}\\right\], \\quad A(:,j) = \\left\[\\begin{array}{c} a\_{1j} \\\\ a\_{2j} \\\\ \\vdots \\\\ a\_{mj} \\end{array}\\right\]$
%[text] Access the element at row 2, column 1 of $A$:
element_21 = A(2, 1);
fprintf('Element at row 2, column 1 of A: %d\n', element_21);
%[text] Access the second row:
row2 = A(2, :)
%[text] Access the first column:
col1 = A(:, 1)
%[text] Slice the submatrix from rows 2-3 and columns 1-2:
submatrix = A(2:3, 1:2)
%[text] **Connection to systems of ODEs.** This is exactly the syntax used inside a rate function to *unpack* the state vector — `x(1)` pulls out position, `x(2)` pulls out velocity. And on the way out of `ode45`, we *slice columns* of the solution matrix: `xx(:,1)` is the time history of state 1, `xx(:,2)` is state 2. See `lesson_secondorder.m`.
%%
%[text] ## Column vs Row Vectors
%[text] A column vector is $n \\times 1$; a row vector is $1 \\times n$. They are *distinct objects* in MATLAB — they are not interchangeable, and many functions care which one you pass.
%[text]{"align":"center"} $\\mathbf{c} = \\left\[\\begin{array}{c} c\_1 \\\\ c\_2 \\\\ \\vdots \\\\ c\_n \\end{array}\\right\] \\in \\mathbb{R}^{n \\times 1}, \\qquad \\mathbf{r} = \\left\[\\begin{array}{cccc} r\_1 & r\_2 & \\cdots & r\_n \\end{array}\\right\] \\in \\mathbb{R}^{1 \\times n}$
rr = 1:5
cc = rr'
%[text] Force a vector to be a column ($n \\times 1$) — two ways:
rr_col = rr(:)
rr_col = reshape(rr, length(rr), 1)
cc_col = cc(:)
%[text] Force a vector to be a row ($1 \\times n$):
rr_row = rr(:)'
rr_row = reshape(rr, 1, length(rr))
cc_row = cc(:)'
%[text] **Connection to systems of ODEs.** `ode45` *requires* the rate function to return a **column** vector — if you accidentally build a row vector, the solver errors out. This is why you will see the line `dxxdt = dxxdt(:);` at the end of the rate function in `lesson_secondorder.m`: it is column-ness insurance. The same logic applies to the initial-condition vector you pass in — `xx0 = [1; 0]` is a column.
%%
%[text] ## Concatenation: Building Block Matrices
%[text] Inside the bracket constructor, commas (or spaces) place matrices *side-by-side* (horizontal); semicolons *stack* them (vertical). The dimensions must agree along the joined edge.
%[text]{"align":"center"} $\\left\[\\begin{array}{cc} C & D \\end{array}\\right\] = \\left\[\\begin{array}{cccc} 1 & 2 & 5 & 6 \\\\ 3 & 4 & 7 & 8 \\end{array}\\right\], \\qquad \\left\[\\begin{array}{c} C \\\\ D \\end{array}\\right\] = \\left\[\\begin{array}{cc} 1 & 2 \\\\ 3 & 4 \\\\ 5 & 6 \\\\ 7 & 8 \\end{array}\\right\]$
%[text] Define two $2 \\times 2$ matrices:
C = [1, 2; 3, 4];
D = [5, 6; 7, 8];
%[text] Horizontal concatenation (side-by-side):
H_concat = [C, D]
%[text] Vertical concatenation (stacked):
V_concat = [C; D]
%[text] **Connection to systems of ODEs.** Vertical concatenation is exactly how we *pack* the state-rate vector at the end of a rate function: `dxdt = [dx1dt; dx2dt]` stacks the individual scalar rates into a single column. The same syntax builds the initial state: `xx0 = [1; 0]`. See `lesson_system_of_odes.m`.
%%
%[text] ## Matrix as a Set of Column Vectors
%[text] A matrix can be viewed as several column vectors stacked side-by-side. This perspective is essential for interpreting the solution matrix returned by `ode45`, where each column is one state's time history.
%[text]{"align":"center"} $A = \\left\[\\begin{array}{cccc} \\mathbf{a}\_1 & \\mathbf{a}\_2 & \\cdots & \\mathbf{a}\_n \\end{array}\\right\], \\qquad \\mathbf{a}\_j = A(:,j)$
%[text] Pull out the columns of `A`:
col1 = A(:, 1)
col2 = A(:, end)
%[text] Reconstruct `A` by horizontal concatenation of its columns:
A_reconstructed = [col1, col2]
%[text] **Connection to systems of ODEs.** When `ode45` returns the solution matrix `xx`, each *row* corresponds to a time step and each *column* corresponds to one state variable. So if the state vector is $\\mathbf{x}(t) = \[\\,y(t);\\; \\dot{y}(t)\\,\]$, then `xx(:,1)` is the position time-series and `xx(:,2)` is the velocity time-series. Run `size(xx)` and you should see `[length(tt), 2]`.
%%
%[text] ## Transpose
%[text] The transpose of $A$ flips it across its main diagonal: rows become columns and vice versa. The transpose operator in MATLAB is the apostrophe `'`.
%[text]{"align":"center"} $(A^T)\_{ij} = A\_{ji}, \\qquad A \\in \\mathbb{R}^{m \\times n} \\;\\Longrightarrow\\; A^T \\in \\mathbb{R}^{n \\times m}$
%[text] Transpose of `H_concat`:
H_concat_transpose = H_concat'

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40}
%---
