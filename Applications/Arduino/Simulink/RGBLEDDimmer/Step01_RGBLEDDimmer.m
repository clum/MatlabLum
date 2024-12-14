%Dim 3 LEDs on the board.  This is similar to the functionality outlined
%in \LumArduinoSDK\Examples\LED\RGBLEDDimmer\RGBLEDDimmer.ino except
%this uses the Simulink Support Package for Arduino Hardware to achieve
%this functionality.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/14/24: Created

clear
clc
close all

%% User settings
PinLED_R                    = 6;    %AKA D6
PinLED_G                    = 5;    %AKA D5
PinLED_B                    = 3;    %AKA D3
T                           = 0.1;  %sample time of model
tFinal                      = 10;

modelName = 'RGBLEDDimmer_model.slx';

%% Compute parameters
t_c = tFinal/3;

t_R = [0 t_c/2 t_c tFinal];
y_R = [0 255 0 0];

t_G = [0 t_c (t_c+t_c/2) 2*t_c tFinal];
y_G = [0 0 255 0 0];

t_B = [0 2*t_c (2*t_c+t_c/2) tFinal];
y_B = [0 0 255 0];

%% Open model
open(modelName);

disp('Run model via Hardware > Monitor & Tune')

disp('DONE!')
