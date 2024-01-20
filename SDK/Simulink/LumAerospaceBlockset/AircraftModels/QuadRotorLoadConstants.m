function [varargout] = QuadRotorLoadConstants(varargin)

%QUADROTORLOADCONSTANTS  Loads constants for a quad-rotor model.
%
%   [AERO, GEOMETRY, PROPULSION, SIMULATION, ENVIRONMENT, INPUTS,
%   CONTROLLER] = QUADROTORLOADCONSTANTS() loads constants for the nominal
%   airframe, a DJI Inspire 1.
%
%   [...] = QUADROTORLOADCONSTANTS(AIRFRAME) does as above but uses
%   constants for the specified AIRFRAME.  Valid values for AIRFRAME are 
%
%       'DJIInspire1' = DJI Inspire 1
%
%   [...] = QUADROTORLOADCONSTANTS(AIRFRAME, SCENARIO) does as above but
%   uses constants for the specified SCENARIO.  Valid values for SCENARIO
%   are
%
%       1 = straight down drop with no thrust
%       2 = same as 1 but with some initial velocity in north direction
%       3 = same as 1 but with some initial velocity in east direction
%       4 = same as 1 but with some initial velocity in west direction and
%           some initial yaw rate
%       5 = same as 1 but with some initial velocity in up direction and
%           some initial yaw rate
%       6 = hover in place with no translational velocity
%       7 = straight forward initial condition with zero Euler angles with
%           asymetric thrust (which should induce some yaw rate).
%       8 = hover in place with motors on opposite ends
%       9 = 
%      10 = 100 ft tumble with constant wind field
%      11 = open loop forward flight at 5 m/s
%      12 = 100 ft elevation, contant wind @ 10 m/s magnitude in -45deg direction, with one failed motor   
%      13 = Nominal Scenario :  
%
%INPUT:     -AIRFRAME:      string denoting the desired airframe
%           -SCENARIO:      integer denoting the desired scenario
%
%OUTPUT:    -AERO:          structure of aerodynamic constants
%           -GEOMETRY:      structure of geometry constants
%           -PROPULSION:    structure of propulsion constants
%           -SIMULATION:    structure of simulation constants
%           -ENVIRONMENT:   structure of environment constants
%           -INPUTS:        structure of input signals
%           -CONTROLLER:    structure of controller constants
%
%Created by Christopher Lum
%lum@uw.edu

%Version History
%10/14/14: Created from older file
%10/17/14: Updated payload information
%01/07/15: Removed degtorad dependencies
%05/24/15: Fixed a0 term in CLwb expression to avoid discontinuity in the
%          curve
%01/07/19: Updated for 2019.
%02/06/19: Updated to change scenarios easily
%03/07/19: Updating parameters for DJI Insipre
%03/24/19: Moved to
%          \\UWMatlab\UWMatlab\Simulink\UWAerospaceBlockset\AircraftModels
%03/26/19: Added documentation regarding the scenarios to the file
%03/27/19: Updating sign of damping derivatives.  Updated motor specs with
%          researched data.
%04/02/19: Added Inertia Matrix information  - subject to change due to
%          ongoing calculations
%04/18/19: Added wind.  Added scenario 9
%04/23/19: Add scenario 11 (open loop forward flight at 5 m/s)
%04/23/19: Add scenario 12 (fails with one motor switched off, constant
%          wind field 10 m/s mag. and -45deg direction) - added variable to
%          vary angle of wind direction
%06/04/19: Added CONTROLLER structure
% Added Scenario 13 describing Nominal Scenarion

%----------------------OBTAIN USER PREFERENCES-----------------------------
switch nargin
    case 2
        %User supplies all inputs
        AIRFRAME    = varargin{1};
        SCENARIO    = varargin{2};
        
    case 1
        %Assume SCENARIO 1
        AIRFRAME    = varargin{1};
        SCENARIO    = 1;
        
    case 0
        %Assume DJI Inspire 1 and everything above
        AIRFRAME    = 'DJIInspire1';
        SCENARIO    = 1;
        
    otherwise
        error('Invalid number of inputs');
