%Illustrate the usage of the 'Digital Output' block.  Specifically, this
%shows how to:
%
%   1.  Use a 'Digital Output' block to blink the built-in LED.
%   2.  Save data to the workspace.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/15/16: Created
%12/14/17: Cleaned up and verified to work.
%12/13/24: Updated for MATLAB 2024a, changed from Arduino Due to Arduino
%          Nano 3.0.  Verified to work.  

clear
clc
close all

%% User settings
T                           = 0.1;  %sample time of model
tFinal                      = Inf;
outputPin                   = 13;   %13 is connected to the Due and Nano's built-in LED
repeatingPulsePeriod        = 1;    %period of pulse
repeatingPulseWidthPercent  = 30;   %duty cycle

modelName = 'DigitalOutput_model.slx';

open(modelName);

disp('DONE!')
