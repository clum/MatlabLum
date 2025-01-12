%Save data from the bang/bang Simulink model.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/11/25: Created

clc
close all

%% User settings
outputFile  = 'BangBangSimulinkData_IDXX.mat';

%% Save data
save(outputFile,'logsout')
disp(['Saved to ',outputFile])

disp('DONE!')
