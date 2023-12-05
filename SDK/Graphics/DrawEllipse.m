function [X,Y,Z] = DrawEllipse(a,b,c,xo,yo,zo,N_x,N_y,cluster,plotselection,gridselection)

%DRAWELLIPSE  Draws an ellipse on a plot
%
%   DRAWELLIPSE(a,b,c,xo,yo,zo) draws a ellipse which satisfies
%
%       (x-xo)^2   (y-yo)^2   (z-zo)^2
%       -------- + -------- + -------- = 1
%         a^2         b^2       c^2
%
%   In other words, an ellipse with major axis of spanning from -a to a, a
%   minor axis spanning from -b to b, a height from -c to c and centered at
%   (xo,yo,zo).  If xo, yo, and zo, are ommitted, this assumes centered at
%   (0,0,0).
%
%   DRAWELLIPSE(a,b,c,xo,yo,zo,N_x,N_y) draws an ellipse as above and uses
%   N_x points across the major axis and N_y points across the minor axis.
%   Note that N_x and N_y should be an odd integer values. This is
%   automatically changed if necessary.
%
%   DRAWELLIPSE(a,b,c,xo,yo,zo,N_x,N_y,cluster) if 0 < cluster < 1, the
%   points are clustered near the edge of the major axis.  This makes the
%   edges of the ellipse "smoother".  The value of cluster must greater
%   than 0.  The smaller the number, the more clustered the points become.
%   If cluster = 1, this yields linearly space values.  If cluster is
%   greater than 1, then the points becomes clustered near the x = 0
%   instead of near x = a . Turn the grid on (see below) to see this
%   effect.  cluster = 0.75 is a good value to start with.
%
%   DRAWELLIPSE(a,b,c,xo,yo,zo,N_x,N_y,cluster,plot) draws an ellipse as
%   above and allows the plot feature to be suppressed (plot = 1 for
%   plotting, plot = 0 to suppress)
%
%   DRAWELLIPSE(a,b,c,xo,yo,zo,N_x,N_y,cluster,plot,grid) draws an ellipse
%   as above and shows the (x,y) grid points used to plot the ellipse (grid
%   = 1 to plot).  It is assumed grid = 0.
%
%   [X,Y,Z] = DRAWELLIPSE(...) draws the ellipse as above and returns the
%   X, Y, and Z values points of the ellipse.  This only returns the Z
%   values for the upper hemisphere.
%
%INPUT: -a:         1/2 major axis
%       -b:         1/2 minor axis
%       -c:         1/2 height
%       -xo:        center of ellipse in x
%       -yo:        center of ellipse in y
%       -zo:        center of elilpse in z
%       -N_x:       number of points around major axis
%       -N_y:       number of points around minor axis
%       -cluster:   cluster coefficient of the x points?
%       -plot:      plot or not (1 = yes, 0 = no)
%       -grid:      plot the (x,y) grid used or not (1 = yes, 0 = no)
%
%OUPUT: -X:         X values of ellipse
%       -Y:         Y values of ellipse
%       -Z:         Z values of ellipse
%
%See also ELLIPSOID, SPHERE, DRAWTORUS (custom code).
%
%Christopher Lum
%lum@uw.edu

%This function arose from the AA599D Manifolds and Geometry of Control,
%winter 2004 Final Question 1.  See this for more information.

%Version History
%05/17/04: Created
%05/18/04: Added point along y = 0 line to for evaluations.  Also added so
%          that ellipse can be centered at (xo,yo,zo).  Did this by
%          calculating ellipse centered at origin then just shifting X, Y,
%          and Z matrices by xo, yo, and zo, respectively.
%05/05/05: Changed some documentation.
%12/04/23: Minor up to documentation

%------------------CHECKING DATA FORMAT----------------------------
if (nargin==1) | (nargin==2) | (nargin==4) | (nargin==5)
    error('Number of input arguments is inconsistent')
end

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 10
        %Assume gridselection is off
        gridselection = 0;

    case 9
        %Assume they want a plot and everything above
        gridselection = 0;
        plotselection = 1;

    case 8
        %Assume the want linearly spaced x values and everything above
        gridselection = 0;
        plotselection = 1;
        cluster = 0;

    case 7
        %Assume they want 21 points for minor axis and everything above
        gridselection = 0;
        plotselection = 1;
        cluster = 0;
        N_y = 21;

    case 6
        %Assume they want 21 points for major axis and everything above
        gridselection = 0;
        plotselection = 1;
        cluster = 0;
        N_y = 21;
        N_x = 21;

    case 3
        %Assume centered at origin and everything abovve
        gridselection = 0;
        plotselection = 1;
        cluster = 0;
        N_y = 21;
        N_x = 21;
        xo = 0;
        yo = 0;
        zo = 0;
