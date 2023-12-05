function [Z_PLANE] = DrawEllipseTangentPlane(X0,Y0,a,b,c,X_EVAL,Y_EVAL,PLOT_SELECTION)

%DRAWELLIPSETANGENTPLANE Calculates the tangent plane to ellipse at a point.
%
%   DRAWELLIPSETANGENTPLANE(X0,Y0,a,b,c,X_EVAL,Y_EVAL) Calculates the
%   tangent plane in the top hemisphere of an ellipsoid defined by
%
%         x^2     y^2     z^2
%       ------ + ----- + ----- = 1
%         a^2     b^2     c^2
%
%   at the point X0, Y0 at the matrices supplied by the vectors X_EVAL and
%   Y_EVAL.  These should be generated using MESHGRID.
%
%   [Z_PLANE] =
%   DRAWELLIPSETANGENTPLANE(X0,Y0,a,b,c,X_EVAL,Y_EVAL,PLOT_SELECTION)
%   Allows for the plane to be drawn to the current figure
%   (PLOT_SELECTION=1).  This is default off.
%
%
%INPUT:     -X0:                x-point of tangency
%           -Y0:                y-point of tangency
%           -a:                 semi-major axis of ellipsoid
%           -b:                 semi-minor axis of ellipsoid
%           -c:                 parameter of ellipsoid
%           -PLOT_SELECTION:    1 = draw plane on current plot
%
%OUTPUT:    -Z_PLANE:           Z values of tangent plane (can be
%                               visualized with surf(X_EVAL,Y_EVAL,Z_PLANE)
%See also MESHGRID
%
%Christopher Lum
%lum@uw.edu

%Version History
%05/05/05: Created
%12/04/23: Minor update to documentation

%-----------------------CHECKING DATA FORMAT-------------------------------
%Make sure that X_EVAL and Y_EVAL are same size
[nx,mx] = size(X_EVAL);
[ny,my] = size(Y_EVAL);

if (nx~=ny) || (mx~=my)
    error('X_EVAL and Y_EVAL must be same size')
end

%Make sure that X0 and Y0 are scalar
if (length(X0)~=1) || (length(Y0)~=1)
    error('X0 and Y0 must be scalars')
end

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 7
        %Assume that user doesn't want plot
        PLOT_SELECTION = 0;

    case 8
        %User supplies all inputs

    otherwise
        error('Inconsistent Number of Inputs')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Evaluate the function at point X0, Y0.
Z0 = sqrt((c^2)*(1 - (X0/a)^2 - (Y0/b)^2));

%Calculate the gradient at point X0, Y0
dzdx = -(c^2)*X0/((a^2)*Z0);
dzdy = -(c^2)*Y0/((b^2)*Z0);

Z_PLANE = Z0*ones(size(X_EVAL)) + dzdx*(X_EVAL - X0) + dzdy*(Y_EVAL - Y0);

%Does user want a plot?
if PLOT_SELECTION==1
    %Draw the plot on the current figure
    hold on
    surf(X_EVAL,Y_EVAL,Z_PLANE)
    shading interp
    hold off
end