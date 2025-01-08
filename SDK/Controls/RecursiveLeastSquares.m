function [theta_hat,P,epsilon,K] = RecursiveLeastSquares(y,u,num,den,P_0,theta_hat_0)

%RECURSIVELEASTSQUARES Simulate a recursive least squares algorithm for
%estimating difference equation parameters.
%
%   RECURSIVELEASTSQUARES(y,u,num,den,P_0,theta_0) simulates the recursive
%   least squares algorithm for estimating parameters given initial guesses
%   of theta_hat and P.  This fits the difference equation given by
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
%   P_0 = P(k) and theta_hat_0 = theta_hat(k) where k is the first time
%   where the regressor vector is able to be completely filled.
%   Therefore, this assumes that P(1:k) = P_0 and theta_hat(1:k) =
%   theta_hat_0.
%
%   [theta_hat,P,epsilon,K] = RECURSIVELEASTSQUARES(...) returns the time
%   history of theta_hat = [a1 ... an b0 .. bm]', P, and epsilon = y(t) -
%   phi(t)*theta_hat(t-1).
%
%INPUT:     -y:             measured outputs
%           -u:             inputs to system
%           -num:           numerator coefficients to fit
%           -den:           denominator coefficients to fit
%           -P_0:           intial guess of P matrix
%           -theta_hat_0:   initial guess of parameters
%
%OUTPUT:    -theta_hat:     time history of parameter estimates
%           -P:             time history of P matrix
%           -epsilon:       time history of error term
%
%See also FITDIFFERENCEEQUATION (custom code)
%
%For more information, see Astrom and Wittenmark.  "Adaptive Control 2nd
%Edition".  Pg.51.
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/11/04: Created
%04/12/04: Changed algorithm to match Eq.2.15, Eq.2.16, and Eq.2.17 in
%          Adaptive Control 2nd Edition by Astrom and Wittenmark.
%01/07/25: Updated documentation.  Removed extraneous else statements

%Additional info:   See AA549: Estimation and System ID.  Homework 2 Problem 3 for
%                   more information.

%------------------CHECKING DATA FORMAT----------------------------
if (nargin~=6)
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
%need to add 1 to this number (Matlab starts indexing at 1, not 0).
k = k + 1;

%How many y and u regressors are there?
y_regressors = sum(den);
u_regressors = sum(num);

%Total number of parameters to fit
N = y_regressors + u_regressors;

%Initialize P and theta_hat matrices
for counter=1:k-1
    P(:,:,counter) = P_0;
    theta_hat(:,counter) = theta_hat_0;
end

%What is the size of the inversion required in the least squares algorithm
[~,d] = size(y);
%Simulate the recursive least squares
for t=k:length(y)
    %OBTAIN REGRESSOR VECTOR
    %First, assume that all coefficients are to be solve for.

    %First, do the denominator (y terms).
    for counter=1:length(den)
        phi_y(counter) = -y(t-counter);
    end

    %Now, do the numerator (u terms)
    for counter=1:length(num)
        phi_u(counter) = u(t-counter+1);
    end

    %Now, only use the regressors which are specified
    inner_counter = 1;
    for counter=1:length(den)
        if den(counter)==1
            phi(inner_counter,t) = phi_y(counter);

            inner_counter = inner_counter + 1;
        end
    end

    %Same with the u terms
    inner_counter = 1;
    for counter=1:length(num)
        if num(counter)==1
            phi(inner_counter+y_regressors,t) = phi_u(counter);

            inner_counter = inner_counter + 1;
        end
    end

    %Calculate next value of K (Eq.2.16)
    K(:,t) = P(:,:,t-1)*phi(:,t)*inv(eye(d) + phi(:,t)'*P(:,:,t-1)*phi(:,t));

    %Calculate next value of P (Eq.2.17)
    P(:,:,t) = (eye(N) - K(:,t)*phi(:,t)')*P(:,:,t-1);

    %Calculate the error
    epsilon(t) = y(t) - phi(:,t)'*theta_hat(:,t-1);

    %Calculate the next value of theta_hat (Eq.2.15)
    theta_hat(:,t) = theta_hat(:,t-1) + K(:,t)*epsilon(t);
end