end

%-----------------------------------------------------------------------
%Also, check that the number of points specified in the y direction
%is even.
if mod(N_y,2)~=1
    %N_y is even, make it odd
    N_y = N_y + 1;
end

%Check the number of points in the specified in the x direction is
%odd
if mod(N_x,2)~=1
    %N_x is even, make it odd
    N_x = N_x + 1;
end

%Make sure we have a valid cluster value.
if cluster<0
    error('cluster value must be greater than 0')
end

%Does user want to cluster the points near the edge of the major axis?
if cluster~=0
    %Cluster the x points near the edge of the major axis
    for k=0:((N_x-1)/2)-1;
        m(k+1) = cluster^k;
    end
    L = a/(sum(m));

    %Calculate the x values
    x(1) = 0;
    for counter=2:(N_x-1)/2
        %Current power
        curr_power = (((N_x-1)/2)-1) + 2 - counter;
        x(counter) = L*cluster^curr_power + x(counter-1);
    end

    %Now shift these by a to obtain the negative a values
    x = x - a;

    %Now create the positive values.  Remember to order these so smallest
    %magnitude is near the middle of the array
    for counter=1:length(x)
        x_pos(counter) = -x(end-counter+1);
    end

    %Create the total x matrix (with the zero)
    x = [x 0 x_pos];

else
    %Just use linearly space x values.
    x = linspace(-a,a,N_x);
    y = linspace(-b,b,N_y);
end

%Initialize the X and Y matrices.
X = zeros(N_x,N_y);
Y = zeros(N_x,N_y);

%At a certain value of x, what are the max and min y values which are on
%the ellipse?
for x_counter = 1:N_x
    %Current x?
    x_curr = x(x_counter);

    %Max y possible?
    y_max = sqrt(b^2*(1-((x_curr^2)/a^2)));

    %At this value of x, the length of this section  is from -y_max to
    %y_max.  Divide this up into N_y sections
    for y_counter = 1:(N_y-1)/2

        Y(x_counter,y_counter) = -y_max*y_counter/((N_y-1)/2);
    end

    %Switch the order so that the smallest magnitude is near the middle of the
    %matrix.
    neg_values = Y(x_counter,1:((N_y-1)/2));
    for counter=1:length(neg_values);
        neg_values_ordered(counter) = neg_values(end-counter+1);
    end

    Y(x_counter,1:((N_y-1)/2)) = neg_values_ordered;

    Y(x_counter,((N_y-1)/2)+2:end) = -neg_values;

    %The X matrix should all have the same x values across this row
    X(x_counter,:) = x_curr;
end

%Plot grid?
if gridselection==1
    %Plot the x,y grid points used
    figure
    hold on
    for x_counter=1:N_x
        for y_counter=1:N_y
            plot3(X(x_counter,y_counter)+xo,Y(x_counter,y_counter)+yo,0,'rx')
        end
    end
    title('(x,y) Grid Points Used to Calculate Ellipse')
    xlabel('x')
    ylabel('y')
    legend(['a = ',num2str(a)],...
        ['b = ',num2str(b)],...
        ['c = ',num2str(c)],...
        ['x_o = ',num2str(xo)],...
        ['y_o = ',num2str(yo)],...
        ['z_o = ',num2str(zo)],...
        ['N_x = ',num2str(N_x)],...
        ['N_y = ',num2str(N_y)])
    grid

    L = max([a b]);
    axis([(xo-L) (xo+L) (yo-L) (yo+L)])
end

%Now, with thse X and Y values, calculate the upper hemisphere
Z = sqrt(c^2*(1-(X.^2./(a^2))-(Y.^2./(b^2))));

%Due to round off error, there is sometimes a small imaginary part on Z,
%chop this off
Z = real(Z);

%Shift X, Y, and Z matrices by xo, yo, and zo respectively
X = X + xo;
Y = Y + yo;
Z = Z + zo;

if plotselection==1
    figure
    hold on
    surf(X,Y,Z)
    surf(X,Y,-Z+(2*zo))
    shading interp
    xlabel('x')
    ylabel('y')
    zlabel('z')
    title(['Ellipse with a=',num2str(a),', b=',num2str(b),', and c=',num2str(c),...
        '.  Centered at (',num2str(xo),',',num2str(yo),',',num2str(zo),...
        ').  N_x = ',num2str(N_x),' and N_y = ',num2str(N_y)])
    grid
    hold off
end