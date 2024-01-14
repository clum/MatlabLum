function [varargout] = CalculateXYDimensionsFromWorldFile(varargin)

%CALCULATEXYDIMENSIONSFROMWORLDFILE  Calculates the dimensions of the image
%
%   [WIDTH, HEIGHT] = CALCULATEXYDIMENSIONSFROMWORLDFILE(FILE_AND_EXTENSION)
%   Calculates the WIDTH and HEIGHT of the image found in the file
%   FILE_AND_EXTENSION.  This does so by looking up data in the associated
%   world file (which has the same file name but appropriate file
%   extension).  This world file has six lines of text corresponding to
%
%       Line 1: A, pixel size in the x-direction in map units/pixel
%       Line 2: D, rotation about y-axis (must be zero for this function)
%       Line 3: B, rotation about x-axis (must be zero for this function)
%       Line 4: E, pixel size in the y-direction in map units, almost always negative
%       Line 5: C, x-coordinate of the center of the upper left pixel
%       Line 6: F, y-coordinate of the center of the upper left pixel
%
%   The image must be contained in the file FILE_AND_EXTENSION.  The
%   associated world file should also be in the path.  Valid extensions of
%   the world file depend on the file extension of the image file.  Valid
%   examples are
%
%       Image File      World File
%       ==========      ==========
%         .jpg            .jgw
%         .png            .pgw
%         .bmp            .bpw
%         .tif            .tfw
%
%   [WIDTH, HEIGHT, WORLD_FILE] = CALCULATEXYDIMENSIONSFROMWORLDFILE(...)
%   does as above but also returns the information in the WORLD_FILE as a
%   6x1 vector.
%
%   [WIDTH, HEIGHT, WORLD_FILE, IMAGE_FILE] = CALCULATEXYDIMENSIONSFROMWORLDFILE(...)
%   does as above but also returns the information in the IMAGE_FILE.
%
%   For more information, see Wikipedia entry on "world file"
%   (http://en.wikipedia.org/wiki/World_file)
%
%INPUT:     -FILE_AND_EXTENSION:    file name and extension of image file
%
%OUTPUT:    -WIDTH:                 width of image in map units
%           -HEIGHT:                heigh of image in map units
%           -WORLD_FILE:            6x1 vector of world file information
%           -IMAGE_FILE:            matrix representing the image
%
%See also CalculateXYRangeGivenOriginRowColNumbers, LoadAndCheckWorldFile
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/17/08: Created
%04/18/08: Updated documentation
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
%Get the file extension
[file_name, file_extension] = SeperateFileNameAndExtension(FILE_AND_EXTENSION);

switch file_extension
    case 'jpg'
        world_file_extension = 'jgw';
        
    case 'png'
        world_file_extension = 'pgw';
        
    case 'bmp'
        world_file_extension = 'bpw';
        
    case 'tif'
        world_file_extension = 'tfw';
        
    otherwise
        error(['Files of type ',file_extension,' are not supported'])
        
end

%Load the world file
world_file_string   = [file_name,'.',world_file_extension];
WORLD_FILE          = LoadAndCheckWorldFile(world_file_string);

A = WORLD_FILE(1);     %pixel length in x direction
E = WORLD_FILE(4);     %negative pixel length in y direction

%Load the actual image file
IMAGE_FILE = LoadImageFile(FILE_AND_EXTENSION);
[m,n,z] = size(IMAGE_FILE);

%Calculate the width and height
WIDTH   = A*n;
HEIGHT  = abs(E)*m;

%Output the objects
varargout{1} = WIDTH;
varargout{2} = HEIGHT;
varargout{3} = WORLD_FILE;
varargout{4} = IMAGE_FILE;