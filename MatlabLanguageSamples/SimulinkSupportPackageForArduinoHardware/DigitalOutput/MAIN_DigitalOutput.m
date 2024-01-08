%Christopher Lum
%lum@uw.edu
%
%Illustrate the usage of the 'Digital Output' block.  Specifically, this
%shows how to:
%
%   1.  Use a 'Digital Output' block to blink the built in LED.
%   2.  Save data to the workspace.
%
%Version History
%12/15/16: Created
%12/14/17: Cleaned up and verified to work.

clear
clc
close all

%% User settings
T                           = 0.1;  %sample time of model
tFinal                      = Inf;
outputPin                   = 13;   %13 is connected to the Due's built in LED
repeatingPulsePeriod        = 1;    %period of pulse
repeatingPulseWidthPercent  = 30;   %duty cycle

modelName = 'DigitalOutput_model.slx';

open(modelName);

disp('DONE!')
