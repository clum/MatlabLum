%Save data from the bang/bang w/ hysteresis Simulink model.
%
%Christopher Lum
%lum@uw.edu

%Version History
%02/01/25: Created

clc
close all

%% User settings
outputFile  = 'BangBangHysteresisSimulinkData_IDXX.mat';

%% Save data
saveVars = {
    'logsout'
    'u_ON'
    'deadbandSize_C'};
s = SaveVarsString(outputFile,saveVars);
eval(s)

disp(['Saved to ',outputFile])

disp('DONE!')
