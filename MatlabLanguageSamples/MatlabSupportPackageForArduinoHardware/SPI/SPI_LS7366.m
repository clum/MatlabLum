%Christopher Lum
%lum@u.washington.edu
%
%Manipulate the Arduino Due's SPI interface using Matlab.
%
%This is based on a tutorial located at 
%https://www.mathworks.com/help/supportpkg/arduinoio/ug/communicate-with-spi-device-on-arduino-hardware.html

%Version History:   12/15/16: Created

clear
clc
close all

tic

%% User settings
ledPin = 'D13';     %D13 for built-in LED


%Instantiate an arduino object
port = 'COM5';
board = 'Due';
a = arduino(port, board, 'Libraries', 'SPI');
disp(['Time to connect to board: ',num2str(toc), ' sec'])

%Create an object for interacting with the LS7366 via SPI
dev = spidev(a,'D39');

%Write MDR0
writeRead(dev, [hex2dec('88') hex2dec('03')]);

%Write MDR1
writeRead(dev, [hex2dec('90') hex2dec('03')]);

%Clear STR
writeRead(dev, hex2dec('30'));

%Clear counter
writeRead(dev, [hex2dec('98') hex2dec('00')]);  %Write to DTR
writeRead(dev, hex2dec('E0'));                  %transfer DTR to CNTR
  
%Read CNTR
for k=1:120
    disp(['k = ',num2str(k)])
    value = writeRead(dev, [hex2dec('60') hex2dec('00')]);
    
    disp('Assuming a 1-byte counter mode')
    count = value(2)
    pause(1);    
end

%% clean up
clear a

disp(['Total time: ',num2str(toc),' seconds'])
disp('DONE!')