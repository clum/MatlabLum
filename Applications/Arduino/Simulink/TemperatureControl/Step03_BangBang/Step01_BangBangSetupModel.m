%Bang Bang loop model with temperature control.
%
%Christopher Lum
%lum@uw.edu

%Version History
%01/11/25: Created

clear
clc
close all

ChangeWorkingDirectoryToThisLocation();

%% User settings
modelName = 'BangBangModel.slx';

tFinal_s = 7*60;
% deltaT_s = 1/2;      %time step
deltaT_s = 1/4;      %time step

% deltaT_s = 1/10;      %time step

% deltaT_s = 1/20;      %time step
% deltaT_s = 1/40;      %time step

u_ON = 0.2;   %When bang/bang controller is on, what control signal should be applied

%% Setup
cwd = pwd;
directoryLibrary = ReturnPathStringNLevelsUp(1);
addpath(directoryLibrary)
cd(cwd);

%% Global section of .ino code
%CR0
MAX31856_CR0_REG_READ   = hex2dec('0x00');  %Config 0 register (read)
MAX31856_CR0_REG_WRITE  = hex2dec('0x80');  %Config 0 register (write)

%CR1
MAX31856_CR1_REG_READ   = hex2dec('0x01');  %Config 1 register (read)
MAX31856_CR1_REG_WRITE  = hex2dec('0x81');  %Config 1 register (write)

%MASK (AKA Fault Mask Register)
MAX31856_MASK_REG_WRITE = hex2dec('0x82');  %Fault Mask register (write)

%CJTO
MAX31856_CJTO_REG_READ  = hex2dec('0x09');  %Cold-Junction Temperature Offset Register (read)
MAX31856_CJTO_REG_WRITE = hex2dec('0x89');  %Cold-Junction Temperature Offset Register (write)

%CJTL/CJTH
MAX31856_CJTH_REG_READ  = hex2dec('0x0A');  %Cold-Junction Temperature Register, MSB (read)
MAX31856_CJTL_REG_READ  = hex2dec('0x0B');  %Cold-Junction Temperature Register, LSB (read)

%LTCBH/LTCBM/LTCBL
MAX31856_LTCBH_REG_READ = hex2dec('0x0C');  %Linearized TC Temperature, Byte 2
MAX31856_LTCBM_REG_READ = hex2dec('0x0D');  %Linearized TC Temperature, Byte 1
MAX31856_LTCBL_REG_READ = hex2dec('0x0E');  %Linearized TC Temperature, Byte 0

disp('Arduino setup')
disp('N/A')

disp('SPI setup')
pin_CS = 10;

%You can set SPI properties such as the SPI clock out frequency (in MHz),
%SPI mode, and the Bit order in the Configuration Parameters > Hardware
%Implementation > SPI properties section. 
%https://www.mathworks.com/help/simulink/supportpkg/arduino_ug/support-spi-communication.html
% SPIMaxSpeed_hz = 1000000;
% spiMode = 1;
warning('Need to programatically set these in configuration settings.')
% max31856SpiSettings = device(a,'SPIChipSelectPin',pin_CS);
% max31856SpiSettings.BitRate = SPIMaxSpeed_hz;
% max31856SpiSettings.SPIMode = spiMode;

%% PWM Output
PinPWM  = 3;

%% Compute parameters

%% Open model
open(modelName);

disp('Run model via Hardware > Monitor & Tune')

disp('DONE!')
