function [varargout] = DrawLineBetweenPoints(varargin)

%DRAWLINEBETWEENPOINTS  Draws a line between two points
%
%   DRAWLINEBETWEENPOINTS(A,B) Draws a line between the points A and B.
%
%   [X_POINTS,Y_POINTS,Z_POINTS] = DRAWLINEBETWEENPOINTS(...) Simply
%   returns to points that can be used to draw the line.  If the points A
%   and B are points in 2D, then Z_POINTS is empty.  No plot is drawn.
%
%INPUT:     -A:         starting point
%           -B:         ending point
%
%OUTPUT:    -X_POINTS:  Array of x values to draw line
%           -Y_POINTS:  Array of y values to draw line
%           -Z_POINTS:  Array of z values to draw line
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/14/08: created
%12/04/23: minor update to documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        A = varargin{1};
        B = varargin{2};

    otherwise
        error('Inconsistent number of inputs')
end

%Does user want a plot or not?
if nargout==0
    plot_selection = 1;
else
    plot_selection = 0;
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% A
if(~isvector(A))
    error('A should be a 1D vector')
end

if((length(A)~=2) && (length(A)~=3))
    error('A should have length 2 or 3')
end

% B
if(~isvector(B))
    error('B should be a 1D vector')
end

if((length(B)~=2) && (length(B)~=3))
    error('B should have length 2 or 3')
end

%cross correlation
if(length(A) ~= length(B))
    error('A and B should have same length')
end
%-------------------------BEGIN CALCULATIONS-------------------------------
was_hold = ishold;
if ~was_hold
    hold on
end

X_POINTS = [A(1) B(1)];
Y_POINTS = [A(2) B(2)];
if (length(A)==3)
    Z_POINTS = [A(3) B(3)];
else
    Z_POINTS = [];
end

if plot_selection==1
    if(isempty(Z_POINTS))
        plot(X_POINTS, Y_POINTS)
    else
        plot3(X_POINTS, Y_POINTS, Z_POINTS)
    end
end

%Return the hold state on the figure
if ~was_hold
    hold off
end

%Output the objects
if (nargout==3)
    varargout{1} = X_POINTS;
    varargout{2} = Y_POINTS;
    varargout{3} = Z_POINTS;
end
