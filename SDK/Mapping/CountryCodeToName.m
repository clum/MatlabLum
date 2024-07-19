function [varargout] = CountryCodeToName(varargin)

%COUNTRYCODETONAME Converts a country code to its full name
%
%   [NAME] = COUNTRYCODETONAME(CODE) converts the specified country CODE to
%   its corresponding NAME.
%
%   For example 'US' > 'United States'
%
%INPUT:     -CODE: country code
%
%OUTPUT:    -NAME: country name
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

NAME = countyInfoTable.name{idx};

%Output the object
varargout{1} = NAME;