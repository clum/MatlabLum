%Christopher Lum
%lum@u.washington.edu
%
%Illustrate using the 'Serial Transmit' block from the Simulink Support
%Package for Arduino Hardware' blockset.

%Version History:   10/21/16: Created

clear
clc
close all


%% User settings
T = 0.01;

modelName = 'SerialTransmit_model.slx';

open(modelName);

disp('DONE!')
