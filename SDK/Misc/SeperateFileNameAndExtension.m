function [varargout] = SeperateFileNameAndExtension(varargin)

%SEPERATEFILENAMEANDEXTENSION   Seperates the file name and extension
%
%   [FILE_NAME, FILE_EXTENSION] =
%   SEPERATEFILENAMEANDEXTENSION(FILE_AND_EXTENSION) seperates the input
%   string (which has both the file name and extension) into just the file
%   name (without extension) and the file extension.
%
%
%INPUT:     -FILE_AND_EXTENSION:    string of filename and file extension
%
%OUTPUT:    -FILE_NAME:             string denoting just the filename
%           -FILE_EXTENSION:        string denoting just the extension
%
%Christopher Lum
%lum@uw.edu

%Version History:
%04/17/08: Created
%05/02/08: Added possibility that FILE_AND_EXTENSION has a relative path
%11/23/23: Minor update

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        FILE_AND_EXTENSION = varargin{1};

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
if (~isstr(FILE_AND_EXTENSION))
    error('FILE_AND_EXTENSION should be a string')
end

if(length(find(FILE_AND_EXTENSION=='.'))==0)
    error('FILE_AND_EXTENSION should contain both the file name and the extension')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Find the .
period_indices = find(FILE_AND_EXTENSION=='.');
period_index = period_indices(end);

%Seperate
FILE_NAME       = FILE_AND_EXTENSION(1:period_index-1);
FILE_EXTENSION  = FILE_AND_EXTENSION(period_index+1:end);

%Output the object
varargout{1} = FILE_NAME;
varargout{2} = FILE_EXTENSION;
