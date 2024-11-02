function [XM, YM] = MakeMonotonicallyIncreasing(varargin)

%MAKEMONOTONICALLYINCREASING Attempts to make the vector monotonically increasing
%
%   [XM] = MAKEMONOTONICALLYINCREASING(X) removes indices in the vector X
%   so that XM is monotonically increasing.
%
%       s_m > s_n   for all m > n
%
%   [XM, YM] = MAKEMONOTONICALLYINCREASING(X, Y) does as above by removing
%   indices by examining the vector X to ensure that XM is monotonically
%   increasing.  This simultaneously removes corresponding indices from the
%   vector Y and returns YM.  This is useful when one would like to use the
%   interp1 function using X and Y where X is required to be monotonically
%   increasing.
%
%   See also IsMonotonicallyIncreasing, IsMonotonicallyDecreasing,
%   IsMonotonicallyNonDecreasing
%
%INPUT:     -X:         Vector to make monotonically increasing.
%           -Y:         depended vector with corresponding indices removed
%
%OUTPUT:    -XM:        Vector X that has indices removed to be
%                       monotonically increasing
%           -YM:        Vector Y that has the same indices as XM removed.
%
%Christopher Lum
%lum@uw.edu

%Version History
%07/26/15: Created
%11/02/24: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        X   = varargin{1};
        Y   = varargin{2};
        
    case 1
        %Assume we are only modifying X, create a dummy Y value
        X   = varargin{1};
        Y   = zeros(size(X));
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
%Make sure it is a real valued vector
if (~IsRealVector(X))
    error('X must be a real valued vector')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
XM = X(1);
YM = Y(1);

N = length(X);

%If X is only 1 element long, then it is monotonically increasing
if(N>1)  
end

%X is more than 1 element long, check that each successive element is
%greater than the previous
for n=2:N
    if ~(X(n)>XM(end))
        %Index n will break the monotonically increasing condition, so
        %do not include it
    else
        %Index n will not break the monotonically increasing condition,
        %so include it
        XM(end+1) = X(n);
        YM(end+1) = Y(n);
    end
end
