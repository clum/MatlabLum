%Christopher Lum
%lum@uw.edu
%
%Illustrate using the 'Digital Input' block from the Simulink Support
%Package for Arduino Hardware' blockset.
%
%This uses the Arduino to output a signal which is then read back in using
%the 'Digital Input' block.  See the Simulink model for more information.

%Version History
%10/23/16: Created
%12/14/17: Updated documentation

clear
clc
close all

%% User settings
T                           = 0.01; %sample time of model
tFinal                      = Inf;
repeatingPulsePeriod        = 1;    %period of pulse
repeatingPulseWidthPercent  = 30;   %duty cycle

modelName = 'DigitalInput_model.slx';

open(modelName);

disp('DONE!')
