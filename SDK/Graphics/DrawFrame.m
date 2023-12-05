function DrawFrame(varargin)

%DRAWFRAME Draws a reference frame
%
%   DRAWFRAME(EULER) draws a set of three axis which are rotated from the
%   local frame (typically the north, east, down frame for aircraft)
%   through the EULER angles, phi, theta, and psi.
%
%   The transformation from Fe to Fb is given by
%
%       V_b = C_b2(phi)*C_21(theta)*C_1e(psi)*V_e
%
%   where   V_b = vector expressed in Fb
%           V_e = vector expressed in Fe
%           C_1e(psi) = rotation over common z-axis through psi
%           C_21(theta) = rotation over common y-axis through theta
%           C_b2(phi) = rotation over common x-axis through phi
%
%   DRAWFRAME(EULER,FB_WRT_FE) draws the reference frame as above but with
%   origin located at FB_WRT_FE.
%
%   DRAWFRAME(EULER,FR_WRT_FE,PARAMS) draws the reference frame as above
%   with certain parameters
%
%       PARAMS.x_axis_color = 1x3 vector of RGB color of Fb x-axis
%       PARAMS.y_axis_color = 1x3 vector of RGB color of Fb y-axis
%       PARAMS.z_axis_color = 1x3 vector of RGB color of Fb z-axis
%       PARAMS.scale_factor = 1x1 scalar to scale x,y, and z axis
%       PARAMS.line_width   = 1x1 scalar denoting line width
%       PARAMS.plot_type = 1x1 scalar denoting what to draw.
%                                   1 = draw 3-axis frame
%                                   2 = draw simple aircraft
%
%INPUT:     -EULER:     3x1 vector of euler angles [phi;theta;psi]
%           -FB_WRT_FE: 3x1 vector expressed in Fe describing origin of Fb
%                       w.r.t Fe
%           -PARAMS:    Structure of plotting parameters
%
%OUTPUT:    -None
%
%For more information, see Stevens, B.L., and Lewis, F.L. "Aircraft Control
%and Simulation. 2nd Edition".  pg.26
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/26/05: Created
%05/28/05: Added possiblility to draw a plane instead of just a 3 axis
%          frame.
%06/20/07: Updated documentation and changed inputs to varargin
%12/04/23: Minor update to documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 3
        %User specifies all inputs
        EULER       = varargin{1};
        FB_WRT_FE   = varargin{2};
        PARAMS      = varargin{3};

    case 2
        EULER       = varargin{1};
        FB_WRT_FE   = varargin{2};

        %Assume standard parameters
        PARAMS.x_axis_color = [1 0 0];
        PARAMS.y_axis_color = [0 1 0];
        PARAMS.z_axis_color = [0 0 1];
        PARAMS.scale_factor = 1;
        PARAMS.line_width = 2;
        PARAMS.plot_type = 1;

    case 1
        EULER       = varargin{1};

        %Assume that Fe and Fb have same origin and everything above
        FB_WRT_FE = zeros(3,1);

        PARAMS.x_axis_color = [1 0 0];
        PARAMS.y_axis_color = [0 1 0];
        PARAMS.z_axis_color = [0 0 1];
        PARAMS.scale_factor = 1;
        PARAMS.line_width = 2;
        PARAMS.plot_type = 1;

    otherwise
        error('Inconsistent number of inputs')
end

%-----------------------CHECKING DATA FORMAT-------------------------------
[ne,me] = size(EULER);
if (ne~=3)||(me~=1)
    error('EULER must be a 3x1 vector')
end

[nf,mf] = size(FB_WRT_FE);
if (nf~=3)||(mf~=1)
    error('FB_WRT_FE must be a 3x1 vector')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Extract Euler angles
phi = EULER(1,1);
theta = EULER(2,1);
psi = EULER(3,1);

%Formulate transformation from earth to body
C_1e = [cos(psi) sin(psi) 0;
    -sin(psi) cos(psi) 0;
    0 0 1];

C_21 = [cos(theta) 0 -sin(theta);
    0 1 0;
    sin(theta) 0 cos(theta)];

C_b2 = [1 0 0;
    0 cos(phi) sin(phi);
    0 -sin(phi) cos(phi)];

C_be = C_b2*C_21*C_1e;

%Since transformation is unitary, the inverse is simply the transpose
C_eb = C_be';