end

%-----------------------CHECKING DATA FORMAT-------------------------------

%-------------------------BEGIN CALCULATIONS-------------------------------

%------------------GEOMETRY-------------------
if(strcmp(AIRFRAME,'DJIInspire1'))
    warning('All geometry needs to be verified, these are placeholders')
    GEOMETRY.mass           = 3.060;               %Aircraft total mass (kg)
    GEOMETRY.S              = 1;                   %reference area (m^2)
    GEOMETRY.bref           = 0.5;                 %reference length (m)
    
    Lx = UWConversionFactorsLength.InchesToMeters(17/2);
    Ly = UWConversionFactorsLength.InchesToMeters(9.5);
    Lz = UWConversionFactorsLength.InchesToMeters(2);
    
    %Motor 1
    GEOMETRY.Xapt1          = Lx;
    GEOMETRY.Yapt1          = Ly;
    GEOMETRY.Zapt1          = -Lz;
    
    %Motor 2
    GEOMETRY.Xapt2          = Lx;
    GEOMETRY.Yapt2          = -Ly;
    GEOMETRY.Zapt2          = -Lz;
    
    %Motor 3
    GEOMETRY.Xapt3          = -Lx;
    GEOMETRY.Yapt3          = -Ly;
    GEOMETRY.Zapt3          = -Lz;
    
    %Motor 4
    GEOMETRY.Xapt4          = -Lx;
    GEOMETRY.Yapt4          = Ly;
    GEOMETRY.Zapt4          = -Lz;    
    
    % Moment of Inertia Matrix - Subject to change     
    GEOMETRY.Ib             = [0.0505 0 0;0 0.0393 0;0 0 0.0657];
else
    error('Unknown AIRFRAME')
    
end

%--------------------AERO---------------------
if(strcmp(AIRFRAME,'DJIInspire1'))
    AERO.Static.CD          = 0.5;                  %Coefficient of drag 
    AERO.Unsteady.dMxbdp    = -0.2;                 %dMx,b/dp (roll damping about body x axis)
    AERO.Unsteady.dMybdq    = -0.2;                 %dMy,b/dq (pitch damping about body y axis)
    AERO.Unsteady.dMzbdr    = -0.2;                 %dMz,b/dr (yaw damping about body z axis)
    
else
    error('Unknown AIRFRAME')
    
end

%----------------PROPULSION-------------------
if(strcmp(AIRFRAME,'DJIInspire1'))
    %Data from https://www.circuitstreet.com/products/dji-inspire-1-v2-0-quadcopter-with-4k-camera-and-3-axis-gimbal?	taxon_id=59
    PROPULSION.Tmax         = UWConversionFactorsForce.LbfToNewton(4.8);            %maximum thrust provided by one motor (N)
    
    %Data from https://rcbenchmark.gitlab.io/docs/en/dynamometer/theory/how-to-measure-brushless-motor-and-propeller-efficiency.html 
    %and https://docs.google.com/spreadsheets/d/18H2PGe0Ep95WG88wOD96KW2jDxnQON9pS_v9SgAnb1E/edit#gid=0
    PROPULSION.Mmax         = UWConversionFactorsMoment.InchLbfToNewtonMeters(5);   %maximum moment generated by one motor (Nm)
       
else
    error('Unknown AIRFRAME')
    
end

%-----------------SIMULATION------------------
if(SCENARIO==1)
    u0 = 0;
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 3;
    sample_time  = 0.05;
    
elseif(SCENARIO==2)
    u0 = UWConversionFactorsVelocity.KnotstoMetersPerSec(20);
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 30;
    sample_time  = 0.05;
    
elseif(SCENARIO==3)
    u0 = 0;
    v0 = UWConversionFactorsVelocity.KnotstoMetersPerSec(20);
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 3;
    sample_time  = 0.05;
   
