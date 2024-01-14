function [varargout] = CalculateXYRangeGivenOriginRowColNumbers(varargin)

%CALCULATEXYRANGEGIVENORIGINROWCOLNUMBERS Calculates the xy range of the image
%
%   [X_RANGE, Y_RANGE] =
%   CALCULATEXYRANGEGIVENORIGINROWCOLNUMBERS(FILE_AND_EXTENSION, ROW_NUM, COL_NUM)
%   Calculates X_RANGE and Y_RANGE of the image stored in
%   FILE_AND_EXTENSION given that the desired origin of the coordinate
%   system is centered at the pixel specified by ROW_NUM, COL_NUM.  The
%   returned X_RANGE and Y_RANGE can be used by image2 to plot the image.
%
%   This does so by looking up data in the associated
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
%   For more information, see Wikipedia entry on "world file"
%   (http://en.wikipedia.org/wiki/World_file)
%
%INPUT:     -FILE_AND_EXTENSION:    file name and extension of image file
%           -ROW_NUM:               row number of pixel where origin of
%                                   coordinate system is (row_num = 1
%                                   corresponds to origin at top of image)
%           -COL_NUM:               column number of pixel where origin of
%                                   coordinate system is (col_num = 1
%                                   corresponds to origin at right of
%                                   image)
%
%OUTPUT:    -X_RANGE:               2 element vector of [x_min x_max]
%           -Y_RANGE:               2 element vector of [y_min y_max]
%
%See also image2, image, CalculateXYDimensionsFromWorldFile,
%         LoadAndCheckWorldFile
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/17/08: Created
%04/18/08: Fixed bug
%01/14/24: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 3
        %User supplies all inputs
        FILE_AND_EXTENSION  = varargin{1};
        ROW_NUM             = varargin{2};
        COL_NUM             = varargin{3};
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
%Calculate the width and height and get the world file info
[image_width, image_height, world_file, image_file] = CalculateXYDimensionsFromWorldFile(FILE_AND_EXTENSION);
[num_rows, num_cols, Z] = size(image_file);

% ROW_NUM
if((ROW_NUM < 1) || (ROW_NUM > num_rows))
    error('ROW_NUM exceeds matrix dimensions')
end

% COL_NUM
if((COL_NUM < 1) || (COL_NUM > num_cols))
    error('COL_NUM exceeds matrix dimensions')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Get the dimensions of the pixels
lx = world_file(1);
ly = abs(world_file(4));

y_max = ly*(ROW_NUM-1) + ly/2;
x_min = -(lx*(COL_NUM-1) + lx/2);

y_min = y_max - image_height;
x_max = x_min + image_width;

X_RANGE = [x_min x_max];
Y_RANGE = [y_min y_max];

%Output the objects
varargout{1} = X_RANGE;
varargout{2} = Y_RANGE;