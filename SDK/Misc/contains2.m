function [varargout] = contains2(varargin)

%CONTAINS2 Similar to contains but with condensed results for cell array
%
%   [TFS] = CONTAINS2(STRARRAY,PAT) is similar to 'contains' but
%   condenses the results when the input is a STRARRAY.  The output is true
%   if any of the elements match and false otherwise.  In other words, this
%   does not return an array of true/false entries, it reduces the output
%   to a single true/false depending if any of the entries match or not.
%
%See also contains
%
%INPUT:     -STRARRAY:  cell array
%           -PAT:       pattern
%
%OUTPUT:    -TFS:       a single true or false (not an array)
%
%Christopher Lum
%lum@uw.edu

%Version History
%07/22/24: Created

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin        
    case 2
        %User supplies all inputs
        STRARRAY    = varargin{1};
        PAT         = varargin{2};
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
%STRARRAY
assert(isa(STRARRAY,'cell'));

%PAT

%-------------------------BEGIN CALCULATIONS-------------------------------
TF = contains(STRARRAY,PAT);

TFS = any(TF);

%Output the object
varargout{1} = TFS;

