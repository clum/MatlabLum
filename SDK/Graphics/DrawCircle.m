function [X_POINTS,Y_POINTS] = DrawCircle(varargin)

%DRAWCIRCLE Draws a circle
%
%   DRAWCIRCLE(RADIUS) Draws a circle with RADIUS centered at (0,0)
%   defaults to use 100 points around the circle.
%
%   DRAWCIRCLE(RADIUS,X,Y) Draws a circle as above but centered at (X,Y)
%
%   DRAWCIRCLE(RADIUS,X,Y,N) Draws a circle as above using N points.
%
%   [X_POINTS,Y_POINTS] = DRAWCIRCLE(...) Simply returns to points that can
%   be used to draw the circle.  No plot is drawn.
%
%
%INPUT:     -RADIUS:    Radius of circle
%           -X:         X coordinate of circle center
%           -Y:         Y coordinate of circle center
%           -N:         Number of points to use (optional)
%
%OUTPUT:    -X_POINTS:  Array of x values to draw circle
%           -Y_POINTS:  Array of y values to draw circle
%
%Christopher Lum
%lum@uw.edu

%Version History
%08/30/05: created
%06/22/10: updated and fixed documentation
%12/04/23: minor update to documentation

%-----------------------CHECKING DATA FORMAT-------------------------------

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 4
        %user supplies all arguments
        RADIUS  = varargin{1};
        X       = varargin{2};
        Y       = varargin{3};
        N       = varargin{4};
        
    case 3
        %Assume N = 100 points and everything above
        RADIUS  = varargin{1};
        X       = varargin{2};
        Y       = varargin{3};
        N = 100;
        
    case 1
        %Assume centered at origin and everything above
        RADIUS  = varargin{1};
        X = 0;
        Y = 0;
        N = 100;

    otherwise
        error('Inconsistent number of inputs')
end

%Does user want a plot or not?
if nargout==0
    plot_selection = 1;
else
    plot_selection = 0;
end

%-------------------------BEGIN CALCULATIONS-------------------------------
theta = linspace(0,2*pi,N);

X_POINTS = RADIUS*cos(theta) + X;
Y_POINTS = RADIUS*sin(theta) + Y;

if plot_selection==1
    plot(X_POINTS,Y_POINTS)
end