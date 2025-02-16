%Simulation of Bang/bang with hysteresis deadband for temperature control.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/26/25: Created
%01/31/25: Updating pathing

clear
clc
close all

ChangeWorkingDirectoryToThisLocation();

%% User settings
outputFile      = 'BangBangHysteresisSimulinkData_IDXX.mat';
simulinkModel   = 'SimulationBangBangHysteresisModel.slx';
deltaT_s = 0.01;
tFinal_s = 7*60;

%Plant parameters
K           = 49;
zeta        = 1.5;
wn          = 0.03;
Tdelay_s    = 1.2;
Tambient_C  = 24.1875;
noisePower  = .00001;

%Controller parameters
u_ON = 1;       %When bang/bang controller is on, what control signal should be applied
deadbandSize_C = 2;

controllerSelection = 3;    %1 = BangBangControllerType01 (bang/bang)
                            %2 = BangBangControllerType02 (bang/bang w/ hysteresis with memory block)
                            %3 = BangBangControllerType03 (bang/bang w/ hysteresis in stateflow)

%% Pathing
cwd = pwd;
addpath(ReturnPathStringNLevelsUp(2));

%% Simulate model
simout = sim(simulinkModel);

%% Save data
saveVars = {
    'K'
    'zeta'
    'wn'
    'Tdelay_s'
    'Tambient_C'
    'noisePower'
    'u_ON'
    'deadbandSize_C'
    'controllerSelection'
    'simout'
    };

s = SaveVarsString(outputFile,saveVars);
eval(s);
disp(['Saved data to ',outputFile])

disp('DONE!')