elseif(SCENARIO==4)
    u0 = 0;
    v0 = UWConversionFactorsVelocity.KnotstoMetersPerSec(-20);
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 2*pi*2;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 3;
    sample_time  = 0.05;
    
elseif(SCENARIO==5)
    u0 = 0;
    v0 = 0;
    w0 = UWConversionFactorsVelocity.KnotstoMetersPerSec(-20);
    p0 = 0;
    q0 = 0;
    r0 = 2*pi*2;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.05;
    
elseif((SCENARIO==6) || (SCENARIO==9))
    u0 = 0;
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.05;
    
elseif(SCENARIO==7)
    u0 = UWConversionFactorsVelocity.KnotstoMetersPerSec(20);
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.005;

elseif(SCENARIO==8)
    u0 = 0;
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.05;
    
elseif(SCENARIO==9)
    u0 = 0;
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.05;
    
elseif(SCENARIO==10)
    u0 = 0;
    v0 = 0;
    w0 = 0;
    p0 = -4*pi;
    q0 = -2*pi;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.005;
    
elseif(SCENARIO==11)
    u0 = 4.8449;
    v0 = 0;
    w0 = -1.2357;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = -0.24973;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.05;

elseif(SCENARIO==12)
    u0 = 0;
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = UWConversionFactorsLength.FtToM(-100);
    
    final_time   = 15;
    sample_time  = 0.05;
    
elseif(SCENARIO==13)
    u0 = UWConversionFactorsVelocity.KnotstoMetersPerSec(10); % Need to decide upon range of variation and 
    v0 = 0;
    w0 = 0;
    p0 = 0;
    q0 = 0;
    r0 = 0;
    phi0 = 0;
    theta0 = 0;
    psi0 = 0;
    PN0 = 0;
    PE0 = 0;
    PD0 = -30; % Range fopr nominal scenarios : 30, 60, 90 and 110 meters - can be toggled by user
    
    final_time   = 60;
    sample_time  = 0.05;
    
else
    error('Unknown SCENARIO')
end

SIMULATION.X_0 = [
    u0;
    v0;
    w0;
    p0;
    q0;
    r0;
    phi0;
    theta0;
    psi0;
    PN0;
    PE0;
    PD0
    ];

SIMULATION.final_time = final_time;     %final time of simulation (sec)
SIMULATION.sample_time = sample_time;   %simulation time step (if applicable for selected solver) (sec)

lat_0 = UWConversionFactorsMisc.DegreeToRadian(47.6205027777778);   %Space needle, Seattle
lon_0 = UWConversionFactorsMisc.DegreeToRadian(-122.349497222222);  %Space needle, Seattle
h_0   = -SIMULATION.X_0(12);

SIMULATION.Xgeodetic_0  = [lat_0;lon_0;h_0];        %initial lat, lon, and altitude (units of rad, rad, m)

%----------------ENVIRONMENT------------------
ENVIRONMENT.air_density             = 1.225;                    %Air density (kg/m^3)
ENVIRONMENT.gravitational_constant  = 9.81;                     %gravitational acceleration (m/s^2)
ENVIRONMENT.wind_NED                = [0;0;0];                  %wind velocity expressed in NED (m/s)

if(SCENARIO==9 || ...
        SCENARIO==10)
    ENVIRONMENT.wind_NED                = [-10;10;0];
end

if(SCENARIO==12)
    theta_ang = -45;
    % tranformation matrix for in-plane rotation
    R = [cosd(theta_ang), -sind(theta_ang), 0;
         sind(theta_ang), cosd(theta_ang),  0 ;
                    0,             0,       1];
     
    ENVIRONMENT.wind_NED              = 10*R*[1;0;0];
end   
    
if(SCENARIO == 13)
    
    % 1. Need to include linear wind model for environment
    % 2. Need to include provision for winds with direction - 3D rotation
    % of wind vector
    
    ENVIRONMENT.wind_NED              = [0;0;0];
    
    % Parameters for Linear Model of Wind Speed Variation with height
    
    %Uncomment once design finalised
    %ENVIRONMENT.wind_Hmax = UWConversionFactorsLength.FtToM(500);
    %ENVIRONMENT.wind_Vmax = UWConversionFactorsVelocity.KnotstoMetersPerSec(20);
    
