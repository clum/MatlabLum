%Christopher Lum
%lum@uw.edu
%
%Illustrate using the 'Analog Input' block from the Simulink Support
%Package for Arduino Hardware' blockset.
%
%See Simulink models for more information.

%Version History
%12/28/16: Created
%12/14/17: Updated documentation
%10/03/18: Verified to work with Matlab R2016b after implementing work
%          around.  See Chris Lum YouTube channel on 'Installing MinGW-w64
%          on Matlab'.

clear
clc
close all

%% User settings
T               = 0.1;
tFinal          = inf;
pinNumber       = 1;    %should be an analog in pin (0=A0, 1=A1, 2=A2, etc.)
modelSelection  = 1;    %1 = 10-bit model, 2 = 12-bit model

if(modelSelection==1)
    modelName = 'AnalogInput10Bit_model.slx';
    
elseif(modelSelection==2)
    modelName = 'AnalogInput12Bit_model.slx';
    
else
    error('Unknown selection')
end

open(modelName);

disp('DONE!')
