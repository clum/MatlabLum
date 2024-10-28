function [varargout] = SphericalToCartesianCoordinates(varargin)

%SPHERICALTOCARTESIANCOORDINATES converts from spherical to catesian
%
%   [X, Y, Z] = SPHERICALTOCARTESIANCOORDINATES(R, THETA, PHI) Converts
%   from spherical coordinates of R, THETA, and PHI to cartesian
%   coordinates of X, Y, Z using
%
%       X = R*cos(THETA)*sin(PHI)
%       Y = R*sin(THETA)*sin(PHI)
%       Z = R*cos(PHI)
%
%   Note that with this convention, THETA is measured positive about the z
%   axis in a right-handed notation with THETA = 0 corresponds to aligned
%   with the positive x axis.
%
%   Also note that R is the total radial distance, not the planar radial
%   distance.
%
%   This follows the definition of spherical coordinates as defined in
%   "Advanced Engineering Mathematics 10th Edition", pg.A74.
%
%INPUT:     -R:     vector of radial distance
%           -THETA: azimuth angles
%           -PHI:   inclination/polar angles
%
%OUTPUT:    -X:     x values
%           -Y:     y values
%           -Z:     z values
%
%Christopher Lum
%lum@uw.edu

%Version History
%10/11/13: Created
%10/27/24: Minor update to documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 3
        %User supplies all inputs
        R       = varargin{1};
        THETA   = varargin{2};
        PHI     = varargin{3};

    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------
X = R.*cos(THETA).*sin(PHI);
Y = R.*sin(THETA).*sin(PHI);
Z = R.*cos(PHI);

varargout{1} = X;
varargout{2} = Y;
varargout{3} = Z;