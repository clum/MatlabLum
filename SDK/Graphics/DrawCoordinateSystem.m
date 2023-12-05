function DrawCoordinateSystem(varargin)

%DRAWCOORDINATESYSTEM Draws a coordinate system
%
%   DRAWCOORDINATESYSTEM(PSI,THETA,PHI,PARAMS) Draws a 3 dimensional plot of
%   the coordinate system given the angles PSI, THETA, and PHI.  These
%   angles are the rotations and are performed in the order
%
%       1.  PSI = Right-handed rotation about z-axis
%       2.  THETA = Right-handed rotation about new y-axis
%       3.  PHI = Right-handed rotation about the new x-axis
%
%   DRAWCOORDINATESYSTEM(PSI,THETA,PHI,PARAMS) does as above but allows
%   parameters to be set.
%
%   PARAMS is a structure defined as
%
%       PARAMS.x_axis_color = 1x3 vector of x axis color
%       PARAMS.y_axis_color = 1x3 vector of y axis color
%       PARAMS.z_axis_color = 1x3 vector of z axis color
%       PARAMS.offset = 3x1 vector of origin of system in Fe
%       PARAMS.axis_length = 1x1 scalar of axis_length
%       PARAMS.line_width = 1x1 scalar of line width
%
%   DRAWCOORDINATESYSTEM(PSI,THETA,PHI,PARAMS,DRAWARROWHEAD) does as above
%   but draws the axis using arrows instead of lines if DRAWARROWHEAD is 1.
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/27/04: Created
%09/13/05: Changed from DrawPlane (used in AA518 hw5_p3 and hw5_p4) to more
%          general DrawCoordinateSystem
%03/13/12: Updated documentation, added arrow head
%10/12/13: Fixed bug and added default option
%21/04/23: Minor update to documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 5
        %User supplies all inputs
        PSI                     = varargin{1};
        THETA                   = varargin{2};
        PHI                     = varargin{3};
        PARAMS                  = varargin{4};
        DRAWARROWHEAD           = varargin{5};

    case 4
        %Assume no arrow heads
        PSI                     = varargin{1};
        THETA                   = varargin{2};
        PHI                     = varargin{3};
        PARAMS                  = varargin{4};
        DRAWARROWHEAD           = 0;

    case 3
        %Assume standard parameters and everything above
        PSI                     = varargin{1};
        THETA                   = varargin{2};
        PHI                     = varargin{3};

        PARAMS.x_axis_color     = [1 0 0];
        PARAMS.y_axis_color     = [0 1 0];
        PARAMS.z_axis_color     = [0 0 1];
        PARAMS.offset           = [0;0;0];
        PARAMS.axis_length      = 1;
        PARAMS.line_width       = 1;
        DRAWARROWHEAD           = 0;

    case 1
        %Assume a non-rotate coordinate frame with user specified
        %parameters
        PSI                     = 0;
        THETA                   = 0;
        PHI                     = 0;
        PARAMS                  = varargin{1};
        DRAWARROWHEAD           = 0;

    case 0
        %Assume a non-rotated coordinate frame
        PSI                     = 0;
        THETA                   = 0;
        PHI                     = 0;
        PARAMS.x_axis_color     = [1 0 0];
        PARAMS.y_axis_color     = [0 1 0];
        PARAMS.z_axis_color     = [0 0 1];
        PARAMS.offset           = [0;0;0];
        PARAMS.axis_length      = 1;
        PARAMS.line_width       = 1;
        DRAWARROWHEAD           = 0;

    otherwise
        error('Inconsistent number of inputs')
end

%----------------CHECKING DATA FORMAT------------------------
if (length(PSI)>1) || (length(THETA)>1) || (length(PHI)>1)
    error('PSI, THETA, and PHI must all be scalar values')
end

%------------------BEGIN CALCULATIONS-------------------------
%Unpack data
x_axis_color = PARAMS.x_axis_color;
y_axis_color = PARAMS.y_axis_color;
z_axis_color = PARAMS.z_axis_color;
x_offset = PARAMS.offset(1);
y_offset = PARAMS.offset(2);
z_offset = PARAMS.offset(3);
axis_length = PARAMS.axis_length;
line_width = PARAMS.line_width;

%Define the xb, yb, and zb
xb = axis_length*[1;0;0];
yb = axis_length*[0;1;0];
zb = axis_length*[0;0;1];

%Rotation from Fe to F1 (earth reference to frame 1 reference)
C_1e = [ cos(PSI) sin(PSI) 0;
    -sin(PSI) cos(PSI) 0;
    0        0        1];

%Rotation from F1 to F2 (frame 1 reference to frame 2 reference)
C_21 = [cos(THETA) 0 -sin(THETA);
    0          1  0;
    sin(THETA) 0  cos(THETA)];

%Rotation from F2 to Fb (frame 2 reference to body reference)
C_b2 = [1  0        0;
    0  cos(PHI) sin(PHI);
    0 -sin(PHI) cos(PHI)];

%Rotate from Fb to Fe.  Since rotation matrices are unitary,
%inv(C_ij)=C_ij'
C_eb = C_1e'*C_21'*C_b2';   %body to earth reference

xe = C_eb*xb;
ye = C_eb*yb;
ze = C_eb*zb;

%----------------------PLOT COORDINATE SYSTEM-----------------------------
if(DRAWARROWHEAD)
    %Use arrows to draw coordinate system

    %Plot the x_b axis
    xAxisParams(1,1) = 1;
    xAxisParams(2,1) = x_axis_color(1);
    xAxisParams(3,1) = x_axis_color(2);
    xAxisParams(4,1) = x_axis_color(3);
    xAxisParams(5,1) = 0.2;
    xAxisParams(6,1) = line_width;
    DrawArrow(x_offset, y_offset, z_offset, xe(1), xe(2), xe(3), xAxisParams);

    %Plot the y_b axis
    yAxisParams(1,1) = 1;
    yAxisParams(2,1) = y_axis_color(1);
    yAxisParams(3,1) = y_axis_color(2);
    yAxisParams(4,1) = y_axis_color(3);
    yAxisParams(5,1) = 0.2;
    yAxisParams(6,1) = line_width;
    DrawArrow(x_offset, y_offset, z_offset, ye(1), ye(2), ye(3), yAxisParams);

    %Plot the z_b axis
    zAxisParams(1,1) = 1;
    zAxisParams(2,1) = z_axis_color(1);
    zAxisParams(3,1) = z_axis_color(2);
    zAxisParams(4,1) = z_axis_color(3);
    zAxisParams(5,1) = 0.2;
    zAxisParams(6,1) = line_width;
    DrawArrow(x_offset, y_offset, z_offset, ze(1), ze(2), ze(3), zAxisParams);

else
    %Just use lines to draw coordinate system

    %Plot the x_b axis
    plot3([x_offset xe(1)+x_offset],[y_offset xe(2)+y_offset],[z_offset xe(3)+z_offset],...
        'Color',x_axis_color,'LineWidth',line_width)
    hold on

    %Plot the y_b axis
    plot3([x_offset ye(1)+x_offset],[y_offset ye(2)+y_offset],[z_offset ye(3)+z_offset],...
        'Color',y_axis_color,'LineWidth',line_width)

    %Plot the z_b axis
    plot3([x_offset ze(1)+x_offset],[y_offset ze(2)+y_offset],[z_offset ze(3)+z_offset],...
        'Color',z_axis_color,'LineWidth',line_width)
end
