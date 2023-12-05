function DrawBoat(X,Y,Z,PSI,SCALE,PARAMS)

%DRAWBOAT Draws a boat
%
%   DRAWBOAT(X,Y,Z,PSI) Draws a planar plot of a boat at the
%   postion (X,Y,Z) with heading angle PSI (measured positive clockwise with
%   0 pointing up).  
%
%   DRAWBOAT(X,Y,Z,PSI,SCALE) does as above but allows you to specify the
%   SCALE to scale the picture up or down
%
%   DRAWBOAT(X,Y,Z,PSI,SCALE, PARAMS) does as above but allows you to
%   specify some plotting PARAMS.
%
%       PARAMS.nose_color = 1x3 vector of color for the nose
%       PARAMS.body_color = 1x3 vector of color for the body
%       PARAMS.motor_color = 1x3 vector of color for the motor
%
%INPUT: -X:         X-coordinate
%       -Y:         Y-coordinate
%       -Z:         Z-coordinate
%       -PSI:       Heading angle (radians)
%       -SCALE:     Scaling factor
%       -PARAMS:    Structure for colors
%
%OUPUT: -None
%
%See also FILL, PATCH, DRAWCOORDINATESYSTEM, DRAWTANK
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/13/06: Created
%03/15/06: Updated documentation
%03/27/19: Updated documentation
%12/04/23: Minor update to documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 6
        %User supplies all inputs
        
    case 5
        %Assume standard parameters
        PARAMS.nose_color = [1 0 0];
        PARAMS.body_color = [1 0 0];
        PARAMS.motor_color = [0 0 0];
        
    case 4
        %Assume as above and SCALE = 1
        PARAMS.nose_color = [1 0 0];
        PARAMS.body_color = [1 0 0];
        PARAMS.motor_color = [0 0 0];
        
        SCALE = 1;

    otherwise
        error('Invalid number of inputs')
end

%-----------------------CHECKING DATA FORMAT-------------------------------
if (length(X)>1) || (length(Y)>1) || (length(PSI)>1) || (length(SCALE)>1)
    error('X, Y, PSI, and SCALE must all be scalar values')
end

%------------------------BEGIN CALCULATIONS--------------------------------
%Define the nose, body, and motor
nose_x = SCALE*[-1 0 1];
nose_y = SCALE*[ 1 2 1];
RotateAndFill([nose_x;nose_y],X,Y,Z,PSI,PARAMS.nose_color);

body_x = SCALE*[-1 -1 1  1];
body_y = SCALE*[-1  1 1 -1];
RotateAndFill([body_x;body_y],X,Y,Z,PSI,PARAMS.body_color);

motor_x = SCALE*[-0.25 -0.25  0.25  0.25];
motor_y = SCALE*[-1.25 -0.75 -0.75 -1.25];
RotateAndFill([motor_x;motor_y],X,Y,Z,PSI,PARAMS.motor_color);

%--------------------------------------------------------------------------
    function RotateAndFill(POINTS_BODY,X,Y,Z,PSI,COLOR)

        %Rotation from Fe to Fb (earth reference to body reference)
        C_be = [ cos(PSI) -sin(PSI);
                 sin(PSI) cos(PSI)];

        %Rotate from Fb to Fe.  Since rotation matrices are unitary,
        %inv(C_ij)=C_ij'
        C_eb = C_be';       %body to earth reference

        %Rotate then translate the points
        points_earth = C_eb*POINTS_BODY;
        points_earth = points_earth + [X*ones(size(points_earth(1,:)));
                                       Y*ones(size(points_earth(2,:)))];

        hold on
        fill3(points_earth(1,:),points_earth(2,:),Z*ones(size(points_earth(2,:))),COLOR)
        
        cow = 1;

    end     %ends RotateAndFill function
%--------------------------------------------------------------------------

end     %ends DrawBoat function
