%Save data from a MAX31856 Simulink model.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/04/25: Created

clc
close all

%% User settings
outputFile  = 'MAX31856SimulinkData_IDXX.mat';

%% Save data
save(outputFile,'logsout')
disp(['Saved to ',outputFile])

disp('DONE!')
