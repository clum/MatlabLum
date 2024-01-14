function [varargout] = LoadAndCheckWorldFile(varargin)

%LOADANDCHECKWORLDFILE  Loads a world file and checks for consistency
%
%   [WORLD_FILE_INFO] = LOADANDCHECKWORLDFILE(FILE_AND_EXTENSION)
%   returns the information contained in the world file specified by
%   FILE_AND_EXTENSION.  The world file should have 6 lines of text
%
%       Line 1: A, pixel size in the x-direction in map units/pixel
%       Line 2: D, rotation about y-axis (must be zero for this function)
%       Line 3: B, rotation about x-axis (must be zero for this function)
%       Line 4: E, pixel size in the y-direction in map units, almost always negative
%       Line 5: C, x-coordinate of the center of the upper left pixel
%       Line 6: F, y-coordinate of the center of the upper left pixel
%
%   For more information, see Wikipedia entry on "world file"
%   (http://en.wikipedia.org/wiki/World_file)
%
%INPUT:     -FILE_AND_EXTENSION:    file name and extension of world file
%
%OUTPUT:    -WORLD_FILE_INFO:       6x1 vector of world file information
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/17/08: Created
%05/02/08: Updated documentation
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

%-------------------------BEGIN CALCULATIONS-------------------------------
%Get the file name and extension
[file_name, file_extension] = SeperateFileNameAndExtension(FILE_AND_EXTENSION);

%Load the world file
eval(['load ',FILE_AND_EXTENSION]);
eval(['WORLD_FILE_INFO = ',file_name,';'])

if(length(WORLD_FILE_INFO)~=6)
    error([FILE_AND_EXTENSION,' does not have 6 elements'])
    
else
    A = WORLD_FILE_INFO(1);
    D = WORLD_FILE_INFO(2);
    B = WORLD_FILE_INFO(3);
    E = WORLD_FILE_INFO(4);
    C = WORLD_FILE_INFO(5);
    F = WORLD_FILE_INFO(6);
    
end

%Verify that rotations are zero
if((D~=0) || (B~=0))
    error('Lines 2 and 3 are non-zero, this may cause problems in other functions')
end

%Verify that A is positive
if(A <= 0)
    error('Pixel length in x direction should be positive.')
end

%Verify that E is negative
if(E>=0)
    error('Line 4 should be negative')
end

%Output the objects
varargout{1} = WORLD_FILE_INFO;