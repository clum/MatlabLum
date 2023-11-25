function DrawArrow(x,y,z,x_comp,y_comp,z_comp,PARAMS)

%DRAWARROW  Draws an arrow on a plot
%
%   DRAWARROW(x,y,x_comp,y_comp) draws an arrow with base point (x,y) and
%   with components x_comp and y_comp in the x and y directions,
%   respectively.
%
%   DRAWARROW(x,y,x_comp,y_comp,PARAMS) draws an arrow with parameters
%   defined by vector PARAMS
%
%   DRAWARROW(x,y,z,x_comp,y_comp,z_comp) draws an arrow with base point
%   (x,y,z) and with components x_comp, y_comp, and z_comp in the x, y, and
%   z directions respectively.
%
%   DRAWARROW(x,y,z,x_comp,y_comp,z_comp,PARAMS) draws an arrow as
%   above and scales entire arrow by SCALE_FACTOR.
%
%INPUT:     -x:             x value of arrow base
%           -y:             y value of arrow base
%           -z:             z value of arrow base (optional)
%           -x_comp:        x component of arrow
%           -y_comp:        y component of arrow
%           -z_comp:        z component of arrow (optional)
%           -PARAMS:        Optional parameters defined as
%
%                           PARAMS(1,1) = scaling factor (stretch/shrink arrow)
%                           PARAMS(2,1) = red component of color (in [0,1])
%                           PARAMS(3,1) = green component of color (in [0,1])
%                           PARAMS(4,1) = blue component of color (in [0,1])
%                           PARAMS(5,1) = arrow head size (in [0,1])
%                           PARAMS(6,1) = LineWidth of arrow
%
%OUTPUT:    -None
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/09/04: Created
%05/13/04: Added scaling feature where entire arrow is scaled by alpha
%05/12/05: Updated documentation.  Changed from atan to atan2.  Added lines
%          121-128.  Added parameters for input
%01/13/06: Added more parameters to input
%07/29/08: Updated documentation
%09/26/08: Fixed automatic hold on/off state
%10/02/08: Fixed error checking
%11/25/23: Update to documentation

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 7
        %User supplies all inputs
        
    case 6
        %Assume standard parameters
        PARAMS = [1;
            0;
            0;
            1;
            0.1;
            1];
        
    case 5
        %Assume that 2D plot but user supplies PARAMS.  Rename stuff.
        PARAMS = y_comp;
        y_comp = x_comp;
        x_comp = z;
        z = 0;
        z_comp = 0;
        
        
    case 4
        %Assume 2D plot so we have to rename some of the input variables
        y_comp = x_comp;
        x_comp = z;
        z = 0;
        z_comp = 0;
        PARAMS = [1;
            0;
            0;
            1;
            0.1;
            1];
        
    otherwise
        error('Number of inputs is inconsistent')
        
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% x
if(~isscalar(x))
    error('x must be a scalar')
end

% y
if(~isscalar(y))
    error('y must be a scalar')
end

% z
if(~isscalar(z))
    error('z must be a scalar')
end

% x_comp
if(~isscalar(x_comp))
    error('x_comp must be a scalar')
end

% y_comp
if(~isscalar(y_comp))
    error('y_comp must be a scalar')
end

% z_comp
if(~isscalar(z_comp))
    error('z_comp must be a scalar')
end

% PARAMS
if((PARAMS(2) < 0) || (PARAMS(2) > 1))
    error('PARAMS(2) should be in [0,1]!')
end

if((PARAMS(3) < 0) || (PARAMS(3) > 1))
    error('PARAMS(3) should be in [0,1]!')
end

if((PARAMS(4) < 0) || (PARAMS(4) > 1))
    error('PARAMS(4) should be in [0,1]!')
end

if((PARAMS(5) < 0) || (PARAMS(5) > 1))
    error('PARAMS(5) should be in [0,1]!')
end

if(PARAMS(6) < 0)
    error('PARAMS(6) should be greater than 0!')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%If hold was not on figure, turn it on
was_hold = ishold;

if ~was_hold
    hold on
end

%Extract parameters
scale_factor = PARAMS(1);

%What is the angle of the arrow head from the axis of the arrow?
theta_head = 30*pi/180;

%What is the percentage of the arrow head w.r.t length of arrow?
head_percent = PARAMS(5);

%What is the angle that the arrow makes with the x axis in xy plane?
theta = atan2(y_comp,x_comp);

if x_comp<0
    theta = theta + pi;
end

%What is the angle that the arrow makes with the x axis in the yz plane?
alpha = atan2(z_comp,(sqrt(x_comp^2 + y_comp^2)));

%Scale all the components by scale_factor
x_comp = scale_factor*x_comp;
y_comp = scale_factor*y_comp;
z_comp = scale_factor*z_comp;

%Length of arrow head.
head_length = head_percent*sqrt(x_comp^2 + y_comp^2 + z_comp^2);

%What are the components of the end of the arrow head in the xy plane?
x_comp_head_1 = sin((pi/2) - theta_head - theta)*head_length;
y_comp_head_1 = cos((pi/2) - theta_head - theta)*head_length;

x_comp_head_2 = cos(theta - theta_head)*head_length;
y_comp_head_2 = sin(theta - theta_head)*head_length;

%If the x component is negative, we need to switch signs on arrow head
if x_comp<0
    x_comp_head_1 = -x_comp_head_1;
    y_comp_head_1 = -y_comp_head_1;
    
    x_comp_head_2 = -x_comp_head_2;
    y_comp_head_2 = -y_comp_head_2;
end

%If the arrow is angled up, we need to rotate the coordinates.
z_comp_head_1 = head_length*cos(theta_head)*sin(alpha);
z_comp_head_2 = z_comp_head_1;

z_head_1 = z + z_comp - z_comp_head_1;
z_head_2 = z + z_comp - z_comp_head_2;

x_head_1 = x + x_comp - x_comp_head_1 + (head_length*(1-cos(alpha))*cos(theta));
y_head_1 = y + y_comp - y_comp_head_1 + (head_length*(1-cos(alpha))*sin(theta));

x_head_2 = x + x_comp - x_comp_head_2 + (head_length*(1-cos(alpha))*cos(theta));
y_head_2 = y + y_comp - y_comp_head_2 + (head_length*(1-cos(alpha))*sin(theta));

%Plot the Arrow
plot3([x x+x_comp],[y y+y_comp],[z z+z_comp],...
    'color',[PARAMS(2) PARAMS(3) PARAMS(4)],'LineWidth',PARAMS(6))
plot3([x+x_comp x_head_1],[y+y_comp y_head_1],[z+z_comp z_head_1],...
    'color',[PARAMS(2) PARAMS(3) PARAMS(4)],'LineWidth',PARAMS(6))
plot3([x+x_comp x_head_2],[y+y_comp y_head_2],[z+z_comp z_head_2],...
    'color',[PARAMS(2) PARAMS(3) PARAMS(4)],'LineWidth',PARAMS(6))

%Return the hold state on the figure
if ~was_hold
    hold off
end