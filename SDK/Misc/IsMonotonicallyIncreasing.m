function [YES_OR_NO, INDEX] = IsMonotonicallyIncreasing(X)

%ISMONOTONICALLYINCREASING Tests if the vector is monotonically increasing
%
%   [YES_OR_NO] = ISMONOTONICALLYINCREASING(X) Tests if the vector X is
%   monotonically increasing or not and returns the result in YES_OR_NO. To
%   be monotonically increasing, the sequence must satisfy
%
%       s_m > s_n   for all m > n
%
%   See also IsMonotonicallyDecreasing, IsMonotonicallyNonDecreasing,
%   MakeMonotonicallyIncreasing
%
%
%INPUT:     -X:         Vector to test for monotonically increasing.
%
%OUTPUT:    -YES_OR_NO: true if X is monotonically increasing, false
%            otherwise
%           -INDEX:     index of the offending element in the vector (this
%                       is -1 if the vector is monotonically increasing)
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/12/06: Created
%07/26/15: Added output of offending index
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
%Make sure it is a real valued vector
if (~IsRealVector(X))
    error('X must be a real valued vector')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
N = length(X);

%If X is only 1 element long, then it is monotonically increasing
if(N>1)    
    %X is more than 1 element long, check that each successive element is
    %greater than the previous
    for n=2:N
        if ~(X(n)>X(n-1))
            YES_OR_NO = false;
            INDEX = n;
            return
        end
    end
end

%All elements check out.  X is monotonically increasing
YES_OR_NO = true;
INDEX = -1;