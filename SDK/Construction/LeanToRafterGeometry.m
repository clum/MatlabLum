function [xCoordinates,yCoordinates] = CalculateLeanToRafterGeometry(m,Lo,d,w,f,L,wTP)

%CalculateLeanToRafterGeometry  Calculates coordinates of rafter
%
%   [xCoordinates,yCoordinates] CalculateLeanToRafterGeometry(m,Lo,d,w,f,L) 
%   Calculates coordinates of the rafter.
%
%INPUT:     -m: slope of rafter/roof
%           -Lo: amount the rafter hangs over on the low end (horizontal
%           projection distance)
%           -d: height/depth of bird's mouth cut
%           -w: distance between two outer walls
%           -f: thickness/fatness of rafter
%           -L: length of rafter
%           -wTP: width of top plates
%
%OUTPUT:    -xCoordinates:  x coordinates
%           -yCoordinates:  y coordinates
%
%Christopher Lum
%lum@uw.edu

%Version History
%02/17/25: Created
%03/09/25: Moved to MatlabLum

arguments
    m       (1,1) double
    Lo      (1,1) double
    d       (1,1) double
    w       (1,1) double
    f       (1,1) double
    L       (1,1) double
    wTP     (1,1) double
end

%% Calculations
x1 = 0;
y1 = 0;

x2 = Lo;
y2 = m*Lo;

x3 = Lo;
y3 = y2 + d;

e = d/m;
x4 = Lo + e;
y4 = y3;

assert(e<wTP)

r5 = w - wTP - e;
x5 = x4 + r5;
y5 = y4 + m*r5;

x6 = x5;
y6 = y5 + d;

x7 = x6 + e;
y7 = y6;

theta = atan(m);
Ltilde = sqrt(x7^2 + y7^2);
assert(Ltilde < L);
h = L-Ltilde;

x8 = x7 + h*cos(theta);
y8 = y7 + h*sin(theta);

x9 = x8 - f*sin(theta);
y9 = y8 + f*cos(theta);

x10 = -f*sin(theta);
y10 = f*cos(theta);

% theta = atan(m);
% alpha = (1/2)*pi-theta;
% h_tilde = f/sin(alpha);
% x6 = Lo+w;
% y6 = h_hat+h_tilde;
% 
% x7 = 0;
% y7 = h_tilde;

%% Check calculations
rise = y6-y3;
run = x5-x2;

slopeCheck = rise/run;

wTP - e;

%% Package outputs
xCoordinates = [
    x1
    x2
    x3
    x4
    x5
    x6
    x7
    x8
    x9
    x10
    x1
    ];
yCoordinates = [
    y1
    y2
    y3
    y4
    y5
    y6
    y7
    y8
    y9
    y10
    y1
    ];