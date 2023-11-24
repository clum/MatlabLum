function [varargout] = ReturnPathStringNLevelsUp(varargin)

%RETURNPATHSTRINGNLEVELSUP  Returns path string of directory n levels up
%
%   [PATH_STRING] = RETURNPATHSTRINGNLEVELSUP(N) Returns a string which
%   represents the directory which is N levels up from the current
%   working directory.  This assumes that the deliniators between paths use
%   '\' (Windows).  Note that N can be a vector of integers in which case
%   PATH_STRING will be a cell array of directories corresponding to each
%   element of N.
%
%   [...] = RETURNPATHSTRINGNLEVELSUP(N, DELINIATOR) Does as above but
%   allows the deliniator between paths to be specified.
%
%
%INPUT:     -N:             number of levels up to specify path
%           -DELINIATOR:    deliniator that OS uses to specify between directories
%
%OUTPUT:    -PATH_STRING:   string denoting the specified directory
%
%Christopher Lum
%lum@uw.edu

%Version History
%10/27/11: Created
%03/06/12: Updated documentation to reflect pwd
%11/23/23: Minor update to documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        N           = varargin{1};
        deliniator  = varargin{2};
        
    case 1
        %Assume deliniator is '\'
        N           = varargin{1};
        deliniator  = '\';
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% N

% deliniator
if(~ischar(deliniator))
    error('DELINIATOR must be a character')
end

if(~isscalar(deliniator))
    error('DELINIATOR must be a single char')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Get the current path    
currentPath                 = pwd;

%Make sure that the end of the string is terminated by a deliniator
if(currentPath(end)~=deliniator)
    currentPath = [currentPath deliniator];
end

%Find the location of all the deliniators
deliniatorIndices           = find(currentPath==deliniator);

for k=1:length(N)
    N_current = N(k);
    
    %Make sure that N_current is an integer and non-negative
    if(mod(N_current,1)~=0)
        error('All elements of N must be integers')
    end
    
    if(N_current < 0)
        error('All elements of N must be non-negative')
    end
    
    %
    NLevelsUpWithDeliniator     = currentPath(1:deliniatorIndices(end-N_current));
    
    %Remove the deliniator at the end
    NLevelsUp = NLevelsUpWithDeliniator(1:end-1);
    
    pathString{k,1} = NLevelsUp;
end

%If there is only 1 path desired, take it out of the cell array
if(length(N)==1)
    varargout{1} = pathString{1};
else
    varargout{1} = pathString;
end