if PARAMS.plot_type==1
    %Draw a simple 3-axis frame
    %Define x, y, and z axis in the body frame
    scale_factor = PARAMS.scale_factor;
    xb = [1;0;0]*scale_factor;
    yb = [0;1;0]*scale_factor;
    zb = [0;0;1]*scale_factor;

    %Now transform xb, yb, and zb to the earth axis
    xe = C_eb*xb;
    ye = C_eb*yb;
    ze = C_eb*zb;

    %These describe the end of the vector assuming that the origin is at
    %zero.  When plotting, add the translation

    %Plot the x-axis
    hold on
    plot3([0+FB_WRT_FE(1) xe(1)+FB_WRT_FE(1)],...
        [0+FB_WRT_FE(2) xe(2)+FB_WRT_FE(2)],...
        [0+FB_WRT_FE(3) xe(3)+FB_WRT_FE(3)],'color',PARAMS.x_axis_color,'LineWidth',PARAMS.line_width)
    hold on

    %Plot the y-axis
    plot3([0+FB_WRT_FE(1) ye(1)+FB_WRT_FE(1)],...
        [0+FB_WRT_FE(2) ye(2)+FB_WRT_FE(2)],...
        [0+FB_WRT_FE(3) ye(3)+FB_WRT_FE(3)],'color',PARAMS.y_axis_color,'LineWidth',PARAMS.line_width)

    %Plot the z-axis
    plot3([0+FB_WRT_FE(1) ze(1)+FB_WRT_FE(1)],...
        [0+FB_WRT_FE(2) ze(2)+FB_WRT_FE(2)],...
        [0+FB_WRT_FE(3) ze(3)+FB_WRT_FE(3)],'color',PARAMS.z_axis_color,'LineWidth',PARAMS.line_width)
    hold off
end

if PARAMS.plot_type==2
    %Draw a simple aircraft figure
    %Define fuselage, wings, and vertical in body frame
    scale_factor = PARAMS.scale_factor;
    fuselage_b = [1;0;0]*scale_factor;
    right_wing_b = [0;1;0]*scale_factor;
    left_wing_b = [0;-1;0]*scale_factor;
    vertical_b = [0;0;-0.5]*scale_factor;

    %Now transform xb, yb, and zb to the earth axis
    fuselage_e = C_eb*fuselage_b;
    right_wing_e = C_eb*right_wing_b;
    left_wing_e = C_eb*left_wing_b;
    vertical_e = C_eb*vertical_b;

    %These describe the end of the vector assuming that the origin is at
    %zero.  When plotting, add the translation

    %Plot the fuselage
    hold on
    plot3([0+FB_WRT_FE(1) fuselage_e(1)+FB_WRT_FE(1)],...
        [0+FB_WRT_FE(2) fuselage_e(2)+FB_WRT_FE(2)],...
        [0+FB_WRT_FE(3) fuselage_e(3)+FB_WRT_FE(3)],...
        'color',PARAMS.x_axis_color,'LineWidth',PARAMS.line_width)
    hold on

    %Plot the right wing
    plot3([0+FB_WRT_FE(1) right_wing_e(1)+FB_WRT_FE(1)],...
        [0+FB_WRT_FE(2) right_wing_e(2)+FB_WRT_FE(2)],...
        [0+FB_WRT_FE(3) right_wing_e(3)+FB_WRT_FE(3)],...
        'color',PARAMS.y_axis_color,'LineWidth',PARAMS.line_width)

    %Plot the left wing
    plot3([0+FB_WRT_FE(1) left_wing_e(1)+FB_WRT_FE(1)],...
        [0+FB_WRT_FE(2) left_wing_e(2)+FB_WRT_FE(2)],...
        [0+FB_WRT_FE(3) left_wing_e(3)+FB_WRT_FE(3)],...
        'color',PARAMS.y_axis_color,'LineWidth',PARAMS.line_width)

    %Plot the vertical
    plot3([0+FB_WRT_FE(1) vertical_e(1)+FB_WRT_FE(1)],...
        [0+FB_WRT_FE(2) vertical_e(2)+FB_WRT_FE(2)],...
        [0+FB_WRT_FE(3) vertical_e(3)+FB_WRT_FE(3)],...
        'color',PARAMS.z_axis_color,'LineWidth',PARAMS.line_width)
    hold off

end