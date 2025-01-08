function [Ainv_reduced,Binv_reduced,T] = CalculateReducedOrderInverse(A,B,C,r,T_bottom)

%CALCULATEREDUCEDORDERINVERSE calculate the reduced order inverse of a
%system.
%
%   CALCULATEREDUCEDORDERINVERSE(A,B,C,r) calculates the reduced order
%   inverse by transforming the full order dynamics states so that the 1st
%   r state are yd, yd^(1),...,yd^(r-1) and leaves the last r+1 to n states
%   unchanged as the internal dynamics.
%
%   CALCULATEREDUCEDORDERINVERSE(A,B,C,r,T_bottom) calculates the reduced
%   order inverse as above but allows user to specify how to transform the
%   last r+1 to n statse.
%
%   [Ainv_reduced,Binv_reduced,T] = CALCULATEREDUCEDORDERINVERSE(...)
%   returns the A and B matrices for the reduced order inverse system where
%   the inputs are u = [yd,yd^(1),...,yd^(r)].  Note that if the last r+1
%   to n states are not transformed, then only the first column of the
%   Binv_reduced matrix will be non-zero, therefore, the inputs to the
%   reduced order inverse are actually only yd.
%
%INPUT:     -A:             A matrix of original system
%           -B:             B matrix of original system
%           -C:             C matrix of original system
%           -r:             Relative degree of system
%           -T_bottom:      Bottom portion of T matrix
%
%OUTPUT:    -Ainv_reduced:  A matrix of reduced order inverse system
%           -Binv_reduced:  B matrix of reduced order inverse system
%           -T:             Transformation matrix used
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/11/04: Created
%01/07/25: Updated documentation

%------------------CHECKING DATA FORMAT----------------------------
%How many states are there?
[num_states,num_inputs] = size(B);
[num_outputs,num_states] = size(C);

%Make sure this is a SISO system
if (num_inputs~=1) | (num_outputs~=1)
    error('System must be SISO')
end

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 4
        %Assume they do not want to transform the last r+1 to n states
        T_bottom = [zeros(num_states-r,r) eye(num_states-r)];

    otherwise
end

%-----------------------BEGIN CALCULATIONS---------------------------
%Construct the top of the transformation matrix
for counter=1:r
    T_top(counter,:) = C*A^(counter-1);
end

%Construct total T matrix
T = [T_top;
    T_bottom];

%Check the rank of this matrix
if rank(T)~=num_states
    error('Transformation matrix is not invertible.')
end

%Find Tinv
Tinv = inv(T);

%Get TinvL and TinvR
TinvL = Tinv(:,1:r);
TinvR = Tinv(:,r+1:num_states);

%Calculate the reduced inverse system.
Ainv_reduced = T_bottom*A*TinvR - T_bottom*B*C*A^r*TinvR*(1/(C*A^(r-1)*B));

Binv_reduced_L = T_bottom*A*TinvL - T_bottom*B*C*A^r*TinvL*(1/(C*A^(r-1)*B));
Binv_reduced_R = T_bottom*B*(1/(C*A^(r-1)*B));

Binv_reduced = [Binv_reduced_L Binv_reduced_R];