end    

%-----------------INPUTS----------------------
if(SCENARIO==1 || ...
        SCENARIO==2 || ...
        SCENARIO==3 || ...
        SCENARIO==4 || ...
        SCENARIO==5 || ...
        SCENARIO==10)
    %no thrust
    u1 = [0; 0];
    u2 = [0; 0];
    u3 = [0; 0];
    u4 = [0; 0];
    
    values = [u1 u2 u3 u4];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
elseif((SCENARIO==6) || (SCENARIO==9))
    u1 = [0.35136; 0.35136];
    u2 = [0.35136; 0.35136];
    u3 = [0.35136; 0.35136];
    u4 = [0.35136; 0.35136];
    
    values = [u1 u2 u3 u4];
    
    U.time = [0; final_time];
    U.signals.values = values;
        
elseif(SCENARIO==7)
    deltaU = 0.2;
    u1 = [0.35136; 0.35136] - deltaU;
    u2 = [0.35136; 0.35136] + deltaU;
    u3 = [0.35136; 0.35136] - deltaU;
    u4 = [0.35136; 0.35136] + deltaU;
        
    values = [u1 u2 u3 u4];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
elseif(SCENARIO==8)
    u1 = [0.35136; 0.35136];
    u2 = [0; 0];
    u3 = [0.35136; 0.35136];
    u4 = [0; 0];
    
    values = [u1 u2 u3 u4];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
elseif(SCENARIO==11)
    u1 = [0.36261; 0.36261];
    u2 = u1;
    u3 = u1;
    u4 = u2;
    
    values = [u1 u2 u3 u4];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
elseif(SCENARIO==12)
    u1 = [0.36261; 0.36261];
    u2 = u1;
    u3 = u1;
    u4 = [0; 0]; % Set motor 4 to zero
    
    values = [u1 u2 u3 u4];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
elseif(SCENARIO == 13)
    u1 = [0.35136; 0.35136];
    u2 = [0.35136; 0.35136];
    u3 = [0.35136; 0.35136];
    u4 = [0.35136; 0.35136];
    
    values = [u1 u2 u3 u4];
    
    U.time = [0; final_time];
    U.signals.values = values;
    
else
    error('Unknown SCENARIO')
end

INPUTS.U = U;


%-----------------CONTROLLER----------------------
%Define tau parameter : Control Authority
CONTROLLER.InnerLoopController.tau = [0.05;
        0.05;
        0.5;
        0.3];
    
%Define U_o
CONTROLLER.Uo = [0.351;
                  0.351;
                  0.351;
                  0.351];

%Define the Inner Loop Controller gains corresponding to altitude, yaw, pitch and roll 
CONTROLLER.InnerLoopController.k_p_roll =  0.86;
CONTROLLER.InnerLoopController.k_i_roll = 1.7;
CONTROLLER.InnerLoopController.k_p_pitch = 0.86;
CONTROLLER.InnerLoopController.k_i_pitch = 1.7;
CONTROLLER.InnerLoopController.k_p_yaw = 2.22;
CONTROLLER.InnerLoopController.k_i_yaw = 0;
CONTROLLER.InnerLoopController.k_p_z = 3.8;
CONTROLLER.InnerLoopController.k_i_z = 0.0034;
CONTROLLER.InnerLoopController.k_d_z = 1.22;

%Define parameters for Waypoint Tracking Controller
CONTROLLER.WaypointTrackingController.theta_forward = deg2rad(-10);

%Define parameters for waypoint tracking
CONTROLLER.WaypointRadius = 5;

%Output the data
varargout{1} = AERO;
varargout{2} = GEOMETRY;
varargout{3} = PROPULSION;
varargout{4} = SIMULATION;
varargout{5} = ENVIRONMENT;
varargout{6} = INPUTS;
varargout{7} = CONTROLLER;
