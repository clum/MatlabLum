function [varargout] = ChangeWorkingDirectoryToThisLocation(varargin)

%CHANGEWORKINGDIRECTORYTOTHISLOCATION Changes the working directory
%
%   CHANGEWORKINGDIRECTORYTOTHISLOCATION() changes the working directory to
%   the location of where this function was called.
%
%
%INPUT:     -None
%
%OUTPUT:    -None
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/03/16: Created
%06/01/16: Fixed bug
%06/02/16: Handle esoteric case where the calling function is not in the
%          Matlab path
%11/23/23: Minor update

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 0
        %User supplies all inputs
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
%Determine where this function was called from
callStack = dbstack;
callingFunction = callStack(2).file;

callingFunctionPathAndName = which(callingFunction);

if(isempty(callingFunctionPathAndName))
    error('Could not find the calling function in the Matlab path.  This is a highly unusual case that may be due to the fact that the working directory was changed via a script.  Possible solution is to add the directory of the calling function to the Matlab path using ''addpath''')
end

deliniatorIndices = find(callingFunctionPathAndName=='\');

callingFunctionPath = callingFunctionPathAndName(1:deliniatorIndices(end)-1);

cd(callingFunctionPath);