%Interface with a MAX31856.  This is similar to the functionality outlined
%in \LumArduinoSDK\Examples\MAX31856\SPI_OneShot\SPI_OneShot.ino except
%this uses the MATLAB Support Package for Arduino Hardware to achieve this
%functionality.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/14/24: Created
%12/17/24: Continued working

clear
clc
close all

%% User selections
N           = 5;     %number iterations
outputFile  = 'MAX31856OneShotData_IDXX.mat';

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

pin_CS = "D10";

a = arduino('COM4','Nano3');

SPIMaxSpeed_hz = 1000000;
spiMode = 1;

max31856SpiSettings = device(a,'SPIChipSelectPin',pin_CS);
max31856SpiSettings.BitRate = SPIMaxSpeed_hz;
max31856SpiSettings.SPIMode = spiMode;

%% Setup
SetupMAX31856(max31856SpiSettings,...
    MAX31856_MASK_REG_READ,MAX31856_MASK_REG_WRITE,...
    MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE,...
    MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE,...
    MAX31856_CJTO_REG_READ,MAX31856_CJTO_REG_WRITE);

disp('---------------------setup------------------')
t0 = readRegister8(max31856SpiSettings,MAX31856_CR0_REG_READ);
disp(['MAX31856_CR0_REG: ',num2str(t0)])

t1 = readRegister8(max31856SpiSettings,MAX31856_CR1_REG_READ);
disp(['MAX31856_CR1_REG_READ: ',num2str(t1)])

t2 = readRegister8(max31856SpiSettings,MAX31856_CJTO_REG_READ);
disp(['MAX31856_CJTO_REG_READ: ',num2str(t2)])
disp('---------------Finished setup---------------')

%% Loop
tempCJ_vec = zeros(N,1);
tempTC_vec = zeros(N,1);
for k=1:N
    ts = readRegister8(max31856SpiSettings,MAX31856_CR0_REG_READ);
    disp(['MAX31856_CR0_REG_READ at loop start: ',num2str(ts)])

    %trigger a one-shot conversion
    triggerOneShot(max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE);
    pause(0.05);

    %Read cold junction temperature
    tempCJ = readColdJunctionTemperature(max31856SpiSettings,MAX31856_CJTH_REG_READ,MAX31856_CJTL_REG_READ);
    disp(['CJ Temp: ',num2str(tempCJ)]);

    %Read thermocouple temperature
    tempTC = readThermocoupleTemperature(max31856SpiSettings,MAX31856_LTCBH_REG_READ,MAX31856_LTCBM_REG_READ,MAX31856_LTCBL_REG_READ);
    disp(['TC Temp: ',num2str(tempTC)]);

    te = readRegister8(max31856SpiSettings,MAX31856_CR0_REG_READ);
    disp(['MAX31856_CR0_REG_READ at loop end: ',num2str(te)])

    tempCJ_vec(k) = tempCJ;
    tempTC_vec(k) = tempTC;

    disp(' ');
    pause(1)
end

%% Save data
save(outputFile,'tempCJ_vec','tempTC_vec')
disp(['Saved to ',outputFile])

%% Cleanup
disp('Clearing arduinoObj')
clear arduinoObj

disp('DONE!')