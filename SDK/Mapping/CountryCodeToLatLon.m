function [varargout] = CountryCodeToLatLon(varargin)

%COUNTRYCODETOLATLON Obtain the lat/lon associated with a country
%
%   [LAT_RAD,LON_RAD] = COUNTRYCODETOLATLON(CODE) obtains the LAT_RAD and
%   LON_RAD for the specified country CODE
%
%   For example 'US' > LAT_RAD ~= 0.6473, LON_RAD ~= -1.6705
%
%INPUT:     -CODE:      country code
%
%OUTPUT:    -LAT_RAD:   latitude (rad)
%           -LON_RAD:   longitude (rad)
%
%Christopher Lum
%lum@uw.edu

%Version History
%07/09/24: Created

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %User supplies all inputs
        CODE = varargin{1};

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
% CODE
assert(ischar(CODE),'CODE should be a char array')

%-------------------------BEGIN CALCULATIONS-------------------------------
%Load the file with the mappings
countryInfoFile = 'CountryLatLon.xlsx';
countyInfoTable = readtable(countryInfoFile);

codes = countyInfoTable.country;
idx = find(strcmp(codes,upper(CODE)));
assert(~isempty(idx),['Could not find country code of ',CODE,' in ',countryInfoFile])
assert(length(idx)==1,['Found more than 1 entry corresponding to country code of ',CODE,' in ',countryInfoFile])

LAT_RAD = deg2rad(countyInfoTable.latitude(idx));
LON_RAD = deg2rad(countyInfoTable.longitude(idx));

%Output the object
varargout{1} = LAT_RAD;
varargout{2} = LON_RAD;