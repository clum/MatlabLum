%Christopher Lum
%lum@uw.edu
%
%Illustrate the usage of the 'Analog Output' block.  Specifically, this
%shows how to:
%
%   1.  Use a 'Digital Output' block to blink the built in LED.
%   2.  Save data to the workspace.
%
%Version History
%12/22/17: Created

clear
clc
close all

%% User settings
T                           = 0.1;  %sample time of model
tFinal                      = Inf;

modelName = 'AnalogOutput_model.slx';

open(modelName);

disp('DONE!')
