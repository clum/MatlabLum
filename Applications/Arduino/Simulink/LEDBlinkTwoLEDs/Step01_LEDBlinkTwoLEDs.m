%Blink 2 LEDs on the board.  This is similar to the functionality outlined
%in \LumArduinoSDK\Examples\LED\LEDBlinkTwoLEDs\LEDBlinkTwoLEDs.ino except
%this uses the Simulink Support Package for Arduino Hardware to achieve
%this functionality.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/13/24: Created
%12/14/24: Continued working

clear
clc
close all

%% User settings
PinLED_R                    = 6;    %AKA D6
PinLED_G                    = 5;    %AKA D5
T                           = 0.1;  %sample time of model
tFinal                      = 5;
repeatingPulsePeriod        = 1;    %period of pulse
repeatingPulseWidthPercent  = 70;   %duty cycle

modelName = 'LEDBlinkTwoLEDs_model.slx';

%% Open model
open(modelName);

disp('Run model via Hardware > Monitor & Tune')

disp('DONE!')
