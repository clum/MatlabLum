function [varargout] = PlanarVehicleLoadConstants(varargin)

%PLANARVEHICLESLOADCONSTANTS  Loads constants for a planar vehicle
%
%   [GEOMETRY, PROPULSION, SIMULATION, ENVIRONMENT, INPUTS] =
%   PLANARVEHICLESLOADCONSTANTS() loads constants for the nominal vehicle,
%   a simple planar boat.
%
%   [...] = PLANARVEHICLESLOADCONSTANTS(VEHICLE) does as above but uses
%   constants for the specified VEHICLE.  Valid values for VEHICLE are 
%
%       'Boat' = a simple boat
%
%   [...] = PLANARVEHICLESLOADCONSTANTS(VEHICLE, SCENARIO) does as above
%   but uses constants for the specified SCENARIO.  Valid values for
%   SCENARIO are
%
%       1 = no initial conditions and no inputs
%       2 = initial velocity and theta = 45 deg and no inputs
%       3 = no translational movement, only initial rotational velocity and
%           no inputs
%       4 = initial velocity in +y direction but initial heading is in +x
%           with input thrust at half capacity (no input moment).
%       5 = only movement in +x direction at full thrust (no input moment)
%           to assess terminal translational velocity
%       6 = only rotational movement at full moment (no input thrust) to
%           assess terminal rotational velocity
%
%INPUT:     -VEHICLE:       string denoting the desired vehicle
%           -SCENARIO:      integer denoting the desired scenario
%
%OUTPUT:    -GEOMETRY:      structure of geometry constants
%           -PROPULSION:    structure of propulsion constants
%           -SIMULATION:    structure of simulation constants
%           -ENVIRONMENT:   structure of environment constants
%           -INPUTS:        structure of input signals
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%03/26/19: Created
%03/27/19: Added PROPULSION constants
%05/28/19: Updated drag coefficients

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        VEHICLE     = varargin{1};
        SCENARIO    = varargin{2};
        
    case 1
        %Assume SCENARIO 1
        VEHICLE     = varargin{1};
        SCENARIO    = 1;
        
    case 0
        %Assume a simple boat and everything above
        VEHICLE     = 'Boat';
        SCENARIO    = 1;
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------

%------------------GEOMETRY-------------------
if(strcmp(VEHICLE,'Boat'))
    GEOMETRY.mass   = 10;                   %total mass (kg)    
    GEOMETRY.Ib     = GEOMETRY.mass*0.5;    %moment of inertia (kg*m^2)
else
    error('Unknown VEHICLE')
    
end

%-----------------PROPULSION------------------
if(strcmp(VEHICLE,'Boat'))
    %Note 
    %Fmax = 10 corresponds to approximate terminal translational velocity of 20 m/s
    %Mmax = 5 corresponds to approximate terminal rotational velocity of 6.667 rad/s
    PROPULSION.Fmax   = 10;                 %maximum force (N)
    PROPULSION.Mmax   = 0.5;                %maximum moment (N*m)
    
else
    error('Unknown VEHICLE')
    
end

%-----------------SIMULATION------------------
if(SCENARIO==1)
    %No initial conditions
    x0          = 0;
    y0          = 0;
    xDot0       = 0;
    yDot0       = 0;
    theta0      = 0;
    thetaDot0   = 0;
    
    final_time   = 10;
    sample_time  = 0.05;
        
elseif(SCENARIO==2)
    %initial speed and theta
    x0          = 0;
    y0          = 0;
    xDot0       = 10;
    yDot0       = 10;
    theta0      = deg2rad(45);
    thetaDot0   = 0;
    
    final_time   = 10;
    sample_time  = 0.05;
    
elseif(SCENARIO==3)
    %No translational movement, only rotational movement
    x0          = 0;
    y0          = 0;
    xDot0       = 0;
    yDot0       = 0;
    theta0      = 0;
    thetaDot0   = deg2rad(360);
    
    final_time   = 10;
    sample_time  = 0.05;
    
elseif(SCENARIO==4)
    %Initial velocity in +y but heading is +x
    x0          = 0;
    y0          = 0;
    xDot0       = 0;
    yDot0       = 20;
    theta0      = 0;
    thetaDot0   = 0;
    
    final_time   = 10;
    sample_time  = 0.05;
    
elseif((SCENARIO==5) || ...
        (SCENARIO==6))
    %No ICs
    x0          = 0;
    y0          = 0;
    xDot0       = 0;
    yDot0       = 0;
    theta0      = 0;
    thetaDot0   = 0;
    
    final_time   = 100;
    sample_time  = 0.05;
    
else
    error('Unknown SCENARIO')
end

SIMULATION.X_0 = [
    x0;
    y0;
    xDot0;
    yDot0;
    theta0;
    thetaDot0
    ];

SIMULATION.final_time = final_time;     %final time of simulation (sec)
SIMULATION.sample_time = sample_time;   %simulation time step (if applicable for selected solver) (sec)

%----------------ENVIRONMENT------------------
ENVIRONMENT.CT  = 1/40;     %coefficient of translational friction (N*s^2/m^2)
ENVIRONMENT.CR  = 0.75;     %coefficient of rotational friction (N*m*s)

%-----------------INPUTS----------------------
if(SCENARIO==1 || ...
        SCENARIO==2 || ...
        SCENARIO==3)
    %no inputs
    u1 = [0; 0];
    u2 = [0; 0];
    
    values = [u1 u2];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
elseif(SCENARIO==4)
    %only u1 input (half throttle)
    u1 = [0.5; 0.5];
    u2 = [0; 0];
    
    values = [u1 u2];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
elseif(SCENARIO==5)
    %only u1 input (full throttle)
    u1 = [1; 1];
    u2 = [0; 0];
    
    values = [u1 u2];
    
    U.time = [0; final_time];
    U.signals.values = values;
   
elseif(SCENARIO==6)
    %only u2 input (full throttle)
    u1 = [0; 0];
    u2 = [1; 1];
    
    values = [u1 u2];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
else
    error('Unknown SCENARIO')
end

INPUTS.U = U;

%Output the data
varargout{1} = GEOMETRY;
varargout{2} = PROPULSION;
varargout{3} = SIMULATION;
varargout{4} = ENVIRONMENT;
varargout{5} = INPUTS;
