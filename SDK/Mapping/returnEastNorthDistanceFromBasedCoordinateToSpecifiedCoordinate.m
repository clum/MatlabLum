function [X] = returnEastNorthDistanceFromBasedCoordinateToSpecifiedCoordinate(varargin)

%RETURNEASTNORTHDISTANCEFROMBASEDCOORDINATETOSPECIFIEDCOORDINATE
%
%   [X] = RETURNEASTNORTHDISTANCEFROMBASEDCOORDINATETOSPECIFIEDCOORDINATE(...
%   BASELATITUDE, BASELONGITUDE, SPECIFIEDLATITUDE, SPECIFIEDLONGITUDE)
%   Computes east and north distance from the base coordinate (BASELATITUDE/BASELONGITUDE)
%   to the specified coordinate (SPECIFIEDLATITUDE/SPECIFIEDLONGITUDE).
%
%   This is done using the Vincenty Formula.   For more information on this
%   formula, see "Direct and Inverse Solutions of Geodesics on the Ellipsoid
%   with Application of Nested Equations" by T. Vincenty.  DMAAC Geodetic
%   Survey Squadron, F.E. Warren AFB, Wyoming 82001.
%
%   A positive distance north implies that the specifiedLattitude is north of the
%   baseLattitude.  A positive distance east implies that the specifiedLongitude
%   is east of the baseLongitude.
%
%   [...] = RETURNEASTNORTHDISTANCEFROMBASEDCOORDINATETOSPECIFIEDCOORDINATE(...
%   BASELATITUDE, BASELONGITUDE, SPECIFIEDLATITUDE, SPECIFIEDLONGITUDE,
%   ELLIPSOIDMODEL) does as above but uses a specified ellposoid model.
%
%INPUT:     -BASELATITUDE:          baseLatitude (in radians)
%           -BASELONGITUDE:         baseLongitude (in radians)
%           -SPECIFIEDLATITUDE:     specifiedLattitude (in radians)
%           -SPECIFIEDLONGITUDE:    specifiedLongitude (in radians)
%           -ELLIPSOIDMODEL:        ellipsoid model to use (default is "WGS-84")
%
%OUTPUT:    -X:                     [distance east; distance north] (in meters)
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/13/10: Created from C code version of function
%01/14/24: Updated documentation

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 5
        %User supplies all inputs
        baseLattitude       = varargin{1};
        baseLongitude       = varargin{2};
        specifiedLattitude  = varargin{3};
        specifiedLongitude  = varargin{4};
        ellipsoidModel      = varargin{5};
        
    case 4
        %Assume WGS-84 model
        baseLattitude       = varargin{1};
        baseLongitude       = varargin{2};
        specifiedLattitude  = varargin{3};
        specifiedLongitude  = varargin{4};
        ellipsoidModel      = 'WGS-84';
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------
GPX_MIN_LATTITUDE   = -pi/2;    %minimum lattitude possible
GPX_MAX_LATTITUDE   = pi/2;     %maximum lattitude possible
GPX_MIN_LONGITUDE   = -pi;      %minimum longitude possible
GPX_MAX_LONGITUDE   = pi;       %maximum longitude possible

% baseLattitude
if ((baseLattitude < GPX_MIN_LATTITUDE) || (baseLattitude > GPX_MAX_LATTITUDE))
    error('baseLattitude is out of bounds (make sure it is in radians)');
end

% baseLongitude
if ((baseLongitude < GPX_MIN_LONGITUDE) || (baseLongitude > GPX_MAX_LONGITUDE))
    error('baseLongitude is out of bounds (make sure it is in radians)!');
end

% specifiedLattitude
if ((specifiedLattitude < GPX_MIN_LATTITUDE) || (specifiedLattitude > GPX_MAX_LATTITUDE))
    error('specifiedLattitude is out of bounds (make sure it is in radians)!')
end

% specifiedLongitude
if ((specifiedLongitude < GPX_MIN_LONGITUDE) || (specifiedLongitude > GPX_MAX_LONGITUDE))
    error('specifiedLongitude is out of bounds (make sure it is in radians)!');
end

%-------------------------BEGIN CALCULATIONS-------------------------------
%Check if the points are coincident
if ((baseLattitude == specifiedLattitude) && (baseLongitude == specifiedLongitude))
    zeroVec = [0;0];
    X = zeroVec;
    return
end

