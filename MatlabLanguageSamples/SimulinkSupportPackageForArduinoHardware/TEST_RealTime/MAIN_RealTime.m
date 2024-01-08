%Christopher Lum
%lum@u.washington.edu
%
%Test the to see if the Arduino is running in real time
%
%Version History:   12/01/16: Created

clear
clc
close all


%% User settings
T = 0.001;

tFinal = inf;

K_preamp = 6;
K_kepco = -2;

PulseAmplitude = 2;
PulsePeriod = 1;
PulseWidth = 25;

modelName = 'RealTime_model.slx';

open(modelName);

disp('DONE!')
