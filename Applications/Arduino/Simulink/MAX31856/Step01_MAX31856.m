%Interface with a MAX31856 via SPI.  This is similar to the functionality
%outlined in \LumArduinoSDK\Examples\MAX31856\SPI_OneShot\SPI_OneShot.ino
%except this uses the Simulink Support Package for Arduino Hardware to
%achieve this functionality.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/14/24: Created
%12/19/24: Continued working after getting MATLAB version to work

clear
clc
close all

%% User settings
modelName = 'MAX31856_model.slx';

tFinal_s = 30;
deltaT_s = 1;      %time step

%% Global section of .ino code
%CR0
MAX31856_CR0_REG_READ   = hex2dec('0x00');  %Config 0 register (read)
MAX31856_CR0_REG_WRITE  = hex2dec('0x80');  %Config 0 register (write)

%CR1
MAX31856_CR1_REG_READ   = hex2dec('0x01');  %Config 1 register (read)
MAX31856_CR1_REG_WRITE  = hex2dec('0x81');  %Config 1 register (write)

%MASK (AKA Fault Mask Register)
MAX31856_MASK_REG_READ  = hex2dec('0x02');  %Fault Mask register (read)
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

%ou can set SPI properties such as the SPI clock out frequency (in MHz),
%SPI mode, and the Bit order in the Configuration Parameters > Hardware
%Implementation > SPI properties section. 
%https://www.mathworks.com/help/simulink/supportpkg/arduino_ug/support-spi-communication.html
% SPIMaxSpeed_hz = 1000000;
% spiMode = 1;
warning('Need to programatically set these in configuration settings.')
% max31856SpiSettings = device(a,'SPIChipSelectPin',pin_CS);
% max31856SpiSettings.BitRate = SPIMaxSpeed_hz;
% max31856SpiSettings.SPIMode = spiMode;

%% Compute parameters

%% Open model
open(modelName);

disp('Run model via Hardware > Monitor & Tune')

disp('DONE!')
