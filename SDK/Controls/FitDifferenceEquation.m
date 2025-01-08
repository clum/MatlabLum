function [A_constants,B_constants,phee,Y] = FitDifferenceEquation(y,u,num,den)

%FITDIFFERENCEEQUATION Calculate the best fit coefficients for a transfer
%function.
%
%   FITDIFFERENCEEQUATION(y,u,num,den) Fits a difference equation/transfer
%   function with a given output, y, with the input, u, to the difference
%   equation.
%
%       y(k) = -a1*y(k-1) - a2*y(k-2) - ... - an*y(k-n) + b0*u(k) + b1*u(k-1) +
%       ... + bm*u(k-m)
%
%   which is equivalent to the transfer function
%
%       Y(z)   b0 + b1*z^-1 + b2*z^-2 + ... + bm*z^-m
%       ---- = --------------------------------------------
%       U(z)    1 + a1*z^-1 + a2*z^-2 + ... + an*z^-n
%
%   num and den are arrays containing the coefficients to solve for.  For
%   example.
%
%       num = [1 1 1 1]   (solve for b0, b1, b2, and b3)
%       num = [1 0 1 1]   (solve for b0, b2, and b3)
%
%       den = [1 1 1 1]   (solve for a1, a2, a3, and a4)
%       den = [1 0 0 1]   (solve for a1 and a4)
%       den = [0 1 0 0]   (change this to den = [0 1] to solve for a2)
%
%   Note that the first element of the num array is for b0 and the first
%   element for the den array is for a1.
%
%   This is useful when there is a priori knowledge that certain
%   coefficient are zero.  Note that one should not specify num or den with
%   zeros in the last position, instead, simply  shorten the array as shown
%   above.
%
%   [A_constant,B_constants,phee,Y,P] = FITDIFFERENCEEQUATION(...) returns
%   the coefficients a1 to an and b0 to bm.  This also returns the matrix
%   phee (filled with regressors) and the vector Y.
%
%INPUT:     -y:             output of system
%           -u:             input to system
%           -num:           numerator coefficients to fit
%           -den:           denominator coefficients to fit
%
%OUTPUT:    -a_constants:   denominator coefficients
%           -b_constants:   numerator coefficients
%
%See also RECURSIVELEASTSQUARES
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/18/04: Created
%05/12/04: Updated documentation.  Also added feature where you can specify
%          which numerator coefficients to solve for if you have a priori
%          knowledge that some other coefficients are zero.
%05/19/04: Changed name to fit standard better
%04/10/04:  Major changes.  Almost warrants a new function.  Complete
%           overhaul of nomenclature to match least squares algorithm as
%           presented in AA549.
%01/07/25: Updated documentation

%Additional info:   See AA581: Digital Control.  Homework 3 Problem 4 for
%                   more information.
%                   See AA581:  Digital Control.  Final Exam Problem 1 for
%                   information regarding modification.
%                   See AA549:  Estimation and System ID.  Homework 2
%                   Problem 1 and 3 for more information regarding the
%                   current version.

%------------------CHECKING DATA FORMAT----------------------------
if (nargin~=4)
    error('Number of input arguments is inconsistent')
end

%Check to make sure that the t and y arrays are in column form
[y_rows y_columns] = size(y);
[u_rows u_columns] = size(u);

if  (y_columns>1 & y_rows>1) | (u_columns>1 & u_rows>1)
    error('y and u arrays must be single column or row vectors (SISO System only)!')
end

if y_columns>1
    y = y';
end

if u_columns>1
    u = u';
end

%Check to make sure the y and u arrays are coincident
if length(y)~=length(u)
    error('y and u arrays are not the same length!')
end

%Make sure that num and den are all 0 or 1
if length(find(num~=1 & num~=0))~=0
    error('num must only have 0 or 1 as entries')
end

if length(find(den~=1 & den~=0))~=0
    error('num must only have 0 or 1 as entries')
end

%Make sure that num and den do now have zeros in the last entries
if (num(end)==0) | (den(end)==0)
    error('num and den must not have 0 as the last entries')
end

%---------------------OBTAIN USER PREFERENCES-----------------------------
%None at this point

%-----------------------BEGIN CALCULATIONS---------------------------
%How many data points are there?
N = length(y);

%What is the order of the numerator and denominator
m = length(num);                    %Number of numerator constants to fit
n = length(den);                    %Number of denominator constants to fit

%Depending on the order of n and m, we can only use data at y(k) and above
%since the regressor vector must be filled for all time less than k.  (it
%m-1 for numerator since b0 doesn't have a delay).
k = max([n m-1]);

%Since we don't have y(0) and we assume that the first input is y(1), we
%need to add 1 to this number (Matlab starts indexing at 1, not 0.
k = k + 1;

%Build the phee matrix assuming that user wants to solve for all possible
%coefficients.
for current_row = 1:(N-k+1)
    %Build the current row of phee matrix

    %regressors for the output.
    for current_col = 1:n
        y_index = k - 1 + current_row - current_col;
        phee(current_row,current_col) = -y(y_index);
    end

    %regressors for the input
    for current_col=1:m
        u_index = k + current_row - current_col;
        phee(current_row,n+current_col) = u(u_index);
    end
end

%Now, modify the phee matrix to only include regressors that are specified.
phee_y = phee(:,1:n);                   %phee matrix associated with y regressors
phee_u = phee(:,n+1:n+m);               %phee matrix associated with u regressors

clear phee

%Check which denominators were specified
inner_counter = 1;
for current_col = 1:n
    if den(current_col)==1
        phee(:,inner_counter)=phee_y(:,current_col);

        inner_counter = inner_counter + 1;
    end
end

[not_used,columns_for_y] = size(phee);

%Check which numerators were specified
inner_counter = 1;
for current_col = 1:m
    if num(current_col)==1
        phee(:,columns_for_y+inner_counter) = phee_u(:,current_col);

        inner_counter = inner_counter + 1;
    end
end

%What is the Y vector?
Y = y(k:end);

%Use least squares algorithm to solve for theta vector w/ minimum error
P_inv = phee'*phee;

%Can we solve for P?
if rank(P_inv)~=length(P_inv)
    error('P_inv is not invertible, excitation condition not met')
end

%Solve for theta vector
P = inv(P_inv);
theta = P*phee'*Y;

%Seperate this vector into A constants and B constants
%How many a and b constants are there?
a = sum(den);
b = sum(num);

A_constants = theta(1:a);
B_constants = theta(a+1:end);