%Rename variables
lat1			= specifiedLattitude;	%lattitude of point 1
lon1			= specifiedLongitude;	%longitude of point 1
lat2			= baseLattitude;		%lattitude of point 2 (base)
lon2			= baseLongitude;		%longitude of point 2 (base)
tolerance		= 0.000000000001;		%convergence tolerance
maxIterations   = 50;                   %maximum number of iterations

%Obtain the parameters for the ellipsoid model
if (strcmp(ellipsoidModel,'WGS-84'))
    %use the WGS-84 model
    a = 6378137.0;
    b = 6356752.314245;
    
elseif (strcmp(ellipsoidModel,'Airy'))
    %use the Airy model (UK)
    a = 6377563.396;
    b = 6356256.909;
    
elseif (strcmp(ellipsoidModel,'GRS-80'))
    %use the GRS-80 model (Australia)
    a = 6378137;
    b = 6356752.3141;
    
elseif (strcmp(ellipsoidModel,'International-1924'))
    %use the international 1924 (much of Europe)
    a = 6378388;
    b = 6356911.946;
    
else
    error(['ellipsoidModel of ', ellipsoidModel,' is unknown!']);
    
end

%Calculate initial parameters
L	= lon2 - lon1;
f	= (a - b)/a;
U1	= atan((1 - f)*tan(lat1));
U2	= atan((1 - f)*tan(lat2));

%Start iterations
lambda = L;

exitFlag = false;
numIterations = 0;
while(~exitFlag)
    
    sinSigma			= sqrt(squareDouble(cos(U2)*sin(lambda)) + squareDouble(cos(U1)*sin(U2) - sin(U1)*cos(U2)*cos(lambda)));
    cosSigma			= sin(U1)*sin(U2) + cos(U1)*cos(U2)*cos(lambda);
    sigma				= atan2(sinSigma, cosSigma);
    
    sinAlpha			= cos(U1)*cos(U2)*sin(lambda)/sinSigma;
    cosSquaredAlpha		= 1 - squareDouble(sinAlpha);
    cos2SigmaM			= cos(sigma) - 2*sin(U1)*sin(U2)/cosSquaredAlpha;
    
    %check if cos2SigmaM is an invalid value, if so, set it to 0
    
    C = f/16*cosSquaredAlpha*(4 + f*(4 - 3*cosSquaredAlpha));
    
    lambdaOld = lambda;
    lambda = L + (1 - C)*f*sinAlpha*(sigma + C*sinSigma*(cos2SigmaM+C*cosSigma*(-1 + 2*cos2SigmaM*cos2SigmaM)));
    
    %check convergence
    lambdaDifference = lambda - lambdaOld;
    if (abs(lambda - lambdaOld) < tolerance)
        exitFlag = true;
    end
    
    %check iteration number
    if (numIterations > maxIterations)
        error('returnEastNorthDistanceFromBasedCoordinateToSpecifiedCoordinate: Vincenty formula failed to converge!');
    else
        numIterations = numIterations+1;
    end
    
end	%end while loop

uSquared = cosSquaredAlpha*(a*a - b*b)/(b*b);
A = 1 + uSquared/16384*(4096 + uSquared*(-768 + uSquared*(320 - 175*uSquared)));
B = uSquared/1024 * (256 + uSquared*(-128 + uSquared*(74 - 47*uSquared)));
deltaSigma = B*sinSigma*(cos2SigmaM + B/4*(cosSigma*(-1 + 2*cos2SigmaM*cos2SigmaM) - B/6*cos2SigmaM*(-3 + 4*sinSigma*sinSigma)*(-3 + 4*cos2SigmaM*cos2SigmaM)));

%Calculate distances and angles
s		= b*A*(sigma - deltaSigma);
alpha1	= atan2(cos(U2)*sin(lambda), cos(U1)*sin(U2) - sin(U1)*cos(U2)*cos(lambda));
alpha2	= atan2(cos(U1)*sin(lambda), -sin(U1)*cos(U2) + cos(U1)*sin(U2)*cos(lambda));

%Make these valid course angles
alpha1 = returnValidCourseAngle(alpha1);
alpha2 = returnValidCourseAngle(alpha2);

%Convert from course angle to theta
theta = convertCourseAngleToTheta(alpha1);

%s*cos(theta) gives the east distance from p1 to p2, we need to reverse this.  Same for north distance
eastNorthDistance = [-s*cos(theta);
    -s*sin(theta)];

X = eastNorthDistance;