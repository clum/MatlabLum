function [tempTC] = readThermocoupleTemperature(max31856SpiSettings,MAX31856_LTCBH_REG_READ,MAX31856_LTCBM_REG_READ,MAX31856_LTCBL_REG_READ)

%Read the thermocouple temperature by reading from the LTCBH, LTCBM, and
%LTCBL registers and performing appropriate bitshifting/conversions.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created

%read the thermocouple temperature registers (3 bytes)
tcByte2 = readRegister8(max31856SpiSettings,MAX31856_LTCBH_REG_READ);
tcByte1 = readRegister8(max31856SpiSettings,MAX31856_LTCBM_REG_READ);
tcByte0 = readRegister8(max31856SpiSettings,MAX31856_LTCBL_REG_READ);

ret = int32(tcByte2);

ret = bitshift(ret,8);
ret = bitor(ret,int32(tcByte1));
ret = bitshift(ret,8);
ret = bitor(ret,int32(tcByte0));

temp24 = ret;

%fix sign
%NEEDS IMPLEMENTATION

%bottom 5 bits are unused
temp24 = bitshift(temp24,-5);

tempTC = double(temp24)*0.0078125;
