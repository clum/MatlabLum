function [varargout] = ConvertLatLonDecimalToDegMin(varargin)

%CONVERTLATLONDECIMALTODEGMINSEC  Converts decimal to deg, min
%
%   [DEGREES, MINUNTES] =
%   CONVERTLATLONDECIMALTODEGMINSEC(COORDINATE) Convert the lat/lon
%   COORDINATE (given in decimal form) to DEGREES, MINUTES.
%
%INPUT:     -COORDINATE:    lat/lon coordinate in decimal form (deg)
%
%OUTPUT:    -DEGREES:       degrees (integer in range [-180,180] )
%           -MINUTES:       minutes (decimal in range (-60, 60) )
%
%Christopher Lum
%lum@uw.edu

%Version History
%08/20/24: Created

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
MINUTES = decimal*60;

if((DEGREES == 0) && (COORDINATE < 0))
    MINUTES = -1*MINUTES;
end

%Output the object
varargout{1} = DEGREES;
varargout{2} = MINUTES;