function [PATHS] = GetPathsMatlabLum()

%GETPATHSMATLABLUM Gets paths for the MatlabLum SDK
%
%   [PATHS] = GETPATHSMATLABLUM() returns paths for the MatlabLum SDK.
%
%INPUT:     -None
%
%OUTPUT:    -PATHS: cell array of paths
%
%Christopher Lum
%lum@uw.edu

%Version History
%11/23/23: Created
%01/14/24: Added Mapping
%01/20/24: Added Simulink
%10/24/24: Added Simulation
%11/30/24: Added Conversions
%01/07/25: Added Controls
%02/15/25: Added FlightMechanics and Networking
%03/09/25: Added Construction

REPO_DIR = fileparts(mfilename('fullpath'));

PATHS = {};

%-------------------------CUSTOM TOOLBOXES----------------------------
%AIML
PATHS{end+1,1} = [REPO_DIR,'\SDK\AIML'];

%Construction
PATHS{end+1,1} = [REPO_DIR,'\SDK\Construction'];

%Controls
PATHS{end+1,1} = [REPO_DIR,'\SDK\Controls'];

%Conversions
PATHS{end+1,1} = [REPO_DIR,'\SDK\Conversions'];

%FlightMechanics
PATHS{end+1,1} = [REPO_DIR,'\SDK\FlightMechanics'];

%Graphics
PATHS{end+1,1} = [REPO_DIR,'\SDK\Graphics'];

%Mapping
PATHS{end+1,1} = [REPO_DIR,'\SDK\Mapping'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Mapping\MicaSense'];

%Misc
PATHS{end+1,1} = [REPO_DIR,'\SDK\Misc'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Misc\tableManipulator'];

%Networking
PATHS{end+1,1} = [REPO_DIR,'\SDK\Networking'];

%Probability
PATHS{end+1,1} = [REPO_DIR,'\SDK\Probability'];

%Simulation
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulation\FlightPatterns'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulation\OccupancyMap'];

%Simulink
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\AircraftModels'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\AircraftModels\PlanarVehicleResources'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\AircraftModels\PlanarVehicleResources\Simulink3D'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\AircraftModels\QuadRotorResources'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\AircraftModels\QuadRotorResources\ParrotSimulink3D'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\AircraftModels\RCAMResources'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\BlocksetFunctions'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumAerospaceBlockset\LumAerospaceBlocksetResources'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumArduinoBlockset'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumControlsBlockset'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumMiscBlockset'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumSimulink3DAnimationBlockset'];
PATHS{end+1,1} = [REPO_DIR,'\SDK\Simulink\LumSimulink3DAnimationBlockset\backgrounds'];

%-------------------------THIRD PARTY CODE---------------------------------
%Real-time blockset
PATHS{end+1,1} = [REPO_DIR,'\ThirdPartyCode\RTBlockset'];

%UDP_toolbox
PATHS{end+1,1} = [REPO_DIR,'\ThirdPartyCode\UDP_toolbox\tcp_udp_ip_2_0_6\tcp_udp_ip'];
