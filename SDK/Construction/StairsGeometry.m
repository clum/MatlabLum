function [stairsStruct] = StairsGeometry(rise,run,numSteps,tR,tT,tFMBF,tS)

%StairsGeometry  Calculates coordinates of a set of stairs
%
%   [xCoordinates,yCoordinates] StairsGeometry(rise,run,numSteps) 
%   Calculates coordinates of the stairs.  See StairsGeometry_GRAPHICS.pptx
%   for diagram of geometry.
%
%INPUT:     -rise:      total rise
%           -run:       total run
%           -numSteps:  number of steps
%           -tR:       thickness of riser material
%           -tT:       thickness of tread material
%           -tFMBF:    thickness of finished material on bottom floor
%           -tS:       thickness of the lumber used to build the stringer
%           (actual dimension, not nominal dimension)
%
%OUTPUT:    -xCoordinates:  x coordinates
%           -yCoordinates:  y coordinates
%           -extra:         struct with extra information
%
%See also PlotStairsGeometery
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/09/25: Created
%04/12/25: Finished wvork.
%06/24/25: Updated for riser and tread material
%06/26/25: Continued working
%06/27/25: Changing to output to stairStruct object.
%06/28/25: Added rotation

arguments
    rise        (1,1) double
    run         (1,1) double
    numSteps    (1,1) double {mustBeInteger}
    tR          (1,1) double = 0
    tT          (1,1) double = 0
    tFMBF       (1,1) double = 0
    tS          (1,1) double = 9.25
end

%% Initialize containers
xCoordinates        = [];
yCoordinates        = [];

%% Calculations
%Intermediate variables
unitRise = rise/numSteps;
unitRun  = run/numSteps;

%Compute points
xCoordinates(end+1,1) = 0;
yCoordinates(end+1,1) = 0;

%Get the first point above the subfloor
xCoordinates(end+1,1) = 0;
yCoordinates(end+1,1) = tFMBF + unitRise - tT;

%Get the front faces of each step
for k=1:numSteps-1
    xCoordinates(end+1,1) = xCoordinates(end) + unitRun;
    yCoordinates(end+1,1) = yCoordinates(end);

    xCoordinates(end+1,1) = xCoordinates(end);
    yCoordinates(end+1,1) = yCoordinates(end) + unitRise;
end

%Get the top right point
xCoordinates(end+1,1) = xCoordinates(end) + unitRun - tR;
yCoordinates(end+1,1) = yCoordinates(end);

%Get the angle, theta, using points 2 and 4
x2 = xCoordinates(2);
y2 = yCoordinates(2);

x4 = xCoordinates(4);
y4 = yCoordinates(4);

theta = atan2(y4-y2,x4-x2);

%The bottom of the stringer should be slid out as much as possible to

%Compute the projected point
pTLx = xCoordinates(end-1); 
pTLy = yCoordinates(end-1);
pTL = [pTLx;pTLy];

v1x = tS*sin(theta);
v1y = -tS*cos(theta);

pPx = pTLx + v1x;
pPy = pTLy + v1y;
pP = [pPx;pPy];

distanceCheck = abs(norm([pPx;pPy]-[pTLx;pTLy]) - tS);
assert(distanceCheck < tS/10000,'Error in computation, pP does not appear correct')

%Compute pPR.  Do this by projecting pP along the line inclined at angle
%theta until the x component is equal to pTRx
pTRx = xCoordinates(end);  
pTRy = yCoordinates(end);
pTR = [pTRx;pTRy];

DT = -(pPx - pTRx)*sec(theta);

pPRx = pPx + DT*cos(theta);
pPRy = pPy + DT*sin(theta);
pPR = [pPRx;pPRy];

xCoordinates(end+1,1) = pPRx;
yCoordinates(end+1,1) = pPRy;

%Compute pPL.  Do this by creating a unit vector from pPR towards pP and
%then projecting this vector until the x component is equal to 0
v = [pPx-pPRx;pPy-pPRy];
u = v*(1/norm(v));
uy = u(2);

DB = -(pPRy/uy);

pPL = pPR + DB*u;

xCoordinates(end+1,1) = pPL(1);
yCoordinates(end+1,1) = pPL(2);

%% Compute extra parameters
%Minimum thickness distance and points
DM = unitRise*sin(theta);
pM = pPR + (DT+DM)*u;

pCrit = [xCoordinates(end-4);yCoordinates(end-4)];
tMin = norm(pM - pCrit);

%Coordinates for riser and tread materials
for k=1:numSteps
    m = 2*k;
    xCorner = xCoordinates(m);
    yCorner = yCoordinates(m);

    %riser
    xMinR = xCorner-tR;
    xMaxR = xCorner;

    yMinR = yCorner-unitRise+tT;
    yMaxR = yCorner;

    xRiser = [xMinR;xMaxR;xMaxR;xMinR];
    yRiser = [yMinR;yMinR;yMaxR;yMaxR];

    riserCoordinates{k} = [xRiser yRiser];

    %tread
    xMinT = xCorner-tR;
    xMaxT = xCorner+unitRun;

    yMinT = yCorner;
    yMaxT = yCorner+tT;

    xTread = [xMinT;xMaxT;xMaxT;xMinT];
    yTread = [yMinT;yMinT;yMaxT;yMaxT];

    treadCoordinates{k} = [xTread yTread];
end

%% Rotate coordinates
%Express coordinates in frame aligned with rough lumber (this makes cutting
%the stringer easier)

%Rotation matrix from cartesian frame (F_C) to lumber frame (F_L)
C_LC = [cos(theta) sin(theta);
    -sin(theta) cos(theta)];

coordinates_C = [xCoordinates';
    yCoordinates'];

coordinates_L = C_LC*coordinates_C;

xCoordinates_L = coordinates_L(1,:)';
yCoordinates_L = coordinates_L(2,:)';

%offset yCoordinates_L so it starts at 0
yCoordinates_L = yCoordinates_L - yCoordinates_L(end);

%length of lumber before cuts
LT = xCoordinates_L(end-2);

%% Package outputs
stairsStruct.xCoordinates       = xCoordinates;
stairsStruct.yCoordinates       = yCoordinates;
stairsStruct.unitRise           = unitRise;
stairsStruct.unitRun            = unitRun;
stairsStruct.pFMBF              = [0;tFMBF];
stairsStruct.pP                 = [pPx;pPy];
stairsStruct.pCrit              = pCrit;
stairsStruct.pM                 = pM;
stairsStruct.tMin               = tMin;
stairsStruct.riserCoordinates   = riserCoordinates;
stairsStruct.treadCoordinates   = treadCoordinates;
stairsStruct.xCoordinates_L     = xCoordinates_L;
stairsStruct.yCoordinates_L     = yCoordinates_L;
stairsStruct.LT                 = LT;