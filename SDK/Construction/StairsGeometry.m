function [xCoordinates,yCoordinates] = StairsGeometry(rise,run,numSteps)

%StairsGeometry  Calculates coordinates of a set of stairs
%
%   [xCoordinates,yCoordinates] StairsGeometry(rise,run,numSteps) 
%   Calculates coordinates of the stairs.  See StairsGeometry_GRAPHICS.pptx
%   for diagram of geometry.
%
%INPUT:     -rise:  total rise
%           -run:   total run
%           -numSteps: number of steps
%
%OUTPUT:    -xCoordinates:  x coordinates
%           -yCoordinates:  y coordinates
%
%Christopher Lum
%lum@uw.edu

%Version History
%03/09/25: Created
%04/12/25: Finished work.

arguments
    rise        (1,1) double
    run         (1,1) double
    numSteps    (1,1) double {mustBeInteger} 
end

%% Calculations
xStart = 0;
yStart = 0;

xCoordinates = [0];
yCoordinates = [0];
for k=1:numSteps
    xCoordinates(end+1,1) = xCoordinates(end) + run/numSteps;
    yCoordinates(end+1,1) = yCoordinates(end);

    xCoordinates(end+1,1) = xCoordinates(end);
    yCoordinates(end+1,1) = yCoordinates(end) + rise/numSteps;
end