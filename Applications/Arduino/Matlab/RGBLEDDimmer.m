%Dim 3 LEDs on the board.  This is similar to the functionality outlined
%in \LumArduinoSDK\Examples\LED\RGBLEDDimmer\RGBLEDDimmer.ino except
%this uses the MATLAB Support Package for Arduino Hardware to achieve this
%functionality.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/14/24: Created

clear
clc
close all

%% User selections
PinLED_R = "D6";    %AKA pin 6
PinLED_G = "D5";    %AKA pin 5
PinLED_B = "D3";    %AKA pin 3

%% Setup
disp('Arduino setup')
arduinoObj = arduino("COM4", "Nano3");

configurePin(arduinoObj, PinLED_R, "PWM");
configurePin(arduinoObj, PinLED_G, "PWM");
configurePin(arduinoObj, PinLED_B, "PWM");

%% Loop
disp('Fading LEDs')
brightnessDutyCycles = linspace(0,1,20);
for k=1:2
    %Fade red
    for k=1:length(brightnessDutyCycles)
        writePWMDutyCycle(arduinoObj,PinLED_R,brightnessDutyCycles(k));
        pause(0.1);
    end

    for k=length(brightnessDutyCycles):-1:1
        writePWMDutyCycle(arduinoObj,PinLED_R,brightnessDutyCycles(k));
        pause(0.1);
    end

    %Fade green
    for k=1:length(brightnessDutyCycles)
        writePWMDutyCycle(arduinoObj,PinLED_G,brightnessDutyCycles(k));
        pause(0.1);
    end

    for k=length(brightnessDutyCycles):-1:1
        writePWMDutyCycle(arduinoObj,PinLED_G,brightnessDutyCycles(k));
        pause(0.1);
    end

    %Fade blue
    for k=1:length(brightnessDutyCycles)
        writePWMDutyCycle(arduinoObj,PinLED_B,brightnessDutyCycles(k));
        pause(0.1);
    end

    for k=length(brightnessDutyCycles):-1:1
        writePWMDutyCycle(arduinoObj,PinLED_B,brightnessDutyCycles(k));
        pause(0.1);
    end
end

%% Cleanup
disp('Clearing arduinoObj')
clear arduinoObj

disp('DONE!')