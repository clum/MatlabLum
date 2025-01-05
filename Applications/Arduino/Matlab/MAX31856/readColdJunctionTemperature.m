function [tempCJ] = readColdJunctionTemperature(max31856SpiSettings,MAX31856_CJTH_REG_READ,MAX31856_CJTL_REG_READ)

%Read the cold junction temperature by reading from the CJTH and CJTL
%registers and performing appropriate bitshifting/conversions.
%
%Christopher Lum
%lum@uw.edu

%Version History
%12/18/24: Created
%01/04/24: Fixing for negative temperatures

%Get current register value
dataCJTH = readRegister8(max31856SpiSettings,MAX31856_CJTH_REG_READ);
dataCJTL = readRegister8(max31856SpiSettings,MAX31856_CJTL_REG_READ);

ret = int16(dataCJTH);

ret = bitshift(ret,8);
ret = bitor(ret,int16(dataCJTL));

tempCJ = double(ret)/256;
