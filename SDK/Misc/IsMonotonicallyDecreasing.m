function [YES_OR_NO, INDEX] = IsMonotonicallyDecreasing(X)

%ISMONOTONICALLYDECREASING Tests if the vector is monotonically decreasing
%
%   [YES_OR_NO] = ISMONOTONICALLYDECREASING(X) Tests if the vector X is
%   monotonically decreasing or not and returns the result in YES_OR_NO. To
%   be monotonically decreasing, the sequence must satisfy
%
%       s_m < s_n   for all m > n
%
%   [YES_OR_NO, INDEX] = ISMONOTONICALLYDECREASING(...) does as above but
%   if YES_OR_NO is false (the vector is not monotonically decreasing) this
%   also returns the INDEX of the first element in the vector that violates
%   the condition.
%
%   See also IsMonotonicallyIncreasing, IsMonotonicallyNonDecreasing,
%   MakeMonotonicallyIncreasing
%
%INPUT:     -X:         Vector to test for monotonically decreasing.
%
%OUTPUT:    -YES_OR_NO: true if X is monotonically decreasing, false
%                       otherwise
%           -INDEX:     index of the offending element in the vector (this
%                       is -1 if the vector is monotonically decreasing)
%
%Christopher Lum
%lum@uw.edu

%Version History
%08/23/12: Created
%07/26/15: Fixed documentation and added ability to return the offending
%          index
%09/03/17: Updated documentation
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

%If X is only 1 element long, then it is monotonically decreasing
if(N>1)    
    %X is more than 1 element long, check that each successive element is
    %less than the previous
    for n=2:N
        if ~(X(n)<X(n-1))
            YES_OR_NO = false;
            INDEX = n;
            return
        end
    end
end
    
%All elements check out.  X is monotonically decreasing
YES_OR_NO = true;
INDEX = -1;