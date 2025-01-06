function [] = SetupMAX31856(max31856SpiSettings,...
    MAX31856_MASK_REG_WRITE,...
    MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE,...
    MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE,...
    MAX31856_CJTO_REG_WRITE)

%Christopher Lum
%lum@uw.edu

%Version History
%12/14/24: Created
%12/17/24: Continued working
%01/05/25: Removed unused register addresses

%----------Setup MASK register------------
%assert on any fault (set all bits to 0)
writeRegister8(max31856SpiSettings,MAX31856_MASK_REG_WRITE, 0x0);

%----------Setup CR0 register-------------
%initialize register to all 0.  As a byproduct, this sets the following:
%  (bit 7)   CMODE = normally off mode
%  (bit 6)   1SHOT = no conversions requested
%  (bit 5:4) OCFAULT = disabled
%  (bit 3)   CJ = cold-junction temperature sensor enabled
%  (bit 2)   FAULT = comparator mode
%  (bit 1)   FAULTCLR = default
%  (bit 0)   50/60 Hz = 60 Hz
writeRegister8(max31856SpiSettings,MAX31856_CR0_REG_WRITE, 0x0);

%enable open circuit fault detection
% setOpenCircuitDetectionMode(max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_DISABLED,max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE);    %CORRECT
setOpenCircuitDetectionMode(max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_ENABLEDA,max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE);
% setOpenCircuitDetectionMode(max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_ENABLEDB,max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE);    %CORRECT
% setOpenCircuitDetectionMode(max31856_opencircuitdetectionmode_t.MAX31856_OCDETECTIONMODE_ENABLEDC,max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE);    %CORRECT

%set One-Shot conversion mode
setConversionMode(max31856_conversionmode_t.MAX31856_CONVERSIONMODE_ONESHOT,max31856SpiSettings,MAX31856_CR0_REG_READ,MAX31856_CR0_REG_WRITE);

%----------Setup CR1 register-------------
%initialize register to all 0.  As a byproduct, this sets the following:
%  (bit 7)   <RESERVED>
%  (bit 6:4) AVGSEL = 1 sample
%  (bit 3:0) TC TYPE = B Type
writeRegister8(max31856SpiSettings,MAX31856_CR1_REG_WRITE, 0x0);

%set thermocouple type
setThermocoupleType(max31856_thermocoupletype_t.MAX31856_TCTYPE_K,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE);

%set averaging mode
setAveragingMode(max31856_averagingmode_t.MAX31856_AVERAGINGMODE_1SAMPLES,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE); %CORRECT
% setAveragingMode(max31856_averagingmode_t.MAX31856_AVERAGINGMODE_2SAMPLES,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE); %CORRECT
% setAveragingMode(max31856_averagingmode_t.MAX31856_AVERAGINGMODE_4SAMPLES,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE); %CORRECT
% setAveragingMode(max31856_averagingmode_t.MAX31856_AVERAGINGMODE_8SAMPLES,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE); %CORRECT
% setAveragingMode(max31856_averagingmode_t.MAX31856_AVERAGINGMODE_16SAMPLES,max31856SpiSettings,MAX31856_CR1_REG_READ,MAX31856_CR1_REG_WRITE); %CORRECT


%----------Setup CJTO register-------------
%set cold junction temperature offset to zero (set all bits to 0)
writeRegister8(max31856SpiSettings,MAX31856_CJTO_REG_WRITE, 0);