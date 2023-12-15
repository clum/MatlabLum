function yd = Differentiate(t,y,yd0)

%DIFFERENTIATE numerical differentiation
%
%   DIFFERENTIATE(t,y) differentiates the function y values which have
%   corresponding time vector, t.  This assumes that that yd(0)=0.  This
%   uses a simple backward rule differentiation given by
%
%       yd(k) = y(k)-y(k-1)/(t(k)-t(k-1))
%
%   DIFFERENTIATE(t,y)(t,y,yd0) differentiates as above, but uses yd(0) = yd0
%   as an initial slope
%
%   yd = DIFFERENTIATE(...) differentiates as above and returns the vector
%   of yd, the derivative of y.
%
%
%INPUT:     -t:     time vector
%           -y:     values to be differentiated
%           -yd0:   initial slope, yd(0)
%
%OUTPUT:    -yd:    derivative of y
%
%Also see DIFF, INTEGRATE (custom function)
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/05/04: Created
%04/15/04: Changed outputs to column vectors
%12/15/23: Moved to MatlabLum

%------------------CHECKING DATA FORMAT----------------------------
if (nargin==1)
    error('Number of input arguments is inconsistent')
end

%Check to make sure that the t and yd arrays are in column form
[t_rows t_columns] = size(t);
[y_rows y_columns] = size(y);

if (t_columns>1 & t_rows>1) | (y_columns>1 & y_rows>1)
    error('t and y arrays must be single column or row vectors!')
end

if t_columns>1
    t = t';
end

if y_columns>1
    y = y';
end

%Check to make sure the t and yd arrays are coincident
if length(y)~=length(t)
    error('t and y arrays are not the same length!')
end

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %Assume yd(0) = 0
        yd0 = 0;
                
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Initial condition
yd(1) = yd0;

%Differentiate function
for counter = 2:length(t)
    %Find dt
    dt = t(counter) - t(counter-1);
    
    %Find dy
    dy = y(counter) - y(counter-1);
    
    %Calculate slope
    yd(counter,1) = dy/dt;
end