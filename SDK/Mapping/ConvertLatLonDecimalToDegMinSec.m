function [varargout] = ConvertLatLonDecimalToDegMinSec(varargin)

%CONVERTLATLONDECIMALTODEGMINSEC  Converts decimal to deg, min, sec
%
%   [DEGREES, MINUNTES, SECONDS] =
%   CONVERTLATLONDECIMALTODEGMINSEC(COORDINATE) Convert the lat/lon
%   COORDINATE (given in decimal form) to DEGREES, MINUTES, SECONDS.
%
%INPUT:     -COORDINATE:    lat/lon coordinate in decimal form
%
%OUTPUT:    -DEGREES:       degrees (integer in range [-180,180] )
%           -MINUTES:       minutes (integer in range (-60, 60) )
%           -SECONDS        seconds (decimal in range (-60, 60) )
%
%Christopher Lum
%lum@uw.edu

%Version History
%04/10/08: Created
%01/14/24: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        COORDINATE = varargin{1};
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
if (COORDINATE < -180) || (COORDINATE > 180)
    error('COORDINATE must be in range of [-180, 180]')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Compute the degrees
DEGREES = fix(COORDINATE);

%Compute the minutes
decimal = abs(COORDINATE - DEGREES);
MINUTES = floor(decimal*60);

if((DEGREES == 0) && (COORDINATE < 0))
    MINUTES = -1*MINUTES;
end

%Compute seconds
seconds_decimal = decimal - abs(MINUTES/60);
SECONDS         = seconds_decimal*3600;

if((DEGREES == 0) && (MINUTES == 0) && (COORDINATE < 0))
    SECONDS = -1*SECONDS;
end

%Output the object
varargout{1} = DEGREES;
varargout{2} = MINUTES;
varargout{3} = SECONDS;