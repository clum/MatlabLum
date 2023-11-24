function [varargout] = isinteger2(varargin)

%ISINTEGER2  Checks if the input value is an integer (ie not a decimal)
%
%   [Y] = ISINTEGER2(X) Checks if X is an integer (ie not a decimal).  Note
%   that this checks that it is a value like -3, 2, 323, etc.  This does
%   not check that the data type is of type integer (for this
%   functionality, see isinteger - built-in Matlab function).
%
%INPUT:     -X: value to check
%
%OUTPUT:    -Y: true if X is an integer (not a decimal), false otherwise
%
%Christopher Lum
%lum@uw.edu

%Version History
%10/06/13: Created
%11/28/16: Changed from outputting 1, 0 to true, false
%09/03/17: Updated documentation
%11/23/23: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        X = varargin{1};
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
%X

%-------------------------BEGIN CALCULATIONS-------------------------------
%Check that this has no decimal points
if(mod(X,1)==0)
    varargout{1} = true;
else
    varargout{1} = false;
end