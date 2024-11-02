function [YES_OR_NO] = IsRealVector(X)

%ISREALVECTOR  Tests to see if the input is a real valued vector.
%
%   [YES_OR_NO] = ISREALVECTOR(X) Tests if the vector X is a real valued
%   vector or not and returns the result in YES_OR_NO. 
%
%INPUT:     -X:         Vector to test for being a real valued vector.
%
%OUTPUT:    -YES_OR_NO: true if X is a real valued vector, false otherwise
%
%See also isvector
%
%Christopher Lum
%lum@uw.edu

%Version History
%10/12/06: Created 
%10/16/06: Made it so it handles cell arrays
%09/03/17: Updated to output true or false vs 1 or 0
%11/02/24: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
%Assume that X is a real valued vector then test to see if it is not.
YES_OR_NO = true;

[m_X,n_X] = size(X);

%Make sure it is a real vector
if (isa(X,'cell'))
    error('IsRealVector function not designed to handle cell arrays.  Perhaps try using isvector function')
else
    if (sum(imag(X))~=0)
        YES_OR_NO = false;
    end
end

%Make sure the minimum dimension is at least 1
if (min(n_X,m_X)<1)
    YES_OR_NO = false;
end

%Make sure it is a Nx1 or 1xN vector
if (m_X>1) && (n_X~=1)
    YES_OR_NO = false;
end

if (n_X>1) && (m_X~=1)
    YES_OR_NO = false;
end