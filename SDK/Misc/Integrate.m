function y = Integrate(t,yd,y0)

%INTEGRATE numerical integration
%
%   [y] = INTEGRATE(t,yd) integrates the function yd values which have
%   corresponding time vector, t.  This assumes that that y(0)=0.  This
%   uses a simple backward rule integration given by
%
%       y(k) = yd(k)*(t(k)-t(k-1)) + y(k-1)
%
%   INTEGRATE(t,yd,y0) integrates as above, but uses y(0) = y0 as an
%   initial condition
%
%INPUT:     -t:     time vector
%           -yd:    integrand vector
%           -y0:    initial condition, y(0)
%
%OUTPUT:    -y:     integral of yd
%
%Also see DIFF, DIFFERENTIATE (custom function)
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/05/04: Created
%04/15/04: Changed outputs to column vectors
%12/15/23: Moved to MatlabLum
%11/23/24: Updating documentation

%------------------CHECKING DATA FORMAT----------------------------
if (nargin==1)
    error('Number of input arguments is inconsistent')
end

%Check to make sure that the t and yd arrays are in column form
[t_rows t_columns] = size(t);
[yd_rows yd_columns] = size(yd);

if (t_columns>1 & t_rows>1) | (yd_columns>1 & yd_rows>1)
    error('t and yd arrays must be single column or row vectors!')
end

if t_columns>1
    t = t';
end

if yd_columns>1
    yd = yd';
end

%Check to make sure the t and yd arrays are coincident
if length(yd)~=length(t)
    error('t and yd arrays are not the same length!')
end

%---------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %Assume y(0) = 0
        y0 = 0;
                
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Initial condition
y(1) = y0;

%Integrate function
for counter = 2:length(t)
    %Find dt
    dt = t(counter) - t(counter-1);
    
    %Integrate using the right point
    y(counter,1) = yd(counter)*dt + y(counter-1);
end