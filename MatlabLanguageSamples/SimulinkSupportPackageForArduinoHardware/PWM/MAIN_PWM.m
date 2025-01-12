%Illustrate the usage of the 'PWM' block.  Specifically, this
%shows how to:
%
%   1.  Output a PWM signal using the 'PWM' block.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/11/25: Created

clear
clc
close all

%% User settings
T       = 0.1;  %sample time of model
tFinal  = 30;
PinPWM  = 3;

modelName = 'PWM_model.slx';

open(modelName);

disp('DONE!')
