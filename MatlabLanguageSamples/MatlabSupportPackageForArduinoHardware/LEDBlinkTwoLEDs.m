%Blink 2 LEDs on the board.  This is similar to the functionality outlined
%in \LumArduinoSDK\Examples\LED\LEDBlinkTwoLEDs\LEDBlinkTwoLEDs.ino except
%this uses the MATLAB Support Package for Arduino Hardware to achieve this
%functionality.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/13/24: Created

clear
clc
close all

%% User selections
PinLED_R = 'A4';
PinLED_G = 'A5';

%% Setup
disp('Arduino setup')
arduinoObj = arduino("COM4", "Nano3", Libraries = ["I2C","SPI","Servo"]);

configurePin(arduinoObj, PinLED_R, "DigitalOutput");
configurePin(arduinoObj, PinLED_G, "DigitalOutput");

%% Loop
disp('Blinking LEDs')
for k=1:5
    writeDigitalPin(arduinoObj,PinLED_R,1);
    writeDigitalPin(arduinoObj,PinLED_G,0);
    pause(0.5)
    writeDigitalPin(arduinoObj,PinLED_R,0);
    writeDigitalPin(arduinoObj,PinLED_G,1);
    pause(0.5)
end

%% Cleanup
disp('Clearing arduinoObj')
clear arduinoObj

disp('DONE!')