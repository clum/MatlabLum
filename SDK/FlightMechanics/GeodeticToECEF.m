function X_ECEF = GeodeticToECEF(X_GEODETIC,a,e)

%GEODETICTOECEF Transforms a Geodetic vector to the Earth Centered Earth
%               Fixed (ECEF) frame.
%
%   [X_ECEF] = GEODETICTOECEF(X_GEODETIC) Converts the vector in the
%   Geodetic Frame, X_GEODETIC, to the ECEF frame.  This assumes a WGS-84
%   model of the earth for semi-major axis and eccentricity
%
%   [X_ECEF] = GEODETICTOECEF(X_GEODETIC,a,e) Does the same as above but
%   uses semi-major axis, a, and eccentricity, e.
%
%
%INPUT:     -X_GEODETIC:    -3x1 vector of [phi;lambda;h] where phi is the
%                            geodetic lattitude, lambda is the terrestrial
%                            longitude, and h is the geodetic altitude.  If
%                            X_GEODETIC is a matrix, then each geodetic
%                            vector should be a column vector (ie v1 =
%                            X_GEODETIC(:,1), v2 = X_GEODETIC(:,2), etc.)
%           -a:             -semi-major axis (assumes a = 6378137m)
%           -b:             -eccentricity (assumes e = 0.081819190842622)
%
%OUTPUT:    -X_ECEF:        -3x1 vector of [x;y;z] this is expressed in the
%                            ECEF frame.  If X_GEODETIC was a matrix, then
%                            X_ECEF is a matrix of the same size.
%
%For more information, see Stevens, B.L., and Lewis, F.L. "Aircraft Control
%and Simulation. 2nd Edition".  pg.38
%
%Created by Christopher Lum
%lum@u.washington.edu

%Version History:   -Created 05/05/05:
%                   -Updated 05/18/05: Allowed for X_GEODETIC to be a
%                    matrix.
%                   -Updated 11/28/05: Added replaced ^ with .^ in
%                    calculation of N to accomodate for X_GEODETIC matrix.

%-----------------------CHECKING DATA FORMAT-------------------------------
%Make sure that X_GEODETIC is a 3x1 vector
[n,m] = size(X_GEODETIC);
if (n~=3)
    error('X_GEODETIC must have only 3 rows')
end

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 1
        %Assume WGS-84 model
        a = 6378137;
        e = 0.081819190842622;
        
    case 3
        %User specifies a and e
    otherwise
        error('Inconsistent number of inputs')
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Obtain phi, lambda, and h
phi = X_GEODETIC(1,:);                    %geodetic lattitude
lambda = X_GEODETIC(2,:);                 %terrrestrial longitude
h = X_GEODETIC(3,:);                      %geodetic altitude

%Calculate N (Eq.1.4-5)
N = a./sqrt(1 - (e*sin(phi)).^2);

%Calculate X_ECEF (Eq.1.4-8 in reference text)
x_ECEF = (N+h).*cos(phi).*cos(lambda);
y_ECEF = (N+h).*cos(phi).*sin(lambda);
z_ECEF = (N.*(1-e^2)+h).*sin(phi);

X_ECEF = [x_ECEF;
          y_ECEF;
          z_ECEF];
