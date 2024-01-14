function [varargout] = LoadImageFile(varargin)

%LOADIMAGEFILE  Loads an image file
%
%   [A] = LOADIMAGEFILE(FILE_AND_EXTENSION) loads the information in the
%   image specified by the FILE_AND_EXTENSION string.
%
%
%INPUT:     -FILE_AND_EXTENSION:    file name and extension of image file
%
%OUTPUT:    -A:                     matrix representing the image
%
%See also imread, image, image2
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/17/08: Created
%01/14/24: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        FILE_AND_EXTENSION = varargin{1};
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
%Error checking done by SeperateFileNameAndExtension.m

%-------------------------BEGIN CALCULATIONS-------------------------------
%Get the file name and extension
[file_name, file_extension] = SeperateFileNameAndExtension(FILE_AND_EXTENSION);

%Load the image file
eval(['A = imread(''',file_name,''',''',file_extension,''');'])

%Output the objects
varargout{1} = A;